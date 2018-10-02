/***********************************************************
file name          : demo003.c
chip type          : ATMEGA8515L
clock frequenoy    : 11.0592MHZ
creator            : ccdzdpj
date created       : 2005-12-05
***********************************************************/

#include <avr/io.h>
#include <avr/delay.h>
#include <avr/pgmspace.h>
#include <avr/signal.h>
#include <avr/interrupt.h>

#define code PROGMEM
#define uchar unsigned char
#define uint  unsigned int

code const uchar led_7[16] = {0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90,0x88,0x83,0xc6,0xa1,0x86,0x8e};//common of +
//code const uchar led_7[16] = {0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f,0x77,0x7c,0x39,0x5e,0x79,0x71};//common of -

code const uchar position[8] = {0x7f,0xbf,0xdf,0xef,0xf7,0xfb,0xfd,0xfe};
//code const uchar position[8] = {0xfe,0xfd,0xfb,0xf7,0xef,0xdf,0xbf,0x7f};

uchar time[4];             //时间计数
volatile uchar disp_buff[8];        //显示缓冲区
volatile uchar time_count = 0;

volatile uchar point_on = 0;
volatile uchar posit = 0;
volatile uchar time_10ms_ok = 0;

void time_to_dispbuff(void);
void time1_init(void);
void time0_init(void);
void display(void);

int main(void)
{
    PORTA = 0xff;
	DDRA = 0xff;
	PORTC = 0xff;
	DDRC = 0xff;

	time[0] = 00;//1/10sec
	time[1] = 30;//sec
	time[2] = 59;//minute
	time[3] = 23;//hour
	time_to_dispbuff();

	time1_init();
    sei();

	while(1)
	{
		if(time_10ms_ok)
		{
		    time_10ms_ok = 0;
			if(++time[0]>=100)
			{
			    time[0] = 0;
                point_on = ~point_on;
                if(++time[1]>=60)
			    {
                    time[1] = 0;
				    if(++time[2]>=60)
				    {
                        time[2] = 0;
					    if(++time[3]>=24)
					    {
					        time[3] = 0;
					    }
				    }
			    }
			}
            time_to_dispbuff();
		}
	}
} 

void time0_init(void)
{
    TCCR0 = 0x05;
	TCNT0 = 0xea;
	TIFR |= 0x02;
	TIMSK |= 0x02;
}


void time1_init(void)
{
    TCCR1A = 0x00;
	TCCR1B = 0x01;
	TCNT1 = 0xa99a;
	//TCNT1H = 0xa9;
	//TCNT1L = 0x9a;
	TIFR |= 0x80;
	TIMSK |= 0x80;
}

SIGNAL(SIG_OVERFLOW1)
{
    TCNT1 = 0xa99a;
    display();
    if(++time_count >=5)
	{
	    time_10ms_ok = 1;
		time_count = 0;
	}
}

void display(void)
{
    PORTC = 0xff;
    PORTA = pgm_read_byte(&led_7[disp_buff[posit]]);
    if(point_on && ((posit==2)||(posit==4)||(posit==6)))PORTA &= 0x7f;
    PORTC = pgm_read_byte(&position[posit]);
    if(++posit>=8)posit = 0;
}

void time_to_dispbuff(void)
{
    uchar i,j=0;
    for(i=0;i<=3;i++)
    {
        disp_buff[j++] = time[i]%10;
        disp_buff[j++] = time[i]/10;
    }
}

