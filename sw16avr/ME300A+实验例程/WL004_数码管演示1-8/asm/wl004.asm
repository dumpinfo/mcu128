;********************************************************************************
;*  标题:  ME300系列开发系统演示程序 - LED数码管显示1-8                         *
;*  硬件： ME300A,ME300A+,ME300B                                                *
;*  文件:  wl004.asm                                                            *
;*  日期:  2004-1-5                                                             *
;*  版本:  1.0                                                                  *
;*  作者:  伟纳电子 - Freeman                                                   *
;*  邮箱:  freeman@willar.com                                                   *
;*  网站： http://www.willar.com                                                *
;********************************************************************************
;*  描述:                                                                       *
;*         LED数码管显示演示程序                                                *
;*         在8个LED数码管上依次显示1,2,3,4,5,6,7,8                              *
;*                                                                              *
;********************************************************************************
;*  跳线设置：                                                                  *
;*     ME300A+    JP1 全部短接，JP2短接2-3端                                    *
;*     ME300B     JP1 短接，    JP2短接2-3端                                    *
;*                                                                              *
;********************************************************************************
;* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
;* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
;********************************************************************************

CODE_SEG	SEGMENT	CODE 

DATA_SEG	SEGMENT	DATA 

	RSEG  DATA_SEG
	
dis_digit:	DS		1
dis_index:	DS		1
dis_buf:	DS		8
stack:		DS		20

;===========================================================

CSEG	AT	00000H				; Reset向量
	LJMP	MAIN

CSEG	AT	0000BH				; 定时器0中断向量

	LJMP	TIMER0


;===========================================================
	RSEG  CODE_SEG	
MAIN:
	MOV	SP,#(stack-1)			; 初始化堆栈指针
	MOV  	P0,#0FFH			; 初始化I/O口
	MOV  	P2,#0FFH
	MOV  	TMOD,#01H			; 初始化timer0
	MOV  	TH0,#0FCH
	MOV  	TL0,#017H
	MOV  	IE,#082H
	
	MOV	DPTR, #DIS_CODE		; 设定显示初值
	MOV	A,#1
	MOVC	A,@A+DPTR
	MOV  	dis_buf,A
	MOV	A,#2
	MOVC	A,@A+DPTR	
	MOV  	dis_buf+01H,A
	MOV	A,#3
	MOVC	A,@A+DPTR
	MOV  	dis_buf+02H,A
	MOV	A,#4
	MOVC	A,@A+DPTR
	MOV  	dis_buf+03H,A
	MOV	A,#5
	MOVC	A,@A+DPTR
	MOV  	dis_buf+04H,A
	MOV	A,#6
	MOVC	A,@A+DPTR
	MOV  	dis_buf+05H,A
	MOV	A,#7
	MOVC	A,@A+DPTR
	MOV  	dis_buf+06H,A
	MOV	A,#8
	MOVC	A,@A+DPTR
	MOV  	dis_buf+07H,A
	
	MOV  	dis_digit,#0FEH		; 初始从第一个数码管开始扫描
	MOV  	dis_index,A

	SETB 	TR0					; 启动定时器0，开始动态扫描显示

MAIN_LP:					

	; 主程序循环，增加其它代码				

	SJMP 	MAIN_LP

; END OF main


;===========================================================

	USING	0
TIMER0:
; 定时器0中断服程序, 用于数码管的动态扫描
; DIS_INDEX --- 显示索引, 用于标识当前显示的数码管和缓冲区的偏移量
; DIS_DIGIT --- 位选通值, 传送到P2口用于选通当前数码管的数值, 如等于0xfe时,
;		选通P2.0口数码管
; DIS_BUF   --- 显于缓冲区基地址		

	PUSH 	ACC
	PUSH 	PSW
	PUSH 	AR0
	
	MOV  	TH0,#0FCH
	MOV  	TL0,#017H
	
	MOV  	P2,#0FFH		; 先关闭所有数码管
	
	MOV  	A,#DIS_BUF		; 获得显示缓冲区基地址
	ADD  	A,DIS_INDEX		; 获得偏移量
	MOV  	R0,A			; R0 = 基地址 + 偏移量
	MOV  	A,@R0			; 获得显示代码
	MOV  	P0,A			; 显示代码传送到P0口
	
	MOV  	P2,DIS_DIGIT		; 

	MOV	A,DIS_DIGIT		; 位选通值左移, 下次中断时选通下一位数码管
	RL	A
	MOV	DIS_DIGIT,A
	
	INC	DIS_INDEX		; DIS_INDEX加1, 下次中断时显示下一位
	ANL	DIS_INDEX,#0x07		; 当DIS_INDEX等于8(0000 1000)时, 清0

	POP  	AR0
	POP  	PSW
	POP  	ACC
	
	RETI 
; END OF timer0
;===========================================================

	RSEG  CODE_SEG
DIS_CODE:
	DB	0C0H
	DB	0F9H
	DB	0A4H
	DB	0B0H
	DB	099H
	DB	092H
	DB	082H
	DB	0F8H
	DB	080H
	DB	090H
	DB	0FFH

	END
