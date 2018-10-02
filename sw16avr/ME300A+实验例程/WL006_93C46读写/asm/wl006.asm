;********************************************************************************
;*  ����:  ME300ϵ�е�Ƭ������ϵͳ��ʾ���� - AT93C46��д��ʾ����                *
;*  Ӳ���� ME300A+,ME300B                                                       *
;*  �ļ�:  wl006.asm                                                            *
;*  ����:  2004-1-5                                                             *
;*  �汾:  1.0                                                                  *
;*  ����:  ΰ�ɵ��� - Freeman                                                   *
;*  ����:  freeman@willar.com                                                   *
;*  ��վ�� http://www.willar.com                                                *
;********************************************************************************
;*  ����:                                                                       *
;*         AT93C46��д��ʾ����                                                  *
;*         �ӵ�ַ0x00��ʼд�����ݡ�www.willar.com���� Ȼ���ٶ���                  *
;*                                                                              *
;*         ע�⣺�ڲ�����д������֮ǰ��������д��EWENָ�93C46�ұߵ�JP7����   *
;*      ����8λ��16λģʽѡ��Ĭ��Ϊ8λģʽ                                    *
;*                                                                              *
;********************************************************************************
;*  �������ã�                                                                  *
;*     ME300A+    JP1 ȫ���̽ӣ�JP2�̽�3-4��                                    *
;*     ME300B     JP1 �̽ӣ�JP2�̽�3-4�ˣ�JP3�̽�93��                           *
;*                                                                              *
;********************************************************************************
;* ����Ȩ�� Copyright(C)ΰ�ɵ��� www.willar.com  All Rights Reserved            *
;* �������� �˳��������ѧϰ��ο���������ע����Ȩ��������Ϣ��                  *
;********************************************************************************

	NAME	WL006

CODE_SEG	SEGMENT CODE 
DATA_SEG	SEGMENT	DATA
STACK_SEG	SEGMENT	IDATA

	RSEG  DATA_SEG
	
INDATA:   	DS   	1
ADDR:   	DS   	1

	RSEG	STACK_SEG
STACK:		DS	20


CS	BIT	P3.4
SK	BIT	P3.3
DI	BIT	P3.5
DO	BIT	P3.6

;===============================================================================
	CSEG	AT	0000H
	JMP	MAIN

;===============================================================================
	RSEG  CODE_SEG
MAIN:
	USING	0
	MOV	SP,#(STACK-1)		; ���ö�ջ
	
	CLR  	CS			; ��ʼ���˿�
	CLR  	SK
	SETB 	DI
	SETB 	DO

	LCALL	EWEN			; ʹ��д�����
	LCALL	ERASE			; ����ȫ������
	
	CLR  	A			; д����ʾ���뵽AT93C46
	MOV  	ADDR,A
WRITE_LP:
	MOV  	A,ADDR
	MOV  	DPTR,#DIS_CODE
	MOVC 	A,@A+DPTR
	
	MOV  	R5,A			; ���ݵ�R5
	MOV  	R7,ADDR			; ��ַ��R7
	LCALL	WRITE
	
	INC  	ADDR			; ��ַ��1
	MOV  	A,ADDR
	CLR  	C
	SUBB 	A,#08H			; ��8���ֽڣ��ж��Ƿ����
	JC   	WRITE_LP
	
	LCALL	EWDS			; ��ֹд�����	
	

	CLR  	A
	MOV  	ADDR,A
	
MAIN_LP:				; ѭ����ȡAT93C46���ݣ��������P0��
	MOV  	R7,ADDR
	LCALL	READ
	
	MOV  	P0,R7
	INC  	ADDR
	ANL  	ADDR,#07H		; ѭ����ȡ��ַΪ0x00��0x07

	MOV  	R7,#250
	LCALL	DELAYMS			; ��ʱ250ms
	
	SJMP 	MAIN_LP


;===============================================================================
	RSEG	CODE_SEG
WRITE:
; �������ݵ�AT93C46
; ���������R7 --- Ҫд�����ݵĵ�ַ
; ���������R5 --- Ҫд�������
; ����ֵ����

	USING	0
	MOV  	INDATA,R5		; �ݴ�Ҫд�������

	MOV  	R5,AR7			; ��ַ
	MOV  	R7,#040H		; д��ָ��
	LCALL	INOP			; ����INOP�ӳ���д��ָ��͵�ַ

	MOV  	R7,INDATA		; ����
	LCALL	SHIN			; ��������

	CLR  	CS

	MOV  	R7,#10
	LJMP 	DELAYMS			; ��ʱ10ms��Twp
