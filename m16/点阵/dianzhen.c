//ICC-AVR application builder : 2007-6-12 20:23:24
// Target : M16
// Crystal: 4.0000Mhz
//该程序采用了循环扫描方式现在汉字，其中用B口作为地址口，用A口作为数据口
//循环扫描地址，显示相应的数据，达到显示整个汉字的目的

#include <iom16v.h>
#include <macros.h>
unsigned char data1[]={0xff,0xfd,0xbd,0xbd,0x81,0xbd,0xbd,0xfd};//需要显示的汉字1
unsigned char data2[]={0xff,0xfd,0xeb,0xe7,0x8f,0xe7,0xeb,0xfd};//需要显示的汉字2
unsigned char addr = 1,i = 0;//addr是用来循环扫描的地址位，即某一位如果为高的话，该列就显示发来的数据
long int j = 0;   //j用来做为选择是否显示汉字1或者汉字2
void port_init(void)
{
 PORTA = 0x00;   //PA
 DDRA  = 0xFF;   //PA口输出
 PORTB = 0x00;
 DDRB  = 0xFF;   //PB口输出
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
               //在定时器中完成显示
 
 PORTB = addr;  //地址送入PB口  
 
 j++;          //选择汉字变量+1
 if(j<5000)    //如果小于5000，显示A
 PORTA = data1[i];
 else
 PORTA = data2[i]; //如果大于5000，显示B
 
 if(j>10000)     //大于10000，清零
 j=0;
 
 i++;            //数据数组地址+1
 
 addr= addr<<1;  //显示口地址左移
 
 if(addr == 0)   //判断是否显示完8个位，如果显示完，回到初始值
  {
   addr =1;
   i=0;
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

