;********************************************************************************
;*  标题:  ME300系列单片机开发系统演示程序 - 数码管显示秒表                     *
;*  硬件： ME300A+,ME300B                                                       *
;*  文件:  wl011.asm                                                            *
;*  日期:  2004-1-5                                                             *
;*  版本:  1.0                                                                  *
;*  作者:  伟纳电子 - Freeman                                                   *
;*  邮箱:  freeman@willar.com                                                   *
;*  网站： http://www.willar.com                                                *
;********************************************************************************
;*  描述:                                                                       *
;*                 数码管显示秒表                                               *
;*                 K1---控制按钮                                                *
;*                       第一次按下时, 启动开始计时                             *
;*                       第二次按下时, 停止                                     *
;*                       第三次按下时, 归零                                     *
;*                                                                              *
;*    秒单位,寄存器与数码管对应关系:                                            *
;*                                                                              *
;* --- 秒单位 ---------- 数码管端口 ---- 缓冲区 --------- 计时(BCD码)值寄存器   *
;*     十万位               P20        dis_buf[7]          sec_bcd[7]           *
;*     万位                 P21        dis_buf[6]          sec_bcd[6]           *
;*     千位                 P22        dis_buf[5]          sec_bcd[5]           *
;*     百位                 P23        dis_buf[4]          sec_bcd[4]           *
;*     十位                 P24        dis_buf[3]          sec_bcd[3]           *
;*     个位(1.s)            P25        dis_buf[2]          sec_bcd[2]           *
;*     十分位(0.1s)         P26        dis_buf[1]          sec_bcd[1]           *
;*     百分位(0.01s)        P27        dis_buf[0]          sec_bcd[0]           *
;*                                                                              *
;********************************************************************************
;*  跳线设置：                                                                  *
;*     ME300A+    JP1 全部短接，JP2短接2-3端                                    *
;*     ME300B     JP1 短接，JP2短接2-3端                                        *
;********************************************************************************
;* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
;* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
;********************************************************************************


NAME	WL011

CODE_SEG       	SEGMENT	CODE
DATA_SEG       	SEGMENT DATA 
STACK_SEG	SEGMENT	IDATA

	RSEG  DATA_SEG
KEY_S:   	DS   1
KEY_V:   	DS   1
DIS_DIGIT:   	DS   1
DIS_INDEX:   	DS   1
SEC_BCD:   	DS   8		; 秒计数值, BCD码
KEY_TIMES:   	DS   1		; K1 按下次数	
DIS_BUF:   	DS   8		; 显示缓冲区

	RSEG	STACK_SEG
STACK:		DS	20

K1	BIT	P1.4

;===============================================================================
CSEG	AT	0000H
	LJMP	MAIN


CSEG	AT	0000BH
	LJMP	TIMER0
	

CSEG	AT	0001BH
	LJMP	TIMER1

;===============================================================================
	RSEG	CODE_SEG
MAIN:
	USING	0
	MOV	SP,#(STACK-1)

	MOV  	P0,#0FFH		; 初始化端口
	MOV  	P2,#0FFH
	MOV  	TMOD,#011H		; 
	MOV  	TH1,#0DCH
	CLR  	A
	MOV  	TL1,A

	MOV  	TH0,#0FCH

	MOV  	TL0,#017H

	LCALL	CLR_TIME		; 清零计时值

	MOV  	DIS_DIGIT,#07FH		; 上电时选通P27数码管

	CLR  	A
	MOV  	DIS_INDEX,A

	MOV  	KEY_TIMES,A

	MOV  	KEY_V,#01H
	
	MOV  	IE,#08AH		; 使能timer0, timer1中断

	SETB 	TR0
	CLR  	TR1
	
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
; END OF main

;===============================================================================

CLR_TIME:
	
	CLR  	A
	MOV  	SEC_BCD,A		; 清零所有计时值
	MOV  	SEC_BCD+01H,A
	MOV  	SEC_BCD+02H,A
	MOV  	SEC_BCD+03H,A
	MOV  	SEC_BCD+04H,A
	MOV  	SEC_BCD+05H,A
	MOV  	SEC_BCD+06H,A
	MOV  	SEC_BCD+07H,A
	LJMP 	UPDATE_DISBUF		; 更新显示缓冲区
	
; END OF CLR_TIME

;===============================================================================
SCAN_KEY:
	CLR  	A
	MOV  	KEY_S,A
	MOV  	C,K1			; 读按键状态
	RLC  	A
	ORL  	KEY_S,A
	MOV  	A,KEY_S
	XRL  	A,KEY_V			; 
	
	RET  	
