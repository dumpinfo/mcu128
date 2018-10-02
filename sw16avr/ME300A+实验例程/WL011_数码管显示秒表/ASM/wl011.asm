;********************************************************************************
;*  ����:  ME300ϵ�е�Ƭ������ϵͳ��ʾ���� - �������ʾ���                     *
;*  Ӳ���� ME300A+,ME300B                                                       *
;*  �ļ�:  wl011.asm                                                            *
;*  ����:  2004-1-5                                                             *
;*  �汾:  1.0                                                                  *
;*  ����:  ΰ�ɵ��� - Freeman                                                   *
;*  ����:  freeman@willar.com                                                   *
;*  ��վ�� http://www.willar.com                                                *
;********************************************************************************
;*  ����:                                                                       *
;*                 �������ʾ���                                               *
;*                 K1---���ư�ť                                                *
;*                       ��һ�ΰ���ʱ, ������ʼ��ʱ                             *
;*                       �ڶ��ΰ���ʱ, ֹͣ                                     *
;*                       �����ΰ���ʱ, ����                                     *
;*                                                                              *
;*    �뵥λ,�Ĵ���������ܶ�Ӧ��ϵ:                                            *
;*                                                                              *
;* --- �뵥λ ---------- ����ܶ˿� ---- ������ --------- ��ʱ(BCD��)ֵ�Ĵ���   *
;*     ʮ��λ               P20        dis_buf[7]          sec_bcd[7]           *
;*     ��λ                 P21        dis_buf[6]          sec_bcd[6]           *
;*     ǧλ                 P22        dis_buf[5]          sec_bcd[5]           *
;*     ��λ                 P23        dis_buf[4]          sec_bcd[4]           *
;*     ʮλ                 P24        dis_buf[3]          sec_bcd[3]           *
;*     ��λ(1.s)            P25        dis_buf[2]          sec_bcd[2]           *
;*     ʮ��λ(0.1s)         P26        dis_buf[1]          sec_bcd[1]           *
;*     �ٷ�λ(0.01s)        P27        dis_buf[0]          sec_bcd[0]           *
;*                                                                              *
;********************************************************************************
;*  �������ã�                                                                  *
;*     ME300A+    JP1 ȫ���̽ӣ�JP2�̽�2-3��                                    *
;*     ME300B     JP1 �̽ӣ�JP2�̽�2-3��                                        *
;********************************************************************************
;* ����Ȩ�� Copyright(C)ΰ�ɵ��� www.willar.com  All Rights Reserved            *
;* �������� �˳��������ѧϰ��ο���������ע����Ȩ��������Ϣ��                  *
;********************************************************************************


NAME	WL011

CODE_SEG       	SEGMENT	CODE
DATA_SEG       	SEGMENT DATA 
STACK_SEG	SEGMENT	IDATA

	RSEG  DATA_SEG
KEY_S:   	DS   1
KEY_V:   	DS   1
DIS_DIGIT:   	DS   1
DIS_INDEX:   	DS   1
SEC_BCD:   	DS   8		; �����ֵ, BCD��
KEY_TIMES:   	DS   1		; K1 ���´���	
DIS_BUF:   	DS   8		; ��ʾ������

	RSEG	STACK_SEG
STACK:		DS	20

K1	BIT	P1.4

;===============================================================================
CSEG	AT	0000H
	LJMP	MAIN


CSEG	AT	0000BH
	LJMP	TIMER0
	

CSEG	AT	0001BH
	LJMP	TIMER1

;===============================================================================
	RSEG	CODE_SEG
MAIN:
	USING	0
	MOV	SP,#(STACK-1)

	MOV  	P0,#0FFH		; ��ʼ���˿�
	MOV  	P2,#0FFH
	MOV  	TMOD,#011H		; 
	MOV  	TH1,#0DCH
	CLR  	A
	MOV  	TL1,A

	MOV  	TH0,#0FCH

	MOV  	TL0,#017H

	LCALL	CLR_TIME		; �����ʱֵ

	MOV  	DIS_DIGIT,#07FH		; �ϵ�ʱѡͨP27�����

	CLR  	A
	MOV  	DIS_INDEX,A

	MOV  	KEY_TIMES,A

	MOV  	KEY_V,#01H
	
	MOV  	IE,#08AH		; ʹ��timer0, timer1�ж�

	SETB 	TR0
	CLR  	TR1
	
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
; END OF main

;===============================================================================

CLR_TIME:
	
	CLR  	A
	MOV  	SEC_BCD,A		; �������м�ʱֵ
	MOV  	SEC_BCD+01H,A
	MOV  	SEC_BCD+02H,A
	MOV  	SEC_BCD+03H,A
	MOV  	SEC_BCD+04H,A
	MOV  	SEC_BCD+05H,A
	MOV  	SEC_BCD+06H,A
	MOV  	SEC_BCD+07H,A
	LJMP 	UPDATE_DISBUF		; ������ʾ������
	
