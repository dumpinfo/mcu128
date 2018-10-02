#line 1 "E:\新建文件夹\avr资料\例程\m16\1602\second.c"







#line 1 "c:/icc/include/iom16v.h"




#line 7 "c:/icc/include/iom16v.h"


#line 10 "c:/icc/include/iom16v.h"


#line 13 "c:/icc/include/iom16v.h"


#line 16 "c:/icc/include/iom16v.h"
























































































































































































































































































































































































































































































































#line 9 "E:\新建文件夹\avr资料\例程\m16\1602\second.c"
#line 1 "c:/icc/include/macros.h"






























#line 35 "c:/icc/include/macros.h"














void _StackCheck(void);
void _StackOverflowed(char);




#line 10 "E:\新建文件夹\avr资料\例程\m16\1602\second.c"
#line 1 "E:\新建文件夹\avr资料\例程\m16\1602/1602.h"




#line 1 "c:/icc/include/iom16v.h"




#line 7 "c:/icc/include/iom16v.h"


#line 10 "c:/icc/include/iom16v.h"


#line 13 "c:/icc/include/iom16v.h"


#line 16 "c:/icc/include/iom16v.h"
























































































































































































































































































































































































































































































































#line 6 "E:\新建文件夹\avr资料\例程\m16\1602/1602.h"
#line 1 "c:/icc/include/macros.h"






























#line 35 "c:/icc/include/macros.h"




















#line 7 "E:\新建文件夹\avr资料\例程\m16\1602/1602.h"















void lcd_init(void);
void lcd_write_command(unsigned char command,unsigned char wait_en);
void lcd_write_data(unsigned char char_data);
void wait_enable(void);
void display_a_char(unsigned char position,unsigned char char_data);
void display_a_string(unsigned char col,unsigned char *ptr);
void delay_1ms(void);
void delay_nms(unsigned int n);
const unsigned char seg_table[]={0x30,0x31,0x32,0x33,0x34,0x35,
0x36,0x37,0x38,0x39};




void lcd_init(void)
{
 delay_nms(100);
 lcd_write_command(0x38,0);
 delay_nms(20);
 lcd_write_command(0x38,0);
 delay_nms(20);
 lcd_write_command(0x38,0);
 delay_nms(20);

 lcd_write_command(0x38,1);
 lcd_write_command(0x08,1);
 lcd_write_command(0x01,1);
 lcd_write_command(0x06,1);
 lcd_write_command(0x0c,1);
}



void delay_1ms(void)
{
 unsigned int i;
 for(i=0;i<1600;i++);
}


void delay_nms(unsigned int n)
{
 unsigned int i;
 for(i=0;i<n;i++)delay_1ms();
}


void lcd_write_command(unsigned char command,unsigned char wait_en)
{
 if(wait_en)wait_enable();
(*(volatile unsigned char *)0x32)&=~(1<<2);
(*(volatile unsigned char *)0x32)&=~(1<<3);
(*(volatile unsigned char *)0x32)&=~(1<<4);
 asm("nop");
(*(volatile unsigned char *)0x32)|=(1<<4);
(*(volatile unsigned char *)0x3B)=command;
(*(volatile unsigned char *)0x32)&=~(1<<4);
}



void display_a_char(unsigned char position,unsigned char char_data)
{
 unsigned char position_tem;
 if(position>=0x10)
 position_tem=position+0xb0;
 else
 position_tem=position+0x80;
 lcd_write_command(position_tem,1);
 lcd_write_data(char_data);
}



void display_a_string(unsigned char col,unsigned char *ptr)
{
 unsigned char col_tem,i;
 col_tem=col<<4;
 for(i=0;i<16;i++)
 display_a_char(col_tem++,*(ptr+i));
}


void lcd_write_data(unsigned char char_data)
{
 wait_enable();
(*(volatile unsigned char *)0x32)|=(1<<2);
(*(volatile unsigned char *)0x32)&=~(1<<3);
(*(volatile unsigned char *)0x32)&=~(1<<4);
 asm("nop");
(*(volatile unsigned char *)0x32)|=(1<<4);
(*(volatile unsigned char *)0x3B)=char_data;
(*(volatile unsigned char *)0x32)&=~(1<<4);
}



void wait_enable(void)
{
(*(volatile unsigned char *)0x3A)&=~ 0x80;
(*(volatile unsigned char *)0x32)&=~(1<<2);
(*(volatile unsigned char *)0x32)|=(1<<3);
 asm("nop");
(*(volatile unsigned char *)0x32)|=(1<<4);
 while((*(volatile unsigned char *)0x39)& 0x80);
(*(volatile unsigned char *)0x32)&=~(1<<4);
(*(volatile unsigned char *)0x3A)|= 0x80;
}

#line 11 "E:\新建文件夹\avr资料\例程\m16\1602\second.c"
unsigned char led_buff[]="0000    ";
unsigned char str1[]="0000";


void timer1_init(void);
void init_devices(void);
unsigned char KeyPress(void);
void delay_ms(unsigned int time);
void StartCount(void);
void StopCount(void);
void Clear(void);
unsigned int hour=0,minute=0,second=0,ms=0;
unsigned char c_next=0,choose=0;

void port_init(void)
{
(*(volatile unsigned char *)0x38) = 0xFF;
(*(volatile unsigned char *)0x37)  = 0xFF;
(*(volatile unsigned char *)0x35) = 0xFF;
(*(volatile unsigned char *)0x34)  = 0xFF;
(*(volatile unsigned char *)0x32) = 0xFF;
(*(volatile unsigned char *)0x31)  = 0xFF;
(*(volatile unsigned char *)0x3B) = 0xFF;
(*(volatile unsigned char *)0x3A)  = 0xFF;
}





void timer1_init(void)
{
(*(volatile unsigned char *)0x4E) = 0x00;
(*(volatile unsigned char *)0x4D) = 0x63;
(*(volatile unsigned char *)0x4C) = 0xc0;
(*(volatile unsigned char *)0x4B) = 0x17;
(*(volatile unsigned char *)0x4A) = 0x70;
(*(volatile unsigned char *)0x49) = 0x17;
(*(volatile unsigned char *)0x48) = 0x70;
(*(volatile unsigned char *)0x47)  = 0x17;
(*(volatile unsigned char *)0x46)  = 0x70;
(*(volatile unsigned char *)0x4F) = 0x00;
(*(volatile unsigned char *)0x4E) = 0x00;
}

#pragma interrupt_handler timer1_ovf_isr:9
void timer1_ovf_isr(void)
{

(*(volatile unsigned char *)0x4D) = 0x63;
(*(volatile unsigned char *)0x4C) = 0xc0;
}


void init_devices(void)
{

 asm("cli");
 port_init();
 timer1_init();

(*(volatile unsigned char *)0x55) = 0x0A;
(*(volatile unsigned char *)0x5B)  = 0x00;
(*(volatile unsigned char *)0x59) = 0x04;
 asm("sei");

}


void main(void)
{
 init_devices();
 lcd_init();

 display_a_string(0,led_buff);
 display_a_string(1,str1);


}


void delay_ms(unsigned int time)
{ unsigned int i,j;

  for(j=0;j<time;j++)
  { for(i=0;i<1000;i++)
     time=time;
  }
}




