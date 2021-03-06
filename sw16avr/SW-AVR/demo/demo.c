///////////////////////////////////////////////////////
//
//          DEMO
//
// MCU: ATmega16   
// RST:	外部RST
// BOD: BOD功能允许，电平4V
// BOOTRST: 复位后从0地址执行
// OCDEN JTAGEN SP1EN CKOPT EESAVE BOOTSZ1 BOOTSZ0 BOOTRST
//   1      0   	0	  1      0      0       0       1	
// 时钟源: 内部RC 8M     
// BODLEVEL BODEN SUT1 SUT0 CKSEL3 CKSEL2 CKSEL1 CKSEL0
//     0      0    0     0    0       1     0       0
// 时钟源: 外部晶振	
// BODLEVEL BODEN SUT1 SUT0 CKSEL3 CKSEL2 CKSEL1 CKSEL0
//     0      0    0     1    1       1     1       1   		 
//注: 1 - 未编程（检查框不打钩） 
//////////////////////////////////////////////////////		 
#include <iom16v.h>

typedef  unsigned char uchar;
typedef  unsigned int  uint;
typedef  unsigned long ulong;

uchar i;

void delay(void) {
	 uchar i,j;
	 for (i=0;i<255;i++) {
	 	 for (j=0;j<255;j++) {
		 	 asm("NOP");
			 asm("NOP");
			 asm("NOP");
			 asm("NOP");
			 asm("NOP");
			 asm("NOP");
			 asm("NOP");
			 asm("NOP");
		}
	 }
}
void main(void){
	 
	 DDRA=0xff;			 //A口为输出口 		
	 PORTA=0xff; 		 //A口全部输出1

	 while(1){
	 	for (i=0;i<8;i++) {	 
			PORTA=0xff; 	 
	 		PORTA&=~(1<<i);
			delay();
		}
	 }
}