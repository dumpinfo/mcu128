///////////////////////////////////////////////////////
//
//          DEMO
//
// MCU: ATmega16   
// RST:	�ⲿRST
// BOD: BOD������������ƽ4V
// BOOTRST: ��λ���0��ִַ��
// OCDEN JTAGEN SP1EN CKOPT EESAVE BOOTSZ1 BOOTSZ0 BOOTRST
//   1      0   	0	  1      0      0       0       1	
// ʱ��Դ: �ڲ�RC 8M     
// BODLEVEL BODEN SUT1 SUT0 CKSEL3 CKSEL2 CKSEL1 CKSEL0
//     0      0    0     0    0       1     0       0
// ʱ��Դ: �ⲿ����	
// BODLEVEL BODEN SUT1 SUT0 CKSEL3 CKSEL2 CKSEL1 CKSEL0
//     0      0    0     1    1       1     1       1   		 
//ע: 1 - δ��̣����򲻴򹳣� 
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
	 
	 DDRA=0xff;			 //A��Ϊ����� 		
	 PORTA=0xff; 		 //A��ȫ�����1

	 while(1){
	 	for (i=0;i<8;i++) {	 
			PORTA=0xff; 	 
	 		PORTA&=~(1<<i);
			delay();
		}
	 }
}