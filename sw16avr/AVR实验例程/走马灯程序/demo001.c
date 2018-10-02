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

//ע�� �ڲ�����_delay_ms() �����ʱ 262.144mS@1MHz �� Լ23.7ms@11.0592MHz
// �ú�������ʵ�ֽϾ�ȷ�Ķ�ʱ�ffor()/while()ָ����Ѽ�����ʱʱ��
// Ϊ��ʹ _delay_ms()��������ʱ��ȷ������makefile���趨F_CPUΪʵ�ʵ�ϵͳʱ��Ƶ
// ������Ϊ11.0592MHz�ⲿ���� �� F_CPU=11059200


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

