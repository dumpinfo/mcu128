//ICC-AVR application builder : 2006-12-22 20:34:51
// Target : M8
// Crystal: 6.0000Mhz
//1602占用了PB口作为数据口,PA6,PA5,PA4分别是RS,WR,E
//按纽采用循环检测方式工作，不采用中断方式.


#include <iom16v.h>
#include <macros.h>
#include "1602.h"
unsigned char led_buff[]="0000    ";
unsigned char str1[]="0000";


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
 PORTB = 0xFF;
 DDRB  = 0xFF;
 PORTC = 0xFF; //m103 output only
 DDRC  = 0xFF;
 PORTD = 0xFF;
 DDRD  = 0xFF;
 PORTA = 0xFF;
 DDRA  = 0xFF;
}

//TIMER1 initialisation - prescale:8
// WGM: 0) Normal, TOP=0xFFFF
// desired value: 1mSec
// actual value:  1.000mSec (0.0%)
void timer1_init(void)
{
 TCCR1B = 0x00; //stop
 TCNT1H = 0x63; //setup
 TCNT1L = 0xc0;
 OCR1AH = 0x17;
 OCR1AL = 0x70;
 OCR1BH = 0x17;
 OCR1BL = 0x70;
 ICR1H  = 0x17;
 ICR1L  = 0x70;
 TCCR1A = 0x00;
 TCCR1B = 0x00; //start Timer
}

#pragma interrupt_handler timer1_ovf_isr:9
void timer1_ovf_isr(void)
{
 //TIMER1 has overflowed
 TCNT1H = 0x63; //reload counter high value
 TCNT1L = 0xc0; //reload counter low value
}

//call this routine to initialise all peripherals
void init_devices(void)
{
 //stop errant interrupts until set up
 CLI(); //disable all interrupts
 port_init();
 timer1_init();

 MCUCR = 0x0A;
 GICR  = 0x00;
 TIMSK = 0x04; //timer interrupt sources
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


