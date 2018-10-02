#include"reg51.h"
#include"51usb.h"		   //51USBʵ����ͷ�ļ�

#define  uchar unsigned char
#define  uint  unsigned int

void delay(uint ticks);// ��ʱ���������

void Left(void);		//�����ƶ�
void Right(void);		//�����ƶ�
void Left_A(void);		//�����ƶ�����
void Right_A(void);		//���󶯼���
void Left_B(void);		//�����ƶ�����
void Right_B(void);		//���Ҷ�����

void main()
{
 P1=0x0C;//ѡͨLED,74HC138��Y6=0���뿴ԭ��ͼ
 while(1)
 {
  Left();
  Right();
  Left_A();
  Right_A();
  Left_B();
  Right_B();
 }
}
//////////// ��ʱ�����ʵ��////////////////////
void delay(uint ticks)
{
 uchar i;
 for(;ticks!=0;ticks--)
 	for(i=1000;i!=0;i--);
}

void Left()
{
 unsigned char i,temp;
 temp=0xfe;			 	
 LED=0xff;				//������LED
 delay(100);			//��ʱ
 for(i=8;i!=0;i--)
 {
   LED=temp;			//���LED����
   temp<<=1;			//LED�������ƶ�һλ
   temp++;				//��һ��Ϊ��Ϩ�����һλLED
   delay(100);	  		//��ʱ
 }

}

void Right()
{
 unsigned char i,temp;
 temp=0x7f;
 LED=0xff;				  //������LED
 delay(100);
 for(i=8;i!=0;i--)
 {
   LED=temp;			 //���LED����
   temp>>=1;			 //LED�������ƶ�һλ
   temp|=0x80;
   delay(100);	  
 }

}

void Left_A(void)
{
 unsigned char i,temp;
 temp=0xff;
 LED=0xff;				  //������LED
 delay(100);
 for(i=8;i!=0;i--)
 {
   temp<<=1;			  //LED�������ƶ�һλ
   LED=temp;			  //���LED����
   delay(100);	   
 }
}

void Right_A(void)
{
 unsigned char i,temp;
 temp=0;
 LED=0;					   //������
 delay(100);
 for(i=8;i!=0;i--)
 {
   temp<<=1;			   //LED�������ƶ�һλ
   temp++;				   //��һ��Ϊ��Ϩ�����һλLED
   LED=temp;			   //���LED����
   delay(100);	  
 }
}

void Left_B(void)
{
 unsigned char i,temp;
 temp=0xff;
 LED=0xff;				   //������LED
 delay(100);
 for(i=8;i!=0;i--)
 {
   temp>>=1;			   //LED�������ƶ�һλ
   LED=temp;			   //���LED����
   delay(100);	   
 }
}

void Right_B(void)
{
 unsigned char i,temp;
 temp=0xFF;
 LED=0;					   //������LED
 delay(100);
 for(i=8;i!=0;i--)
 {
   temp>>=1;			   //LED�������ƶ�һλ
   temp|=0x80;			   //���λ��һ��Ϊ��Ϩ�����һλLED
   LED=temp;			   //���LED����
   delay(100);	  
 }
}

