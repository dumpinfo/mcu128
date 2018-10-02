/*
测试sdram中的数据模块是否有错误！

*/

#include "ioregs.h" 
#include "flash.h"
#include "put.h"

void writeram(int n){
int i;
for(i=0;i<n;i+=4)
RAM_WORD(i)=0xFFFFFFFF;
}

void readram(int n){
int i;
int temp=0xffffffff;
for(i=0;i<n;i+=4)
	{if(RAM_WORD(i)!=0xFFFFFFFF){
	put_num32(i);put_char('*');
	temp=temp&i;
	put_num32(temp);put_char('\n');
	if (temp==0)
	{
		return;
	}		
}

}

}

delay()
{
int i,j;
for(i=0;i<1000;i++)
j++;


}


void writeandread(int n){
int i,j=0;
unsigned long temp=0xABCDEF12;
for(i=0;i<n;i+=4)
	{
	j=j+4;
	RAM_WORD(i)=temp;
	if(RAM_WORD(i)!=temp){
	put_num32(i);put_char(':');put_num32(RAM_WORD(i));
	//put_char(':');put_num32(RAM_WORD(i));
	//put_char(':');put_num32(RAM_WORD(i));
	//put_char(':');put_num32(RAM_WORD(i));
	
	put_char('*');

	//temp=temp&i;
	//put_num32(temp);
	put_char('\n');
	//if (temp==0)
	//{
	//	return;
	//}		
	}	
	if(j==4*1024)
		{
		j=0;
		put_char('.');
		}
}
}
void ramtest(int addr)
{
	int i=0,temp;
	RAM_WORD(addr)=0xF0F0F0F0;

	while(1){
	i++;
	temp=RAM_WORD(addr);
	if(temp!=0xF0F0F0F0)
	{
		put_num32(i);put_char('*');
		put_num32(temp);
		put_char('\n');
	}
	if (i>1000000)
	{
		return;
	}
	}
}
void ramtest1()
{
	int data=0xF0F0F0F0,temp,count=0,i,j;
	for(i=0;i<0x020;i+=4)
	{
	RAM_WORD(i)=data;
		for(j=0;j<100;j++)
		{
		j=j+1;j=j-1;
		}
	temp=RAM_WORD(i);
	if (temp!=data)
	{
		put_num32(i);put_char(':');put_num32(temp);put_char('\n');break;
		RAM_WORD(i)=data;
		//发现第一个错误的地址
		count=0;
			get_char();
		while(count<2){
			RAM_WORD(i)=data;
					for(j=0;j<1000;j++)
					{
					j=j+1;j=j-1;
					}

			temp=RAM_WORD(i);count++;
			if (temp!=data){
			put_num32(count);put_char('-');
			put_num32(temp);put_char('\n');
			}
		}
		}
	if ((i|0xFFFF1000)==0xFFFF1000)
	{
	//	put_num32(i);put_char('\n');
	}


	
	}

}

void ramtest2()
{
;
}
void  C_vMain(void)
{
	//writeram(500000);
	//readram(500000);
	//writeandread(2000);
	//ramtest(0x00000B00);
	put_char('s');
	get_char();
	writeandread(0x1000000);

	//ramtest1();
	put_char('D');
	}