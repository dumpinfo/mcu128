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
void ISR_Timer0(void) interrupt 1 using 1
{
 TL0=0x1C;
 TH0=0x63;

}
 

void main()
{
 inittimer();
 while(1);
}

void inittimer()
{
 TL0=0x1C;
 TH0=0x63;
 TMOD=0x00;		//��ʱ��0ģʽ1
 TR0=1;			//������ʱ��0
 ET0=1;			//����ʱ��0�ж�
 EA=1;			//��ȫ���ж�
}
