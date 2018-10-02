//ICC-AVR application builder : 2007-6-12 20:23:24
// Target : M16
// Crystal: 4.0000Mhz
//�ó��������ѭ��ɨ�跽ʽ���ں��֣�������B����Ϊ��ַ�ڣ���A����Ϊ���ݿ�
//ѭ��ɨ���ַ����ʾ��Ӧ�����ݣ��ﵽ��ʾ�������ֵ�Ŀ��

#include <iom16v.h>
#include <macros.h>
unsigned char data1[]={0xff,0xfd,0xbd,0xbd,0x81,0xbd,0xbd,0xfd};//��Ҫ��ʾ�ĺ���1
unsigned char data2[]={0xff,0xfd,0xeb,0xe7,0x8f,0xe7,0xeb,0xfd};//��Ҫ��ʾ�ĺ���2
unsigned char addr = 1,i = 0;//addr������ѭ��ɨ��ĵ�ַλ����ĳһλ���Ϊ�ߵĻ������о���ʾ����������
long int j = 0;   //j������Ϊѡ���Ƿ���ʾ����1���ߺ���2
void port_init(void)
{
 PORTA = 0x00;   //PA
 DDRA  = 0xFF;   //PA�����
 PORTB = 0x00;
 DDRB  = 0xFF;   //PB�����
 PORTC = 0x00; //m103 output only
 DDRC  = 0x00;
 PORTD = 0x00;
 DDRD  = 0x00;
}

//TIMER0 initialize - prescale:64
// WGM: Normal
// desired value: 1KHz
// actual value:  1.008KHz (0.8%)
void timer0_init(void)
{
 TCCR0 = 0x00; //stop
 TCNT0 = 0xC2; //set count
 OCR0  = 0x3E;  //set compare
 TCCR0 = 0x03; //start timer
}

#pragma interrupt_handler timer0_ovf_isr:10
void timer0_ovf_isr(void)
{
 TCNT0 = 0xC2; //reload counter value
               //�ڶ�ʱ���������ʾ
 
 PORTB = addr;  //��ַ����PB��  
 
 j++;          //ѡ���ֱ���+1
 if(j<5000)    //���С��5000����ʾA
 PORTA = data1[i];
 else
 PORTA = data2[i]; //�������5000����ʾB
 
 if(j>10000)     //����10000������
 j=0;
 
 i++;            //���������ַ+1
 
 addr= addr<<1;  //��ʾ�ڵ�ַ����
 
 if(addr == 0)   //�ж��Ƿ���ʾ��8��λ�������ʾ�꣬�ص���ʼֵ
  {
   addr =1;
   i=0;
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
 //insert your functional code here...
}

