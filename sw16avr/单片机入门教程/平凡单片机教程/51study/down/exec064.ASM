ORG	0000H
AJMP	START
ORG	000BH  ;定时器0的中断向量地址
AJMP	TIME0	;跳转到真正的定时器程序处
ORG	30H
START:
	MOV	P1,#0FFH  ;关所 灯
	MOV	30H,#00H  ;软件计数器预清0
	MOV	TMOD,#00000001B ;定时/计数器0工作于方式1
	MOV	TH0,#3CH	
	MOV	TL0,#0B0H  ;即数15536
	SETB	EA	;开总中断允许
	SETB	ET0	;开定时/计数器0允许
SETB	TR0	       ;定时/计数器0开始运行
LOOP:	AJMP	LOOP	;真正工作时,这里可写任意程序
TIME0:			;定时器0的中断处理程序
	PUSH	ACC
PUSH	PSW	;将PSW和ACC推入堆栈保护
	INC	30H
	INC	31H	;两个计数器都加1
	MOV	A,30H
	CJNE	A,#20,T_NEXT	;30H单元中的值到了20了吗?
T_L1:	CPL	P1.0		;到了,取反P10
	MOV	30H,#0               ;清软件计数器
T_NEXT:
	MOV	A,31H
	CJNE	A,#40,T_RET	;31h单元中的值到40了吗?
T_L2:
	CPL	P1.1
	MOV	31H,#0		;到了,取反P11,清计数器,返回
T_RET:
MOV	TH0,#15H
	MOV	TL0,#9FH	;重置定时常数
	POP	PSW
	POP	ACC
	RETI
END
