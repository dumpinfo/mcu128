ORG	0000H
AJMP	START
ORG	000BH  ;��ʱ��0���ж�������ַ
AJMP	TIME0	;��ת�������Ķ�ʱ������
ORG	30H
START:
	MOV	P1,#0FFH  ;���� ��
	MOV	TMOD,#00000001B ;��ʱ/������0�����ڷ�ʽ1
	MOV	TH0,#15H	
	MOV	TL0,#0A0H  ;����5536
	SETB	EA	;�����ж�����
	SETB	ET0	;����ʱ/������0����
SETB	TR0	       ;��ʱ/������0��ʼ����
LOOP:	AJMP	LOOP	;��������ʱ,�����д�������
TIME0:			;��ʱ��0���жϴ������
	PUSH	ACC
PUSH	PSW	;��PSW��ACC�����ջ����
	CPL	P1.0	
	MOV	TH0,#15H
	MOV	TL0,#0A0H	;���ö�ʱ����
	POP	PSW
	POP	ACC
	RETI
END
