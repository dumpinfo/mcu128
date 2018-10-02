/*******************************************************************************
*  标题:  ME300系列单片机开发系统演示程序 -  报警声程序                        *
*  硬件： ME300A,ME300S,ME300A+,ME300B                                         *
*  文件:  wl002.C                                                              *
*  日期:  2004-1-5                                                             *
*  版本:  1.0                                                                  *
*  作者:  伟纳电子 - Freeman                                                   *
*  邮箱:  freeman@willar.com                                                   *
*  网站： http://www.willar.com                                                *
********************************************************************************
*  描述:                                                                       *
*         单片机模拟报警声                                                     *
*                                                                              *
********************************************************************************
*  跳线设置：                                                                  *
*     ME300A+    JP1 全部短接，                                                *
*     ME300B     JP1 短接，                                                    *
*                                                                              *
*                                                                              *
********************************************************************************
* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
*******************************************************************************/
                   
#include <reg51.h>
#include <intrins.h>

sbit	SPK = P3^7;

unsigned char frq; 

void delayms(unsigned char ms);

main()
{
	TMOD = 0x01;
	frq = 0x00;
	TH0 = 0x00;
	TL0 = 0xff;	
	TR0 = 1;
	IE = 0x82;
	
	while(1)
	{
		frq++;
		delayms(1);
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