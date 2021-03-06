#include"reg51.h"
#include"51usb.h"			   //51USB实验板的头文件

#define  uchar unsigned char
#define  uint  unsigned int
//////以下函数用于LCD的操作///////////
void delay();					//判断LCD是否忙
void writedata(uchar lcddata); //写数据到LCD
void writecom(uchar lcddata);  //写命令到LCD
void writeline(uchar *str);	   //写一串数据到LCD
void initlcd();				  //初始化LCD

void  main()
{
 initlcd();
 writeline("www.ourembed.com");
 writecom(0xc0);	//第二行
 writeline("TEL:13979813332");
 while(1)	;
}

void delay()
{
 while(RCOM&0x80); //读状态寄存器，如果LCD忙，就一直读。
}

void writedata(uchar lcddata)
{
 WDAT=lcddata; //写数据到LCD
 delay();
}
/////////////////////////////////
void writecom(uchar lcddata)
{
 WCOM=lcddata;//写命令到LCD
 delay();
}

void writeline(uchar *str)
{
 while(*str)writedata(*str++);
}

///////////////////////////////////
void initlcd()
{
 writecom(0x01);	//清屏
 writecom(0x38);	//功能设置
 writecom(0x0f);	//显示开关控制
 writecom(0x06);	//设置输入模式
 writecom(0x01);	//清屏
 writecom(0x80);	//回车
}
///////////////////////////////////