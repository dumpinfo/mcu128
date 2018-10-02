最简单的红外接收演示程序（入门练习） 

 主要是练习在WINAVR编译软件下，如何调用delay函数和位定义、位操作。
－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

实验系统： ME300全系列单片机开发板。

实验芯片： ATmega8515L或Atmega8515

工作频率： 8MHz

编译软件： WINAVR 1.41

作者：伟纳电子 gguoqing

出处：伟纳电子网站 www.wllar.com

－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

将 ME300B 的 JP2  的3、4脚用跳线帽短接，选择使用LED显示 。

－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

功能：

接收到红外信号后，8个LED亮2秒后熄灭。

－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

#include < ;avr/io.h>                     //头文件
#include < ;avr/delay.h>

#define uchar unsigned char
#define uint  unsigned int     
#define IR_IN 2                           //定义IR_IN为端口2


/*-------延时函数 -------*/

void delay_1ms(void)                 //1ms延时函数 
  {   
    _delay_loop_2(2000) ;          //16-bit count, 4 cycles/loop  
   }                                            //8MHz/8000=1ms 8000/4=2000=1ms  
     
void delay_nms(Uint n)             //N ms延时函数 
  { 
   uint i=0 ; 
   for (i=0 ;i< ;n ;i++) 
   delay_1ms() ; 
  }
  
int  main(void)

{
    uint j=0 ;
 
    DDRA=0xFF ;                         //PA口为输出
    PORTA=0xFF ;                      //PA口设置内部上拉电阻
    DDRD=_BV(IR_IN) ;              //PD2为输出
    PORTD|=_BV(IR_IN) ;           //PD2设置内部上拉电阻
    DDRD&=~_BV(IR_IN) ;          //PD2为输入
  
   while(1)
    {   
       PORTA=0xFF ;                           //关闭8个LED
       if ((PIND&0B00000100)==0)    //检测PD2是否为低电平
                                     
       {  
             j++ ;
             if (j>20)                            //连续检测到有20次PD2都为低电平
           { 
                  j=0 ;
                  PORTA=0x00 ;             //点亮8个LED灯 
                 delay_nms(2000) ;
            }
        } 
     }
} 
  
 
