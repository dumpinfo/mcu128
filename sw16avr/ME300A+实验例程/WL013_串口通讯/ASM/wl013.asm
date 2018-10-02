;********************************************************************************
;*  标题:  伟纳电子ME300B单片机开发系统演示程序 - PC与ME300串行通迅程序         *
;*  文件:  wl013.asm                                                            *
;*  日期:  2005-1-20                                                            *
;*  版本:  1.0                                                                  *
;*  作者:  伟纳电子 - Freeman                                                   *
;*  邮箱:  freeman@willar.com                                                   *
;*  网站： http://www.willar.com                                                *
;********************************************************************************
;*  描述:                                                                       *
;*         单片机接收主机的数据,然后将数据传送到P0口, 并传回给主机;             *
;*         当按下K1时, 单片机发送字串"welcome! www.willar.com\n\r" 给主机       * 
;*                                                                              *
;*  注意：演示此程序需要配合串口调试软件,且串口调试软件与ME300软件不能同时打开。*
;*        串口调试软件在光盘“工具软件”目录下有。                              *
;*                                                                              *
;*  实验方法：先用ME300软件将程序写入单片机，关闭ME300软件，将ME300的串口切换   *
;*            开关切换到仿真位置（这样设置后计算机的串口才能与试验芯片串口通信）*
;*            最后运行串口调试软件即可实验。                                    *
;*                                                                              *
;*********************************************************************************
;* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
;* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
;********************************************************************************

K1	EQU	P1.4			; 按键端口
; 变量定义
KEY_S	EQU	50H			; 当前的按键状态			
KEY_V	EQU	51H			; 上次的按键状态


	ORG	0000H
	LJMP	MAIN
	
MAIN:
	MOV	TMOD,#20H		; 定时器1工作于8位自动重载模式,用于产生波特率
	MOV	TH1,#0FDH
	MOV	TL1,#0FDH		; 波特率9600
	
	MOV	SCON,#50H		; 设定串行口工作方式
	ANL	PCON,#0EFH		; 波特率不倍增
	
	SETB	TR1			; 启动定时器1
	MOV	IE,#0			; 禁止任何中断

	MOV	KEY_V,#01H		; 
	
MAIN_RX:
	JNB	RI,MAIN_KEY		; 是否有数据到来
	CLR	RI
	MOV	A,SBUF			; 暂存接收到的数据
	MOV	P0,A			; 数据传送到P0口
	LCALL	SEND_CHAR		; 回传接收到的数据
	
MAIN_KEY:
	LCALL	SCAN_KEY		;  扫描按键
	JZ	MAIN_RX
	LCALL	DELAY_15MS		;  延时去抖动
	LCALL	SCAN_KEY
	JZ	MAIN_RX
	MOV	KEY_V,KEY_S		;  保存键值
	LCALL	PROC_KEY		; 键处理
	SJMP	MAIN_RX
;===============================================================================
SCAN_KEY:
; 扫描按键, (在此实例中仅扫描按键K1)	
; 传入参数: 无
; 返回值:　无
	CLR	A
	MOV	C,K1
	MOV	ACC.0, C
	MOV	KEY_S,A
	XRL	A,KEY_V			; 检查按键状态是否改变
	RET
;===============================================================================	
PROC_KEY:
; 按键处理子程序 --- 发送字符串到PC
; 传入参数: KEY_V --- 按键值
; 返回值: 无	
	JB	K1,END_PROC_KEY	; K1未按下时，直接返回
	MOV	DPTR,#TAB_WWW		; 字串表格地址

SEND_STRING:
	CLR	A
	MOVC	A,@A+DPTR
	JZ	END_PROC_KEY		; 查到00H时,表示字串结束
	ACALL	SEND_CHAR
	INC	DPTR			; 下一字符
	SJMP	SEND_STRING
END_PROC_KEY:
	RET	

;===============================================================================
SEND_CHAR:
; 传送一个字符
; 传入参数: ACC(要发送的数据)
; 返回值: 无
	MOV	SBUF,A
	JNB	TI,$			; 等特数据传送
	CLR	TI			; 清除数据传送标志
	RET
;===============================================================================
; 扫描按键, (在此实例中仅扫描按键K1)	
; 传入参数: 无
; 返回值:　无
DELAY_15MS:
	MOV	R7,#15
DELAY15MS_1:
	MOV	R6,#0E8H
DELAY15MS_2:
	NOP
	NOP
	DJNZ	R6,DELAY15MS_2
	DJNZ	R7,DELAY15MS_1
	RET

	
TAB_WWW:
	DB	"welcome! www.willar.com"
	DB	0AH,0DH		;换行/回车
	DB	00H
	END