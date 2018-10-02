;********************************************************************************
;*  ����:  ME300ϵ�е�Ƭ������ϵͳ��ʾ���� - AT24C02��д��ʾ����                *
;*  Ӳ���� ME300A+                                                               *
;*  �ļ�:  wl007.asm                                                            *
;*  ����:  2004-1-5                                                             *
;*  �汾:  1.0                                                                  *
;*  ����:  ΰ�ɵ��� - Freeman                                                   *
;*  ����:  freeman@willar.com                                                   *
;*  ��վ�� http://www.willar.com                                                *
;********************************************************************************
;*  ����:                                                                       *
;*         AT24C02��д��ʾ����                                                  *
;*                                                                              *
;********************************************************************************
;*  �������ã�                                                                  *
;*         JP1 ȫ���̽ӣ�JP2�̽�2-3��                                           *
;*                                                                              *
;********************************************************************************
;* ����Ȩ�� Copyright(C)ΰ�ɵ��� www.willar.com  All Rights Reserved            *
;* �������� �˳��������ѧϰ��ο���������ע����Ȩ��������Ϣ��                  *
;********************************************************************************

NAME	WL007

OP_READ		EQU	0xa1		; ������ַ�Լ���ȡ����
OP_WRITE 	EQU	0xa0		; ������ַ�Լ�д�����
MAX_ADDR 	EQU	0x7f		; AT24C02����ַ

CODE_SEG	SEGMENT CODE 
DATA_SEG	SEGMENT DATA
STACK_SEG	SEGMENT	IDATA


	RSEG  DATA_SEG
ADDR:	DS	1
TMP2:	DS	1
TMP3:   DS	1

	RSEG	STACK_SEG
STACK:		DS	20

SCL	BIT	P3.3
SDA	BIT	P1.3

;===============================================================================
CSEG	AT	0000H			; ��λ����
	JMP	MAIN



;===============================================================================
	RSEG  CODE_SEG
MAIN:
; ������ʼ

	USING	0
	
	MOV	SP, #(STACK-1)		; ���ö�ջ
	
	SETB 	SDA
	SETB 	SCL

	MOV  	R7,#05AH		; ȫ�����0xff
	LCALL	FILL_BYTE

	CLR  	A
	MOV  	ADDR,A
MAIN_LP1:				; �����DIS_CODE������д�뵽EEPROM

	MOV  	A,ADDR
	MOV  	DPTR,#DIS_CODE
	MOVC 	A,@A+DPTR		; ���
	
	MOV  	R5,A			; ���ݵ�R5 	
	MOV  	R7,ADDR			; ��ַ��R7
	LCALL	WRITE_BYTE

	INC  	ADDR			; ��ַ��1
	MOV  	A,ADDR
	CLR  	C
	SUBB 	A,#08H			; ��8�ֽڣ��ж��Ƿ����
	JC   	MAIN_LP1		; 
	
	CLR  	A			; 
	MOV  	ADDR,A			; 
MAIN_LP2:				; ѭ����ȡAT24C02���ݣ��������P0��
	MOV  	R7,ADDR			; ��ַ��R7
	LCALL	READ_RANDOM
	MOV  	P0,R7			; ����ȡ�����ݴ��͵�P0
	
	INC  	ADDR			; ��ַ��1
	ANL  	ADDR,#07H		; ѭ����ȡ��ΧΪ0x00��0x07
	
	MOV  	R7,#0FAH		; delay
	LCALL	DELAYMS
	
	SJMP 	MAIN_LP2
; END OF MAIN

;===============================================================================
	RSEG  CODE_SEG
START:
; ��ʼλ
; ��������� ��
; ����ֵ����

	SETB 	SDA
	SETB 	SCL
	NOP 
	NOP  
	CLR  	SDA
	NOP
	NOP  	
	NOP  	
	NOP  	
	CLR  	SCL
	RET  	
; END OF START

;===============================================================================

	RSEG  CODE_SEG
STOP:
; ֹͣλ
; ��������� ��
; ����ֵ����

	CLR  	SDA
	NOP  	
	NOP  	
	SETB 	SCL
	NOP  	
	NOP  	
	NOP  	
	NOP  	
	SETB 	SDA
	RET  	
; END OF STOP

;===============================================================================
	RSEG  CODE_SEG
SHIN:
; ��AT24Cxx�������ݵ�MCU
; ��������� ��
; ����ֵ��R7 --- �Ƴ�������

	USING	0
	CLR  	A
	MOV  	R6,A
