;********************************************************************************
;*  标题:  伟纳电子ME300B单片机开发系统演示程序 - 数码管显示简易电子时钟        *
;*  文件:  wl010.asm                                                            *
;*  日期:  2004-1-5                                                             *
;*  版本:  1.0                                                                  *
;*  作者:  伟纳电子 - Freeman                                                   *
;*  邮箱:  freeman@willar.com                                                   *
;*  网站： http://www.willar.com                                                *
;********************************************************************************
;*  描述:                                                                       *
;*         简易电子时钟,数码管显示                                              *
;*         K1---时调整                                                          *
;*         K2---分调整                                                          *
;*                                                                              *
;*                                                                              *
;********************************************************************************
;* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
;* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
;********************************************************************************

CODE_SEG	SEGMENT CODE 
DATA_SEG	SEGMENT DATA 
STACK_SEG	SEGMENT	IDATA


K1	BIT	P1.4
K2	BIT	P1.5

	RSEG  DATA_SEG
KEY_S:		DS  	1
KEY_V:   	DS  	1
DIS_DIGIT:   	DS  	1
SEC:   		DS  	1
DIS_INDEX:  	DS   	1
HOUR:   	DS   	1
MIN:   		DS   	1
SEC100:   	DS   	1
DIS_BUF:   	DS   	8
        
BUF_HOUR_H	EQU	DIS_BUF		; 小时十位
BUF_HOUR_L	EQU	DIS_BUF+1	; 小时个位
BUF_MIN_H	EQU	DIS_BUF+3	; 分十位
BUF_MIN_L	EQU	DIS_BUF+4	; 分个位
BUF_SEC_H	EQU	DIS_BUF+6	; 秒十位
BUF_SEC_L	EQU	DIS_BUF+7	; 秒个位

	RSEG	STACK_SEG
STACK:	DS	20	
	

;===============================================================================

CSEG	AT	0000H
	JMP	MAIN
	
CSEG	AT	0000BH
	LJMP	TIMER0	

CSEG	AT	0001BH
	LJMP	TIMER1

;===============================================================================


	RSEG  CODE_SEG
MAIN:
	USING	0
	
	MOV	SP, #(STACK-1)		;
	
	
	MOV  	P0,#0FFH
	MOV  	P2,#0FFH
	MOV  	TMOD,#011H		; 定时器0, 1工作模式1, 16位定时方式
	MOV  	TH0,#0FCH
	MOV  	TL0,#017H
	MOV  	TH1,#0DCH
	CLR  	A
	MOV  	TL1,A
	
	MOV  	HOUR,#12		; 
	CLR	A			; 
	MOV  	MIN,A
	MOV  	SEC,A
	MOV  	SEC100,A
	
	MOV  	A,HOUR
	MOV  	B,#10
	DIV  	AB
	MOV  	DPTR,#DIS_CODE
	MOVC 	A,@A+DPTR
	MOV  	BUF_HOUR_H,A		; 时十位
	MOV  	A,HOUR
	MOV  	B,#10
	DIV  	AB
	MOV  	A,B
	MOVC 	A,@A+DPTR
	MOV  	BUF_HOUR_L,A		; 时个位
	MOV  	A,MIN
	MOV  	B,#10
	DIV  	AB
	MOVC 	A,@A+DPTR
	MOV  	BUF_MIN_H,A		; 分十位
	MOV  	A,MIN
	MOV  	B,#10
	DIV  	AB
	MOV  	A,B
	MOVC 	A,@A+DPTR
	MOV  	BUF_MIN_L,A		; 分个位
	MOV  	A,SEC
	MOV  	B,#10
	DIV  	AB
	MOVC 	A,@A+DPTR
	MOV  	BUF_SEC_H,A		; 秒十位
	MOV  	A,SEC
	MOV  	B,#10
	DIV  	AB
	MOV  	A,B
	MOVC 	A,@A+DPTR
	MOV  	BUF_SEC_L,A		; 秒个位
	
	MOV  	BUF_HOUR_H+02H,#0BFH
	MOV  	BUF_HOUR_H+05H,#0BFH
	
	MOV  	DIS_DIGIT,#0FEH
	CLR	A
	MOV  	DIS_INDEX,A
	
	MOV  	IE,#08AH		; 使能timer0,1 中断
	
	SETB	TR0
	SETB	TR1
	
	MOV  	KEY_V,#03H
	
MAIN_LP:
	LCALL	SCAN_KEY		; 键扫描
	JZ  	MAIN_LP			; 无键返回
	
	MOV	R7,#10			; 延时10ms
	LCALL	DELAYMS			; 延时去抖动
	LCALL	SCAN_KEY		; 再次扫描
	JZ	MAIN_LP			; 无键返回
	
	MOV  	KEY_V,KEY_S		; 保存键值
	LCALL	PROC_KEY		; 键处理
	SJMP	MAIN_LP			; 调回主循环


;===============================================================================
SCAN_KEY:
; 扫键扫描子程序
; 保存按键状态到key_s
; 返回: A --- 按键是否按下(BOOL)

	CLR	A
	
	MOV  	C,K1			; 读按键K1
	MOV	ACC.0,C
	MOV	C,K2			; 读按键K2
	MOV	ACC.1,C
	
	MOV	KEY_S,A			;  保存按键状态到key_s
	XRL  	A,KEY_V
	RET  	

;===============================================================================
PROC_KEY:
; 键处理子程序
; 传入参数: KEY_V --- 按键值
; 返回值: 无

	CLR  	EA
	
	MOV  	A,KEY_V
	JNB	ACC.0,PROC_K1
	JNB	ACC.1,PROC_K2
	SJMP	END_PROC_KEY
	
