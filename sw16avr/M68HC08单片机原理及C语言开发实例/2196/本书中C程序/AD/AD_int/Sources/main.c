#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */

//#define  unsigned char  uchar
//#define  unsigned int   uint 

#define  N 10
uchar  adc_result[N],i;

void delay(int num)
{
	int i;
	for(i=0;i<num;i++);
}

void main(void) 
{
  uchar j,max,min;
  uint  temp;
  EnableInterrupts; /* enable interrupts */
  
  /* include your code here */
  
  CONFIG1=0x09; //5������ģʽ���رտ��Ź�
  CONFIG2=0x10; //ѡ��x-tal
   
  ADICLK=0x10; // ѡ���ڲ�����ʱ����ΪADC��ʱ�ӡ�
  
  DDRD=0xff;   // PTDΪ���
  PTD=0;       // ��ʼ��PTDΪ0

  //��ʼ������
  for(j=0;j<N;j++)
  {
      adc_result[j]=0;
  }
  i=0;
  temp=0;
  ADSCR=0x00;     //ͨ��0
  ADSCR_AIEN=1;  //ʹ���ж�
  while(1)       /* loop forever */
  {
       // ʮ�β���ֲȡƽ�������˲�����
     if(i>=N)
     {
        //ADSCR=0x1f;  //�ر�ADC
        i=0;
        temp=0;
        for(j=0;j<N;j++)
        {  
            max=adc_result[0];
            min=adc_result[0];
           if(max<adc_result[j])
           {
               max=adc_result[j];
           }
           if(min>adc_result[j])
           {
               min=adc_result[j];
           }
           temp+=adc_result[j];
         }
         temp=(temp-max-min)/(N-2);
         //����PPTD4~7�ϵ�4������ʾ����ֲ
	     PTD=(uchar)temp;   
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
         //delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);
	     PTD=(uchar)(temp<<4);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);   
	     PTD=0xff;
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);
      }
        
  }
}

interrupt void _ADC_int(void)
{
       ADSCR_AIEN=0;  //��ֹ�ж�
       adc_result[i]=ADR0L;  //�������ֵ
       i++;       
       ADSCR=0x00;          //ѡ��ͨ��0
       ADSCR_AIEN=1;         //ʹ���ж�
}
