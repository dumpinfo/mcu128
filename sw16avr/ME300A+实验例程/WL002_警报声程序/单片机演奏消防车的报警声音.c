// ��Ƭ�������������ı�������
// ���ߣ�chenming
// ������ΰ�ɵ�����̳www.wllar.com


#include <reg51.h>
#include <intrins.h>
sbit	SPK = P3^7;
unsigned char frq; 
unsigned int flag;			
void delayms(unsigned char ms);
void main()
{	
	TMOD = 0x01;
	frq = 0x00;
	TH0 = 0x00;
	TL0 = 0xff;	
	TR0 = 1;
	IE = 0x82;
	flag=0;
	while(1)
	{
		switch(flag)
		{	case 0:frq++;break;			 //flag��־��0ʱ,frq����
			case 1:frq--;break;			 //flag��־��1ʱ,frq�ݼ�
		}
		if (!(frq^0xff)) flag=1;		 //��frq���ӵ�FFHʱ,flag��1,׼��frq�ݼ�	
		if (!(frq^0x00)) flag=0;		 //��frq�ݼ���00Hʱ,flag��0,׼��frq����
		delayms(15);	
	}
}		
void timer0() interrupt 1 using 1
{
	TH0 = 0xfe;
	TL0 = frq;
	SPK = ~SPK;	
}

void delayms(unsigned char ms)	
// ��ʱ�ӳ���
{						
	unsigned char i;
	while(ms--)
	{
		for(i = 0; i < 120; i++);
	}
}
