//ICC-AVR application builder : 2007-3-14 9:32:42
// Target : M16
// Crystal: 7.3728Mhz
// Designed by solo       转载请注明
// http://www.ourembed.com     
// qq:15537031 phone:13879805760
//该程序使用了PD口，请将PD口接到LED的脚上，然后运行程序
//显示结果应该是循环点亮LED，
//请注意主频
#include <iom128v.h>
#include <macros.h>

unsigned char data = 1;
void port_init(void)
{
 PORTA = 0x00;
 DDRA  = 0x00;
 PORTB = 0x00;
 DDRB  = 0x00;
 PORTC = 0x00; //m103 output only
 DDRC  = 0x00;
 PORTD = 0x88;
 DDRD  = 0xFF;
 PORTE = 0x00;
 DDRE  = 0x00;
 PORTF = 0x00;
 DDRF  = 0x00;
 PORTG = 0x00;
 DDRG  = 0x00;
}

//TIMER1 initialize - prescale:64
// WGM: 0) Normal, TOP=0xFFFF
// desired value: 1Hz
// actual value:  1.000Hz (0.0%)
void timer1_init(void)
{
 TCCR1B = 0x00; //stop
 TCNT1H = 0x0B; //setup
 TCNT1L = 0xDC;
 OCR1AH = 0xF4;
 OCR1AL = 0x24;
 OCR1BH = 0xF4;
 OCR1BL = 0x24;
 OCR1CH = 0xF4;
 OCR1CL = 0x24;
 ICR1H  = 0xF4;
 ICR1L  = 0x24;
 TCCR1A = 0x00;
 TCCR1B = 0x03; //start Timer
}

#pragma interrupt_handler timer1_ovf_isr:15
void timer1_ovf_isr(void)
{
 //TIMER1 has overflowed
 TCNT1H = 0x0B; //reload counter high value
 TCNT1L = 0xDC; //reload counter low value
 
 PORTD = data;  //
 data = data<<1;
 if (data == 0)
  data = 1;
 
 
}

//call this routine to initialize all peripherals
void init_devices(void)
{
 //stop errant interrupts until set up
 CLI(); //disable all interrupts
 XDIV  = 0x00; //xtal divider
 XMCRA = 0x00; //external memory
 port_init();
 timer1_init();

 MCUCR = 0x00;
 EICRA = 0x00; //extended ext ints
 EICRB = 0x00; //extended ext ints
 EIMSK = 0x00;
 TIMSK = 0x04; //timer interrupt sources
 ETIMSK = 0x00; //extended timer interrupt sources
 SEI(); //re-enable interrupts
 //all peripherals are now initialized
}

//
void main(void)
{
 init_devices();
 //insert your functional code here...
}

