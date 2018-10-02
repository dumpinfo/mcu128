#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */

#define N  4
void delay(int num)
{
	int i;
	for(i=0;i<num;i++);
}

void main(void) {
 // EnableInterrupts; /* enable interrupts */
  /* include your code here */
  uchar  adc_result[N];
  
  CONFIG1=0x09; //5������ģʽ,�رտ��Ź�
  CONFIG2=0x10; // ѡ���ⲿ������Ϊʱ��Դ
  
  ADICLK=0x10; // ѡ���ڲ�����ʱ����ΪADC��ʱ�ӡ�
  ADASCR=0x07; // �Զ�ɨ��ģʽ �� ATD0~ATD3;
  
  DDRD=0xff;   // PTDΪ���   
  PTD=0;       // ��ʼ��PTDΪ0
  
  //������ʼ��

  adc_result[3]=0;
  adc_result[2]=0;
  adc_result[1]=0;
  adc_result[0]=0;
  
  ADSCR=0x00;   //����ADC
  
  while(1)       /* loop forever */
  {
      if(ADSCR_COCO==1)   //�Ƿ�ת�����
      {

          adc_result[0]=ADR0L;  //�������ֵ
          adc_result[1]=ADR1L;  //�������ֵ
          adc_result[2]=ADR2L;
          adc_result[3]=ADR3L;
          //����PPTD4~7�ϵ�4������ʾ����ֲ
	      PTD= adc_result[0] ;  
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      PTD=(adc_result[0]<<4);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	       PTD= adc_result[1] ;  
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      PTD=(adc_result[1]<<4);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	       PTD= adc_result[2] ;  
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      PTD=(adc_result[2]<<4);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	       PTD= adc_result[3];   
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      PTD=(adc_result[3]<<4);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      delay(5000);
	      ADSCR=0x00;   //����ADC

	   }
     
  }
}