SHIN_LP:
	SETB 	SCL
	MOV  	A,R7
	ADD  	A,ACC
	MOV  	R7,A
	MOV  	C,SDA
	CLR  	A
	RLC  	A
	ORL  	AR7,A
	CLR  	SCL
	INC  	R6
	CJNE 	R6,#08H,SHIN_LP		; ��8λ���ж��Ƿ����
	
	RET  	
; END OF SHIN

;===============================================================================
	RSEG  CODE_SEG
SHOUT:
; ��MCU�Ƴ����ݵ�AT24Cxx
; ��������� R7 --- Ҫ�Ƴ�������
; ����ֵ��C --- AT24Cxx��Ӧ��λ

	USING	0

	CLR  	A
	MOV  	R6,A
SHOUT_LP:				; ѭ������8��λ
	MOV  	A,R7
	RLC  	A
	MOV  	SDA,C
	NOP  	
	SETB 	SCL
	NOP  	
	NOP  	
	CLR  	SCL
	MOV  	A,R7
	ADD  	A,ACC
	MOV  	R7,A
	INC  	R6
	CJNE 	R6,#08H,SHOUT_LP	; ��8λ���ж��Ƿ����
	
	SETB 	SDA			; ��ȡӦ��
	NOP  	
	NOP  	
	SETB 	SCL
	NOP  	
	NOP  	
	NOP  	
	NOP  	
	MOV  	C,SDA			; ����Ӧ��λ��C
	CLR  	SCL
	RET  	
; END OF SHOUT

;===============================================================================
	RSEG  CODE_SEG	
WRITE_BYTE:
; ��ָ����ַд������
; ��������� R7 --- д�����ݵĵ�ַ
; ��������� R5 --- Ҫд�������
; ����ֵ����

	USING	0

	MOV  	R4,AR7
	LCALL	START
	
	MOV  	R7,#OP_WRITE		; д��������ַ��д����
	LCALL	SHOUT
	
	MOV  	R7,AR4			; ��ַ
	LCALL	SHOUT
	
	MOV  	R7,AR5			; ����
	LCALL	SHOUT
	
	LCALL	STOP

	MOV  	R7,#10			; д������, ��ʱ10ms
	LJMP 	DELAYMS
	
; END OF WRITE_BYTE

;===============================================================================
	RSEG  CODE_SEG
FILL_BYTE:
; ������ݵ�EEPROM��
; ��������� R7 --- Ҫ��������
; ����ֵ����

	USING	0
	
	MOV  	TMP3,R7

	CLR  	A
	MOV  	TMP2,A
FILL_LP:
	MOV  	R5,TMP3
	MOV  	R7,TMP2
	LCALL	WRITE_BYTE

	INC  	TMP2
	MOV  	A,TMP2
	CLR  	C
	SUBB 	A,#07FH
	JC   	FILL_LP
	
; END OF FILL_BYTE

;===============================================================================
	RSEG  CODE_SEG
READ_CURRENT:
; �ڵ�ǰ��ַ��ȡ
; ����������� 
; ����ֵ��R7 --- ����������

	USING	0
	LCALL	START

	MOV  	R7,#OP_READ		; д��������ַ�Ͷ�ȡ����
	LCALL	SHOUT
	
	LCALL	SHIN			; ��ȡ���ݣ�������R7

	LCALL	STOP

	RET  	
; END OF read_current

;===============================================================================
	RSEG  CODE_SEG
READ_RANDOM:
; ��ָ����ַ��ȡ
; ���������R7 --- ��ַ 
; ����ֵ��R7 --- ����������
	
	USING	0
	MOV  	R5,AR7			; �ݴ��ַ

	LCALL	START

	MOV  	R7,#OP_WRITE		; д��������ַ��д������
	LCALL	SHOUT

	MOV  	R7,AR5			; д���ַ
	LCALL	SHOUT

	LCALL	READ_CURRENT		; �ڵ�ǰ��ַ��ȡ

	RET  	
; END OF READ_RANDOM

;===============================================================================

	RSEG  CODE_SEG
DELAYMS:
; ��ʱ�ӳ���
; ���������R7 --- ��ʱֵ(MS) 
; ����ֵ����

	MOV	A,R7
	JZ	END_DLYMS	
DLY_LP1:
	MOV	R6,#185
DLY_LP2:
	NOP
	NOP
	NOP
	DJNZ	R6,DLY_LP2
	DJNZ	R7,DLY_LP1

END_DLYMS:
	RET 
	
; END OF DELAYMS

;===============================================================================
	RSEG  CODE_SEG
DIS_CODE:
; д�뵽AT24C02�����ݴ�

	DB	07EH
	DB	0BDH
	DB	0DBH
	DB	0E7H
	DB	0DBH
	DB	0BDH
	DB	07EH
	DB	0FFH


	END
