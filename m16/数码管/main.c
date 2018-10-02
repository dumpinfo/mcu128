//ICC-AVR application builder : 2007-6-11 20:45:01
// Target : M16
// Crystal: 4.0000Mhz
//使用了PA口和PB口，其中PA口作为数据口，PB口作为地址口。
//该程序使用了定时器T0，采用循环扫描方式显示8位数据
#include "seg7.h"
#include <iom16v.h>
#include <macros.h>

unsigned char addr=1,ldata = 0,jdata = 0,i=0;//定义几个变量

unsigned char kdata[] = {1,2,3,4,5,6,7,8};//需要显示的数据
void port_init(void)
{
 PORTA = 0xFF;
 DDRA  = 0xFF;
 PORTB = 0xFF;
 DDRB  = 0xFF;
 PORTC = 0x00; //m103 output only
 DDRC  = 0x00;
 PORTD = 0x00;
 DDRD  = 0x00;
}

//TIMER0 initialize - prescale:64
// WGM: Normal
// desired value: 1KHz
// actual value:  1.008KHz (0.8%)
void timer0_init(void)
{
 TCCR0 = 0x00; //stop
 TCNT0 = 0xC2; //set count
 OCR0  = 0x3E;  //set compare
 TCCR0 = 0x03; //start timer
}

#pragma interrupt_handler timer0_ovf_isr:10
void timer0_ovf_isr(void)
{
 TCNT0 = 0xC2; //reload counter value
 PORTB = addr; //地址送如PB口
 jdata = kdata[i];//取出需要显示的数据
 ldata = seg7[jdata];//数据译码成7段SEG数据
 PORTA = ldata;//数据送如PA口
 
 i++;         //取数地址加1
 addr = addr<<1;//显示地址左移
 if(addr == 0)//如果显示完8位后，返回到第一位
  {addr = 1;
   i = 0;
  }
 
 
}

//call this routine to initialize all peripherals
void init_devices(void)
{
 //stop errant interrupts until set up
 CLI(); //disable all interrupts
 port_init();
 timer0_init();

 MCUCR = 0x00;
 GICR  = 0x00;
 TIMSK = 0x01; //timer interrupt sources
 SEI(); //re-enable interrupts
 //all peripherals are now initialized
}

//
void main(void)
{
 init_devices();
 //insert your functional code here...
}

