	.module demo.c
	.area text(rom, con, rel)
	.dbfile D:\AVR\demo\demo.c
	.dbfunc e delay _delay fV
;              i -> R16
;              j -> R18
	.even
_delay::
	.dbline -1
	.dbline 27
; ///////////////////////////////////////////////////////
; //
; //          DEMO
; //
; // MCU: ATmega16   
; // RST:	外部RST
; // BOD: BOD功能允许，电平4V
; // BOOTRST: 复位后从0地址执行
; // OCDEN JTAGEN SP1EN CKOPT EESAVE BOOTSZ1 BOOTSZ0 BOOTRST
; //   1      0   	0	  1      0      0       0       1	
; // 时钟源: 内部RC 8M     
; // BODLEVEL BODEN SUT1 SUT0 CKSEL3 CKSEL2 CKSEL1 CKSEL0
; //     0      0    0     0    0       1     0       0
; // 时钟源: 外部晶振	
; // BODLEVEL BODEN SUT1 SUT0 CKSEL3 CKSEL2 CKSEL1 CKSEL0
; //     0      0    0     1    1       1     1       1   		 
; //注: 1 - 未编程（检查框不打钩） 
; //////////////////////////////////////////////////////		 
; #include <iom16v.h>
; 
; typedef  unsigned char uchar;
; typedef  unsigned int  uint;
; typedef  unsigned long ulong;
; 
; uchar i;
; 
; void delay(void) {
	.dbline 29
	clr R16
	xjmp L5
L2:
	.dbline 29
; 	 uchar i,j;
; 	 for (i=0;i<255;i++) {
	.dbline 30
	clr R18
	xjmp L9
L6:
	.dbline 30
	.dbline 31
	NOP
	.dbline 32
	NOP
	.dbline 33
	NOP
	.dbline 34
	NOP
	.dbline 35
	NOP
	.dbline 36
	NOP
	.dbline 37
	NOP
	.dbline 38
	NOP
	.dbline 39
L7:
	.dbline 30
	inc R18
L9:
	.dbline 30
	cpi R18,255
	brlo L6
	.dbline 40
L3:
	.dbline 29
	inc R16
L5:
	.dbline 29
	cpi R16,255
	brlo L2
	.dbline -2
L1:
	.dbline 0 ; func end
	ret
	.dbsym r i 16 c
	.dbsym r j 18 c
	.dbend
	.dbfunc e main _main fV
	.even
_main::
	.dbline -1
	.dbline 42
; 	 	 for (j=0;j<255;j++) {
; 		 	 asm("NOP");
; 			 asm("NOP");
; 			 asm("NOP");
; 			 asm("NOP");
; 			 asm("NOP");
; 			 asm("NOP");
; 			 asm("NOP");
; 			 asm("NOP");
; 		}
; 	 }
; }
; void main(void){
	.dbline 44
; 	 
; 	 DDRA=0xff;			 //A口为输出口 		
	ldi R24,255
	out 0x1a,R24
	.dbline 45
; 	 PORTA=0xff; 		 //A口全部输出1
	out 0x1b,R24
	xjmp L12
L11:
	.dbline 47
; 
; 	 while(1){
	.dbline 48
	clr R2
	sts _i,R2
	xjmp L17
L14:
	.dbline 48
	.dbline 49
	ldi R24,255
	out 0x1b,R24
	.dbline 50
	lds R17,_i
	ldi R16,1
	xcall lsl8
	mov R2,R16
	com R2
	in R3,0x1b
	and R3,R2
	out 0x1b,R3
	.dbline 51
	xcall _delay
	.dbline 52
L15:
	.dbline 48
	lds R24,_i
	subi R24,255    ; addi 1
	sts _i,R24
L17:
	.dbline 48
	lds R24,_i
	cpi R24,8
	brlo L14
	.dbline 53
L12:
	.dbline 47
	xjmp L11
X0:
	.dbline -2
L10:
	.dbline 0 ; func end
	ret
	.dbend
	.area bss(ram, con, rel)
	.dbfile D:\AVR\demo\demo.c
_i::
	.blkb 1
	.dbsym e i _i c
