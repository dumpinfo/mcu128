//ICC-AVR application builder : 2007-6-11 20:45:01
// Target : M16
// Crystal: 4.0000Mhz
//ʹ����PD�ں�PC�ڣ�����Pd����Ϊ���ݿڣ�PC����Ϊ��ַ�ڡ�
//�ó���ʹ���˶�ʱ��T0������ѭ��ɨ�跽ʽ��ʾ8λ����


//ICC-AVR application builder : 2007-6-26 15:48:39
// Target : M128
// Crystal: 6.0000Mhz

#include <iom128v.h>
#include <macros.h>
//#include "seg7.h"
unsigned char seg7[]={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90};
unsigned char addr=1,ldata = 0,jdata = 0,i=0;//���弸������

unsigned char kdata[] = {5,6,7,8};//��Ҫ��ʾ������
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
 PORTE = 0x0; 
 DDRE  = 0xFF;
 PORTF = 0xFF;
 DDRF  = 0xFF;
 PORTG = 0x0;
 DDRG  = 0xFF;
}

//TIMER0 initialisation - prescale:8
// WGM: Normal
// desired value: 10KHz
// actual value: 10.000KHz (0.0%)
void timer0_init(void)
{
 TCCR0 = 0x00; //stop
 ASSR  = 0x00; //set async mode
 TCNT0 = 0xB5; //set count
 OCR0  = 0x4B;
 TCCR0 = 0x02; //start timer
}

#pragma interrupt_handler timer0_ovf_isr:17
void timer0_ovf_isr(void)
{
 TCNT0 = 0xB5; //reload counter value
 
 PORTC = addr; //��ַ����PC��
 jdata = kdata[i];//ȡ����Ҫ��ʾ������
 
 
 //���������7��SEG����
 PORTD = seg7[jdata];//��������PD��
 
 i++;         //ȡ����ַ��1
 addr = addr<<1;//��ʾ��ַ����
 if(i == 4)//�����ʾ��8λ�󣬷��ص���һλ
  {addr = 1;
   i = 0;
  }
  
 
}

//call this routine to initialise all peripherals
void init_devices(void)
{
 //stop errant interrupts until set up
 CLI(); //disable all interrupts
 XDIV  = 0x00; //xtal divider
 XMCRA = 0x00; //external memory
 port_init();
 timer0_init();

 MCUCR = 0x00;
 EICRA = 0x00; //extended ext ints
 EICRB = 0x00; //extended ext ints
 EIMSK = 0x00;
 TIMSK = 0x01; //timer interrupt sources
 ETIMSK = 0x00; //extended timer interrupt sources
 SEI(); //re-enable interrupts
 //all peripherals are now initialised
}

//
void main(void)
{
 init_devices();
 
 //insert your functional code here...

}



