;********************************************************************************
;*  ����:  ME300ϵ�п���ϵͳ��ʾ���� - LED�������ʾ1-8                         *
;*  Ӳ���� ME300A,ME300A+,ME300B                                                *
;*  �ļ�:  wl004.asm                                                            *
;*  ����:  2004-1-5                                                             *
;*  �汾:  1.0                                                                  *
;*  ����:  ΰ�ɵ��� - Freeman                                                   *
;*  ����:  freeman@willar.com                                                   *
;*  ��վ�� http://www.willar.com                                                *
;********************************************************************************
;*  ����:                                                                       *
;*         LED�������ʾ��ʾ����                                                *
;*         ��8��LED�������������ʾ1,2,3,4,5,6,7,8                              *
;*                                                                              *
;********************************************************************************
;*  �������ã�                                                                  *
;*     ME300A+    JP1 ȫ���̽ӣ�JP2�̽�2-3��                                    *
;*     ME300B     JP1 �̽ӣ�    JP2�̽�2-3��                                    *
;*                                                                              *
;********************************************************************************
;* ����Ȩ�� Copyright(C)ΰ�ɵ��� www.willar.com  All Rights Reserved            *
;* �������� �˳��������ѧϰ��ο���������ע����Ȩ��������Ϣ��                  *
;********************************************************************************

CODE_SEG	SEGMENT	CODE 

DATA_SEG	SEGMENT	DATA 

	RSEG  DATA_SEG
	
dis_digit:	DS		1
dis_index:	DS		1
dis_buf:	DS		8
stack:		DS		20

;===========================================================

CSEG	AT	00000H				; Reset����
	LJMP	MAIN

CSEG	AT	0000BH				; ��ʱ��0�ж�����

	LJMP	TIMER0


;===========================================================
	RSEG  CODE_SEG	
MAIN:
	MOV	SP,#(stack-1)			; ��ʼ����ջָ��
	MOV  	P0,#0FFH			; ��ʼ��I/O��
	MOV  	P2,#0FFH
	MOV  	TMOD,#01H			; ��ʼ��timer0
	MOV  	TH0,#0FCH
	MOV  	TL0,#017H
	MOV  	IE,#082H
	
	MOV	DPTR, #DIS_CODE		; �趨��ʾ��ֵ
	MOV	A,#1
	MOVC	A,@A+DPTR
	MOV  	dis_buf,A
	MOV	A,#2
	MOVC	A,@A+DPTR	
	MOV  	dis_buf+01H,A
	MOV	A,#3
	MOVC	A,@A+DPTR
	MOV  	dis_buf+02H,A
	MOV	A,#4
	MOVC	A,@A+DPTR
	MOV  	dis_buf+03H,A
	MOV	A,#5
	MOVC	A,@A+DPTR
	MOV  	dis_buf+04H,A
	MOV	A,#6
	MOVC	A,@A+DPTR
	MOV  	dis_buf+05H,A
	MOV	A,#7
	MOVC	A,@A+DPTR
	MOV  	dis_buf+06H,A
	MOV	A,#8
	MOVC	A,@A+DPTR
	MOV  	dis_buf+07H,A
	
	MOV  	dis_digit,#0FEH		; ��ʼ�ӵ�һ������ܿ�ʼɨ��
	MOV  	dis_index,A

	SETB 	TR0					; ������ʱ��0����ʼ��̬ɨ����ʾ

MAIN_LP:					

	; ������ѭ����������������				

	SJMP 	MAIN_LP

; END OF main


;===========================================================

	USING	0
TIMER0:
; ��ʱ��0�жϷ�����, ��������ܵĶ�̬ɨ��
; DIS_INDEX --- ��ʾ����, ���ڱ�ʶ��ǰ��ʾ������ܺͻ�������ƫ����
; DIS_DIGIT --- λѡֵͨ, ���͵�P2������ѡͨ��ǰ����ܵ���ֵ, �����0xfeʱ,
;		ѡͨP2.0�������
; DIS_BUF   --- ���ڻ���������ַ		

	PUSH 	ACC
	PUSH 	PSW
	PUSH 	AR0
	
	MOV  	TH0,#0FCH
	MOV  	TL0,#017H
	
	MOV  	P2,#0FFH		; �ȹر����������
	
	MOV  	A,#DIS_BUF		; �����ʾ����������ַ
	ADD  	A,DIS_INDEX		; ���ƫ����
	MOV  	R0,A			; R0 = ����ַ + ƫ����
	MOV  	A,@R0			; �����ʾ����
	MOV  	P0,A			; ��ʾ���봫�͵�P0��
	
	MOV  	P2,DIS_DIGIT		; 

	MOV	A,DIS_DIGIT		; λѡֵͨ����, �´��ж�ʱѡͨ��һλ�����
	RL	A
	MOV	DIS_DIGIT,A
	
	INC	DIS_INDEX		; DIS_INDEX��1, �´��ж�ʱ��ʾ��һλ
	ANL	DIS_INDEX,#0x07		; ��DIS_INDEX����8(0000 1000)ʱ, ��0

	POP  	AR0
	POP  	PSW
	POP  	ACC
	
	RETI 
; END OF timer0
;===========================================================

	RSEG  CODE_SEG
DIS_CODE:
	DB	0C0H
	DB	0F9H
	DB	0A4H
	DB	0B0H
	DB	099H
	DB	092H
	DB	082H
	DB	0F8H
	DB	080H
	DB	090H
	DB	0FFH

	END
