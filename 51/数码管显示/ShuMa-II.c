#include"reg51.h"
#include"51usb.h"			  //51USBʵ���ͷ�ļ�

#define  uchar unsigned char
#define  uint  unsigned int
///////���������//////////
/*
C51��ʽ:
unsigned char code Tab[]={0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,
                          0x80,0x90,0x88,0x83,0xC6,0xA1,0x86,0x8E};
������Ը�ʽ:
TAB:    DB C0H,F9H,A4H,B0H
        DB 99H,92H,82H,F8H
        DB 80H,90H,88H,83H
        DB C6H,A1H,86H,8EH
��ѡ�񲢸��Ƶ��ı���ȥ��
*/
void delay(uint ticks);// ��ʱ���������
unsigned char code Tab[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,
                          0x7F,0x6F,0x77,0x7C,0x39,0x5E,0x79,0x71};
void main()
{
 uchar i=0,j=0;
 while(1)
 {
	 XBYTE[0x100]= Tab[1];
	 XBYTE[0x200]= Tab[2];
	 XBYTE[0x400]= Tab[3];
	 XBYTE[0x800]= Tab[4];
	 XBYTE[0x1000]= Tab[5];
	 XBYTE[0x2000]= Tab[6];
	 XBYTE[0x4000]= Tab[7];
	 XBYTE[0x8000]= Tab[8];
 }
}
//////////// ��ʱ�����ʵ��////////////////////
void delay(uint ticks)
{
 uchar i;
 for(;ticks!=0;ticks--)for(i=200;i!=0;i--);
}