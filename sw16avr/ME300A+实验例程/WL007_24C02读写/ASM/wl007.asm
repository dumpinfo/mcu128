;********************************************************************************
;*  标题:  ME300系列单片机开发系统演示程序 - AT24C02读写演示程序                *
;*  硬件： ME300A+                                                               *
;*  文件:  wl007.asm                                                            *
;*  日期:  2004-1-5                                                             *
;*  版本:  1.0                                                                  *
;*  作者:  伟纳电子 - Freeman                                                   *
;*  邮箱:  freeman@willar.com                                                   *
;*  网站： http://www.willar.com                                                *
;********************************************************************************
;*  描述:                                                                       *
;*         AT24C02读写演示程序                                                  *
;*                                                                              *
;********************************************************************************
;*  跳线设置：                                                                  *
;*         JP1 全部短接，JP2短接2-3端                                           *
;*                                                                              *
;********************************************************************************
;* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
;* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
;********************************************************************************

NAME	WL007

OP_READ		EQU	0xa1		; 器件地址以及读取操作
OP_WRITE 	EQU	0xa0		; 器件地址以及写入操作
MAX_ADDR 	EQU	0x7f		; AT24C02最大地址

CODE_SEG	SEGMENT CODE 
DATA_SEG	SEGMENT DATA
STACK_SEG	SEGMENT	IDATA


	RSEG  DATA_SEG
ADDR:	DS	1
TMP2:	DS	1
TMP3:   DS	1

	RSEG	STACK_SEG
STACK:		DS	20

SCL	BIT	P3.3
SDA	BIT	P1.3

;===============================================================================
CSEG	AT	0000H			; 复位向量
	JMP	MAIN



;===============================================================================
	RSEG  CODE_SEG
MAIN:
; 主程序开始

	USING	0
	
	MOV	SP, #(STACK-1)		; 设置堆栈
	
	SETB 	SDA
	SETB 	SCL

	MOV  	R7,#05AH		; 全部填充0xff
	LCALL	FILL_BYTE

	CLR  	A
	MOV  	ADDR,A
MAIN_LP1:				; 将表格DIS_CODE内数据写入到EEPROM

	MOV  	A,ADDR
	MOV  	DPTR,#DIS_CODE
	MOVC 	A,@A+DPTR		; 查表
	
	MOV  	R5,A			; 数据到R5 	
	MOV  	R7,ADDR			; 地址到R7
	LCALL	WRITE_BYTE

	INC  	ADDR			; 地址加1
	MOV  	A,ADDR
	CLR  	C
	SUBB 	A,#08H			; 共8字节，判断是否完成
	JC   	MAIN_LP1		; 
	
	CLR  	A			; 
	MOV  	ADDR,A			; 
MAIN_LP2:				; 循环读取AT24C02内容，并输出到P0口
	MOV  	R7,ADDR			; 地址到R7
	LCALL	READ_RANDOM
	MOV  	P0,R7			; 将读取的数据传送到P0
	
	INC  	ADDR			; 地址加1
	ANL  	ADDR,#07H		; 循环读取范围为0x00～0x07
	
	MOV  	R7,#0FAH		; delay
	LCALL	DELAYMS
	
	SJMP 	MAIN_LP2
; END OF MAIN

;===============================================================================
	RSEG  CODE_SEG
START:
; 开始位
; 传入参数： 无
; 返回值：无

	SETB 	SDA
	SETB 	SCL
	NOP 
	NOP  
	CLR  	SDA
	NOP
	NOP  	
	NOP  	
	NOP  	
	CLR  	SCL
	RET  	
; END OF START

;===============================================================================

	RSEG  CODE_SEG
STOP:
; 停止位
; 传入参数： 无
; 返回值：无

	CLR  	SDA
	NOP  	
	NOP  	
	SETB 	SCL
	NOP  	
	NOP  	
	NOP  	
	NOP  	
	SETB 	SDA
	RET  	
; END OF STOP

;===============================================================================
	RSEG  CODE_SEG
SHIN:
; 从AT24Cxx移入数据到MCU
; 传入参数： 无
; 返回值：R7 --- 移出的数据

	USING	0
	CLR  	A
	MOV  	R6,A
