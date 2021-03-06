//ICC-AVR application builder : 2007-3-14 9:32:42
// Target : M16
// Crystal: 7.3728Mhz
// Designed by solo       转载请注明
// http://www.ourembed.com     
// qq:15537031 phone:13879805760
//该程序使用了PA口，请将PA口接到LED的脚上，然后运行程序
//显示结果应该是循环点亮LED，
//请注意主频
#include <iom16v.h>
#include <macros.h>

unsigned LM_Data=1;
void port_init(void)
{
 PORTA = 0xFF;
 DDRA  = 0xFF;
 PORTB = 0x00;
 DDRB  = 0x00;
 PORTC = 0x00; //m103 output only
 DDRC  = 0x00;
 PORTD = 0x00;
 DDRD  = 0x00;
}

//TIMER1 initialize - prescale:256
// WGM: 0) Normal, TOP=0xFFFF
// desired value: 1Sec
// actual value:  1.000Sec (0.0%)
void timer1_init(void)
{
 TCCR1B = 0x00; //stop
 TCNT1H = 0xcF; //setup
 TCNT1L = 0xc1;
 OCR1AH = 0x70;
 OCR1AL = 0x7F;
 OCR1BH = 0x70;
 OCR1BL = 0x7F;
 ICR1H  = 0x70;
 ICR1L  = 0x7F;
 TCCR1A = 0x00;
 TCCR1B = 0x02; //start Timer
}

#pragma interrupt_handler timer1_ovf_isr:9
void timer1_ovf_isr(void)
{
 //TIMER1 has overflowed
 TCNT1H = 0xeF; //reload counter high value
 TCNT1L = 0xff; //reload counter low value
 PORTA = LM_Data;
 
 switch (LM_Data)
 {
  case 1: LM_Data = 3;
          break;
		  
  case 3: LM_Data = 2;
          break;
  case 2: LM_Data = 6;
          break;
  case 6: LM_Data = 4;
          break;
  case 4: LM_Data = 12;
          break;
  case 12:	LM_Data = 8;
          break;
  case 8: 	LM_Data = 9;
          break;
  case 9: 	LM_Data = 1;
          break;
	 
 }
}

//call this routine to initialize all peripherals
void init_devices(void)
{
 //stop errant interrupts until set up
 CLI(); //disable all interrupts
 port_init();
 timer1_init();

 MCUCR = 0x00;
 GICR  = 0x00;
 TIMSK = 0x04; //timer interrupt sources
 SEI(); //re-enable interrupts
 //all peripherals are now initialized
}

//
void main(void)
{
 init_devices();
 //insert your functional code here...
}

