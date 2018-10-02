#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */

void main(void)
 {
  //EnableInterrupts; /* enable interrupts */
  /* include your code here */
  CONFIG1=0x09; //关闭看门狗，5V模式
  
 // DDRA=0xff;
  
  T1SC_TSTOP=1; //stop T1
  T1SC_TRST=1;//reset T1 
  
  T1MODH=0x04;          // PWM period  0x400*1/(9.8704/4)us 
  T1MODL=0x00;
 
  T1CH0H=0x01;          //占空比  25%
  T1CH0L=0x00;
  
  T1SC0=0x1A;           //00011010;unbuffered PWM
                        //00101010:buffered PWM
                        //0001l000;占空比0%
                        //00011011;占空比100%  
  T1SC=0x00;
  while(1);

 } /* loop forever */

