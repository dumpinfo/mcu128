//ICC-AVR application builder : 2007-10-19 14:27:15
// Target : M16
// Crystal: 1.0000Mhz

//PA0~PA6��CKA,ENA,CWA,CKB,ENB,CWB

#include <iom16v.h>
#include <macros.h>

#define CKA (1<<0)
#define ENA (1<<1)
#define CWA (1<<2)
#define CKB (1<<3)
#define ENB (1<<4)
#define CWB (1<<5)


unsigned int data = 0;
unsigned char choose = 0,key = 0;
void port_init(void)
{
 PORTA = 0x00;
 DDRA  = 0xFF;
 PORTB = 0x00;
 DDRB  = 0x00;
 PORTC = 0x00; //m103 output only
 DDRC  = 0x00;
 PORTD = 0x00;
 DDRD  = 0x00;
}

//TIMER0 initialize - prescale:1024
// WGM: Normal
// desired value: 200mSec
// actual value: 199.680mSec (0.2%)
void timer0_init(void)
{
 TCCR0 = 0x00; //stop
 TCNT0 = 0x3D; //set count
 OCR0  = 0xC3;  //set compare
 TCCR0 = 0x05; //start timer
}

#pragma interrupt_handler timer0_ovf_isr:10
void timer0_ovf_isr(void)
{
 TCNT0 = 0x3D; //reload counter value
 
 /*if(choose == 0)
  {data++;
   if(data == 1000)
    {choose = 1;
	 data = 0;
    }
   	PORTA |= CWA;
	PORTA &= ~CWB;
  }
 else
  {data++;
   if(data == 1000)
    {choose = 0;
	 data = 0;
	}
	PORTA |= CWB;
	PORTA &= ~CWA;
  } */
  if(key == 0)
   {key = 1;
    PORTA |= CKA;
	PORTA |= CKB;
   }
   else
   {key = 0;
    PORTA &= ~CKA;
	PORTA &= ~CKB;
   }
}

//call this routine to initialize all peripherals
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
 //all peripherals are now initialized
}

//
void main(void)
{
 init_devices();
 PORTA &= ~ENA;
 PORTB &= ~ENB;
 //insert your functional code here...
}

