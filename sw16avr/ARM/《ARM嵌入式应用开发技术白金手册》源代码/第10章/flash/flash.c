#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "ioregs.h" 
#include "flash.h"

//初始化串口1
char str[20];
void init_uart1(void)
{
	
IO_UBRLCR1 = (IO_UBRLCR1 & ~BRDIV) | BR_9600;
IO_UBRLCR1 = IO_UBRLCR1 | FIFOEN;
IO_UBRLCR1 = (IO_UBRLCR1 & ~WRDLEN) | (3<<WRDLEN_SHIFT);
IO_SYSCON1 |=  UART1EN;

}
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
//输出两个字符
static void put_word(int data)
{
	put_char((data>>8)&0xff);
	put_char(data&0xff);
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
//输出字符串到串口
static void put_string(char *pt)
{
        while(*pt)put_char(*pt++);
}

void 	read_block(short int blockNo,int len){
int i;
FLASH_BYTE(blockNo<<16)=0xFF;
for (i=0;i<len ;i++ )
{
	put_num32(FLASH_WORD((blockNo<<16)+i*4));
	put_char('\n');
}

}

void 	erase_block(short int blockNo){
	int i;
FLASH_BYTE(blockNo<<16)=0x50;
FLASH_BYTE(blockNo<<16)=0x20;
FLASH_BYTE(blockNo<<16)=0xD0;
//for (i=0;i<50 ;i++ )

while(FLASH_WORD(blockNo<<15)!=0x00800080)

FLASH_BYTE(blockNo<<16)=0x50;

FLASH_BYTE(blockNo<<16)=0xFF;
}
void 	read_idcode(){
/*put_string("The ID Code is:");
//FLASH_BYTE(0)=0x50;
FLASH_BYTE(0)=0x90;
put_num32(FLASH_WORD(0));
put_num32(FLASH_WORD(4));
*/
}

void	write_block(){
	
	//向block 0 写一段数据20个word
int ba,i,buffer,j,size;
ba=0x0000;
buffer=0x000F;

size=90;       //写8个word的0

//FLASH_BYTE(ba)=0x60;
//FLASH_BYTE(ba)=0xd0;
//put_string("s....\n");
for(i=ba;i<ba+size;i=i+buffer/2)
	{

	FLASH_BYTE(ba)=0x50;
	FLASH_BYTE(ba)=0xE8;
	while((FLASH_WORD(ba)&0x0080)!=0x0080);

	FLASH_BYTE(ba)=buffer;
	for(j=0;j<=buffer/2;j++)
	FLASH_WORD(i+j*4)=RAM_WORD(i+j*4);
	
	FLASH_BYTE(ba)=0xD0;

	while((FLASH_WORD(ba)&0x0080)!=0x0080);

	
	//put_string("do....\n");
	FLASH_BYTE(i)=0xff;
	}

//put_string("done\n");

}
void copytoram()
{
	int i;
for(i=0;i<500 ;i++ )
	RAM_WORD(i*4)=FLASH_WORD(i*4);


}

void readram()
{
	int i;
/*for (i=0;i<50 ;i++ )
{
	put_num32(RAM_WORD(i*4));
	put_char('\n');
}
*/
}

void clear_ram()
{
	int i;
for(i=0;i<500 ;i++ )
	RAM_WORD(i*4)=0x0;
}

void jump()
{
/*	__asm {

        ldr r0,[0xC0000000]
        mov r1,pc       
        add pc,r1,r0
        nop      	 }
*/
}

void  C_vMain(void)
{
/*
	__asm {
	str	sp,[0xc0000000]
	str	r14,[0xc0000004]
	str pc,[0xc0000008]
	}
*/
	__asm{
	ldr	r0, [0x80002000]
	mov r1,0x61
	str r1,[r0,#0x2c0]
	}

	strcpy(str,"Hello World!\n");
	init_uart1();
	put_string(str);
	while(1){
	switch (get_char()) {
	case 'l':
			clear_ram();
			break;
	case 'r':
			read_block(0,50);
			break;
	case 'e':
			erase_block(0);
			break;
	case 'w':
			write_block();
			break;
	case 'j':
			jump();
			break;
	case 'i':
			read_idcode();
			break;
	case 'c':
			copytoram();		//把自己拷贝到内存里面然后跳转指针到所拷贝的内存地址开始运行
			break;
	case 'd':
			readram();		//读取刚才读到的数据
			break;

	default:

			//put_string("*input s to start network"); 			
			break;
		}
		}
}
