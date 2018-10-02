;********************************************************************************
;*  ����:  ME300ϵ�е�Ƭ������ϵͳ��ʾ���� - ����ɨ�����                       *
;*  Ӳ���� ME300A+,ME300B                                                       *
;*  �ļ�:  wl005.asm                                                            *
;*  ����:  2004-1-5                                                             *
;*  �汾:  1.0                                                                  *
;*  ����:  ΰ�ɵ��� - Freeman                                                   *
;*  ����:  freeman@willar.com                                                   *
;*  ��վ�� http://www.willar.com                                                *
;********************************************************************************
;*  ����:                                                                       *
;*         ����ɨ�����                                                         *
;*         ����K1,��������                                                      *
;*         ����K2,��������                                                      *
;*                                                                              *
;********************************************************************************
;*  �������ã�                                                                  *
;*     ME300A+    JP1 ȫ���̽ӣ�JP2�̽�3-4��                                    *
;*     ME300B     JP1 �̽ӣ�    JP2�̽�3-4��                                    *
;*                                                                              *
;********************************************************************************
;* ����Ȩ�� Copyright(C)ΰ�ɵ��� www.willar.com  All Rights Reserved            *
;* �������� �˳��������ѧϰ��ο���������ע����Ȩ��������Ϣ��                  *
;********************************************************************************

CODE_SEG	SEGMENT	CODE
DATA_SEG	SEGMENT	DATA
STACK_SEG	SEGMENT	IDATA

	RSEG	DATA_SEG
KEY_S:	DS	1
KEY_V:	DS	1

	RSEG	STACK_SEG
STACK:	DS	20


K1	BIT	P1.4		; 
K2	BIT	P1.5		; 


	CSEG	AT	0000H
	JMP	MAIN

;===============================================================================	
	RSEG	CODE_SEG
MAIN:
	MOV	SP,#(STACK-1)		; ����ջָ��
	MOV	P0,#0FEH		; ��ʼ����LED P00
	MOV	KEY_V,#03H		; ��ʼ��ֵ

KEY_CHKSW:				; ѭ����ⰴ���Ƿ���					
	ACALL	SCAN_KEY		; ���밴��״̬
	MOV	KEY_S,A
	XRL	A,KEY_V			; ��鰴��ֵ�Ƿ�ı�
	JZ	KEY_CHKSW		; ���޼�����,������KEY_CHKSW
	
	MOV	R7,#10			; ��ʱ10ms
	ACALL	DELAYMS			; ��ʱȥ��
	ACALL	SCAN_KEY		; �ٴμ�鰴��ֵ
	MOV	KEY_S,A
	XRL	A,KEY_V
	JZ	KEY_CHKSW
	
	MOV	KEY_V,KEY_S		; ���水��״̬
	ACALL	PROC_KEY		;
	SJMP	KEY_CHKSW
;===============================================================================
SCAN_KEY:				
; ɨ�谴��
; �������:��
; ����ֵ:A --- ����״̬

	CLR	A
	MOV	C,K1
	MOV	ACC.0,C
	MOV	C,K2
	MOV	ACC.1,C
	RET

;===============================================================================	
PROC_KEY:
; ���������ӳ���
; �������: KEY_V --- ����ֵ
; ����ֵ: ��

	MOV	A,KEY_V
	JNB	ACC.0,PROC_K1
	JNB	ACC.1,PROC_K2
	RET
	
PROC_K1:				; ����K1�������
	MOV	A,P0			; ����
	RR	A
	MOV	P0,A
	RET
	
PROC_K2:				; ����K2�������
	MOV	A,P0			; ����
	RL	A
	MOV	P0,A	 
	RET

;===============================================================================	

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
	
	END