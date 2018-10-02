#include"reg51.h"
#include"51usb.h"			  //51USB实验板头文件

#define  uchar unsigned char
#define  uint  unsigned int

unsigned char code 	SEG[8]={0x00,0x02,0x04,0x06,0x08,0x0A,0x0C,0x0E};
unsigned char code  Tab[]	=	{0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,
                          		 0x80,0x90,0x88,0x83,0xC6,0xA1,0x86,0x8E};


unsigned char ShuMa[7]={0,0,0,0,0,0,0xFF};//数码管显示缓冲区
unsigned int count=0;

void delay(uint ticks);// 延时程序的声明
void display();
void inittimer();

//每50毫秒中断一次，误差--正负5us
void ISR_Timer0(void) interrupt 1 using 1
{
 count++;
}


void main()
{
 inittimer();
 while(1)
 {
    if(count>5000)
	{//刷新显示缓冲区
	   count=0;
	   if(++ShuMa[0]>0x0f)ShuMa[0]=0;
	   if(++ShuMa[1]>0x0f)ShuMa[1]=0;
	   if(++ShuMa[2]>0x0f)ShuMa[2]=0;
	   if(++ShuMa[3]>0x0f)ShuMa[3]=0;
	   if(++ShuMa[4]>0x0f)ShuMa[4]=0;
	   if(++ShuMa[5]>0x0f)ShuMa[5]=0;	   
	}

 	display(); 
 }
}

void inittimer()
{
 TL0=0x38;	    //0x38=56
 TH0=0x38;		//0x38=56
 TMOD=0x02;		//定时器0模式2
 TR0=1;			//启动定时器0
 ET0=1;			//开定时器0中断
 EA=1;			//开全局中断
}

void display()
{
 unsigned char index;

 for(index=0;index!=6;index++)
 {
	 P1=1;//关显示
	 LED=Tab[ShuMa[index]];	//查表显示数码管数据
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