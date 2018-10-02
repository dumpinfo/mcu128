Counter		EQU	59H	;����������ʾ����ͨ������֪������ʾ�ĸ������
FIRST		EQU	P2.7	;��һλ����ܵ�λ����
SECOND  	EQU	P2.6	;�ڶ�λ����ܵ�λ����
DISPBUFF	EQU	5AH	;��ʾ������Ϊ5AH��5BH
	ORG	0000H
	AJMP	START
	ORG	000BH		;��ʱ��T0�����
	AJMP	DISP		;��ʾ����
	ORG	30H
START:
	MOV	SP,#5FH		;���ö�ջ
	MOV	P1,#0FFH
	MOV	P0,#0FFH
	MOV	P2,#0FFH	;��ʼ��������ʾ����LED��
	MOV	TMOD,#00000001B	;��ʱ��T0������ģʽ1��16λ��ʱ/����ģʽ��
	MOV	TH0,#HIGH(65536-2000)
	MOV	TL0,#LOW(65536-2000)
	SETB	TR0
	SETB	EA
	SETB	ET0
	MOV	Counter,#0	;��������ʼ��
	MOV	DISPBUFF,#0	;��һλʼ����ʾ0
	MOV	A,#0
LOOP:	
	MOV	DISPBUFF+1,A	;�ڶ�λ������ʾ0-9
	INC	A
	LCALL	DELAY
	CJNE	A,#10,LOOP
	MOV	A,#0
	AJMP	LOOP
;�����򵽴˽���
DISP:
	PUSH	ACC		;ACC��ջ
	PUSH	PSW		;PSW��ջ
	MOV	TH0,#HIGH(65536-2000)
	MOV	TL0,#LOW(65536-2000)
	SETB	FIRST
	SETB	SECOND		;����ʾ
	MOV	A,#DISPBUFF	;��ʾ�������׵�ַ�
	ADD	A,Counter	
	MOV	R0,A
	MOV	A,@R0		;���ݼ�������ֵȡ��Ӧ����ʾ��������ֵ
	MOV	DPTR,#DISPTAB	;���α��׵�ַ
	MOVC	A,@A+DPTR	;ȡ������
	MOV	P0,A		;����������P0λ���οڣ�
	MOV	A,Counter	;ȡ��������ֵ
	JZ	DISPFIRST	;�����0����ʾ��һλ
	CLR	SECOND		;������ʾ�ڶ�λ
	AJMP	DISPSECOND
DISPFIRST:
	CLR	FIRST		;��ʾ��һλ		
DISPSECOND:
	INC	Counter		;��������1
	MOV	A,Counter	
	DEC	A		;����������Ƶ�2������������0
	DEC	A		
	JZ	RSTCOUNT	
	AJMP	DISPNEXT
RSTCOUNT:
	MOV	Counter,#0	;��������ֵֻ����0��1
DISPNEXT:

	POP	PSW
	POP	ACC
	RETI
DELAY:			;��ʱ130����
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
