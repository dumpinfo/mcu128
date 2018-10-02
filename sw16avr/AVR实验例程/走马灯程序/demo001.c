/***********************************************************
file name          : demo001.c
chip type          : ATMEGA8515L
clock frequenoy    : 11.0592MHZ
creator            : ccdzdpj
date created       : 2005-12-05
***********************************************************/

#include <avr/io.h>
#include <avr/delay.h>

#define uchar unsigned char
#define uint  unsigned int

//注： 内部函数_delay_ms() 最高延时 262.144mS@1MHz 即 约23.7ms@11.0592MHz
// 该函数可以实现较精确的定时for()/while()指令很难计算延时时间
// 为了使 _delay_ms()函数的延时正确，须在makefile中设定F_CPU为实际的系统时钟频
// 本范例为11.0592MHz外部晶振 即 F_CPU=11059200


int main(void)
{
    uchar position = 0;
	uchar i;
	DDRA = 0xff;
	PORTA = 0xff;

	while(1)
	{
        PORTA = ~(1<<position);
		if(++position>=8)position = 0;
		for(i=0;i<50;i++)_delay_ms(20);
	}
}