; END OF scan_key

;===============================================================================
PROC_KEY:
	MOV  	A,KEY_V
	JB   	ACC.0,END_PROC_KEY
	
	INC  	KEY_TIMES
	MOV  	A,KEY_TIMES
	CJNE 	A,#01H,PROC_KEY1
	
	SETB 	TR1			; KEY_TIMES = 1,第一次按下K1, 启动开始计时 
	RET
	
PROC_KEY1:
	MOV  	A,KEY_TIMES		
	CJNE 	A,#02H,PROC_KEY2
	
	CLR  	TR1			; KEY_TIMES = 2, 第二次按下K1, 停止计时
	
	RET  
		
PROC_KEY2:
	LCALL	CLR_TIME		; 第三次按下K1, 清零计时值
	
	CLR  	A
	MOV  	KEY_TIMES,A		; 清零KEY_TIMES
	
END_PROC_KEY:
	RET  	
	
;===============================================================================

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

	MOV	A,DIS_DIGIT		; 位选通值右移(P20<-P27), 下次中断时选通下一位数码管
	RR	A
	MOV	DIS_DIGIT,A
	
	INC	DIS_INDEX		; DIS_INDEX加1, 下次中断时显示下一位
	ANL	DIS_INDEX,#0x07		; 当DIS_INDEX等于8(0000 1000)时, 清0

	POP  	AR0
	POP  	PSW
	POP  	ACC
	
	RETI 
; END OF timer0

;===============================================================================

TIMER1:
	PUSH 	ACC
	PUSH 	B
	PUSH 	DPH
	PUSH 	DPL
	PUSH	PSW
	PUSH	AR7

	ORL  	TH1,#0DCH		; 恢复定时器初值

	CLR  	A
	MOV  	R7,A
	
	MOV  	A,#LOW (SEC_BCD)	
	MOV  	R0,A			; 计时值寄存器地址到R0
	
TIMER_INC:			; 
	
	INC  	@R0			; 计时值加1

	MOV  	A,@R0
	CLR  	C
	SUBB 	A,#10			; 
	JC   	END_INC			; 如果低位不满10, 则结束

	MOV  	@R0,#00H		; 低位满10, 清零低位

	INC	R0			; 指向高位

	INC  	R7			;	 
	CJNE 	R7,#08H,TIMER_INC	; 如果达到最高位, 则结束
	
END_INC:

	LCALL	UPDATE_DISBUF

	POP	AR7	
	POP	PSW
	POP  	DPL
	POP  	DPH
	POP  	B
	POP  	ACC
	RETI 	
; END OF timer1

;===============================================================================
UPDATE_DISBUF:
; 根据计时寄存器的值更新显示缓冲区

	MOV  	DPTR,#DIS_CODE		; 保存表格地址
	
	MOV  	A,sec_bcd
	MOV  	DPTR,#dis_code
	MOVC 	A,@A+DPTR		; 获得显示代码
	MOV  	dis_buf,A		; 更新显示缓冲区

	MOV  	A,sec_bcd+01H
	MOVC 	A,@A+DPTR
	MOV  	dis_buf+01H,A

	MOV  	A,sec_bcd+02H
	MOVC 	A,@A+DPTR
	ANL  	A,#07FH			; 显示小数点
	MOV  	dis_buf+02H,A

	MOV  	A,sec_bcd+03H
	MOVC 	A,@A+DPTR
	MOV  	dis_buf+03H,A

	MOV  	A,sec_bcd+04H
	MOVC 	A,@A+DPTR
	MOV  	dis_buf+04H,A

	MOV  	A,sec_bcd+05H
	MOVC 	A,@A+DPTR
	MOV  	dis_buf+05H,A

	MOV  	A,sec_bcd+06H
	MOVC 	A,@A+DPTR
	MOV  	dis_buf+06H,A

	MOV  	A,sec_bcd+07H
	MOVC 	A,@A+DPTR
	MOV  	dis_buf+07H,A

	RET  	

; END OF UPDATE_DISBUF	

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
	DB	0C0H		; '0'
	DB	0F9H		; '1'
	DB	0A4H		; '2'
	DB	0B0H		; '3'
	DB	099H		; '4'
	DB	092H		; '5'
	DB	082H		; '6'
	DB	0F8H		; '7'
	DB	080H		; '8'
	DB	090H		; '9'
	DB	0FFH		; off

	END
