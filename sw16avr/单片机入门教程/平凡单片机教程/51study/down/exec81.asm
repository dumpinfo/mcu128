FIRST		EQU	P2.7	;��һλ����ܵ�λ����
SECOND  	EQU	P2.6	;�ڶ�λ����ܵ�λ����
DISPBUFF	EQU	5AH	;��ʾ������Ϊ5AH��5BH
	ORG	0000H
	AJMP	START
	ORG	30H
START:
	MOV	SP,#5FH		;���ö�ջ
	MOV	P1,#0FFH
	MOV	P0,#0FFH
	MOV	P2,#0FFH	;��ʼ��������ʾ����LED��
	MOV	DISPBUFF,#0	;��һλ��ʾ0
	MOV	DISPBUFF+1,#1	;�ڶ�����ʾ1
	
LOOP:
	LCALL	DISP		;������ʾ����
	AJMP	LOOP
;�����򵽴˽���
DISP:
	PUSH	ACC		;ACC��ջ
	PUSH	PSW		;PSW��ջ
	MOV	A,DISPBUFF	;ȡ��һ������ʾ��
	MOV	DPTR,#DISPTAB	;���α��׵�ַ
	MOVC	A,@A+DPTR	;ȡ������
	MOV	P0,A		;����������P0λ���οڣ�
	CLR	FIRST		;����һλ��ʾ��λ��
	LCALL	DELAY		;��ʱ1����
	SETB	FIRST		;�رյ�һλ��ʾ������ʼ׼���ڶ�λ�����ݣ�
	MOV	A,DISPBUFF+1	;ȡ��ʾ�������ĵڶ�λ
	MOV	DPTR,#DISPTAB	
	MOVC	A,@A+DPTR
	MOV	P0,A		;���ڶ�����������P0��
	CLR	SECOND		;���ڶ�λ��ʾ��
	LCALL	DELAY		;��ʱ
	SETB	SECOND		;�صڶ�λ��ʾ
	POP	PSW
	POP	ACC
	RET
DELAY:			;��ʱ1����
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
