ORG	0000H
AJMP	START
ORG	000BH
AJMP	TIMER0	;��ʱ��0���жϴ���
ORG	30H
START:
	MOV	SP,#5FH
	MOV	TMOD,#00000101B	;��ʱ/������1��������,ģʽ1,0����ȫ��0
	MOV	TH0,#0FFH
	MOV	TL0,#0FAH		;Ԥ��ֵ,Ҫ��ÿ�Ƶ�6�����弴Ϊһ���¼�
	SETB	EA
SETB	ET0		;�����жϺͶ�ʱ��1�ж�����
	SETB	TR0		;����������1��ʼ����.
	AJMP	$
TIMER0:
	PUSH	ACC
	PUSH	PSW
	CPL		P1.0		;����ֵ��,��ȡ��P1.0
	MOV	TH0,#0FFH
	MOV	TL0,#0FAH  ;���ü�����ֵ
        POP     PSW
        POP     ACC
	RETI	
END
