#include"reg51.h"
#include"51usb.h"		   //51USB实验板的头文件

#define  uchar unsigned char
#define  uint  unsigned int

void delay(uint ticks);// 延时程序的声明
void inittimer();
/*
请进入Debug模式，软件调试
查看states和sec
这两个参数会每隔5000us运行到断点一次
*/
void ISR_Timer1(void) interrupt 3 using 1
{
 TL1=0x1c;
 TH1=0x63;

}
 

void main()
{
 inittimer();
 while(1);
}

void inittimer()
{
 TL1=0x1c;
 TH1=0x63;
 TMOD=0x00;		//定时器1模式1
 TR1=1;			//启动定时器1
 ET1=1;			//开定时器1中断
 EA=1;			//开全局中断
}
