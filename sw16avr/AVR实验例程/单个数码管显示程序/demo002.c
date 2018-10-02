/***********************************************************
file name          : demo002.c
chip type          : ATMEGA8515L
clock frequenoy    : 11.0592MHZ
creator            : ccdzdpj
date created       : 2005-12-05
***********************************************************/

#include <avr/io.h>
#include <avr/delay.h>
#include <avr/pgmspace.h>

#define code PROGMEM
#define uchar unsigned char
#define uint  unsigned int

code const unsigned char led_7[16] = {0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90,0x88,0x83,0xc6,0xa1,0x86,0x8e};//common of +
//code const uchar led_7[16] = {0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f,0x77,0x7c,0x39,0x5e,0x79,0x71};//common of -


int main(void)
{
    uchar i = 0;
	uchar j = 0;
	
	PORTA = 0xff;
	DDRA = 0xff;
	PORTC = 0xff;
	DDRC = 0xff;

	PORTC &= 0xfe;//PC0=0

	while(1)
	{
	    for(i=0;i<16;i++)
		{
            PORTA = pgm_read_byte(&led_7[i]);
            PORTA &= 0x7f;
			for(j=0;j<25;j++)_delay_ms(20);
			PORTA |= 0x80;
			for(j=0;j<25;j++)_delay_ms(20);
		}
	}
} 

