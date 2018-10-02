/*******************************************************************************
*  标题:  ME300系列单片机开发系统演示程序 -  LED数码管显示1-8                  *
*  硬件： ME300A,ME300A+,ME300B                                                *
*  文件:  wl004.C                                                              *
*  日期:  2004-1-5                                                             *
*  版本:  1.0                                                                  *
*  作者:  伟纳电子 - Freeman                                                   *
*  邮箱:  freeman@willar.com                                                   *
*  网站： http://www.willar.com                                                *
********************************************************************************
*  描述:                                                                       *
*         LED数码管显示演示程序                                                *
*         在8个LED数码管上依次显示1,2,3,4,5,6,7,8                              *
*                                                                              *
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

unsigned char data dis_digit;
unsigned char code dis_code[11]={0xc0,0xf9,0xa4,0xb0,	// 0, 1, 2, 3
				0x99,0x92,0x82,0xf8,0x80,0x90, 0xff};// 4, 5, 6, 7, 8, 9, off 
unsigned char data dis_buf[8];
unsigned char data dis_index;

void main()
{
	P0 = 0xff;
	P2 = 0xff;
	TMOD = 0x01;
	TH0 = 0xFC;
	TL0 = 0x17;
	IE = 0x82;

	dis_buf[0] = dis_code[0x1];
	dis_buf[1] = dis_code[0x2];
	dis_buf[2] = dis_code[0x3];
	dis_buf[3] = dis_code[0x4];
	dis_buf[4] = dis_code[0x5];
	dis_buf[5] = dis_code[0x6];
	dis_buf[6] = dis_code[0x7];
	dis_buf[7] = dis_code[0x8];
	
	dis_digit = 0xfe;
	dis_index = 0;
	
	TR0 = 1;
	while(1);

}

void timer0() interrupt 1
// 定时器0中断服务程序, 用于数码管的动态扫描
// dis_index --- 显示索引, 用于标识当前显示的数码管和缓冲区的偏移量
// dis_digit --- 位选通值, 传送到P2口用于选通当前数码管的数值, 如等于0xfe时,
//				选通P2.0口数码管
// dis_buf   --- 显于缓冲区基地址	
{
	TH0 = 0xFC;
	TL0 = 0x17;
	
	P2 = 0xff;							// 先关闭所有数码管
	P0 = dis_buf[dis_index];			// 显示代码传送到P0口
	P2 = dis_digit;						// 

	dis_digit = _crol_(dis_digit,1);	// 位选通值左移, 下次中断时选通下一位数码管
	dis_index++;						// 
					
	dis_index &= 0x07;			// 8个数码管全部扫描完一遍之后，再回到第一个开始下一次扫描
}
