#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */
unsigned char temp=0;
unsigned char rxdata=0;


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
  //SCC1=0x40;//enable SCI,no parity test,8bit data
  SCC1=0x53;//enable SCI,9bit data,enable parity,odd test
  SCC2=0x2C;//enable transmitter and receiver
  SCC3=0x00;
  SCC2_SCTIE=0;
  EnableInterrupts; /* enable interrupts */
 
  for(;;) {
    __RESET_WATCHDOG(); /* kicks the dog */
  } /* loop forever */
}

interrupt void SCIRx(void)
{
	temp=SCS1;
	rxdata=SCDR;
  	if(rxdata==0x55) PTD_PTD4=1;
  	else PTD_PTD4=0;
  	 	
  	SCC2_SCTIE=1;
 }
 
 interrupt void SCITx(void)
 {
 	temp=SCS1;
  	SCDR=rxdata;
  	SCC2_SCTIE=0;
 }
 
 interrupt void SCIError(void)
 {
 	PTD_PTD5=1;
 }