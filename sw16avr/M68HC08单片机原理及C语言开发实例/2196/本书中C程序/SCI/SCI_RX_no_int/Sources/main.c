#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */

void main(void) {
  unsigned char temp,rxdata;
  temp=0;
  rxdata=0;
  PTD=0;
  DDRD=0xff;//output
  /* include your code here */
  CONFIG1=0x39;
  CONFIG2=0x00;	//sci clock source:CGMXCLK=9.8MHz
  
  SCBR=0x04;//baud rate 9600 9.8M/(64*16)=9600
  SCC1=0x40;
  SCC2=0x0C;//enable transmitter and receiver
  SCC3=0x00;
  EnableInterrupts; /* enable interrupts */
  while(1)
  {
  	//while(SCS1_SCRF==0);
  	if(SCS1_SCRF==1)
  	{
  		rxdata=SCDR;
  		if(rxdata==0x55) PTD_PTD4=1;
  		else PTD_PTD4=0;
  		if(rxdata==0x00) PTD_PTD7=1;
  		else PTD_PTD7=0;
  		while(SCS1_SCTE==0);
  		temp=SCS1;//清除标志位
  		SCDR=rxdata;
  	}
  }
  
}
