// 单片机演奏消防车的报警声音
// 作者：chenming
// 出处：伟纳电子论坛www.wllar.com


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
		{	case 0:frq++;break;			 //flag标志置0时,frq递增
			case 1:frq--;break;			 //flag标志置1时,frq递减
		}
		if (!(frq^0xff)) flag=1;		 //当frq增加到FFH时,flag置1,准备frq递减	
		if (!(frq^0x00)) flag=0;		 //当frq递减到00H时,flag置0,准备frq递增
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
// 延时子程序
{						
	unsigned char i;
	while(ms--)
	{
		for(i = 0; i < 120; i++);
	}
}