; END OF WRITE

;===============================================================================
	RSEG  CODE_SEG
READ:
; ��ȡAT93C46�ڵ�����
; ���������R7 --- ��ַ
; ����ֵ��R7 --- ��ȡ������

	USING	0
	
	MOV  	R5,AR7
	MOV  	R7,#080H
	LCALL	INOP			; ����INOP�ӳ���д��ָ��͵�ַ

	LCALL	SHOUT			; ����SHOUT���������ݱ��浽R7
	
	CLR  	CS

	RET  	
; END OF READ

;===============================================================================
	RSEG  CODE_SEG
EWEN:
; д��ʹ��ָ��
; �����������
; ����ֵ����

	USING	0

	MOV  	R5,#060H
	CLR  	A
	MOV  	R7,A
	LCALL	INOP

	CLR  	CS

	RET  	
; END OF EWEN


;===============================================================================
	RSEG  CODE_SEG
EWDS:
; д���ָֹ��
; �����������
; ����ֵ����

	USING	0
	
	CLR  	A
	MOV  	R5,A
	MOV  	R7,A
	LCALL	INOP

	CLR  	CS

	RET  	
; END OF EWDS

;===============================================================================
	RSEG  CODE_SEG
ERASE:
; ������������
; �����������
; ����ֵ����

	USING	0
	
	MOV  	R5,#040H
	CLR  	A
	MOV  	R7,A
	LCALL	INOP

	MOV  	R7,#01EH
	LCALL	DELAYMS

	CLR  	CS

	RET  	
; END OF ERASE

;===============================================================================
	RSEG  CODE_SEG
INOP:
; д�������
; ���������R7����λ --- ָ����ĸ���λ
; ���������R5����λ --- ָ����ĵ�7λ���ַ
; ����ֵ����

	USING	0		

	CLR  	SK			; ��ʼλ
	SETB 	DI
	SETB 	CS
	NOP  	
	NOP  	
	SETB 	SK
	NOP  	
	NOP  				
	CLR  	SK			; ��ʼλ����

	MOV  	A,R7			; ������ָ�����λ
	RLC  	A
	MOV  	DI,C
	SETB 	SK
	RLC	A
	CLR  	SK
	MOV  	DI,C			; ����ָ����θ�λ
	SETB 	SK
	NOP  	
	NOP  	
	CLR  	SK


	MOV  	A,R5			; �������µ�ָ������ַ����
	RLC	A
	MOV  	R5,A			; R5����һλ 
	
	CLR  	A
	MOV  	R7,A
INOP_LP:
	MOV  	A,R5			; ����R5�ĸ�7λ
	RLC  	A
	MOV  	DI,C
	SETB 	SK
	MOV  	A,R5
	RLC	A
	MOV  	R5,A
	CLR  	SK
	
	INC  	R7
	CJNE 	R7,#07H,INOP_LP		; �ж��Ƿ�7λȫ����

	SETB 	DI

	RET  	
; END OF INOP

;===============================================================================
	RSEG  CODE_SEG
SHIN:
; ��MCU�Ƴ����ݵ�AT93C46
; ���������R7 --- Ҫ���������
; ����ֵ����

	USING	0

	CLR  	A
	MOV  	R6,A
	MOV	A,R6
	MOV  	A,R7
SHIN_LP:
	RLC  	A
	MOV  	DI,C
	SETB 	SK
	NOP
	NOP
	CLR  	SK
	
	INC  	R6
	CJNE 	R6,#08H,SHIN_LP	; ��8λ���ж��Ƿ����

	SETB 	DI
	RET  	
; END OF SHIN

;===============================================================================

	RSEG  CODE_SEG
SHOUT:
; ��AT93C46�Ƴ�����MCU
; �����������
; ����ֵ��R7 --- ����������

	USING	0

	CLR  	A
	MOV  	R6,A
SHOUT_LP:
	SETB 	SK
	NOP
	NOP	
	CLR  	SK	
	MOV  	C,DO
	RLC  	A
	INC  	R6
	CJNE 	R6,#08H,SHOUT_LP		; ��8λ���ж��Ƿ����
	MOV	AR7,A

	RET  	
; END OF SHOUT

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
; д�뵽AT93C46�����ݴ�

	DB	07EH
	DB	0BDH
	DB	0DBH
	DB	0E7H
	DB	0DBH
	DB	0BDH
	DB	07EH
	DB	0FFH

	END


