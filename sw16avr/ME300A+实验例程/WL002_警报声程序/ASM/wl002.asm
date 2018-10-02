;********************************************************************************
;*  标题:  ME300系列单片机开发系统演示程序 - 报警声程序                         *
;*  硬件： ME300A,ME300S,ME300A+,ME300B                                         *
;*  文件:  wl002.asm                                                            *
;*  日期:  2004-1-5                                                             *
;*  版本:  1.0                                                                  *
;*  作者:  伟纳电子 - Freeman                                                   *
;*  邮箱:  freeman@willar.com                                                   *
;*  网站： http://www.willar.com                                                *
;********************************************************************************
;*  描述:                                                                       *
;*         单片机模拟报警声                                                     *
;*                                                                              *
;********************************************************************************
;*  跳线设置：                                                                  *
;*     ME300A+    JP1 全部短接，                                                *
;*     ME300B     JP1 短接，                                                    *
;*                                                                              *
;*                                                                              *
;********************************************************************************    
;* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
;* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *  
;********************************************************************************

CODE_SEG	SEGMENT CODE 
DATA_SEG	SEGMENT DATA
STACK_SEG	SEGMENT	IDATA

SPK	BIT	P3.7

	RSEG	DATA_SEG
FRQ:   DS   1
TMP:   DS   1

	RSEG	STACK_SEG
STACK:	DS	20

;===============================================================================
CSEG	AT	00000H
	LJMP	MAIN


CSEG	AT	0000BH
	LJMP	TIMER0
	
	
	
;===============================================================================

	RSEG	CODE_SEG
MAIN:
	USING	0
	
	MOV	SP,#(STACK-1)
	
	MOV  	TMOD,#01H
	CLR  	A
	MOV  	FRQ,A
	MOV  	TH0,A
	MOV  	TL0,#0FFH
	SETB 	TR0
	MOV  	IE,#082H
	
MAIN_LP:

	INC  	FRQ
	
	MOV  	R7,#04		; 
	LCALL	DELAYMS

	SJMP 	MAIN_LP
	
; END OF main

;===============================================================================


TIMER0:
	MOV  	TH0,#0FEH
	MOV  	TL0,frq
	CPL  	SPK
	RETI 	
; END OF TIMER0


;===============================================================================
DELAYMS:
; 延时子程序
; 传入参数：R7 --- 延时值(MS) 
; 返回值：无

	MOV	A,R7
	JZ	END_DLYMS	
DLY_LP1:
	MOV	R6,#185
DLY_LP2:
	NOP
	NOP
	NOP
	DJNZ	R6,DLY_LP2
	DJNZ	R7,DLY_LP1

END_DLYMS:
	RET 

	END
