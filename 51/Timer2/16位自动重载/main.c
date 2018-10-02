#include"reg52.h"
#include"51usb.h"		   //51USB实验板的头文件

#define  uchar unsigned char
#define  uint  unsigned int

void initsys();		   //初始化系统
void display();		   //显示刷新
void delay(uint ticks);

unsigned char code 	SEG[8]={0x00,0x02,0x04,0x06,0x08,0x0A,0x0C,0x0E};
unsigned char code  Tab[]	=	{0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,
                          		 0x80,0x90,0x88,0x83,0xC6,0xA1,0x86,0x8E};

unsigned char Count=0;
unsigned char Number;

/*
请进入Debug模式，软件调试
查看states和sec
这两个参数会每隔50ms运行到断点一次
*/
void ISR_Timer2() interrupt 5 using 1
{
	TF2=0;
	Count++;	  //观察断点

}

void main()
{
 initsys();
	 while(1)
	 {
		   if(Count>20)
		   {//20次50ms
			     Count=0;
				 if(Number++==0x0f)	Number=0;	
		   } 
		   display();
	 }
}


void initsys()
{
 //3CB0
 //(RCAP2L,RCAP2H)===>(TL2,TH2)
 TL2	=0xB0;
 RCAP2L	=0xB0;
 TH2	=0x3C;
 RCAP2H	=0x3C;

 TR2=1;	//Star Timer2
 ET2=1;		//Enable Timer2 Interrupt
 EA	=1;		

}

void display()
{
 unsigned char index;

 for(index=0;index!=6;index++)
 {
	 P1=1;//关显示
	 LED=Tab[Number];	//查表显示数码管数据
	 P1=SEG[index];
	 delay(10);
 }
}


//////////// 延时程序的实现////////////////////
void delay(uint ticks)
{
 uchar i;
 for(;ticks!=0;ticks--)for(i=50;i!=0;i--);
}
