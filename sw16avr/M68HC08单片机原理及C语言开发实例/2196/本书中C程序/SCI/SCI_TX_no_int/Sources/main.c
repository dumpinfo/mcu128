#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */
void delay(unsigned int count)
{
	unsigned int i;
	for(i=1;i<count;i++);
}

void main(void) {
  /* include your code here */
  unsigned char temp;
  temp=0; 
  CONFIG1=0x39;
  CONFIG2=0x00;	//sci clock source:CGMXCLK=9.8MHz
 
  SCBR=0x04;//baud rate 9600 9.8M/(64*16)=9600
  SCC1=0x40;
  SCC2=0x08;
  SCC3=0x00;
  //EnableInterrupts; /* enable interrupts */
  while(1)
  {
  	delay(50000);
  	delay(50000);
  	while(SCS1_SCTE==0);
  	temp=SCS1;
  	SCDR=0x55;
  }
}
