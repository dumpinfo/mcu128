#include"reg52.h"
#include"51usb.h"		   //51USB实验板的头文件
#include"stdio.h"


#define  uchar unsigned char
#define  uint  unsigned int


void initsys();
void delay(uint ticks);

void main()
{
 initsys();
 printf("\n---------AT89S52 Will Transit Data To PC With RS232---------\n");
 printf("\n------------------------WWW.LGMCU.COM-----------------------\n");
 while(1)
 {
	delay(5000);
	printf("\nWellcom to www.lgmcu.com\n");
 }


}

void initsys()
{
 //(RCAP2L,RCAP2H)===>(TL2,TH2)
 //波特率
 TL2=0xD9;
 TH2=0xFF;
 RCAP2L=0xD9;
 RCAP2H=0xFF;

 SCON=0x50; //串口模式
 TI=1;
 TCLK=1;	//发送时钟来自Timer2
 RCLK=1;	//接收时钟来自Timer2
 TR2=1;	//Star Timer2
 

}

void delay(uint ticks)
{
 uchar i;
 for(;ticks!=0;ticks--)for(i=50;i!=0;i--);
}


