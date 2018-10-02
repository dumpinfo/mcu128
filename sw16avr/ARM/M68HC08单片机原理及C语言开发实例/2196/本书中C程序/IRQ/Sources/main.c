#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */

void main(void) {
	CONFIG1 = 0x39;
    DDRD = 0xFF;	   //PortD设置为输出
	PTD = 0x00;        //PortD输出都为低电平 与中断无关仅为指示作用			
	INTSCR1_IMASK1 = 0;//允许IRQ1中断
	INTSCR1_MODE1 = 1; //触发方式选择为下降沿和低电平
    EnableInterrupts;  //enable interrupts 
    for(;;);		   //死循环
}
/*IRQ1中断服务程序*/
interrupt  void IRQ1_ISR(void)
{
	INTSCR1_IMASK1 = 1;//为防止误中断，屏蔽中断
	PTD_PTD4 = 1;
	PTD_PTD5 = 1;      //通过两个口控制两个发光管，指示是否进入了中断
	INTSCR1_ACK1 = 1;  //确认中断，清除中断锁存
	INTSCR1_IMASK1 = 0;//退出前开启中断	
}
