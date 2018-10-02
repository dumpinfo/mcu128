#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */


void delay(int num)
{
	int i;
	for(i=0;i<num;i++);
}

void main(void) {
 // EnableInterrupts; /* enable interrupts */
  /* include your code here */
  uchar  adc_result[10],i,j;
  uint   temp;
  
  
  CONFIG1=0x09; //5������ģʽ,�رտ��Ź� 
  ADICLK=0x10; // ѡ���ڲ�����ʱ����ΪADC��ʱ�ӡ�
  
  DDRD=0xff;   // PTDΪ���
  PTD=0;       // ��ʼ��PTDΪ0
  //ADSCR=0x00;   //����ת��
  ADSCR=0x20;     //����ת��
  temp=0;
  for(i=0;i<10;i++)
  {
     adc_result[i]=0;
  }
  i=0;
  while(1)       /* loop forever */
  {
      if(ADSCR_COCO==1)   //�Ƿ�ת�����
      {
          adc_result[i]=ADR0L;  //�������ֵ
          
          i++;
          // ʮ�β���ֲȡƽ�������˲�����
          if(i==10)
          {
              i=0; 
              temp=0;
              for(j=0;j<10;j++)
              {
                   temp=temp+adc_result[j];
              }
              temp=temp/10;
              //����PPTD4~7�ϵ�4������ʾ����ֲ
		      PTD=(uchar)temp;   
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
		      PTD=(uchar)(temp<<4);
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
		      PTD=0xff;
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
                
          }
         
      }
      
      
  }
}
