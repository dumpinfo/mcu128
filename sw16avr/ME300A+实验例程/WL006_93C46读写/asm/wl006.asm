;********************************************************************************
;*  标题:  ME300系列单片机开发系统演示程序 - AT93C46读写演示程序                *
;*  硬件： ME300A+,ME300B                                                       *
;*  文件:  wl006.asm                                                            *
;*  日期:  2004-1-5                                                             *
;*  版本:  1.0                                                                  *
;*  作者:  伟纳电子 - Freeman                                                   *
;*  邮箱:  freeman@willar.com                                                   *
;*  网站： http://www.willar.com                                                *
;********************************************************************************
;*  描述:                                                                       *
;*         AT93C46读写演示程序                                                  *
;*         从地址0x00开始写入数据“www.willar.com”， 然后再读出                  *
;*                                                                              *
;*         注意：在擦除或写入数据之前，必须先写入EWEN指令，93C46右边的JP7跳线   *
;*      用于8位和16位模式选择，默认为8位模式                                    *
;*                                                                              *
;********************************************************************************
;*  跳线设置：                                                                  *
;*     ME300A+    JP1 全部短接，JP2短接3-4端                                    *
;*     ME300B     JP1 短接，JP2短接3-4端，JP3短接93端                           *
;*                                                                              *
;********************************************************************************
;* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
;* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
;********************************************************************************

	NAME	WL006

CODE_SEG	SEGMENT CODE 
DATA_SEG	SEGMENT	DATA
STACK_SEG	SEGMENT	IDATA

	RSEG  DATA_SEG
	
INDATA:   	DS   	1
ADDR:   	DS   	1

	RSEG	STACK_SEG
STACK:		DS	20


CS	BIT	P3.4
SK	BIT	P3.3
DI	BIT	P3.5
DO	BIT	P3.6

;===============================================================================
	CSEG	AT	0000H
	JMP	MAIN

;===============================================================================
	RSEG  CODE_SEG
MAIN:
	USING	0
	MOV	SP,#(STACK-1)		; 设置堆栈
	
	CLR  	CS			; 初始化端口
	CLR  	SK
	SETB 	DI
	SETB 	DO

	LCALL	EWEN			; 使能写入操作
	LCALL	ERASE			; 擦除全部内容
	
	CLR  	A			; 写入显示代码到AT93C46
	MOV  	ADDR,A
WRITE_LP:
	MOV  	A,ADDR
	MOV  	DPTR,#DIS_CODE
	MOVC 	A,@A+DPTR
	
	MOV  	R5,A			; 数据到R5
	MOV  	R7,ADDR			; 地址到R7
	LCALL	WRITE
	
	INC  	ADDR			; 地址加1
	MOV  	A,ADDR
	CLR  	C
	SUBB 	A,#08H			; 共8个字节，判断是否完成
	JC   	WRITE_LP
	
	LCALL	EWDS			; 禁止写入操作	
	

	CLR  	A
	MOV  	ADDR,A
	
MAIN_LP:				; 循环读取AT93C46内容，并输出到P0口
	MOV  	R7,ADDR
	LCALL	READ
	
	MOV  	P0,R7
	INC  	ADDR
	ANL  	ADDR,#07H		; 循环读取地址为0x00～0x07

	MOV  	R7,#250
	LCALL	DELAYMS			; 延时250ms
	
	SJMP 	MAIN_LP


;===============================================================================
	RSEG	CODE_SEG
WRITE:
; 定入数据到AT93C46
; 传入参数：R7 --- 要写入数据的地址
; 传入参数：R5 --- 要写入的数据
; 返回值：无

	USING	0
	MOV  	INDATA,R5		; 暂存要写入的数据

	MOV  	R5,AR7			; 地址
	MOV  	R7,#040H		; 写入指令
	LCALL	INOP			; 调用INOP子程序，写入指令和地址

	MOV  	R7,INDATA		; 数据
	LCALL	SHIN			; 移入数据

	CLR  	CS

	MOV  	R7,#10
	LJMP 	DELAYMS			; 延时10ms，Twp
; END OF WRITE

;===============================================================================
	RSEG  CODE_SEG
