;********************************************************************************
;*  ����:  ΰ�ɵ���ME300B��Ƭ������ϵͳ��ʾ���� - �������ʾ���׵���ʱ��        *
;*  �ļ�:  wl010.asm                                                            *
;*  ����:  2004-1-5                                                             *
;*  �汾:  1.0                                                                  *
;*  ����:  ΰ�ɵ��� - Freeman                                                   *
;*  ����:  freeman@willar.com                                                   *
;*  ��վ�� http://www.willar.com                                                *
;********************************************************************************
;*  ����:                                                                       *
;*         ���׵���ʱ��,�������ʾ                                              *
;*         K1---ʱ����                                                          *
;*         K2---�ֵ���                                                          *
;*                                                                              *
;*                                                                              *
;********************************************************************************
;* ����Ȩ�� Copyright(C)ΰ�ɵ��� www.willar.com  All Rights Reserved            *
;* �������� �˳��������ѧϰ��ο���������ע����Ȩ��������Ϣ��                  *
;********************************************************************************

CODE_SEG	SEGMENT CODE 
DATA_SEG	SEGMENT DATA 
STACK_SEG	SEGMENT	IDATA


K1	BIT	P1.4
K2	BIT	P1.5

	RSEG  DATA_SEG
KEY_S:		DS  	1
KEY_V:   	DS  	1
DIS_DIGIT:   	DS  	1
SEC:   		DS  	1
DIS_INDEX:  	DS   	1
HOUR:   	DS   	1
MIN:   		DS   	1
SEC100:   	DS   	1
DIS_BUF:   	DS   	8
        
BUF_HOUR_H	EQU	DIS_BUF		; Сʱʮλ
BUF_HOUR_L	EQU	DIS_BUF+1	; Сʱ��λ
BUF_MIN_H	EQU	DIS_BUF+3	; ��ʮλ
BUF_MIN_L	EQU	DIS_BUF+4	; �ָ�λ
BUF_SEC_H	EQU	DIS_BUF+6	; ��ʮλ
BUF_SEC_L	EQU	DIS_BUF+7	; ���λ

	RSEG	STACK_SEG
STACK:	DS	20	
	

;===============================================================================

CSEG	AT	0000H
	JMP	MAIN
	
CSEG	AT	0000BH
	LJMP	TIMER0	

CSEG	AT	0001BH
	LJMP	TIMER1

;===============================================================================


	RSEG  CODE_SEG
MAIN:
	USING	0
	
	MOV	SP, #(STACK-1)		;
	
	
	MOV  	P0,#0FFH
	MOV  	P2,#0FFH
	MOV  	TMOD,#011H		; ��ʱ��0, 1����ģʽ1, 16λ��ʱ��ʽ
	MOV  	TH0,#0FCH
	MOV  	TL0,#017H
	MOV  	TH1,#0DCH
	CLR  	A
	MOV  	TL1,A
	
	MOV  	HOUR,#12		; 
	CLR	A			; 
	MOV  	MIN,A
	MOV  	SEC,A
	MOV  	SEC100,A
	
	MOV  	A,HOUR
	MOV  	B,#10
	DIV  	AB
	MOV  	DPTR,#DIS_CODE
	MOVC 	A,@A+DPTR
	MOV  	BUF_HOUR_H,A		; ʱʮλ
	MOV  	A,HOUR
	MOV  	B,#10
	DIV  	AB
	MOV  	A,B
	MOVC 	A,@A+DPTR
	MOV  	BUF_HOUR_L,A		; ʱ��λ
	MOV  	A,MIN
	MOV  	B,#10
	DIV  	AB
	MOVC 	A,@A+DPTR
	MOV  	BUF_MIN_H,A		; ��ʮλ
	MOV  	A,MIN
	MOV  	B,#10
	DIV  	AB
	MOV  	A,B
	MOVC 	A,@A+DPTR
	MOV  	BUF_MIN_L,A		; �ָ�λ
	MOV  	A,SEC
	MOV  	B,#10
	DIV  	AB
	MOVC 	A,@A+DPTR
	MOV  	BUF_SEC_H,A		; ��ʮλ
	MOV  	A,SEC
	MOV  	B,#10
	DIV  	AB
	MOV  	A,B
	MOVC 	A,@A+DPTR
	MOV  	BUF_SEC_L,A		; ���λ
	
	MOV  	BUF_HOUR_H+02H,#0BFH
	MOV  	BUF_HOUR_H+05H,#0BFH
	
	MOV  	DIS_DIGIT,#0FEH
	CLR	A
	MOV  	DIS_INDEX,A
	
	MOV  	IE,#08AH		; ʹ��timer0,1 �ж�
	
	SETB	TR0
	SETB	TR1
	
	MOV  	KEY_V,#03H
	
