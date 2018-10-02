#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */

uchar  led_data;
void main(void)
{
  EnableInterrupts; /* enable interrupts */
  /* include your code here */
  CONFIG1=0x09;   //关闭看门狗， 5V模式
  T1SC_TSTOP=1;   //停止计时器1
  T1SC_TRST=1;//reset  T1
  T1SC=0x46;   //使能溢出中断,64分频 总线时钟9.8304MHz/4
  T1MODH=0x4B; // 定时0.5s
  T1MODL=0x00;
  
  
  DDRD=0xff;  //PTD设置为输出
  PTD=0;
  led_data=0x80;//初始化变量
  while(1); /* loop forever */
}
interrupt void T1_OverFlow_ISR(void)
{
   T1SC_TOIE=0;
   //T1SC&=~0x80;
   T1SC_TOF=0;
   if(led_data<0x10)
   {
       led_data=0x80;
   }    
   PTD=led_data;
   led_data=(led_data>>1);
   T1SC_TOIE=1;
  }