FIRST		EQU	P2.7	;第一位数码管的位控制
SECOND  	EQU	P2.6	;第二位数码管的位控制
DISPBUFF	EQU	5AH	;显示缓冲区为5AH和5BH
	ORG	0000H
	AJMP	START
	ORG	30H
START:
	MOV	SP,#5FH		;设置堆栈
	MOV	P1,#0FFH
	MOV	P0,#0FFH
	MOV	P2,#0FFH	;初始化，所显示器，LED灭
	MOV	DISPBUFF,#0	;第一位显示0
	MOV	DISPBUFF+1,#1	;第二握显示1
	
LOOP:
	LCALL	DISP		;调用显示程序
	AJMP	LOOP
;主程序到此结束
DISP:
	PUSH	ACC		;ACC入栈
	PUSH	PSW		;PSW入栈
	MOV	A,DISPBUFF	;取第一个待显示数
	MOV	DPTR,#DISPTAB	;字形表首地址
	MOVC	A,@A+DPTR	;取字形码
	MOV	P0,A		;将字形码送P0位（段口）
	CLR	FIRST		;开第一位显示器位口
	LCALL	DELAY		;延时1毫秒
	SETB	FIRST		;关闭第一位显示器（开始准备第二位的数据）
	MOV	A,DISPBUFF+1	;取显示缓冲区的第二位
	MOV	DPTR,#DISPTAB	
	MOVC	A,@A+DPTR
	MOV	P0,A		;将第二个字形码送P0口
	CLR	SECOND		;开第二位显示器
	LCALL	DELAY		;延时
	SETB	SECOND		;关第二位显示
	POP	PSW
	POP	ACC
	RET
DELAY:			;延时1毫秒
	PUSH	PSW
	SETB	RS0
	MOV	R7,#50
D1:	MOV	R6,#10
D2:	DJNZ	R6,$
	DJNZ	R7,D1
	POP	PSW
	RET
	
	
	
DISPTAB:DB 28H,7EH,0a4H,64H,72H,61H,21H,7CH,20H,60H	
	END
