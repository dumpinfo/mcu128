//ICC-AVR application builder : 2006-12-22 20:34:51
// Target : M8
// Crystal: 6.0000Mhz
//1602占用了PC口作为数据口,PD5,PD6,PD7分别是RS,WR,E
//按纽采用循环检测方式工作，不采用中断方式.


//ICC-AVR application builder : 2007-6-26 15:29:01
// Target : M128
// Crystal: 6.0000Mhz

#include <iom128v.h>
#include <macros.h>

#include "1602.h"
unsigned char led_buff[]="qian ru shi LM! ";
unsigned char str1[]="www.ourembed.com";


void timer1_init(void);
void init_devices(void);
unsigned char KeyPress(void);
void delay_ms(unsigned int time);
void StartCount(void);
void StopCount(void);
void Clear(void);
unsigned int hour=0,minute=0,second=0,ms=0;
unsigned char c_next=0,choose=0;

void port_init(void)
{
 PORTA = 0xFF;
 DDRA  = 0xFF;
 PORTB = 0xFF;
 DDRB  = 0xFF;
 PORTC = 0xFF; //m103 output only
 DDRC  = 0xFF;
 PORTD = 0xFF;
 DDRD  = 0xFF;
 PORTE = 0xFF;
 DDRE  = 0xFF;
 PORTF = 0xFF;
 DDRF  = 0xFF;
 PORTG = 0x1F;
 DDRG  = 0xFF;
}

//call this routine to initialise all peripherals
void init_devices(void)
{
 //stop errant interrupts until set up
 CLI(); //disable all interrupts
 XDIV  = 0x00; //xtal divider
 XMCRA = 0x00; //external memory
 port_init();

 MCUCR = 0x00;
 EICRA = 0x00; //extended ext ints
 EICRB = 0x00; //extended ext ints
 EIMSK = 0x00;
 TIMSK = 0x00; //timer interrupt sources
 ETIMSK = 0x00; //extended timer interrupt sources
 SEI(); //re-enable interrupts
 //all peripherals are now initialised
}





//
void main(void)
{
 init_devices();
 lcd_init();
 //insert your functional code here...
 display_a_string(0,led_buff);
 display_a_string(1,str1);
 

}

//延时
void delay_ms(unsigned int time)
{ unsigned int i,j;
  
  for(j=0;j<time;j++)
  { for(i=0;i<1000;i++)
     time=time;
  }
}

//键盘


