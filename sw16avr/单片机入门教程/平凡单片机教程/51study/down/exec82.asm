Counter		EQU	59H	;计数器，显示程序通过它得知现正显示哪个数码管
FIRST		EQU	P2.7	;第一位数码管的位控制
SECOND  	EQU	P2.6	;第二位数码管的位控制
DISPBUFF	EQU	5AH	;显示缓冲区为5AH和5BH
	ORG	0000H
	AJMP	START
	ORG	000BH		;定时器T0的入口
	AJMP	DISP		;显示程序
	ORG	30H
START:
	MOV	SP,#5FH		;设置堆栈
	MOV	P1,#0FFH
	MOV	P0,#0FFH
	MOV	P2,#0FFH	;初始化，所显示器，LED灭
	MOV	TMOD,#00000001B	;定时器T0工作于模式1（16位定时/计数模式）
	MOV	TH0,#HIGH(65536-2000)
	MOV	TL0,#LOW(65536-2000)
	SETB	TR0
	SETB	EA
	SETB	ET0
	MOV	Counter,#0	;计数器初始化
	MOV	DISPBUFF,#0	;第一位始终显示0
	MOV	A,#0
LOOP:	
	MOV	DISPBUFF+1,A	;第二位轮流显示0-9
	INC	A
	LCALL	DELAY
	CJNE	A,#10,LOOP
	MOV	A,#0
	AJMP	LOOP
;主程序到此结束
DISP:
	PUSH	ACC		;ACC入栈
	PUSH	PSW		;PSW入栈
	MOV	TH0,#HIGH(65536-2000)
	MOV	TL0,#LOW(65536-2000)
	SETB	FIRST
	SETB	SECOND		;关显示
	MOV	A,#DISPBUFF	;显示缓冲区首地址�
	ADD	A,Counter	
	MOV	R0,A
	MOV	A,@R0		;根据计数器的值取相应的显示缓冲区的值
	MOV	DPTR,#DISPTAB	;字形表首地址
	MOVC	A,@A+DPTR	;取字形码
	MOV	P0,A		;将字形码送P0位（段口）
	MOV	A,Counter	;取计数器的值
	JZ	DISPFIRST	;如果是0则显示第一位
	CLR	SECOND		;否则显示第二位
	AJMP	DISPSECOND
DISPFIRST:
	CLR	FIRST		;显示第一位		
DISPSECOND:
	INC	Counter		;计数器加1
	MOV	A,Counter	
	DEC	A		;如果计数器计到2望，则让它回0
	DEC	A		
	JZ	RSTCOUNT	
	AJMP	DISPNEXT
RSTCOUNT:
	MOV	Counter,#0	;计数器的值只能是0或1
DISPNEXT:

	POP	PSW
	POP	ACC
	RETI
DELAY:			;延时130毫秒
	PUSH	PSW
	SETB	RS0
	MOV	R7,#255
D1:	MOV	R6,#255
D2:	NOP
	NOP
	NOP
	NOP
	DJNZ	R6,D2
	DJNZ	R7,D1
	POP	PSW
	RET
DISPTAB:DB 28H,7EH,0a4H,64H,72H,61H,21H,7CH,20H,60H	
	END
