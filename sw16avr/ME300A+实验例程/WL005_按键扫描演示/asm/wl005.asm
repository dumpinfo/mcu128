;********************************************************************************
;*  标题:  ME300系列单片机开发系统演示程序 - 按键扫描程序                       *
;*  硬件： ME300A+,ME300B                                                       *
;*  文件:  wl005.asm                                                            *
;*  日期:  2004-1-5                                                             *
;*  版本:  1.0                                                                  *
;*  作者:  伟纳电子 - Freeman                                                   *
;*  邮箱:  freeman@willar.com                                                   *
;*  网站： http://www.willar.com                                                *
;********************************************************************************
;*  描述:                                                                       *
;*         按键扫描程序                                                         *
;*         按下K1,单灯右移                                                      *
;*         按下K2,单灯左移                                                      *
;*                                                                              *
;********************************************************************************
;*  跳线设置：                                                                  *
;*     ME300A+    JP1 全部短接，JP2短接3-4端                                    *
;*     ME300B     JP1 短接，    JP2短接3-4端                                    *
;*                                                                              *
;********************************************************************************
;* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
;* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
;********************************************************************************

CODE_SEG	SEGMENT	CODE
DATA_SEG	SEGMENT	DATA
STACK_SEG	SEGMENT	IDATA

	RSEG	DATA_SEG
KEY_S:	DS	1
KEY_V:	DS	1

	RSEG	STACK_SEG
STACK:	DS	20


K1	BIT	P1.4		; 
K2	BIT	P1.5		; 


	CSEG	AT	0000H
	JMP	MAIN

;===============================================================================	
	RSEG	CODE_SEG
MAIN:
	MOV	SP,#(STACK-1)		; 设置栈指针
	MOV	P0,#0FEH		; 初始点亮LED P00
	MOV	KEY_V,#03H		; 初始键值

KEY_CHKSW:				; 循环检测按键是否按下					
	ACALL	SCAN_KEY		; 输入按键状态
	MOV	KEY_S,A
	XRL	A,KEY_V			; 检查按键值是否改变
	JZ	KEY_CHKSW		; 若无键被按,则跳回KEY_CHKSW
	
	MOV	R7,#10			; 延时10ms
	ACALL	DELAYMS			; 延时去抖
	ACALL	SCAN_KEY		; 再次检查按键值
	MOV	KEY_S,A
	XRL	A,KEY_V
	JZ	KEY_CHKSW
	
	MOV	KEY_V,KEY_S		; 保存按键状态
	ACALL	PROC_KEY		;
	SJMP	KEY_CHKSW
;===============================================================================
SCAN_KEY:				
; 扫描按键
; 传入参数:无
; 返回值:A --- 按键状态

	CLR	A
	MOV	C,K1
	MOV	ACC.0,C
	MOV	C,K2
	MOV	ACC.1,C
	RET

;===============================================================================	
PROC_KEY:
; 按键处理子程序
; 传入参数: KEY_V --- 按键值
; 返回值: 无

	MOV	A,KEY_V
	JNB	ACC.0,PROC_K1
	JNB	ACC.1,PROC_K2
	RET
	
PROC_K1:				; 按键K1处理程序
	MOV	A,P0			; 右移
	RR	A
	MOV	P0,A
	RET
	
PROC_K2:				; 按键K2处理程序
	MOV	A,P0			; 左移
	RL	A
	MOV	P0,A	 
	RET

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
	
; END OF DELAYMS
	
	END