#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */

#define N  4
void delay(int num)
{
	int i;
	for(i=0;i<num;i++);
}

void main(void)
{
    CONFIG1 = 0x09;				/* COP dis,  5v	模式	*/
	
	PCTL_PLLON=0;// 关闭锁相环电路  
	
	PWMDR2 = 0x40;                        
	PWMDR1 = 0x40;				//占空比25％  0x40/0xFF'
	PWMDR0 = 0x40;
	
	PWMCCR = 0x02;              //选用CGMOUT作为PWM的输入时钟，预分频系数为4
	
	//PWMPCR=0x1A;                 //相位寄存器：
	//PWMPCR_PHEN=1;               //使能相位寄存器
	 
	PWMCR= 0x07;                 //配置PWM输出口
	PWMCR |= 0xE0;               //使能1
	
  while(1);      /* loop forever */

}
