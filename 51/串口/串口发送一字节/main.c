#include"reg51.h"
#include"absacc.h"

//波特率：4.8K
/*
请打开串口调试工具，选择波特率4800
*/
void init();

void main()
{
 init();
 SBUF='A';
 while(!TI)TI=0;
 while(1);
}


void init()
{
 TMOD=0x20;	 //Timer1 模式2
 TH1=0xF3;	 //
 TL1=0xF3;	 //
 TR1=1;		 //启动Timer1
 PCON|=0x80; //波特率加倍
 SCON=0x50;	 //设置串口
 EA=0;
}


