//ICC-AVR application builder : 2006-11-4 10:04:08
// Target : M16
// Crystal: 7.3728Mhz

#include <REG52.h>
#include <stdlib.h>

#include "12864.h"

void main(void)
{

 

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

