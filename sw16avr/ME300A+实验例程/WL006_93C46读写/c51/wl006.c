/*******************************************************************************
*  标题:  ME300系列单片机开发系统演示程序 -  AT93C46读写演示程序               *
*  硬件： ME300A+,ME300B                                                       *
*  文件:  wl006.C                                                              *
*  日期:  2004-1-5                                                             *
*  版本:  1.0                                                                  *
*  作者:  伟纳电子 - Freeman                                                   *
*  邮箱:  freeman@willar.com                                                   *
*  网站： http://www.willar.com                                                *
********************************************************************************
*  描述:                                                                       *
*         AT93C46读写演示程序                                                  *
*         从地址0x00开始写入数据“www.willar.com”， 然后再读出                  *
*                                                                              *
*         注意：在擦除或写入数据之前，必须先写入EWEN指令，93C46右边的JP7跳线   *
*               用于8位和16位模式选择，默认为8位模式                           *
********************************************************************************
*  跳线设置：                                                                  *
*     ME300A+    JP1 全部短接，JP2短接3-4端                                    *
*     ME300B     JP1 短接，JP2短接3-4端，JP3短接93端                           *
*                                                                              *
********************************************************************************
* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
*******************************************************************************/


#include <reg51.h>
#include <intrins.h>

//define OP code
#define OP_EWEN_H		0x00	// 00					write enable
#define OP_EWEN_L		0x60	// 11X XXXX				write enable
#define OP_EWDS_H		0x00	// 00					disable
#define OP_EWDS_L		0x00	// 00X XXXX				disable

#define OP_WRITE_H		0x40	// 01 A6-A0				write data
#define OP_READ_H		0x80	// 10 A6-A0				read data

#define OP_ERASE_H		0xc0	// 11 A6-A0				erase a word

#define OP_ERAL_H		0x00	// 00					erase all
#define OP_ERAL_L		0x40	// 10X XXXX				erase all
#define OP_WRAL_H		0x00	// 00  					write all	
#define OP_WRAL_L		0x20	// 01X XXXX		 		write all	


//define pin
sbit CS = P3^4;
sbit SK = P3^3;
sbit DI	= P3^5;
sbit DO = P3^6;

unsigned char code dis_code[] = {0x7e,0xbd,0xdb,0xe7,0xdb,0xbd,0x7e,0xff};

void start();
void ewen();
void ewds();
void erase();
void write(unsigned char addr, unsigned char indata);
unsigned char read(unsigned char addr);
void inop(unsigned char op_h, unsigned char op_l);
void shin(unsigned char indata);
unsigned char shout();
void delayms(unsigned char ms);

main()
{
	unsigned char i;
	CS = 0;				//初始化端口
	SK = 0;
	DI = 1;
	DO = 1;

	ewen();				// 使能写入操作
	erase();			// 擦除全部内容
		
	for(i = 0 ; i < 8; i++)		//写入显示代码到AT93C46
	{
		write(i, dis_code[i]);
	}
	
	ewds();				// 禁止写入操作	
	
	i = 0;
	while(1)
	{
		P0 = read(i);	// 循环读取AT93C46内容，并输出到P0口
		i++;
		i &= 0x07;		// 循环读取地址为0x00～0x07
		delayms(250);		
	}
}


void write(unsigned char addr, unsigned char indata)
// 写入数据indata到addr
{
	inop(OP_WRITE_H, addr);	// 写入指令和地址
		shin(indata);
		CS = 0;
	delayms(10);			// Twp
}

unsigned char read(unsigned char addr)
// 读取addr处的数据
{
	unsigned char out_data;
	inop(OP_READ_H, addr);	// 写入指令和地址
	out_data = shout();
	CS = 0;	
	return out_data;
}

void ewen()
{
	inop(OP_EWEN_H, OP_EWEN_L);
	CS= 0;
}

void ewds()
{
	inop(OP_EWDS_H, OP_EWDS_L);
	CS= 0;	
}

void erase()
{
	inop(OP_ERAL_H, OP_ERAL_L);
	delayms(30);
	CS = 0;
}


void inop(unsigned char op_h, unsigned char op_l)
//移入op_h的高两位和op_l的低7位
//op_h为指令码的高两位
//op_l为指令码的低7位或7位地址
{	

	unsigned char i;
	
	SK = 0;		// 开始位
	DI = 1;
	CS = 1;
	_nop_();
	_nop_(); 
	SK = 1;
	_nop_();
	_nop_();
	SK = 0;		// 开始位结束

	DI = (bit)(op_h & 0x80);	// 先移入指令码高位
	SK = 1;
	op_h <<= 1;
	SK = 0;		

	DI = (bit)(op_h & 0x80);	// 移入指令码次高位
	SK = 1;
	_nop_();
	_nop_();	
	SK = 0;
	
	// 移入余下的指令码或地址数据
	op_l <<= 1;	
	for(i = 0; i < 7; i++)		
	{
		DI = (bit)(op_l & 0x80);	// 先移入高位
		SK = 1;
		op_l <<= 1;
		SK = 0;		
	}
	DI = 1;		
}


void shin(unsigned char indata)		
//移入数据
{
	unsigned char i;
	for(i = 0; i < 8; i++)
	{
		DI = (bit)(indata & 0x80);	// 先移入高位
		SK = 1;
		indata <<= 1;
		SK = 0;		
	}
	DI = 1;
}

unsigned char shout(void)			
// 移出数据
{
	unsigned char i, out_data;
	for(i = 0; i < 8; i++)
	{
		SK = 1;
		out_data <<= 1;
		SK = 0;
		out_data |= (unsigned char)DO;
	}
	return(out_data);
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
