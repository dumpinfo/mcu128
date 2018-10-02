#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "ioregs.h" 
#include "flash.h"

/*
writeram()   写ram
readram()
readflash()
ramtoflash() 写flash

*/

//从串口输入一个字符，输入的值是ASCII码的值
static unsigned char get_char(void)
{
	while (IO_SYSFLG1 & URXFE1);
	return IO_UARTDR1 & 0xff;
}
//输出一个字符到终端
static void put_char(unsigned char data)
{
		while (IO_SYSFLG1 & UTXFF1);
		IO_UARTDR1 = data;
}
static void put_num8(unsigned char i)
{
		put_char(((((i>>4) & 0x0f)  + '0')> '9' )? ((i>>4) & 0x0f) +'0'+7 : ((i>>4) & 0x0f) +'0' );
		put_char((((i & 0x0f)  + '0')> '9' )? (i & 0x0f) +'0'+7 : (i & 0x0f) +'0' );
}
static void put_num16(int i)
{
	put_num8((unsigned char)(( i>>8) & 0xff));
	put_num8( (unsigned char) (i & 0xff));
}
static void put_num32(int i)
{
 		put_num8( (unsigned char) (i & 0xff));
		put_num8((unsigned char)(( i>>8) & 0xff));
		put_num8( (unsigned char) (i>>16 & 0xff));
		put_num8((unsigned char)(( i>>24) & 0xff));
}
void writeram(int length)
{
	int i;
for(i=0;i<length;i+=1000)
RAM_WORD(i*4)=0x12345678;

}
void readram(int length)
{
	int i;
for(i=0;i<length;i+=1000)
	{
	put_num32(RAM_WORD(i*4));
	put_char('\n');
	}
}

void ramtoflash(int length)
{
int point=0,j,block,t,k,buffer;
buffer=0x000f000f;
//首先得到需要擦除的block个数
block=length/(128*1024);
if (block*128*1024!=length)
block=block+1;
put_num32(block);
//擦除

for(t=0;t<block;t++ )
{
	FLASH_BYTE(t<<16)=0x50;
	FLASH_BYTE(t<<16)=0x20;
	FLASH_BYTE(t<<16)=0xD0;
	while((FLASH_WORD(t<<16)&0x0080)!=0x0080);
	FLASH_BYTE(t<<16)=0x50;
}

for(t=0x0000;t<length;t=t+0x10000)			//每次写一个block
	{	
	for(j=0;j<32;j+=32)
		{	FLASH_BYTE(t)=0x50;
			FLASH_BYTE(t)=0xE8;
			put_char('S');
			while((FLASH_WORD(t)&0x0080)!=0x0080);
			FLASH_BYTE(t)=buffer;
			for(k=0;k<=buffer/2;k++)
				FLASH_WORD(j+k*4)=0x11111111;
			FLASH_BYTE(t)=0xD0;
			while((FLASH_WORD(t)&0x0080)!=0x0080);
				put_char('A');FLASH_BYTE(t)=0xFF;
		}

	
	}
}


void readflash(int length)
{
	int i;
//FLASH_BYTE(0)=0x50;
for(i=0x0;i<0x0+0x16;i++)
	{
	put_num32(FLASH_WORD(i*4));
	put_char('\n');
	}
}
void readID()
{
	int i;
	FLASH_BYTE(0)=0x90;
	put_num8(FLASH_BYTE(0));
	put_num8(FLASH_BYTE(2));	
	FLASH_BYTE(0)=0xFF;
	
}
void readConf()
{
	int i;
	FLASH_BYTE(0)=0xB8;
	put_num8(FLASH_BYTE(0));
	put_num8(FLASH_BYTE(2));		
	}
void clearBlock0()
{
	FLASH_BYTE(0)=0x50;
	FLASH_BYTE(0)=0x20;
	FLASH_BYTE(0)=0xD0;
	while((FLASH_WORD(0)&0x0080)!=0x0080);
	FLASH_BYTE(0)=0x50;
	
}


void  C_vMain(void)
{
	int length;
	length=1000;
for(;;){
	switch (get_char())
	{
	case 'w':
		writeram(length);
		break;
	case 'r':
		readram(length);
		break;
	case 't':
		ramtoflash(length);
		break;
	case 'd':
		readflash(length);
		break;
	case 'i':
		readID();
		break;
	case 'c':
		readConf();
		break;
	case 'e':
		clearBlock0();
		break;
	default:
		put_char('?');
		break;
	}

}

}