SHIN_LP:
	SETB 	SCL
	MOV  	A,R7
	ADD  	A,ACC
	MOV  	R7,A
	MOV  	C,SDA
	CLR  	A
	RLC  	A
	ORL  	AR7,A
	CLR  	SCL
	INC  	R6
	CJNE 	R6,#08H,SHIN_LP		; 共8位，判断是否完成
	
	RET  	
; END OF SHIN

;===============================================================================
	RSEG  CODE_SEG
SHOUT:
; 从MCU移出数据到AT24Cxx
; 传入参数： R7 --- 要移出的数据
; 返回值：C --- AT24Cxx的应答位

	USING	0

	CLR  	A
	MOV  	R6,A
SHOUT_LP:				; 循环移入8个位
	MOV  	A,R7
	RLC  	A
	MOV  	SDA,C
	NOP  	
	SETB 	SCL
	NOP  	
	NOP  	
	CLR  	SCL
	MOV  	A,R7
	ADD  	A,ACC
	MOV  	R7,A
	INC  	R6
	CJNE 	R6,#08H,SHOUT_LP	; 共8位，判断是否完成
	
	SETB 	SDA			; 读取应答
	NOP  	
	NOP  	
	SETB 	SCL
	NOP  	
	NOP  	
	NOP  	
	NOP  	
	MOV  	C,SDA			; 保存应答位到C
	CLR  	SCL
	RET  	
; END OF SHOUT

;===============================================================================
	RSEG  CODE_SEG	
WRITE_BYTE:
; 在指定地址写入数据
; 传入参数： R7 --- 写入数据的地址
; 传入参数： R5 --- 要写入的数据
; 返回值：无

	USING	0

	MOV  	R4,AR7
	LCALL	START
	
	MOV  	R7,#OP_WRITE		; 写入器件地址和写命令
	LCALL	SHOUT
	
	MOV  	R7,AR4			; 地址
	LCALL	SHOUT
	
	MOV  	R7,AR5			; 数据
	LCALL	SHOUT
	
	LCALL	STOP

	MOV  	R7,#10			; 写入周期, 延时10ms
	LJMP 	DELAYMS
	
; END OF WRITE_BYTE

;===============================================================================
	RSEG  CODE_SEG
FILL_BYTE:
; 填充数据到EEPROM内
; 传入参数： R7 --- 要填充的数据
; 返回值：无

	USING	0
	
	MOV  	TMP3,R7

	CLR  	A
	MOV  	TMP2,A
FILL_LP:
	MOV  	R5,TMP3
	MOV  	R7,TMP2
	LCALL	WRITE_BYTE

	INC  	TMP2
	MOV  	A,TMP2
	CLR  	C
	SUBB 	A,#07FH
	JC   	FILL_LP
	
; END OF FILL_BYTE

;===============================================================================
	RSEG  CODE_SEG
READ_CURRENT:
; 在当前地址读取
; 传入参数：无 
; 返回值：R7 --- 读出的数据

	USING	0
	LCALL	START

	MOV  	R7,#OP_READ		; 写入器件地址和读取命令
	LCALL	SHOUT
	
	LCALL	SHIN			; 读取数据，保存在R7

	LCALL	STOP

	RET  	
; END OF read_current

;===============================================================================
	RSEG  CODE_SEG
READ_RANDOM:
; 在指定地址读取
; 传入参数：R7 --- 地址 
; 返回值：R7 --- 读出的数据
	
	USING	0
	MOV  	R5,AR7			; 暂存地址

	LCALL	START

	MOV  	R7,#OP_WRITE		; 写入器件地址和写入命令
	LCALL	SHOUT

	MOV  	R7,AR5			; 写入地址
	LCALL	SHOUT

	LCALL	READ_CURRENT		; 在当前地址读取

	RET  	
; END OF READ_RANDOM

;===============================================================================

	RSEG  CODE_SEG
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
	RSEG  CODE_SEG
DIS_CODE:
; 写入到AT24C02的数据串

	DB	07EH
	DB	0BDH
	DB	0DBH
	DB	0E7H
	DB	0DBH
	DB	0BDH
	DB	07EH
	DB	0FFH


	END
