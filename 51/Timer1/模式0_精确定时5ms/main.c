#include"reg51.h"
#include"51usb.h"		   //51USBʵ����ͷ�ļ�

#define  uchar unsigned char
#define  uint  unsigned int

void delay(uint ticks);// ��ʱ���������
void inittimer();
/*
�����Debugģʽ���������
�鿴states��sec
������������ÿ��5000us���е��ϵ�һ��
*/
void ISR_Timer1(void) interrupt 3 using 1
{
 TL1=0x1c;
 TH1=0x63;

}
 

void main()
{
 inittimer();
 while(1);
}

void inittimer()
{
 TL1=0x1c;
 TH1=0x63;
 TMOD=0x00;		//��ʱ��1ģʽ1
 TR1=1;			//������ʱ��1
 ET1=1;			//����ʱ��1�ж�
 EA=1;			//��ȫ���ж�
}
