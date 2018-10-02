#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */

void main(void) {
 
  CONFIG1 = 0x39;
  DDRD =  0xF0;     //PTD高四位作为输出，低四位作为输入
  PTD &= 0x0F;      //PTD高四位输出初始值为0
  KBSCR_MODEK = 1;  //选择触发方式为下降沿和低电平
   /*Initialize KeyBoard(to prevent a false interrupt)*/
  KBSCR_IMASKK = 1;
  KBIER = 0x0F;     
  KBSCR_ACKK = 1;
  KBSCR_IMASKK = 0;  
  EnableInterrupts; /* enable interrupts */
  for(;;);
}

interrupt  void  KBI_ISR(void)
{
    KBSCR_IMASKK = 1;  //屏蔽键盘中断
    if(PTD_PTD0==0)    //在中断服务程序中查询是由哪一个口引起的中断 
    {
      PTD=0;
      PTD_PTD4 = 1;    //点亮指示试验板指示灯用作验证
    }
    if(PTD_PTD1==0) 
    {
      PTD=0;
      PTD_PTD5 = 1;
    }
	KBSCR_ACKK = 1;   //清除中断确认，避免误中断
	KBSCR_IMASKK = 0; //不屏蔽键盘中断
}
