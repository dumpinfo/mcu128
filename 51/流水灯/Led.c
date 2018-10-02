#include"reg51.h"
#include"51usb.h"		   //51USB实验板的头文件

#define  uchar unsigned char
#define  uint  unsigned int

void delay(uint ticks);// 延时程序的声明

void Left(void);		//向左移动
void Right(void);		//向右移动
void Left_A(void);		//向左移动增亮
void Right_A(void);		//向左动减灭
void Left_B(void);		//向右移动增亮
void Right_B(void);		//向右动减灭

void main()
{
 P1=0x0C;//选通LED,74HC138的Y6=0；请看原理图
 while(1)
 {
  Left();
  Right();
  Left_A();
  Right_A();
  Left_B();
  Right_B();
 }
}
//////////// 延时程序的实现////////////////////
void delay(uint ticks)
{
 uchar i;
 for(;ticks!=0;ticks--)
 	for(i=1000;i!=0;i--);
}

void Left()
{
 unsigned char i,temp;
 temp=0xfe;			 	
 LED=0xff;				//灭所有LED
 delay(100);			//延时
 for(i=8;i!=0;i--)
 {
   LED=temp;			//输出LED数据
   temp<<=1;			//LED数据左移动一位
   temp++;				//加一，为了熄灭最后一位LED
   delay(100);	  		//延时
 }

}

void Right()
{
 unsigned char i,temp;
 temp=0x7f;
 LED=0xff;				  //灭所有LED
 delay(100);
 for(i=8;i!=0;i--)
 {
   LED=temp;			 //输出LED数据
   temp>>=1;			 //LED数据右移动一位
   temp|=0x80;
   delay(100);	  
 }

}

void Left_A(void)
{
 unsigned char i,temp;
 temp=0xff;
 LED=0xff;				  //灭所有LED
 delay(100);
 for(i=8;i!=0;i--)
 {
   temp<<=1;			  //LED数据左移动一位
   LED=temp;			  //输出LED数据
   delay(100);	   
 }
}

void Right_A(void)
{
 unsigned char i,temp;
 temp=0;
 LED=0;					   //亮所有
 delay(100);
 for(i=8;i!=0;i--)
 {
   temp<<=1;			   //LED数据左移动一位
   temp++;				   //加一，为了熄灭最后一位LED
   LED=temp;			   //输出LED数据
   delay(100);	  
 }
}

void Left_B(void)
{
 unsigned char i,temp;
 temp=0xff;
 LED=0xff;				   //灭所有LED
 delay(100);
 for(i=8;i!=0;i--)
 {
   temp>>=1;			   //LED数据右移动一位
   LED=temp;			   //输出LED数据
   delay(100);	   
 }
}

void Right_B(void)
{
 unsigned char i,temp;
 temp=0xFF;
 LED=0;					   //亮所有LED
 delay(100);
 for(i=8;i!=0;i--)
 {
   temp>>=1;			   //LED数据右移动一位
   temp|=0x80;			   //最高位置一，为了熄灭最高一位LED
   LED=temp;			   //输出LED数据
   delay(100);	  
 }
}

