#include"reg51.h"
#include"absacc.h"
#include"stdio.h"
//�����ʣ�4.8K
/*
��򿪴��ڵ��Թ��ߣ�ѡ������4800
*/
void init();
void main()
{
 init();
 printf("\nwww.lgmcu.com\n");
 while(1);
}


void init()
{
 TMOD=0x20;	 //Timer1 ģʽ2
 TH1=0xF3;	 //
 TL1=0xF3;	 //
 TR1=1;		 //����Timer1
 PCON|=0x80; //�����ʼӱ�
 SCON=0x50;	 //���ô���
 TI=1;
 EA=0;
}


