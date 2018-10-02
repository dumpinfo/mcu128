/*******************************************************************************
*  标题:  ME300系列单片机开发系统演示程序 - 按键扫描程序                       *
*  硬件： ME300A+,ME300B                                                       *
*  文件:  wl005.C                                                              *
*  日期:  2004-1-5                                                             *
*  版本:  1.0                                                                  *
*  作者:  伟纳电子 - Freeman                                                   *
*  邮箱:  freeman@willar.com                                                   *
*  网站： http://www.willar.com                                                *
********************************************************************************
*  描述:                                                                       *
*         按键扫描程序                                                         *
*         上电时, 点亮P00口LED                                                 *
*         按下K1时, LED向右移一位                                              *
*         按下K2时, LED向左移一位                                              *
********************************************************************************
*  跳线设置：                                                                  *
*     ME300A+    JP1 全部短接，JP2短接2-3端                                    *
*     ME300B     JP1 短接，    JP2短接2-3端                                    *
*                                                                              *
********************************************************************************
* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
*******************************************************************************/

#include <reg51.h>
#include <intrins.h>

unsigned char scan_key();
void proc_key(unsigned char key_v);
void delayms(unsigned char ms);

sbit	K1 = P1^4;
sbit	K2 = P1^5;

main()
{
	
	unsigned char key_s,key_v;
	key_v = 0x03;
	P0 = 0xfe;
	while(1)
	{
		key_s = scan_key();
		if(key_s != key_v)
		{
			delayms(10);
			key_s = scan_key();
			if(key_s != key_v)
			{	
				key_v = key_s;
				proc_key(key_v);					
			}
		}
	}	
}

unsigned char scan_key()
{
	unsigned char key_s;
	key_s = 0x00;
	key_s |= K2;
	key_s <<= 1;
	key_s |= K1;
	return key_s;		
}

void proc_key(unsigned char key_v)
{
	if((key_v & 0x01) == 0)
	{
		P0 = _cror_(P0,1);
	}
	else if((key_v & 0x02) == 0)
	{
		P0 = _crol_(P0, 1);
	}
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
