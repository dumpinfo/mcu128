#include"reg51.h"
#include"51usb.h"			   //51USBʵ����ͷ�ļ�

#define  uchar unsigned char
#define  uint  unsigned int
//////���º�������LCD�Ĳ���///////////
void delay();					//�ж�LCD�Ƿ�æ
void writedata(uchar lcddata); //д���ݵ�LCD
void writecom(uchar lcddata);  //д���LCD
void writeline(uchar *str);	   //дһ�����ݵ�LCD
void initlcd();				  //��ʼ��LCD


void delay_ms(uint ticks);


void  main()
{
 uchar i;
 initlcd();
 while(1)
 {
	writeline("www.ourmebed.com");
	writecom(0xc0);	//�ڶ���
	writeline("TEL:13979813332");
	for(i=0;i!=16;i++)
	{
		 delay_ms(1000);
		 writecom(0x1C); //���ƶ�

	}
	for(i=0;i!=32;i++)
	{
	     delay_ms(1000);
		 writecom(0x18); //���ƶ�		 
	}
	 writecom(0x01);	//����
	 writecom(0x80);	//�س�
 }
}


void delay_ms(uint ticks)
{
 uchar i;
 for(;ticks!=0;ticks--)
 	for(i=200;i!=0;i--);

}
////////////////////////////////////
void delay()
{
 while(RCOM&0x80); //��״̬�Ĵ��������LCDæ����һֱ����
}

void writedata(uchar lcddata)
{
 WDAT=lcddata; //д���ݵ�LCD
 delay();
}
/////////////////////////////////
void writecom(uchar lcddata)
{
 WCOM=lcddata;//д���LCD
 delay();
}

void writeline(uchar *str)
{
 while(*str)writedata(*str++);
}

///////////////////////////////////
void initlcd()
{
 writecom(0x01);	//����
 writecom(0x38);	//��������
 writecom(0x0f);	//��ʾ���ؿ���
 writecom(0x06);	//��������ģʽ
 writecom(0x01);	//����
 writecom(0x80);	//�س�
}
///////////////////////////////////