MAIN_LP:
	LCALL	SCAN_KEY		; ��ɨ��
	JZ  	MAIN_LP			; �޼�����
	
	MOV	R7,#10			; ��ʱ10ms
	LCALL	DELAYMS			; ��ʱȥ����
	LCALL	SCAN_KEY		; �ٴ�ɨ��
	JZ	MAIN_LP			; �޼�����
	
	MOV  	KEY_V,KEY_S		; �����ֵ
	LCALL	PROC_KEY		; ������
	SJMP	MAIN_LP			; ������ѭ��


;===============================================================================
SCAN_KEY:
; ɨ��ɨ���ӳ���
; ���水��״̬��key_s
; ����: A --- �����Ƿ���(BOOL)

	CLR	A
	
	MOV  	C,K1			; ������K1
	MOV	ACC.0,C
	MOV	C,K2			; ������K2
	MOV	ACC.1,C
	
	MOV	KEY_S,A			;  ���水��״̬��key_s
	XRL  	A,KEY_V
	RET  	

;===============================================================================
PROC_KEY:
; �������ӳ���
; �������: KEY_V --- ����ֵ
; ����ֵ: ��

	CLR  	EA
	
	MOV  	A,KEY_V
	JNB	ACC.0,PROC_K1
	JNB	ACC.1,PROC_K2
	SJMP	END_PROC_KEY
	
PROC_K1:				; ����k1����
	LCALL	INC_HOUR		; Сʱ��1
	SJMP 	END_PROC_KEY

PROC_K2:				; ����K2����
	INC  	MIN			; ���Ӽ�1
	
	MOV  	A,MIN			; 
	SETB 	C
	SUBB 	A,#59	
	JC   	K2_UPDATE_MIN		; ������ӵ���60,�����0,Сʱ��1
	
	CLR  	A			; 
	MOV  	MIN,A

K2_UPDATE_MIN:				; ���·���ʾ������
	MOV  	A,MIN
	MOV  	B,#10
	DIV  	AB			; A = MIN / 10	
	MOV  	DPTR,#DIS_CODE
	MOVC 	A,@A+DPTR
	MOV  	BUF_MIN_H,A		; ���·�ʮλ
	
	MOV  	A,MIN
	MOV  	B,#10
	DIV  	AB
	MOV  	A,B			; A = MIN % 10
	MOVC 	A,@A+DPTR
	MOV  	BUF_MIN_L,A		; ���·ָ�λ	
	
END_PROC_KEY:
	SETB 	EA
	RET  	

;===============================================================================

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
	
	MOV  	P2,DIS_DIGIT

	MOV	A,DIS_DIGIT		; λѡֵͨ����, �´��ж�ʱѡͨ��һλ�����
	RL	A
	MOV	DIS_DIGIT,A
	
	INC	DIS_INDEX		; DIS_INDEX��1, �´��ж�ʱ��ʾ��һλ
	ANL	DIS_INDEX,#0x07		; ��DIS_INDEX����8(0000 1000)ʱ, ��0

	POP  	AR0
	POP  	PSW
	POP  	ACC
	
	RETI 	

