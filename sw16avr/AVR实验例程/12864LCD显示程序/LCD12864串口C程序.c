/*
LCD12864串行显示程序，在第一行显示“FALSHMAN”
FLASHMAN编写，在ME300B上运行成功，欢迎交流，QQ28476691
*/

#include <io8515v.h>
#include<macros.h>
#define uchar unsigned char
#define uint unsigned int
	
const uchar cs=0;
const uchar sid=1;
const uchar sclk=2;
const uchar psb=3;
const uchar rst=5;

void LcdIni(void);
void WrOp(uchar dat);
void WrDat(uchar dat);
void SndByte(uchar dat);
void delay(void);
	
main()
{
	LcdIni();
	WrOp(0x80);
	WrDat('F');
	WrDat('L');
	WrDat('A');
	WrDat('S');
	WrDat('H');
	WrDat('M');
	WrDat('A');
	WrDat('N');

	while(1);
}

void LcdIni(void)
{
	DDRC=0XFF;				
	PORTC=0XFF;				//PORTC输出全部为1
	PORTC &=~BIT(psb);		//psb为低，选择串口方式
	
	PORTC |=BIT(cs);		//片选有效
	PORTC &=~BIT(rst);
	delay();				//延时以复位
	PORTC |=BIT(rst);		
	PORTC &=~BIT(cs);		//片选无效
	
	WrOp(0x20);
	WrOp(0x01);
	WrOp(0x06);
	WrOp(0x0c);
	
}

void WrOp(uchar dat)
{
	PORTC |=BIT(cs);
	SndByte(0xf8);		//命令字1111 1100
	SndByte(dat & 0xf0);//高四位0000
	SndByte(dat<<4);
	PORTC &=~BIT(cs);
	delay();
}

void WrDat(uchar dat)
{
	PORTC |=BIT(cs);
	SndByte(0xfa);
	SndByte(dat & 0xf0);
	SndByte(dat<<4);
	PORTC &=~BIT(cs);
	delay();
}
	
void SndByte(uchar dat)
{
	uchar i;
	for(i=8;i>0;i--)
		{
			if(dat & BIT(i-1)) PORTC |=BIT(sid);   //置1
			else PORTC &=~BIT(sid);				//置0
			PORTC |=BIT(sclk);					
			NOP();
			PORTC &=~BIT(sclk);
		}
}

void delay(void)
{
	uchar i,j;
	for(i=0;i<200;i++)
		for(j=0;j<200;j++);
}