PROC_K1:				; 按键k1处理
	LCALL	INC_HOUR		; 小时加1
	SJMP 	END_PROC_KEY

PROC_K2:				; 按键K2处理
	INC  	MIN			; 分钟加1
	
	MOV  	A,MIN			; 
	SETB 	C
	SUBB 	A,#59	
	JC   	K2_UPDATE_MIN		; 如果分钟等于60,则分清0,小时加1
	
	CLR  	A			; 
	MOV  	MIN,A

K2_UPDATE_MIN:				; 更新分显示缓冲区
	MOV  	A,MIN
	MOV  	B,#10
	DIV  	AB			; A = MIN / 10	
	MOV  	DPTR,#DIS_CODE
	MOVC 	A,@A+DPTR
	MOV  	BUF_MIN_H,A		; 更新分十位
	
	MOV  	A,MIN
	MOV  	B,#10
	DIV  	AB
	MOV  	A,B			; A = MIN % 10
	MOVC 	A,@A+DPTR
	MOV  	BUF_MIN_L,A		; 更新分个位	
	
END_PROC_KEY:
	SETB 	EA
	RET  	

;===============================================================================

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
	
	MOV  	P2,DIS_DIGIT

	MOV	A,DIS_DIGIT		; 位选通值左移, 下次中断时选通下一位数码管
	RL	A
	MOV	DIS_DIGIT,A
	
	INC	DIS_INDEX		; DIS_INDEX加1, 下次中断时显示下一位
	ANL	DIS_INDEX,#0x07		; 当DIS_INDEX等于8(0000 1000)时, 清0

	POP  	AR0
	POP  	PSW
	POP  	ACC
	
	RETI 	

;===============================================================================
	USING	0
TIMER1:
; 定时器1中断服务程序, 产生时基信号10ms
; 
;
	PUSH	PSW
	PUSH 	ACC
	PUSH 	B
	PUSH 	DPH
	PUSH 	DPL
	
	MOV  	TH1,#0DCH
	
	INC  	SEC100
	
	MOV  	A,SEC100
	CLR  	C
	SUBB 	A,#100			; 是否中断100次(达到1s)
	JC   	END_TIMER1		; < 1S
	
	MOV  	SEC100,#00H		; 达到1s 
	LCALL	INC_SEC			; 秒加1 
	
END_TIMER1:
	POP  	DPL
	POP  	DPH
	POP  	B
	POP  	ACC
	POP	PSW
	
	RETI 				; 

;===============================================================================
INC_SEC:
	INC  	SEC
	
	MOV  	A,SEC
	SETB 	C
	SUBB 	A,#59			; 
	JC   	UPDATE_SEC
	
	CLR  	A
	MOV  	SEC,A
	LCALL	INC_MIN
	
UPDATE_SEC:
	MOV  	A,SEC
	MOV  	B,#10
	DIV  	AB			; A = SEC / 10
	MOV  	DPTR,#DIS_CODE
	MOVC 	A,@A+DPTR		; 
	MOV  	BUF_SEC_H,A		; 
	
	MOV  	A,SEC
	MOV  	B,#10
	DIV  	AB
	MOV  	A,B			; A = SEC % 10
	MOVC 	A,@A+DPTR
	MOV  	BUF_SEC_L,A
	RET  	

;===============================================================================

INC_MIN:
	INC  	MIN			; 分钟加1
	
	MOV  	A,MIN			; 
	SETB 	C
	SUBB 	A,#59	
	JC   	UPDATE_MIN		; 如果分钟等于60,则分清0,小时加1
	
	CLR  	A			; 
	MOV  	MIN,A
	LCALL	INC_HOUR		; 小时加1
	
UPDATE_MIN:				; 更新分显示缓冲区
	MOV  	A,MIN
	MOV  	B,#10
	DIV  	AB			; A = MIN / 10	
	MOV  	DPTR,#DIS_CODE
	MOVC 	A,@A+DPTR
	MOV  	BUF_MIN_H,A		; 更新分十位
	
	MOV  	A,MIN
	MOV  	B,#10
	DIV  	AB
	MOV  	A,B			; A = MIN % 10
	MOVC 	A,@A+DPTR
	MOV  	BUF_MIN_L,A		; 更新分个位
	
	RET  	

;===============================================================================

INC_HOUR:
	INC  	HOUR			; 小时加1 
	MOV  	A,HOUR
	SETB 	C
	SUBB 	A,#24
	JC   	UPDATE_HOUR		; 如果小时等于24,则小时清0
	
	CLR  	A
	MOV  	HOUR,A			; 小时清0 
	
UPDATE_HOUR:
	MOV  	A,HOUR
	SETB 	C
	SUBB 	A,#9
	JC   	UPDATE_HOUR1		; 如果小时小于10,则十位0不显示
	
	MOV  	A,HOUR
	MOV  	B,#10
	DIV  	AB
	MOV  	DPTR,#DIS_CODE
	MOVC 	A,@A+DPTR		; 
	MOV  	BUF_HOUR_H,A
	SJMP 	UPDATE_HOUR2
	
UPDATE_HOUR1:
	MOV  	BUF_HOUR_H,#0FFH
	
UPDATE_HOUR2:
	MOV  	A,HOUR
	MOV  	B,#10
	DIV  	AB
	MOV  	A,B
	MOV  	DPTR,#DIS_CODE
	MOVC 	A,@A+DPTR
	MOV  	BUF_HOUR_L,A
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

;===============================================================================

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
