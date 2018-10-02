
---------------------------------------------------------
   简单的时钟程序 
---------------------------------------------------------

实验系统： ME300全系列单片机开发板。

实验芯片： ATmega8515L或Atmega8515

工作频率： 8MHz

编译软件： WINAVR 1.41

作者：伟纳电子 gguoqing  Email：gguoqing@willar.com
---------------------------------------------------------

功能：

简易带有百位毫秒显示的24小时制时钟

8个数码管从左至右依次显示：时，分，秒，－，百位毫秒。

显示格式： 01. 23. 45. － 6 

程序中有内部RC振荡效准功能。

－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

将 ME300B 的 JP2  的2、3脚用跳线帽短接，选择使用数码管显示 。

－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
 
C语言编写：



//***************WINAVR V1.41编译*****************//

#include"avr/io.h"             //头文件
#include < ;avr/pgmspace.h>      //
#include"avr/interrupt.h"     //中断处理函数
#include"avr/signal.h"        //    
#include < ;compat/ina90.h> 

#define uchar unsigned char
#define uint  unsigned int

//数码管字型表，对应0，1，2，3，4，5，6，7，8，9，后十位数是带小数点的0-9//
uchar Table[22]={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90,
            0x40,0x79,0x24,0x30,0x19,0x12,0x02,0x78,0x00,0x10,0xbf,0xff} ;


uchar Data[8]={0,0,0,0,0,0,0,0} ;               //显示初始值：0 0 0 0 0 0
uint CNT=0 ;                                                 //初始计数值：0
uchar Timer[4]={0x00,0x00,0x00,0x00} ;   //初始时间00:00:00


//const prog_uchar OSCCAL_value_Flash ;  //定义指向flash存储器的指针

void DelayMs(uint i)           //Ms级延时，参数i为延时时间
{uint j ;
 for( ;i!=0 ;i--)
  {for(j=8000 ;j!=0 ;j--) { ;}}
}

void Display(uchar *p)            //动态显示函数，参数p为待显示的数组名
{uchar i,sel=0xfe ; 
 for(i=0 ;i< ;8 ;i++)
  {PORTC=sel ;                         //选通最右边的数码管
   PORTA=Table[p[ i ] ] ;          //送字型码
   DelayMs(2) ;                        //显示延时    
   sel=(sel< ;< ;1)|0x01 ;            //移位以显示前一位
  }
}

//计数值处理函数。参数p1:时间数组名；参数p2:显示数组名//
//功能：此函数用于将计数值拆分为BCD码的10时，时，10分，分，10秒，秒，100毫秒
void Process(uchar *p1,uchar *p2) 
{p2[0]=p1[0]/10 ;                      //时十位
 p2[1]=(p1[0]-p2[0]*10)+10 ;   //时个位数加小数点显示
 p2[2]=p1[1]/10 ;                      //分十位
 p2[3]=(p1[1]-p2[2]*10)+10 ;   //分个位数加小数点显示
 p2[4]=p1[2]/10 ;              /        /秒十位
 p2[5]=(p1[2]-p2[4]*10)+10 ;   //秒个位数加小数点显示
 p2[6]=20 ;                                //显示－
 p2[7]=p1[3] ;                           //ms百位
}

void Init_IO(void)             //初始化I/O口
{DDRA=0xff ;                    //设置A口为推挽1输出
 PORTA=0xff ;
 DDRC=0xff ;                    //设置C口为推挽1输出；             
 PORTC=0xff ;
}

int main(void)
{

OSCCAL=pgm_read_word(0x0003) ;  //从地址0x0003中读出校正值放进OSCCAL   

//OSCCAL=0x9d ;                 //校正值放入0SCCAL
// _NOP() ;
    
 Init_IO() ;                           //初始化I/O口
 PORTA=0x00 ;                   //点亮以测试所有的数码管
 PORTC=0x00 ;                   
 DelayMs(3000) ;                 //延时
 PORTC=0xff ;                     //熄灭所有的数码管
 TCCR0=0x02 ;                    //T/C0工作于定时方式，系统时钟8分频
 TCNT0=-10 ;                      //计数初始值 -10
 TIMSK=0x02 ;                     //开放TOV0中断
 SREG=SREG|0x80 ;             //开放总中断
 while(1)
 {Process(Timer,Data) ;      //计数值处理
  Display(Data) ;                //动态扫描显示
 }
}

//********************T/C0中断服务函数********************//

SIGNAL(SIG_OVERFLOW0)

{
  TCNT0=-10 ;                     //重装计数初始值-10
  CNT++ ;                            //中断次数累加
 if(CNT==8229)                 
    {CNT=0 ;                       //计数到8229次，计数值复位
 Timer[3]++ ;                     //毫秒加1
     if(Timer[3]==10)
        {Timer[3]=0 ;
          Timer[2]++ ;}           //秒进位
     if(Timer[2]==60)
        {Timer[2]=0 ;
         Timer[1]++ ;}            //分进位
       if(Timer[1]==60)
          {Timer[1]=0 ;
     Timer[0]++ ;}               //时进位
      if(Timer[0]==24)
            {Timer[0]=0  ;}
 }                                      //计数到达最高位，计数复位
}