/*******************************************************************************
*  标题:  ME300系列单片机开发系统演示程序 - 读写AT24C02演示程序                *
*  硬件:  ME300A+                                                              *
*  文件:  wl007.C                                                              *
*  日期:  2004-1-5                                                             *
*  版本:  1.0                                                                  *
*  作者:  伟纳电子 - Freeman                                                   *
*  邮箱:  freeman@willar.com                                                   *
*  网站： http://www.willar.com                                                *
********************************************************************************
*  描述:                                                                       *
*         读写AT24C02演示程序                                                  *
*                                                                              *
********************************************************************************
*  跳线设置：                                                                  *
*         JP1 全部短接，JP2短接2-3端                                           *
*                                                                              *
********************************************************************************
* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
*******************************************************************************/


#include <reg51.h>
#include <intrins.h>

#define	OP_READ	0xa1		// 器件地址以及读取操作
#define	OP_WRITE 0xa0		// 器件地址以及写入操作
#define	MAX_ADDR 0x7f		// AT24C02最大地址

unsigned char code dis_code[] = {0x7e,0xbd,0xdb,0xe7,0xdb,0xbd,0x7e,0xff};
				// 写入到AT24C01的数据串

sbit SDA = P1^3;
sbit SCL = P3^3;


void start();
void stop();
unsigned char shin();
bit shout(unsigned char write_data);
unsigned char read_random(unsigned char random_addr);
void write_byte( unsigned char addr, unsigned char write_data);
void fill_byte(unsigned char fill_data);
void delayms(unsigned char ms);

main(void)
{
	unsigned char i;
	SDA = 1;
	SCL = 1;
	fill_byte(0xff);		// 全部填充0xff

	for(i = 0 ; i < 8; i++)		//写入显示代码到AT24Cxx
	{
		write_byte(i, dis_code[i]);
	}

	i = 0;
	while(1)
	{

		P0 = read_random(i);	// 循环读取24Cxx内容，并输出到P0口
		i++;
		i &= 0x07;		// 循环读取范围为0x00～0x07
		delayms(250);
	}
}

void start()
// 开始位
{
	SDA = 1;
	SCL = 1;
	_nop_();
	_nop_();
	SDA = 0;
	_nop_();
	_nop_();
	_nop_();
	_nop_();
	SCL = 0;
}

void stop()
// 停止位
{
	SDA = 0;
	_nop_();
	_nop_();
	SCL = 1;
	_nop_();
	_nop_();
	_nop_();
	_nop_();
	SDA = 1;
}

unsigned char shin()
// 从AT24Cxx移入数据到MCU
{
	unsigned char i,read_data;
	for(i = 0; i < 8; i++)
	{
		SCL = 1;
		read_data <<= 1;
		read_data |= (unsigned char)SDA;
		SCL = 0;
	}
	return(read_data);
}
bit shout(unsigned char write_data)
// 从MCU移出数据到AT24Cxx
{
	unsigned char i;
	bit ack_bit;
	for(i = 0; i < 8; i++)		// 循环移入8个位
	{
		SDA = (bit)(write_data & 0x80);
		_nop_();
		SCL = 1;
		_nop_();
		_nop_();
		SCL = 0;
		write_data <<= 1;
	}
	SDA = 1;			// 读取应答
	_nop_();
	_nop_();
	SCL = 1;
	_nop_();
	_nop_();
	_nop_();
	_nop_();
	ack_bit = SDA;
	SCL = 0;
	return ack_bit;			// 返回AT24Cxx应答位
}

void write_byte(unsigned char addr, unsigned char write_data)
// 在指定地址addr处写入数据write_data
{
	start();
	shout(OP_WRITE);
	shout(addr);
	shout(write_data);
	stop();
	delayms(10);		// 写入周期
}

void fill_byte(unsigned char fill_data)
// 填充数据fill_data到EEPROM内
{
	unsigned char i;
	for(i = 0; i < MAX_ADDR; i++)
	{
		write_byte(i, fill_data);
	}

}

unsigned char read_current()
// 在当前地址读取
{
	unsigned char read_data;
	start();
	shout(OP_READ);
	read_data = shin();
	stop();
	return read_data;
}

unsigned char read_random(unsigned char random_addr)
// 在指定地址读取
{
	start();
	shout(OP_WRITE);
	shout(random_addr);
	return(read_current());
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