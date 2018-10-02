//ICC-AVR application builder : 2007-4-12 9:38:39
// Target : M16
// Crystal: 7.3728Mhz
//PA0Êä³öÆµÂÊ²¨ÐÎ
#include <iom16v.h>
#include <macros.h>

unsigned char Data=0;
void port_init(void)
{
 PORTA = 0xFF;
 DDRA  = 0xFF;
 PORTB = 0xFF;
 DDRB  = 0x00;
 PORTC = 0xFF; 
 DDRC  = 0x00;
 PORTD = 0xFF;
 DDRD  = 0x00;
}

//TIMER0 initialisation - prescale:64
// WGM: Normal
// desired value: 1KHz
// actual value:  1.002KHz (0.2%)
void timer0_init(void)
{
 TCCR0 = 0x00; //stop
 TCNT0 = 0x8D; //set count
 OCR0  = 0x73;  //set compare
 TCCR0 = 0x03; //start timer
}

#pragma interrupt_handler timer0_ovf_isr:10
void timer0_ovf_isr(void)
{
 TCNT0 = 0x8D; //reload counter value
 PORTA = Data;
 if(Data ==0)
  Data = 1;
 else
  Data = 0;
}

//call this routine to initialise all peripherals
void init_devices(void)
{
 //stop errant interrupts until set up
 CLI(); //disable all interrupts
 port_init();
 timer0_init();

 MCUCR = 0x00;
 GICR  = 0x00;
 TIMSK = 0x01; //timer interrupt sources
 SEI(); //re-enable interrupts
 //all peripherals are now initialised
}

//
void main(void)
{
 init_devices();
 //insert your functional code here...
}

