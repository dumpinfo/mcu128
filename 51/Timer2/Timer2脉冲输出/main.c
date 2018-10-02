#include"reg52.h"
#include"51usb.h"		   //51USBʵ����ͷ�ļ�

#define  uchar unsigned char
#define  uint  unsigned int

sfr  T2MOD	= 0xC9;

void initsys();			  //��ʼ��ϵͳ
void delay(uint ticks);




void main()
{
 initsys();
 LED=0;
 P1=0;
 while(1)
 {
  delay(5000); //Լ0.5s
  TR2^=1;	   //ֹͣTimer2
 }


}

void initsys()
{
 //(RCAP2L,RCAP2H)===>(TL2,TH2)
 TL2=0;
 TH2=0;
 RCAP2L=0;
 RCAP2H=0;

 T2MOD=0x02;
 TR2=1;	//Star Timer2

}

void delay(uint ticks)
{
 uchar i;
 for(;ticks!=0;ticks--)for(i=50;i!=0;i--);
}

