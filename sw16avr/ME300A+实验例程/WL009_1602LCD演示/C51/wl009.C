/*******************************************************************************
*  标题:  ME300系列片机开发系统演示程序 - 1602LCD显示演示程序                  *
*  硬件： ME300A+,ME300B                                                       *
*  文件:  wl009.C                                                              *
*  日期:  2004-1-5                                                             *
*  版本:  1.0                                                                  *
*  作者:  伟纳电子 - Freeman                                                   *
*  邮箱:  freeman@willar.com                                                   *
*  网站： http://www.willar.com                                                *
********************************************************************************
*  描述:                                                                       *
*         1602字符型LCD显示演示程序                                            *
*         在第一行显示  welcome                                                *
*         在第一行显示  www.willar.com                                         *
********************************************************************************
*  跳线设置：                                                                  *
*     ME300A+    JP1 全部短接，JP2短接1-2端                                    *
*     ME300B     JP1 短接，JP2短接1-2端                                        *
*                                                                              *
********************************************************************************
* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
*******************************************************************************/


#include <reg51.h>
#include <intrins.h>

typedef unsigned char BYTE;
typedef unsigned int WORD;
typedef bit BOOL ; 

sbit rs	= P2^0;		//
sbit rw = P2^1;
sbit ep = P2^2;

BYTE code dis1[] = {"welcome!"};
BYTE code dis2[] = {"www.willar.com"};

delay(BYTE ms)
{							// 延时子程序
	BYTE i;
	while(ms--)
	{
		for(i = 0; i< 250; i++)
		{
			_nop_();
			_nop_();
			_nop_();
			_nop_();
		}
	}
}

BOOL lcd_bz()
{							// 测试LCD忙碌状态
	BOOL result;
	rs = 0;
	rw = 1;
	ep = 1;
	_nop_();
	_nop_();
	_nop_();
	_nop_();
	result = (BOOL)(P0 & 0x80);
	ep = 0;
	return result;	
}

lcd_wcmd(BYTE cmd)
{							// 写入指令数据到LCD
	while(lcd_bz());
	rs = 0;
	rw = 0;
	ep = 0;
	_nop_();
	_nop_();	
	P0 = cmd;
	_nop_();
	_nop_();
	_nop_();
	_nop_();
	ep = 1;
	_nop_();
	_nop_();
	_nop_();
	_nop_();
	ep = 0;		
}

lcd_pos(BYTE pos)
{							//设定显示位置
	lcd_wcmd(pos | 0x80);
}

lcd_wdat(BYTE dat)	
{							//写入字符显示数据到LCD
	while(lcd_bz());
	rs = 1;
	rw = 0;
	ep = 0;
	P0 = dat;
	_nop_();
	_nop_();
	_nop_();
	_nop_();
	ep = 1;
	_nop_();
	_nop_();
	_nop_();
	_nop_();
	ep = 0;	
}

lcd_init()
{							//LCD初始化设定
	lcd_wcmd(0x38);			//
	delay(1);
	lcd_wcmd(0x0c);			//
	delay(1);
	lcd_wcmd(0x06);			//
	delay(1);
	lcd_wcmd(0x01);			//清除LCD的显示内容
	delay(1);
}

main()
{
	BYTE i;
	lcd_init();				// 初始化LCD			
	delay(10);
	lcd_pos(4);				// 设置显示位置为第一行的第5个字符
	i = 0;
	while(dis1[i] != '\0')
	{						// 显示字符"welcome!"
		lcd_wdat(dis1[i]);
		i++;
	}
	lcd_pos(0x41);			// 设置显示位置为第二行第二个字符
	i = 0;
	while(dis2[i] != '\0')
	{
		lcd_wdat(dis2[i]);	// 显示字符"  www.willar.com  "
		i++;
	}
	while(1);				// 
}


