//ICC-AVR application builder : 2008-01-04 16:13:23
// Target : M128
// Crystal: 2.0000Mhz

#include <iom128v.h>
#include <macros.h>


#define LCD_DDR  DDRC
#define LCD_PORT PORTC

#define DATA_DDR  DDRD
#define DATA_PORT PORTD


//#define LCD_SID (1<<7)   //PIN8  data0
//#define LCD_DL  (1<<6)   //PIN7  data1 
//#define LCD_DM  (1<<1)   //PIN2  data2
//#define LCD_DR  (1<<0)   //PIN1  data3


#define LCD_DLL (1<<0)   //PIN3  
#define LCD_M   (1<<1)   //PIN4   共
#define LCD_CL1 (1<<2)   //PIN5   共
#define LCD_CL2 (1<<3)   //PIN6
                         //PIN9  VCC
                         //PIN10 GND
                         //PIN11 VEE(-5~-10V)
                         //PIN12 NC
                         //PIN13 BLK~
                         //PIN14 BLK~
#define SET_LCD_DLL()	 (LCD_PORT |= LCD_DLL)
#define SET_LCD_M() 	 (LCD_PORT |= LCD_M)
#define SET_LCD_CL1()	 (LCD_PORT |= LCD_CL1)
#define SET_LCD_CL2()	 (LCD_PORT |= LCD_CL2)

 

#define CLR_LCD_DLL()	 (LCD_PORT &= ~LCD_DLL)
#define CLR_LCD_M()	 (LCD_PORT &= ~LCD_M)
#define CLR_LCD_CL1()	 (LCD_PORT &= ~LCD_CL1)
#define CLR_LCD_CL2()	 (LCD_PORT &= ~LCD_CL2)


unsigned char  data=0,data1;
void port_init(void)
{
 PORTA = 0x00;
 DDRA  = 0x00;
 PORTB = 0x00;
 DDRB  = 0x00;
 PORTC = 0x00; //m103 output only
 DDRC  = 0xFF;
 PORTD = 0x00;
 DDRD  = 0xFF;
 PORTE = 0x00;
 DDRE  = 0x00;
 PORTF = 0x00;
 DDRF  = 0xff;
 PORTG = 0x00;
 DDRG  = 0x00;
}



//TIMER0 initialize - prescale:1024
// WGM: Normal
// desired value: 100mSec
// actual value: 99.840mSec (0.2%)
void timer0_init(void)
{
 TCCR0 = 0x00; //stop
 ASSR  = 0x00; //set async mode
 TCNT0 = 0x3D; //set count
 OCR0  = 0xC3;
 TCCR0 = 0x07; //start timer
}

#pragma interrupt_handler timer0_ovf_isr:17
void timer0_ovf_isr(void)
{
 TCNT0 = 0x3D; //reload counter value
 

}



//TIMER1 initialize - prescale:64
// WGM: 0) Normal, TOP=0xFFFF
// desired value: 1Sec
// actual value:  1.000Sec (0.0%)
void timer1_init(void)
{
 TCCR1B = 0xFF; //stop
 TCNT1H = 0x85; //setup
 
 TCNT1L = 0xEE;
 OCR1AH = 0x7A;
 OCR1AL = 0x12;
 OCR1BH = 0x7A;
 OCR1BL = 0x12;

 ICR1H  = 0x7A;
 ICR1L  = 0x12;
 TCCR1A = 0x00;
 TCCR1B = 0x03; //start Timer
}

#pragma interrupt_handler timer1_ovf_isr:9
void timer1_ovf_isr(void)
{
 //TIMER1 has overflowed
 TCNT1H = 0x85; //reload counter high value
 TCNT1L = 0xEE; //reload counter low value
 
 
  data++;
 if(data == 2)
 {
 SET_LCD_DLL();
 data = 0;
 }
 else
 CLR_LCD_DLL();
 
 
 SET_LCD_CL1();
 CLR_LCD_CL1();
 
 DATA_PORT = 0Xf;     //装载数据
 CLR_LCD_CL2();
 SET_LCD_CL2();
 }
  




//call this routine to initialize all peripherals
void init_devices(void)
{
 //stop errant interrupts until set up
 CLI(); //disable all interrupts
 XDIV  = 0x00; //xtal divider
 XMCRA = 0x00; //external memory
 port_init();
 timer0_init();
 timer1_init();

 MCUCR = 0x00;
 EICRA = 0x00; //extended ext ints
 EICRB = 0x00; //extended ext ints
 EIMSK = 0x00;
 TIMSK = 0x05; //timer interrupt sources
  
 SEI(); //re-enable interrupts
 //all peripherals are now initialized
}

//
void main(void)
{
 int i,j;
 init_devices();
 //insert your functional code here...
 
}