READ:
; 读取AT93C46内的数据
; 传入参数：R7 --- 地址
; 返回值：R7 --- 读取的数据

	USING	0
	
	MOV  	R5,AR7
	MOV  	R7,#080H
	LCALL	INOP			; 调用INOP子程序，写入指令和地址

	LCALL	SHOUT			; 调用SHOUT，读出数据保存到R7
	
	CLR  	CS

	RET  	
; END OF READ

;===============================================================================
	RSEG  CODE_SEG
EWEN:
; 写入使能指令
; 传入参数：无
; 返回值：无

	USING	0

	MOV  	R5,#060H
	CLR  	A
	MOV  	R7,A
	LCALL	INOP

	CLR  	CS

	RET  	
; END OF EWEN


;===============================================================================
	RSEG  CODE_SEG
EWDS:
; 写入禁止指令
; 传入参数：无
; 返回值：无

	USING	0
	
	CLR  	A
	MOV  	R5,A
	MOV  	R7,A
	LCALL	INOP

	CLR  	CS

	RET  	
; END OF EWDS

;===============================================================================
	RSEG  CODE_SEG
ERASE:
; 擦除所有内容
; 传入参数：无
; 返回值：无

	USING	0
	
	MOV  	R5,#040H
	CLR  	A
	MOV  	R7,A
	LCALL	INOP

	MOV  	R7,#01EH
	LCALL	DELAYMS

	CLR  	CS

	RET  	
; END OF ERASE

;===============================================================================
	RSEG  CODE_SEG
INOP:
; 写入操作码
; 传入参数：R7高两位 --- 指令码的高两位
; 传入参数：R5低七位 --- 指令码的低7位或地址
; 返回值：无

	USING	0		

	CLR  	SK			; 开始位
	SETB 	DI
	SETB 	CS
	NOP  	
	NOP  	
	SETB 	SK
	NOP  	
	NOP  				
	CLR  	SK			; 开始位结束

	MOV  	A,R7			; 先移入指令码高位
	RLC  	A
	MOV  	DI,C
	SETB 	SK
	RLC	A
	CLR  	SK
	MOV  	DI,C			; 移入指令码次高位
	SETB 	SK
	NOP  	
	NOP  	
	CLR  	SK


	MOV  	A,R5			; 移入余下的指令码或地址数据
	RLC	A
	MOV  	R5,A			; R5左移一位 
	
	CLR  	A
	MOV  	R7,A
INOP_LP:
	MOV  	A,R5			; 移入R5的高7位
	RLC  	A
	MOV  	DI,C
	SETB 	SK
	MOV  	A,R5
	RLC	A
	MOV  	R5,A
	CLR  	SK
	
	INC  	R7
	CJNE 	R7,#07H,INOP_LP		; 判断是否7位全移完

	SETB 	DI

	RET  	
; END OF INOP

;===============================================================================
	RSEG  CODE_SEG
SHIN:
; 从MCU移出数据到AT93C46
; 传入参数：R7 --- 要移入的数据
; 返回值：无

	USING	0

	CLR  	A
	MOV  	R6,A
	MOV	A,R6
	MOV  	A,R7
SHIN_LP:
	RLC  	A
	MOV  	DI,C
	SETB 	SK
	NOP
	NOP
	CLR  	SK
	
	INC  	R6
	CJNE 	R6,#08H,SHIN_LP	; 共8位，判断是否完成

	SETB 	DI
	RET  	
; END OF SHIN

;===============================================================================

	RSEG  CODE_SEG
SHOUT:
; 从AT93C46移出数据MCU
; 传入参数：无
; 返回值：R7 --- 读出的数据

	USING	0

	CLR  	A
	MOV  	R6,A
SHOUT_LP:
	SETB 	SK
	NOP
	NOP	
	CLR  	SK	
	MOV  	C,DO
	RLC  	A
	INC  	R6
	CJNE 	R6,#08H,SHOUT_LP		; 共8位，判断是否完成
	MOV	AR7,A

	RET  	
; END OF SHOUT

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
; 写入到AT93C46的数据串

	DB	07EH
	DB	0BDH
	DB	0DBH
	DB	0E7H
	DB	0DBH
	DB	0BDH
	DB	07EH
	DB	0FFH

	END


