#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */

uint temp1, temp2;
uchar F_data;

void delay(uint num)
{
  uint i;
  for(i=0;i<num;i++)
  {}
 } 
     
void main(void) {
  EnableInterrupts; /* enable interrupts */
  /* include your code here */
  CONFIG1=0x09; //�رտ��Ź���5Vģʽ
  
  T1SC_TSTOP=1; //�رն�ʱ��
  T1SC_TRST=1;  //reset T1,counter��0
   
  T1SC=0x06; //������ʱ���� ��Ƶϵ��64(bus clock is 2.4576MHz,timer clock is 38.4KHz)
 // T1SC0=0x4c;//ʹ�ܲ����жϣ������غ��½��ز���
 // T1SC0=0x44;//ʹ�ܲ����жϣ������ز���
  T1SC0=0x48;//ʹ�ܲ����жϣ������ز���
   
  temp1=0;
  temp2=0;
  F_data=0;
  DDRD=0xff;//���ģʽ
  PTD=0;
  while(1)
  { 
     if(temp1>=temp2)
     {
        F_data=(uchar)(temp1-temp2);
     }
     else
     {
         F_data=(uchar)(0xffff-temp2+temp1);  
      }
      PTD=0xff;//light the leds 
      delay(5000);
      delay(5000);
      delay(5000);
      delay(5000); 
      delay(5000);
       
      PTD=F_data; //if there's no input,F_data will always be 0
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
      PTD=(F_data<<4); 
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
interrupt void T1_CH0_ISR(void)
{
   T1SC0_CH0IE=0;
   T1SC0_CH0F=0;
   temp2=temp1;
   temp1=T1CH0H;
   temp1=(temp1<<8)+T1CH0L;
   T1SC0_CH0IE=1;
   //PTD=0x55;
}