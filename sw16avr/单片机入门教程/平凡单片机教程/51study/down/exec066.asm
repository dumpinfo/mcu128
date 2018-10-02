ORG	0000H
AJMP	START
ORG	000BH
AJMP	TIMER0	;定时器0的中断处理
ORG	30H
START:
	MOV	SP,#5FH
	MOV	TMOD,#00000101B	;定时/计数器1作计数用,模式1,0不用全置0
	MOV	TH0,#0FFH
	MOV	TL0,#0FAH		;预置值,要求每计到6个脉冲即为一个事件
	SETB	EA
SETB	ET0		;开总中断和定时器1中断允许
	SETB	TR0		;启动计数器1开始运行.
	AJMP	$
TIMER0:
	PUSH	ACC
	PUSH	PSW
	CPL		P1.0		;计数值到,即取反P1.0
	MOV	TH0,#0FFH
	MOV	TL0,#0FAH  ;重置计数初值
        POP     PSW
        POP     ACC
	RETI	
END
