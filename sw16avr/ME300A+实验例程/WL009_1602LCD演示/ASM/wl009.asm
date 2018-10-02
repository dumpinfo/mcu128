;********************************************************************************
;*  ����:  ME300ϵ�е�Ƭ������ϵͳ��ʾ���� - 1602LCD��ʾ��ʾ����                *
;*  Ӳ���� ME300A+,ME300B                                                       *
;*  �ļ�:  wl009.asm                                                            *
;*  ����:  2005-1-20                                                            *
;*  �汾:  1.0                                                                  *
;*  ����:  ΰ�ɵ��� - Freeman                                                   *
;*  ����:  freeman@willar.com                                                   *
;*  ��վ�� http://www.willar.com                                                *
;********************************************************************************
;*  ����:                                                                       *
;*         1602�ַ���LCD��ʾ��ʾ����                                            *
;*         �ڵ�һ����ʾ     welcome                                             *
;*         �ڵڶ�����ʾ  www.willar.com                                         *
;********************************************************************************
;*  �������ã�                                                                  *
;*     ME300A+    JP1 ȫ���̽ӣ�JP2�̽�1-2��                                    *
;*     ME300B     JP1 �̽ӣ�JP2�̽�1-2��                                        *
;*                                                                              *
;********************************************************************************
;* ����Ȩ�� Copyright(C)ΰ�ɵ��� www.willar.com  All Rights Reserved            *
;* �������� �˳��������ѧϰ��ο���������ע����Ȩ��������Ϣ��                  *
;********************************************************************************


; �˿ڶ���
RS	EQU	P2.0
RW	EQU	P2.1
EP	EQU	P2.2

	ORG	0000H
	LJMP	MAIN


MAIN:
	LCALL	LCD_INIT		; ��ʼ��LCD
	MOV	A,#15
	LCALL	DELAY_MS		;

MAIN_LOOP:	
;  �ڵ�һ����ʾ�ַ���"welcome!"
	MOV	A,#4
	LCALL	SET_LCD_POS		; ����LCD��굽��һ�еĵ�5���ַ�
	
	MOV	DPTR,#TAB_WELCOME	; "welcome!"�ִ�����ַ
	LCALL	DISPLAY_STRING		; ��ʾ�ַ���
; �ڵڶ�����ʾ�ַ���"www.willar.com"	
	MOV	A,#41H			; 
	LCALL	SET_LCD_POS		; ����LCD��굽�ڶ��еڶ����ַ�
	
	MOV	DPTR,#TAB_WILLAR
	LCALL	DISPLAY_STRING

; ��˸��ʾ����	
	MOV	A,#200			; 
	LCALL	DELAY_MS		; 
	
	LCALL	LCD_TURN_OFF	
	MOV	A,#200			; 
	LCALL	DELAY_MS		; 
	
	LCALL	LCD_TURN_ON
	
	MOV	A,#200			; 
	LCALL	DELAY_MS		; 
	
	LCALL	LCD_TURN_OFF
		
	MOV	A,#200			; 
	LCALL	DELAY_MS		; 
	
	LCALL	LCD_TURN_ON
	
	MOV	A,#200			; 
	LCALL	DELAY_MS		; 
;����
	LCALL	LCD_CLEAR
	MOV	A,#1
	LCALL	DELAY_MS
; ������ʾ	
	JMP	MAIN_LOOP	

;��ʾ�ַ�������
;���������DPTR(�ַ�������ַ)
;����ֵ����
DISPLAY_STRING:	
	CLR	A
	MOVC	A,@A+DPTR		; 
	JZ	END_DISPLAY_STRING	; �������00H��ʾ������
	LCALL	LCD_WRITE_DATA		; д���ݵ�LCD
	INC	DPTR			; ָ�������һ�ַ�
	MOV	A, #200			; 
	LCALL	DELAY_MS		; 
	SJMP	DISPLAY_STRING		; ѭ��ֱ���ַ�������
END_DISPLAY_STRING:
	RET
	
	
; ��ʼ��LCD
LCD_INIT:

; ������ʾ��ʽ---
	MOV	A,#38H			; 38H --- 16*2����ʾ,5*7����,8λ���ݽӿ�
	LCALL	LCD_WRITE_COMMAND
	MOV	A,#1
	LCALL	DELAY_MS
;����ʾ
	LCALL	LCD_TURN_ON
;��д��ָ���1
	MOV	A,#06H			; 06H --- ��д��ָ���1
	LCALL	LCD_WRITE_COMMAND
	MOV	A,#1
	LCALL	DELAY_MS
; ���LCD��Ļ
	LCALL	LCD_CLEAR
	RET


;����ʾ
LCD_TURN_ON:
	MOV	A,#0CH			; 0CH --- ����ʾ,�޹��
	LCALL	LCD_WRITE_COMMAND
	MOV	A,#1
	LCALL	DELAY_MS
	RET
	
; ����ʾ
LCD_TURN_OFF:
	MOV	A,#08H			; 08H --- ����ʾ
	LCALL	LCD_WRITE_COMMAND
	MOV	A,#1
	LCALL	DELAY_MS
	RET

; ���LCD��Ļ
LCD_CLEAR:
	MOV	A,#01H			; 01H����ָ��			
	LCALL	LCD_WRITE_COMMAND
	MOV	A,#1
	LCALL	DELAY_MS
	RET

;����LCD��ǰ����λ��

SET_LCD_POS:
	ORL	A,#80H		; 
	LCALL	LCD_WRITE_COMMAND
	RET

; д�����ָ�LCD
; �������: ACC(Ҫд�������)
; ����ֵ: ��
LCD_WRITE_COMMAND:
	LCALL	CHECK_LCD_BUSY
	CLR	RS
	CLR	RW
	CLR	EP
	NOP
	NOP
	MOV	P0,A			; д�����ݵ�LCD�˿�
	NOP
	NOP
	NOP
	NOP
	SETB	EP
	NOP
	NOP
	NOP
	NOP
	CLR	EP
	RET
	
; д����ʾ���ݵ�LCD
; �������: ACC(Ҫд�������)
; ����ֵ: ��
LCD_WRITE_DATA:
	LCALL	CHECK_LCD_BUSY
	SETB	RS
	CLR	RW
	CLR	EP
	NOP
	NOP
	MOV	P0,A			; д�����ݵ�LCD�˿�
	NOP
	NOP
	NOP
	NOP
	SETB	EP
	NOP
	NOP
	NOP
	NOP
	CLR	EP
	RET
	
CHECK_LCD_BUSY:
	CLR	RS
	SETB	RW
	SETB	EP
	NOP
	NOP
	NOP
	NOP
	MOV	C,P0.7			; ��ȡæµλ
	NOP
	NOP
	CLR 	EP
	NOP
	NOP
	JC	CHECK_LCD_BUSY		; �ȴ�LCD����(P0.7=0)
	
	RET


; ��ʱ�ӳ���
; �������: ACC(��ʱʱ��,��λ����)
; ����ֵ: ��
DELAY_MS:
	MOV	R7,A
DELAY_LOOP1:
	MOV	R6,#0E8H
DELAY_LOOP2:
	NOP
	NOP
	DJNZ	R6,DELAY_LOOP2
	DJNZ	R7,DELAY_LOOP1
	RET
		

TAB_WILLAR:
	DB	"www.willar.com"
	DB	00			; �ַ�������־
	
TAB_WELCOME:
	DB	"welcome!"
	DB	00			; �ַ�������־

	END
