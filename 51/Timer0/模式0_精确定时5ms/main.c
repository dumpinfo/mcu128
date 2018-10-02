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
void ISR_Timer0(void) interrupt 1 using 1
{
 TL0=0x1C;
 TH0=0x63;

}
 

void main()
{
 inittimer();
 while(1);
}

void inittimer()
{
 TL0=0x1C;
 TH0=0x63;
 TMOD=0x00;		//定时器0模式1
 TR0=1;			//启动定时器0
 ET0=1;			//开定时器0中断
 EA=1;			//开全局中断
}
