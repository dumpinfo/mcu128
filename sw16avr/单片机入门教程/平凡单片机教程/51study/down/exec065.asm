ORG	0000H
AJMP	START
ORG	30H
START:
	MOV	SP,#5FH
        MOV     TMOD,#00000110B ;��ʱ/������1��������,0����ȫ��0
	SETB	TR0		;����������1��ʼ����.
LOOP:
        MOV     A,TL0
        CPL	A
	MOV	P1,A
	AJMP	LOOP
END
