//AM12864参考程序(st7920)
/********************************************/
/* AM12864系列测试程序 1.0for mega16 */
/* Designed by ourembed.com */
/* 2003.04.23 */
/********************************************/
//ICC-AVR application builder : 2006-11-7 18:33:11
// Target : M16
// Crystal: 4.0000Mhz

#include <iom16v.h>
#include <macros.h>

#include "12864.H"




void port_init(void)
{
 PORTA = 0xFF;
 DDRA  = 0xFF;
 PORTB = 0xFF;
 DDRB  = 0xFF;
 PORTC = 0xFF; //m103 output only
 DDRC  = 0xFF;
 PORTD = 0xFF;
 DDRD  = 0xFF;
}

//call this routine to initialise all peripherals
void init_devices(void)
{
 //stop errant interrupts until set up
 CLI(); //disable all interrupts
 port_init();

 MCUCR = 0x00;
 GICR  = 0x00;
 TIMSK = 0x00; //timer interrupt sources
 SEI(); //re-enable interrupts
 //all peripherals are now initialised
}

//
void main(void)
{int i,j;
 init_devices();
 //insert your functional code here...
 init_lcd();
 Test(0x10);
 Test(0x23);
 Test(0x35);
 init_lcd();         //LCD初始化
 Testlcd2(0XA0,0XC1);//根据LCD12864自带字库，显示需要显示的汉字
 Testlcd2(0XA0,0XC1);
 Testlcd2(0XB6,0XBB);
 Testlcd2(0XAD,0XD3);
 Testlcd2(0XE2,0XB9);
 Testlcd2(0XD9,0XC1);
 Testlcd2(0XA0,0XC1);
 Testlcd2(0XA0,0XC1);
 Testlcd2(0XA0,0XC1);
 Testlcd2(0XB6,0XC7);
 Testlcd2(0XEB,0XC8);
 Testlcd2(0XBD,0XCA);
 Testlcd2(0XAA,0XC1);
 Testlcd2(0XCB,0XC3);/**/
 
 
} 