; END OF CLR_TIME

;===============================================================================
SCAN_KEY:
	CLR  	A
	MOV  	KEY_S,A
	MOV  	C,K1			; ������״̬
	RLC  	A
	ORL  	KEY_S,A
	MOV  	A,KEY_S
	XRL  	A,KEY_V			; 
	
	RET  	
; END OF scan_key

;===============================================================================
PROC_KEY:
	MOV  	A,KEY_V
	JB   	ACC.0,END_PROC_KEY
	
	INC  	KEY_TIMES
	MOV  	A,KEY_TIMES
	CJNE 	A,#01H,PROC_KEY1
	
	SETB 	TR1			; KEY_TIMES = 1,��һ�ΰ���K1, ������ʼ��ʱ 
	RET
	
PROC_KEY1:
	MOV  	A,KEY_TIMES		
	CJNE 	A,#02H,PROC_KEY2
	
	CLR  	TR1			; KEY_TIMES = 2, �ڶ��ΰ���K1, ֹͣ��ʱ
	
	RET  
		
PROC_KEY2:
	LCALL	CLR_TIME		; �����ΰ���K1, �����ʱֵ
	
	CLR  	A
	MOV  	KEY_TIMES,A		; ����KEY_TIMES
	
END_PROC_KEY:
	RET  	
	
;===============================================================================

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

	MOV	A,DIS_DIGIT		; λѡֵͨ����(P20<-P27), �´��ж�ʱѡͨ��һλ�����
	RR	A
	MOV	DIS_DIGIT,A
	
	INC	DIS_INDEX		; DIS_INDEX��1, �´��ж�ʱ��ʾ��һλ
	ANL	DIS_INDEX,#0x07		; ��DIS_INDEX����8(0000 1000)ʱ, ��0

	POP  	AR0
	POP  	PSW
	POP  	ACC
	
	RETI 
; END OF timer0

;===============================================================================

TIMER1:
	PUSH 	ACC
	PUSH 	B
	PUSH 	DPH
	PUSH 	DPL
	PUSH	PSW
	PUSH	AR7

	ORL  	TH1,#0DCH		; �ָ���ʱ����ֵ

	CLR  	A
	MOV  	R7,A
	
	MOV  	A,#LOW (SEC_BCD)	
	MOV  	R0,A			; ��ʱֵ�Ĵ�����ַ��R0
	
TIMER_INC:			; 
	
	INC  	@R0			; ��ʱֵ��1

	MOV  	A,@R0
	CLR  	C
	SUBB 	A,#10			; 
	JC   	END_INC			; �����λ����10, �����

	MOV  	@R0,#00H		; ��λ��10, �����λ

	INC	R0			; ָ���λ

	INC  	R7			;	 
	CJNE 	R7,#08H,TIMER_INC	; ����ﵽ���λ, �����
	
END_INC:

	LCALL	UPDATE_DISBUF

	POP	AR7	
	POP	PSW
	POP  	DPL
	POP  	DPH
	POP  	B
	POP  	ACC
	RETI 	
; END OF timer1

;===============================================================================
UPDATE_DISBUF:
; ���ݼ�ʱ�Ĵ�����ֵ������ʾ������

	MOV  	DPTR,#DIS_CODE		; �������ַ
	
	MOV  	A,sec_bcd
	MOV  	DPTR,#dis_code
	MOVC 	A,@A+DPTR		; �����ʾ����
	MOV  	dis_buf,A		; ������ʾ������

	MOV  	A,sec_bcd+01H
	MOVC 	A,@A+DPTR
	MOV  	dis_buf+01H,A

	MOV  	A,sec_bcd+02H
	MOVC 	A,@A+DPTR
	ANL  	A,#07FH			; ��ʾС����
	MOV  	dis_buf+02H,A

	MOV  	A,sec_bcd+03H
	MOVC 	A,@A+DPTR
	MOV  	dis_buf+03H,A

	MOV  	A,sec_bcd+04H
	MOVC 	A,@A+DPTR
	MOV  	dis_buf+04H,A

	MOV  	A,sec_bcd+05H
	MOVC 	A,@A+DPTR
	MOV  	dis_buf+05H,A

	MOV  	A,sec_bcd+06H
	MOVC 	A,@A+DPTR
	MOV  	dis_buf+06H,A

	MOV  	A,sec_bcd+07H
	MOVC 	A,@A+DPTR
	MOV  	dis_buf+07H,A

	RET  	

; END OF UPDATE_DISBUF	

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
	DB	0C0H		; '0'
	DB	0F9H		; '1'
	DB	0A4H		; '2'
	DB	0B0H		; '3'
	DB	099H		; '4'
	DB	092H		; '5'
	DB	082H		; '6'
	DB	0F8H		; '7'
	DB	080H		; '8'
	DB	090H		; '9'
	DB	0FFH		; off

	END
