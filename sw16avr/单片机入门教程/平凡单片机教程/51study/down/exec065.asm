ORG	0000H
AJMP	START
ORG	30H
START:
	MOV	SP,#5FH
        MOV     TMOD,#00000110B ;定时/计数器1作计数用,0不用全置0
	SETB	TR0		;启动计数器1开始运行.
LOOP:
        MOV     A,TL0
        CPL	A
	MOV	P1,A
	AJMP	LOOP
END
