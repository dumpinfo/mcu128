//ICC-AVR application builder : 2006-11-4 10:04:08
// Target : M16
// Crystal: 7.3728Mhz

#include <iom16v.h>
#include <macros.h>
#include <stdlib.h>

#include "12864.h"
int i,j;
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
}

//call this routine to initialise all peripherals
void init_devices(void)
{
 //stop errant interrupts until set up
 CLI(); //disable all interrupts
 port_init();

 MCUCR = 0x00;
 GICR  = 0x00;
 TIMSK = 0x00; //timer interrupt sources
 SEI(); //re-enable interrupts
 //all peripherals are now initialised
}

//
void main(void)
{
 int k;
 init_devices();
 

  OutI(0,0x3e);
  OutI(0,0xb8);
  OutI(0,0x40);
  
  OutI(0,0xC0);
  OutI(0,0x3f); //Æô¶¯LCD
  ClearDisplay();
  ClearDisplay();
   DisplayLine(0,0x04,0,1);
  DisplayLine(128,0x04,4,1);
  DisplayLine(256,0x04,1,1);
  DisplayLine(384,0x04,5,1);
  DisplayLine(512,0x03,2,1);
  DisplayLine(608,0x04,3,1);
  DisplayLine(736,0x03,7,1);

 


  
 //insert your functional code here...
}

