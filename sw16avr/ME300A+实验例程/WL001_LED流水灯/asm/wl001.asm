;********************************************************************************
;*  标题:  ME300系列单片机开发系统演示程序 - LED流水灯                          *
;*  硬件： ME300A,ME300S,ME300A+,ME300B                                         *
;*  文件:  wl001.asm                                                            *
;*  日期:  2004-1-5                                                             *
;*  版本:  1.0                                                                  *
;*  作者:  伟纳电子 - Freeman                                                   *
;*  邮箱:  freeman@willar.com                                                   *
;*  网站： http://www.willar.com                                                *
;********************************************************************************
;*  描述:                                                                       *
;*         延时实现LED流水灯效果                                                *
;*                                                                              *
;********************************************************************************
;*  跳线设置：                                                                  *
;*     ME300A+    JP1 全部短接，JP2短接在3-4端                                  *
;*     ME300B     JP1 短接，JP2短接在3-4端                                      *
;*                                                                              *
;********************************************************************************
;* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
;* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
;********************************************************************************


	ORG	0000H
	LJMP	MAIN

MAIN:
	MOV	P0,#0FEH		; 初始点亮LED1 
	MOV	R7,#0FEH		; 保存P0
MAIN_LP:
	LCALL	DELAY			; 延时
	MOV	A,R7			; 
	RL	A			; 循环移位
	MOV	R7,A			; 保存到R7
	MOV	P0,A			; 点亮下一个LED
	JMP	MAIN_LP			; 不停循环

;===========================================================
DELAY:					; 延时子程序
	MOV	R0,#0FFH
	MOV	R1,#0FFH
DLY_LP:
	NOP
	NOP
	DJNZ	R0,DLY_LP
	MOV	R0,#0FFH
	DJNZ	R1,DLY_LP 
	RET
	
	END