;===============================================================================
	USING	0
TIMER1:
; ��ʱ��1�жϷ������, ����ʱ���ź�10ms
; 
;
	PUSH	PSW
	PUSH 	ACC
	PUSH 	B
	PUSH 	DPH
	PUSH 	DPL
	
	MOV  	TH1,#0DCH
	
	INC  	SEC100
	
	MOV  	A,SEC100
	CLR  	C
	SUBB 	A,#100			; �Ƿ��ж�100��(�ﵽ1s)
	JC   	END_TIMER1		; < 1S
	
	MOV  	SEC100,#00H		; �ﵽ1s 
	LCALL	INC_SEC			; ���1 
	
END_TIMER1:
	POP  	DPL
	POP  	DPH
	POP  	B
	POP  	ACC
	POP	PSW
	
	RETI 				; 

;===============================================================================
INC_SEC:
	INC  	SEC
	
	MOV  	A,SEC
	SETB 	C
	SUBB 	A,#59			; 
	JC   	UPDATE_SEC
	
	CLR  	A
	MOV  	SEC,A
	LCALL	INC_MIN
	
UPDATE_SEC:
	MOV  	A,SEC
	MOV  	B,#10
	DIV  	AB			; A = SEC / 10
	MOV  	DPTR,#DIS_CODE
	MOVC 	A,@A+DPTR		; 
	MOV  	BUF_SEC_H,A		; 
	
	MOV  	A,SEC
	MOV  	B,#10
	DIV  	AB
	MOV  	A,B			; A = SEC % 10
	MOVC 	A,@A+DPTR
	MOV  	BUF_SEC_L,A
	RET  	

;===============================================================================

INC_MIN:
	INC  	MIN			; ���Ӽ�1
	
	MOV  	A,MIN			; 
	SETB 	C
	SUBB 	A,#59	
	JC   	UPDATE_MIN		; ������ӵ���60,�����0,Сʱ��1
	
	CLR  	A			; 
	MOV  	MIN,A
	LCALL	INC_HOUR		; Сʱ��1
	
UPDATE_MIN:				; ���·���ʾ������
	MOV  	A,MIN
	MOV  	B,#10
	DIV  	AB			; A = MIN / 10	
	MOV  	DPTR,#DIS_CODE
	MOVC 	A,@A+DPTR
	MOV  	BUF_MIN_H,A		; ���·�ʮλ
	
	MOV  	A,MIN
	MOV  	B,#10
	DIV  	AB
	MOV  	A,B			; A = MIN % 10
	MOVC 	A,@A+DPTR
	MOV  	BUF_MIN_L,A		; ���·ָ�λ
	
	RET  	

;===============================================================================

INC_HOUR:
	INC  	HOUR			; Сʱ��1 
	MOV  	A,HOUR
	SETB 	C
	SUBB 	A,#24
	JC   	UPDATE_HOUR		; ���Сʱ����24,��Сʱ��0
	
	CLR  	A
	MOV  	HOUR,A			; Сʱ��0 
	
UPDATE_HOUR:
	MOV  	A,HOUR
	SETB 	C
	SUBB 	A,#9
	JC   	UPDATE_HOUR1		; ���СʱС��10,��ʮλ0����ʾ
	
	MOV  	A,HOUR
	MOV  	B,#10
	DIV  	AB
	MOV  	DPTR,#DIS_CODE
	MOVC 	A,@A+DPTR		; 
	MOV  	BUF_HOUR_H,A
	SJMP 	UPDATE_HOUR2
	
UPDATE_HOUR1:
	MOV  	BUF_HOUR_H,#0FFH
	
UPDATE_HOUR2:
	MOV  	A,HOUR
	MOV  	B,#10
	DIV  	AB
	MOV  	A,B
	MOV  	DPTR,#DIS_CODE
	MOVC 	A,@A+DPTR
	MOV  	BUF_HOUR_L,A
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

;===============================================================================

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
