#include <stdio.h>

void ramtoflash(int length)
{
int point=0,block,t,k;
//首先得到需要擦除的block个数
block=length/(128*1024);
if (block*128*1024!=length)
block=block+1;

//擦除
for(t=0;t<block;t++ )
{
	FLASH_BYTE(t<<16)=0x50;
	FLASH_BYTE(t<<16)=0x20;
	FLASH_BYTE(t<<16)=0xD0;
	while(FLASH_WORD(t<<16)!=0x00800080);
}

//擦完了开始写

for(t=0;t<length;t=t+0x10000)			//每次写一个block
	{
	for(j=0;j<0x10000;j+=4)
		{
			FLASH_BYTE(t+j)=0x60;
			FLASH_BYTE(t+j)=0xd0;
			FLASH_BYTE(t+j)=0x50;
			FLASH_BYTE(t+j)=0xE8;
			while(FLASH_WORD(t+j)!=0x00800080);
			for(k=0;k<8;k++)
				{
				FLASH_WORD(point)=RAM_WORD(point);
				point=point+4;
				}
			FLASH_BYTE(t+j)=0xD0;
			while(FLASH_WORD(t+j)!=0x00800080);

		}
	
	
	}
}
