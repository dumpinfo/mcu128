/*******************************************
  数码管显示遥控器键值程序
********************************************
  
 功能：每按下一键时数码管显示一位,当8个数码管显示完毕,重新从第一个开始显示

 作者：伟纳电子网友 dk_wang
 
 出处：伟纳电子论坛 www.willar.com

********************************************/





#include <reg52.h>
#include <intrins.h>
#define uchar unsigned char

/*******************************************
函数定义声明区
*******************************************/
uchar m;

void delay(unsigned char m);
bit k_scan_estimate(void);     //flag 为1时表明有按键;按下否则无;
     bit flag;                   //按键有无按下标志位;
	 uchar key_initialization;   //按键初始化值;
	 uchar key_prevenvient;      //按键前一状态值

uchar key_dispose();
     uchar key_h;        
	 uchar key_l;
	 uchar key;  
     uchar key_before;//键值前一状态;



  uchar key_word(uchar key_m);//由键码值得出按键所对应的状态值;
     uchar code digital_val[]={0xc0,0xf9,0xa4,0xb0,//0123
                               0x99,0x92,0x82,0xf8,//4567
                               0x80,0x90,0x88,0x00,//89AB
                               0x46,0x40,0x86,0x8e};//CDEF
    uchar word_inx_before;
    uchar word_inx;

uchar data display_buffer[8]={0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
uchar buffer_i;//计数变量
uchar f;//位码变量
uchar r;//段码变量
uchar k;


void buzzer(void);//响片驱动程序
  uchar buzzer_i;
  sbit buzzer_voice=P3^7;
  uchar buzzer_ii;



/********************************************/


void main(void)
{
  f=0;
  r=0xfe;
  TMOD=0x01;
  EA=1;
  ET0=1;
  TH0=-2000/256;
  TL0=-2000%256;
  

  TR0=1;
while(1)
   {
   k_scan_estimate();
   if(flag)
   {
    key_dispose();
	if(flag)
	{     buzzer();
	   if(buffer_i==0)
	     {
		 for(k=0;k<8;k++)
		   {display_buffer[k]=0xff;}
		  }
	display_buffer[buffer_i]=digital_val[key_word(key_dispose())];
	buffer_i++;
	buffer_i&=0x07;
    flag=0;
}
}
}
}

/*******************************
定时器0中断入口
********************************/

void timer0(void) interrupt 1
{
   TR0=0;
   TH0=-2000/256;
   TL0=-2000%256;
   P0=display_buffer[f];
   f++;
   f&=0x07;
   P2=r;
   r=_crol_(r,1);
   TR0=1;
 }



bit k_scan_estimate(void) //键盘状态判断,当有按下时标志位置位否则标志位为0;
{
   key_initialization=0xf0;
   P1=key_initialization;
   key_initialization=P1;

   if(key_initialization^key_prevenvient)
      {
	      delay(50);

		 if(key_initialization^key_prevenvient)
		   {
		   key_prevenvient=key_initialization;
		   return(flag=1);
		   }
		}
	 else return(flag=0);
       
}




 uchar key_dispose()//按键处理,当有按键按下时将返回键码值
 {key_before=key;
    key_l=0xfe;

    while(1)
	{
    P1=key_l;
	key_h=key_l=P1;
	if((key_l&0xf0)!=0xf0)
	   {
	    key_l&=0x0f;
		key_h=P1&0xf0;
		key=key_l|key_h;
		return(key);
		}
	  else
	  {
	   key_l=_crol_(key_l,1);
	   if((key_l&0x0f)==0x0f)
	       {
		     flag=0;
	         return(key_before);
		   }
	   }
	 }
  }


  uchar key_word(uchar key_m)//输入键码值返回段码值;
  {


  uchar data key_val[]={0xee,0xed,0xeb,0xe7,//0,1,2,3
                         0xde,0xdd,0xdb,0xd7,//4,5,6,7
                         0xbe,0xbd,0xbb,0xb7,//8,9,A,B
                         0x7e,0x7d,0x7b,0x77};//C,D,E,F;
  uchar *pp=key_val;
         word_inx=0;
for(;*pp!=key_m;pp++)
  {   word_inx++;
    if(pp>(key_val+0x0f)){return(word_inx_before);}
  }
 word_inx_before=word_inx;
  return(word_inx);
  }



  void delay(uchar m)  //延时程式
  {
  uchar n;
  while(m--)
  {
  for(n=250;n>0;n--);
  }

  }




  void buzzer(void)
  {
   
  
  for(buzzer_ii=150;buzzer_ii>0;buzzer_ii--)
  {
     for(buzzer_i=250;buzzer_i>0;buzzer_i--)
     { 
      buzzer_voice=~buzzer_voice;
	  }
   }
   
   }

   





