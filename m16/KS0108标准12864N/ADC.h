//ICC-AVR application builder : 2006-5-30 8:29:21
// Target : M8
// Crystal: 4.0000Mhz

#include <iom16v.h>
#include <macros.h>

#define Vref   500//参考电压值

unsigned int adc_rel;
unsigned char adc_mux;

const unsigned char seg_table[]={0x30,0x31,0x32,0x33,0x34,0x35,
0x36,0x37,0x38,0x39};//,0x41,042,0x43,0x44,045,0x46};
unsigned char led_buff[16]={0x53,0x74,0x50,0x3a,0,0,0,0x20,0x50,0x72,0x65,0x73,0,0,0,0};
unsigned char key_buff[16]={0x53,0x74,0x54,0x3a,0,0,0,0x20,0x54,0x69,0x6d,0x65,0,0,0,0};

void adc_init(void);
unsigned int ADCtoBCD(unsigned int temp,unsigned int temp1,unsigned int choose);

void adc_init(void)
{
 PORTC = 0x7F; //m103 output only
 DDRC  = 0x7E;
 ADCSRA = 0x00; 
 ADMUX =(1<<REFS0)|(adc_mux&0x0f);//选择内部AVCC为基准
 ACSR  =(1<<ACD);//关闭模拟比较器
 ADCSRA=(1<<ADEN)|(1<<ADSC)|(1<<ADIE)|(1<<ADPS2)|(1<<ADPS1) ;//64分频
}

//ADC完成中断
#pragma interrupt_handler adc_isr:iv_ADC     
void adc_isr(void)
{
 adc_rel=ADC&0x3ff;
 ADMUX=(1<<REFS0)|(adc_mux&0x0f);//选择内部AVCC为基准
 ADCSRA|=(1<<ADSC);//启动AD转换
}

//将ADC得到的HEX数据转换成ASC码，供显示用，并加上了小数点。
unsigned int ADCtoBCD(unsigned int temp,unsigned int temp1,unsigned int choose)
 {
  unsigned int tt;
  unsigned char i;
  if(choose==1)
   { temp=tt=(unsigned int)(((unsigned long int)((unsigned long int)temp*Vref))/0x3ff);
  for(i=0;i<3;i++)
  {
   led_buff[14-i]=seg_table[temp%10];
   temp=temp/10;
   led_buff[6-i]=seg_table[temp1%10];
   temp1=temp1/10;
   }
   }
  else
   for(i=0;i<3;i++)
  {
   key_buff[14-i]=seg_table[temp%10];
   temp=temp/10;
   key_buff[6-i]=seg_table[temp1%10];
   temp1=temp1/10;
   }
   return tt;
 }