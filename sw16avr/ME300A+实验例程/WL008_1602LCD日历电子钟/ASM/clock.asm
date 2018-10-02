;********************************************************************************
;ME300ϵ�е�Ƭ������ϵͳ��ʾ��������ʱ��
;********************************************************************************
;
;��K1,���ν������ӹ��ܣ�����ʱ�䣬��,��,�պ�ʱ,��,��ģʽ��ֱ���˳�����״̬
;��K2,�����Ƿ��������Ӻ͵�������ʱ,��,��,��,��,��,ʱ���ʱ,��,�������
;������ʱ����K2����ֹͣ���ӵ�����
;����״̬,������ǰ����ʾһ�Զ����ַ���������ǰ������"willar"
;����״̬,LCD������ǰ����ʾ"P",������ǰ����������ʱ��ʾ"alarm:"��������ʾ"time:"
;��������ʱ����LCD�����м���ʾһС���ȣ����ӽ���ʱ���޴�С����
;����仯2000--2099,�����Զ�ת��
;���������Զ����ַ�д��
;���ߣ�chenming
;������ΰ�ɵ�����̳ www.willar.com
;
;********************************************************************************* 


;**************�����Ķ���***************** 
RS		BIT	P2.0		;LCD����/����ѡ���(H/L)
RW		BIT    	P2.1    	;LCD��/дѡ���(H/L)
EP		BIT 	P2.2		;LCDʹ�ܿ���
PRE		BIT  	P1.4		;������(K1)
ADJ		BIT	P1.5		;������(K2)
SPK		BIT    	P3.7		;�������������	

YEAR 		DATA	18H		;��,��,�ձ���
MONTH		DATA	19H
DATE		DATA 	1AH
WEEK		DATA 	1BH

HOUR		DATA 	1CH		;ʱ,��,��,�ٷ�֮һ�����
MIN		DATA	1DH
SEC		DATA	1EH
SEC100		DATA	1FH
		
HOUR_ARM	DATA 	20H		;����ʱ,��,��,����
MIN_ARM		DATA	21H
SEC_ARM		DATA	22H

STATE		DATA	23H
ALARM		BIT	STATE.0		;�����Ƿ����ñ�־1--���ã�0--��ֹ			
LEAP		BIT	STATE.1		;�Ƿ������־1--���꣬0--ƽ��

KEY_S		DATA	24H		;��ǰɨ���ֵ
KEY_V		DATA	25H		;�ϴ�ɨ���ֵ

DIS_BUF_U0	DATA	26H		;LCD������ʾ������	
DIS_BUF_U1	DATA	27H
DIS_BUF_U2	DATA	28H
DIS_BUF_U3	DATA	29H
DIS_BUF_U4	DATA	2AH
DIS_BUF_U5	DATA	2BH	
DIS_BUF_U6	DATA	2CH
DIS_BUF_U7	DATA	2DH
DIS_BUF_U8	DATA	2EH
DIS_BUF_U9	DATA	2FH
DIS_BUF_U10	DATA	30H
DIS_BUF_U11	DATA	31H
DIS_BUF_U12	DATA	32H
DIS_BUF_U13	DATA	33H
DIS_BUF_U14	DATA	34H
DIS_BUF_U15	DATA	35H


DIS_BUF_L0	DATA	36H		;LCD������ʾ������
DIS_BUF_L1	DATA	37H
DIS_BUF_L2	DATA	38H
DIS_BUF_L3	DATA	39H
DIS_BUF_L4	DATA	3AH
DIS_BUF_L5	DATA	3BH	
DIS_BUF_L6	DATA	3CH
DIS_BUF_L7	DATA	3DH
DIS_BUF_L8	DATA	3EH
DIS_BUF_L9	DATA	3FH
DIS_BUF_L10	DATA	40H
DIS_BUF_L11	DATA	41H
DIS_BUF_L12	DATA	42H
DIS_BUF_L13	DATA	43H
DIS_BUF_L14	DATA	44H
DIS_BUF_L15	DATA	45H

FLAG		DATA	46H		;��ʶ����״̬ 0-���ӹ��ܣ�1-����ʱ��2-���ӷ֣�3-������
					;4-�꣬5-�£�6-�գ�7-ʱ��8-�֣�9-�룬10-�˳�������
DIS_H		DATA	47H
DIS_M		DATA	48H
DIS_S		DATA	49H

DIS_S0		DATA	4AH						     
DIS_S1		DATA	4BH
DIS_S2		DATA	4CH
DIS_S3		DATA	4DH
DIS_S4		DATA	4EH
DIS_S5		DATA	4FH	


;******************��ʼ��***********************
		ORG	0000H
		LJMP	START
		ORG	000BH
		LJMP	TIMER0
		ORG	001BH
		LJMP	TIMER1
		ORG	0100H
START:		MOV	SP,#60H
		MOV	R0,#18H
		MOV	A,#00H
MEM_INI:	MOV	@R0,A
		INC	R0
		CJNE	R0,#5FH,MEM_INI	
		LCALL	DELAY_5ms	;��ʼ��LCD
		MOV	R0,#38H		;����LCDΪ16X2��ʾ,5X7����,��λ���ݽӿ�
		LCALL	LCD_WCMD
		LCALL	DELAY_5ms
		MOV	R0,#0CH		;����LCD����ʾ�������ʽ(��겻��˸,����ʾ"-")
		LCALL	LCD_WCMD		
		LCALL	DELAY_5ms
		MOV	R0,#06H		;LCD��ʾ����ƶ�����(����ַָ���1,������ʾ���ƶ�)	
		LCALL	LCD_WCMD
		LCALL	DELAY_5ms
		MOV	R0,#01H		;���LCD����ʾ����
		LCALL	LCD_WCMD
		LCALL	DELAY_5ms
		
		
					;��һ�Զ����ַ���
		MOV	R0,#40H
		LCALL	lcd_wcmd	;"01 000 000"��1�е�ַ (D7D6Ϊ��ַ�趨������ʽ�DD5D4D3Ϊ�ַ����λ��(0--7)��D2D1D0Ϊ�ַ��е�ַ(0--7)��
		MOV	R0,#1FH
		LCALL	lcd_wdat	;"XXX 11111"��1�����ݣ�D7D6D5ΪXXX����ʾΪ������(һ����000����D4D3D2D1D0Ϊ�ַ�������(1-������0-Ϩ��
		MOV	R0,#41H
		LCALL	lcd_wcmd 	;"01 000 001"��2�е�ַ
		MOV	R0,#11H
		LCALL	lcd_wdat 	;"XXX 10001"��2������
		MOV	R0,#42H
		LCALL	lcd_wcmd	;"01 000 010"��3�е�ַ
		MOV	R0,#15H
		LCALL	lcd_wdat 	;"XXX 10101"��3������
		MOV	R0,#43H
		LCALL	lcd_wcmd 	;"01 000 011"��4�е�ַ
		MOV	R0,#11H
		LCALL	lcd_wdat	;"XXX 10001"��4������
		MOV	R0,#44H
		LCALL	lcd_wcmd	;"01 000 100"��5�е�ַ
		MOV	R0,#1FH
		LCALL	lcd_wdat	;"XXX 11111"��5������
		MOV	R0,#45H
		LCALL	lcd_wcmd	;"01 000 101"��6�е�ַ
		MOV	R0,#0AH
		LCALL  	lcd_wdat	;"XXX 01010"��6������
		MOV	R0,#46H
		LCALL	lcd_wcmd	;"01 000 110"��7�е�ַ
		MOV	R0,#1FH
		LCALL  	lcd_wdat	;"XXX 11111"��7������
		MOV	R0,#47H
		LCALL	lcd_wcmd	;"01 000 111"��8�е�ַ
		MOV	R0,#00H
		LCALL  	lcd_wdat	;"XXX 00000"��8������ 

					;�ڶ����Զ����ַ���
		MOV	R0,#48H
		LCALL	lcd_wcmd	;"01 001 000"��1�е�ַ
		MOV	R0,#01H
		LCALL  	lcd_wdat	;"XXX 00001"��1������
		MOV	R0,#49H
		LCALL	lcd_wcmd	;"01 001 001"��2�е�ַ
		MOV	R0,#1BH
		LCALL  	lcd_wdat	;"XXX 11011"��2������
		MOV	R0,#4AH
		LCALL	lcd_wcmd	;"01 001 010"��3�е�ַ
		MOV	R0,#1DH
		LCALL  	lcd_wdat	;"XXX 11101"��3������
		MOV	R0,#4BH
		LCALL	lcd_wcmd	;"01 001 011"��4�е�ַ
		MOV	R0,#19H
		LCALL  	lcd_wdat	;"XXX 11001"��4������
		MOV	R0,#4CH
		LCALL	lcd_wcmd	;"01 001 100"��5�е�ַ
		MOV	R0,#1DH
		LCALL  	lcd_wdat	;"XXX 11101"��5������
		MOV	R0,#4DH
		LCALL	lcd_wcmd	;"01 001 101"��6�е�ַ
		MOV	R0,#1BH
		LCALL  	lcd_wdat	;"XXX 11011"��6������
		MOV	R0,#4EH
		LCALL	lcd_wcmd	;"01 001 110"��7�е�ַ
		MOV	R0,#01H
		LCALL	lcd_wdat	;"XXX 00001"��7������
		MOV	R0,#4FH
		LCALL	lcd_wcmd	;"01 001 111"��8�е�ַ
		MOV	R0,#00H
		LCALL  	lcd_wdat	;"XXX 00000"��8������ 

		MOV	YEAR,#5		;�����ֵ	
		MOV	MONTH,#1	;���³�ֵ
		MOV	DATE,#1		;���ճ�ֵ
		MOV	DIS_S0,#77H	;"w"
		MOV	DIS_S1,#69H	;"i"
		MOV	DIS_S2,#6CH	;"l"
		MOV	DIS_S3,#6CH	;"l"
		MOV	DIS_S4,#61H	;"a"
		MOV	DIS_S5,#72H	;"r"
		MOV	R1,#00H		;��ʾһ�Զ����ַ�	
		LCALL	WEEK_PRO
		LCALL	UPDATE_BUF
		LCALL	DISPLAY_PRO	;���Գ�ʼ��

;*********************������********************* 
MAIN:		MOV	IE,#8AH		;CPU���ж�,Timer0,Timer1���ж�		
		MOV	TMOD,#11H 	;Timer0,Timer1������ģʽ1, 16λ��ʱ��ʽ
		MOV	TH0,#0DCH	;Timer0��10ms��ʱ��ֵ 	
		MOV	TL0,#00H        	 
		MOV	TH1,#0FFH	;Timer1������������ֵ 
		MOV	TL1,#00H			 
		SETB	ALARM		;��ʼ�������ӹ���	
		CLR	TR1 		;Timer1��ֹ		
		SETB	TR0          	;Timer0����
		MOV	KEY_V,#03H

MAIN_1:		LCALL	KEY_SCAN
		MOV	A,KEY_S
		XRL	A,KEY_V
		JZ	MAIN_1
		LCALL	DELAY_5ms
		LCALL	DELAY_5ms
		LCALL	KEY_SCAN
		MOV	A,KEY_S
		XRL	A,KEY_V
		JZ	MAIN_1
		MOV	KEY_V,KEY_S
		MOV	A,KEY_V
		XRL	A,#01H
		JNZ	MAIN_2
		CLR	TR0		;�������״̬����ֹTimer0
		MOV	IE,#00H		;CPU��ֹ�ж�	
		LCALL	KEY_PRE_PRO	;PRE��������,����PRE�����������
		SJMP	MAIN_1
MAIN_2:		MOV	A,KEY_V
		XRL	A,#02H
		JNZ	MAIN_1
		LCALL	KEY_ADJ_PRO	;ADJ��������,����PRE�����������	
		SJMP	MAIN_1

;*******************����ɨ�����******************
KEY_SCAN:	CLR	A
		MOV	P3,#0FFH
		MOV	C,PRE
		MOV	ACC.1,C
		MOV	C,ADJ
		MOV	ACC.0,C
		MOV	KEY_S,A			;����ɨ���ֵ����KEY_S

		RET

;**************PRE�����������*******************
KEY_PRE_PRO:	INC	FLAG
		MOV	R4,FLAG
		CJNE	R4,#1,KEY_PRE_1	;ע�⣬��ָ��ı����
		MOV	R0,#0EH
		LCALL	LCD_WCMD	;��ʾ���"_",������겻��˸
		MOV	DIS_S0,#61H	;"a"
		MOV	DIS_S1,#6cH	;"l"
		MOV	DIS_S2,#61H	;"a"
		MOV	DIS_S3,#72H	;"r"
		MOV	DIS_S4,#6dH	;"m"
		MOV	DIS_S5,#3aH	;":"	           
		MOV	R1,#50H		;"P"
		MOV	DIS_H,HOUR_ARM	
		MOV	DIS_M,MIN_ARM		
		MOV	DIS_S,SEC_ARM
		LCALL	UPDATE_BUF
		LCALL	DISPLAY_PRO	;������������
		MOV	R0,#47H
		LCALL	LCD_POS		;ʹ���λ�ڵ�һ����������
		JMP	KEY_PRE_E
KEY_PRE_1:	CJNE	R4,#2,KEY_PRE_2	
		MOV	R0,#49H		
		LCALL	LCD_POS		;�����Сʱ��������λ��
		JMP	KEY_PRE_E
KEY_PRE_2:	CJNE	R4,#3,KEY_PRE_3
		MOV	R0,#4CH	
		LCALL	LCD_POS		;����÷��ӱ�������λ��
		JMP	KEY_PRE_E
KEY_PRE_3:	CJNE	R4,#4,KEY_PRE_4
		MOV	R0,#4FH		
		LCALL	LCD_POS		;�������ʱ��������λ��
		JMP	KEY_PRE_E
KEY_PRE_4:	CJNE	R4,#5,KEY_PRE_5		
		MOV	DIS_S0,#74H	;"t"
		MOV	DIS_S1,#69H	;"i"
		MOV	DIS_S2,#6dH	;"m"
		MOV	DIS_S3,#65H	;"e"
		MOV	DIS_S4,#3aH	;":"
		MOV	DIS_S5,#20H	;" "	           
		MOV	R1,#50H		;"P"
		MOV	DIS_H,HOUR	
		MOV	DIS_M,MIN		
		MOV	DIS_S,SEC
		LCALL	UPDATE_BUF
		LCALL	DISPLAY_PRO	;������������
		MOV	R0,#05H
		LCALL	LCD_POS		;����������λ��	
		JMP	KEY_PRE_E
KEY_PRE_5:	CJNE	R4,#6, KEY_PRE_6
		MOV	R0,#08H
		LCALL	LCD_POS		;������µ���λ��
		JMP	KEY_PRE_E	
KEY_PRE_6:	CJNE	R4,#7,KEY_PRE_7
		MOV	R0,#0bH
		LCALL	LCD_POS		;������յ���λ��
		JMP	KEY_PRE_E
KEY_PRE_7:	CJNE	R4,#8,KEY_PRE_8
		MOV	R0,#49H
		LCALL	LCD_POS		;�����ʱ����λ��
		JMP	KEY_PRE_E
KEY_PRE_8:	CJNE	R4,#9,KEY_PRE_9
		MOV	R0,#4cH
		LCALL	LCD_POS		;����÷ֵ���λ��
		JMP	KEY_PRE_E
KEY_PRE_9:	CJNE	R4,#10,KEY_PRE_10
		MOV	R0,#4fH
		LCALL	LCD_POS		;����������λ��
		JMP	KEY_PRE_E
KEY_PRE_10:	MOV	FLAG,#0		;FLAG��11��������
		MOV	R0,#0CH
		LCALL	LCD_WCMD	;����LCD����ʾ����겻��˸,����ʾ"-"
		MOV	R0,#01H
		LCALL	LCD_WCMD	;���LCD����ʾ����
		MOV	IE,#8AH		;CPU���ж�,TIMER0,TIMER1���ж�
		SETB	TR0		;����TIMER0	
KEY_PRE_E:
		RET

;**************ADJ�����������*******************
KEY_ADJ_PRO:	MOV	R5,FLAG
		CJNE	R5,#0,KEY_ADJ_0		;FLAG=0,�����������������ֹͣ��������
		MOV	C,TR1
		JNC	KEY_ADJ_A
		CLR	TR1
KEY_ADJ_A:	JMP	KEY_ADJ_E
KEY_ADJ_0:	CJNE	R5,#1,KEY_ADJ_1		;FLAG=1�������Ƿ���������	
		CPL	ALARM
		LCALL	UPDATE_BUF
		LCALL	DISPLAY_PRO
		MOV	R0,#47H
		LCALL	LCD_POS
		JMP	KEY_ADJ_E	
KEY_ADJ_1:	CJNE	R5,#2,KEY_ADJ_2		;FLAG=2����������ʱ
		INC	HOUR_ARM
		MOV	A,HOUR_ARM
		CJNE	A,#24,KEY_ADJ_1_1
		MOV	HOUR_ARM,#0
KEY_ADJ_1_1:	MOV	DIS_H,HOUR_ARM
		LCALL	UPDATE_BUF
		LCALL	DISPLAY_PRO
		MOV	R0,#49H
		LCALL	LCD_POS
		JMP	KEY_ADJ_E
KEY_ADJ_2:	CJNE	R5,#3,KEY_ADJ_3		;FLAG=3���������ӷ�
		INC	MIN_ARM
		MOV	A,MIN_ARM
		CJNE	A,#60,KEY_ADJ_2_1
		MOV	MIN_ARM,#0
KEY_ADJ_2_1:	MOV	DIS_M,MIN_ARM
		LCALL	UPDATE_BUF
		LCALL	DISPLAY_PRO
		MOV	R0,#4CH
		LCALL	LCD_POS
		JMP	KEY_ADJ_E
KEY_ADJ_3:	CJNE	R5,#4,KEY_ADJ_4		;FLAG=4������������
		INC	SEC_ARM
		MOV	A,SEC_ARM
		CJNE	A,#60,KEY_ADJ_3_1
		MOV	SEC_ARM,#0
KEY_ADJ_3_1:	MOV	DIS_S,SEC_ARM
		LCALL	UPDATE_BUF
		LCALL	DISPLAY_PRO
		MOV	R0,#4FH
		LCALL	LCD_POS
		JMP	KEY_ADJ_E 
KEY_ADJ_4:	CJNE	R5,#5,KEY_ADJ_5		;FLAG=5��������
		INC	YEAR
		MOV	A,YEAR
		CJNE	A,#100,KEY_ADJ_4_1
		MOV	YEAR,#0
KEY_ADJ_4_1:	LCALL	WEEK_PRO
		LCALL	UPDATE_BUF
		LCALL	DISPLAY_PRO
		MOV	R0,#05H
		LCALL	LCD_POS
		JMP	KEY_ADJ_E 
KEY_ADJ_5:	CJNE	R5,#6,KEY_ADJ_6		;FLAG=6��������
		INC	MONTH
		MOV	A,MONTH
		CJNE	A,#13,KEY_ADJ_5_1
		MOV	MONTH,#1
KEY_ADJ_5_1:	LCALL	WEEK_PRO
		LCALL	UPDATE_BUF
		LCALL	DISPLAY_PRO
		MOV	R0,#08H
		LCALL	LCD_POS
		JMP	KEY_ADJ_E 
KEY_ADJ_6:	CJNE	R5,#7,KEY_ADJ_7		;FLAG=7��������
		INC	DATE			
		MOV	A,MONTH
		XRL	A,#2	
		JNZ	KEY_ADJ_6_2		;���Ƕ�����ת
		MOV	A,DATE			;
		MOV	C,LEAP			;�ж��Ƿ�����
		JC	KEY_ADJ_6_1		
		XRL	A,#29			;ƽ���������28��	
		JNZ	KEY_ADJ_6_5			
		JMP	KEY_ADJ_6_4		
KEY_ADJ_6_1:	XRL	A,#30			;�����������29��
		JNZ	KEY_ADJ_6_5			
		JMP	KEY_ADJ_6_4		;��ת���´���
KEY_ADJ_6_2:	MOV	A,MONTH
		XRL	A,#4			
		JZ	KEY_ADJ_6_3
		MOV	A,MONTH
		XRL	A,#6
		JZ	KEY_ADJ_6_3
		MOV	A,MONTH
		XRL	A,#9
		JZ	KEY_ADJ_6_3
		MOV	A,MONTH
		XRL	A,#11
		JZ	KEY_ADJ_6_3
		MOV	A,DATE
		XRL	A,#32			;��������31��
		JNZ	KEY_ADJ_6_5
		JMP	KEY_ADJ_6_4	
KEY_ADJ_6_3:	MOV	A,DATE
		XRL	A,#31			;С������30��
		JNZ	KEY_ADJ_6_5
KEY_ADJ_6_4:	MOV	DATE,#1
KEY_ADJ_6_5:	LCALL	WEEK_PRO
		LCALL	UPDATE_BUF
		LCALL	DISPLAY_PRO
		MOV	R0,#0BH
		LCALL	LCD_POS
		JMP	KEY_ADJ_E 
KEY_ADJ_7:	CJNE	R5,#8,KEY_ADJ_8		;FLAG=8������ʱ
		INC	HOUR
		MOV	A,HOUR
		CJNE	A,#24,KEY_ADJ_7_1
		MOV	HOUR,#0
KEY_ADJ_7_1:	MOV	DIS_H,HOUR
		LCALL	UPDATE_BUF
		LCALL	DISPLAY_PRO
		MOV	R0,#49H
		LCALL	LCD_POS
		JMP	KEY_ADJ_E
KEY_ADJ_8:	CJNE	R5,#9,KEY_ADJ_9		;FLAG=9��������
		INC	MIN
		MOV	A,MIN
		CJNE	A,#60,KEY_ADJ_8_1
		MOV	MIN,#0
KEY_ADJ_8_1:	MOV	DIS_M,MIN
		LCALL	UPDATE_BUF
		LCALL	DISPLAY_PRO
		MOV	R0,#4CH
		LCALL	LCD_POS
		JMP	KEY_ADJ_E
KEY_ADJ_9:	CJNE	R5,#10,KEY_ADJ_E	;FLAG=10��������
		INC	SEC
		MOV	A,SEC
		CJNE	A,#60,KEY_ADJ_9_1
		MOV	SEC,#0
KEY_ADJ_9_1:	MOV	DIS_S,SEC
		LCALL	UPDATE_BUF
		LCALL	DISPLAY_PRO
		MOV	R0,#4FH
		LCALL	LCD_POS
		JMP	KEY_ADJ_E 
KEY_ADJ_E:
		RET

;***************Timer0��ʱ�жϳ���*****************
TIMER0:		MOV  	TH0,#0DCH
		MOV	TL0,#00H
		INC  	SEC100	
		MOV  	A,SEC100
		CJNE	A,#100,TIMER0_E
		MOV	SEC100,#0
		LCALL	TIME_PRO
		MOV	A,SEC			;"willar��ʾ1���ӣ���ʧһ���֣��γ�����
		ANL	A,#01
		JZ	TIMER0_1
		MOV	DIS_S0,#20H		;" "
		MOV	DIS_S1,#20H		;" "
		MOV	DIS_S2,#20H		;" "
		MOV	DIS_S3,#20H		;" "
		MOV	DIS_S4,#20H		;" "
		MOV	DIS_S5,#20H		;" "	
		SJMP	TIMER0_2			
TIMER0_1:	MOV	DIS_S0,#77H		;"w"
		MOV	DIS_S1,#69H		;"i"
		MOV	DIS_S2,#6CH		;"l"
		MOV	DIS_S3,#6CH		;"l"
		MOV	DIS_S4,#61H		;"a"
		MOV	DIS_S5,#72H		;"r"	
TIMER0_2:	MOV	R1,#00H		
		MOV	DIS_H,HOUR	
		MOV	DIS_M,MIN		
		MOV	DIS_S,SEC	
		LCALL	UPDATE_BUF
		LCALL	DISPLAY_PRO
TIMER0_E:		
		RETI 				


;***********Timer1��ʱ�жϳ���******************
TIMER1:		MOV	TH1,#0FFH
		MOV	TL1,#00H
		CPL	SPK
		RETI

;**************ʱ�����ڴ�����******************
TIME_PRO:	INC	SEC			;�봦��
		MOV	A,SEC
		CJNE	A,#60,TIME_PRO_A
		MOV	SEC,#0
		INC	MIN			;�ִ���
		MOV	A,MIN
		CJNE	A,#60,TIME_PRO_A
		MOV	MIN,#0
		INC	HOUR			;ʱ����
		MOV	A,HOUR
		CJNE	A,#24,TIME_PRO_A
		MOV	HOUR,#0	
		INC	DATE			;�մ����մ���Ҫ�����Ƿ����꣬���£�С�£�
		MOV	A,MONTH
		XRL	A,#2	
		JNZ	TIME_PRO_D2		;���Ƕ��£�תTIME_PRO_D2
		MOV	A,DATE			;
		MOV	C,LEAP			;�ж��Ƿ�����
		JC	TIME_PRO_D1		
		XRL	A,#29			;ƽ���������28��	
		JNZ	TIME_PRO_W			
		SJMP	TIME_PRO_M		;��ת���´���
TIME_PRO_D1:	XRL	A,#30			;�����������29��
		JNZ	TIME_PRO_W			
		SJMP	TIME_PRO_M		;��ת���´���
TIME_PRO_D2:	MOV	A,MONTH
		XRL	A,#4			
		JZ	TIME_PRO_D3
		MOV	A,MONTH
		XRL	A,#6
		JZ	TIME_PRO_D3
		MOV	A,MONTH
		XRL	A,#9
		JZ	TIME_PRO_D3
		MOV	A,MONTH
		XRL	A,#11
		JZ	TIME_PRO_D3
		MOV	A,DATE
		XRL	A,#32			;��������31��
		JNZ	TIME_PRO_W
		SJMP	TIME_PRO_M		;��ת���´���
TIME_PRO_D3:	MOV	A,DATE
		XRL	A,#31			;С������30��
		JNZ	TIME_PRO_W	
TIME_PRO_M:	MOV	DATE,#1
		INC	MONTH			;�´���
		MOV	A,MONTH
		CJNE	A,#13,TIME_PRO_W
		MOV	MONTH,#1
		INC	YEAR			;�괦��
		MOV	A,YEAR
		CJNE	A,#100,TIME_PRO_W
		MOV	YEAR,#0
TIME_PRO_W:	LCALL	WEEK_PRO		;���ڴ���
		
TIME_PRO_A:	JNB	ALARM,TIME_PRO_E	;alarm=0,���ӹ��ܽ��ã����ж�����ʱ���Ƿ�	
		MOV	A,SEC	
		CJNE	A,SEC_ARM,TIME_PRO_E	 ;alarm=1,���ӹ������ã��ж���
		MOV	A,MIN
		CJNE	A,MIN_ARM,TIME_PRO_E	 ;alarm=1,���ӹ������ã��жϷ�
		MOV	A,HOUR                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
		CJNE	A,HOUR_ARM,TIME_PRO_E	;alarm=1,���ӹ������ã��ж�ʱ
		SETB	TR1		 	;����ʱ�䵽������Timer1(TR1=1)
TIME_PRO_E:			

		RET

;**********�����Զ����㺯��*********************
;�������㳣��W(5��6)
;�������ĿL(0--99��:L=YEAR/4 ����)
;����YEAR
;�²α���MONTH_TAB(0,3,3,6,1,4,6,2,5,0,3,5)
;����DATE
;������=(W+L+YEAR+MONTH_TAB+DATE)%7 (����)

WEEK_PRO:	MOV	A,MONTH			;ȷ���������㳣��W
		XRL	A,#1
		JZ	WEEK_PRO_1
		MOV	A,MONTH
		XRL	A,#2
		JZ	WEEK_PRO_1
		SJMP	WEEK_PRO_2
WEEK_PRO_1:	LCALL	LEAP_PRO
		MOV	C,LEAP
		JNC	WEEK_PRO_2
		MOV	R3,#5
		SJMP	WEEK_PRO_3
WEEK_PRO_2:	MOV	R3,#6
WEEK_PRO_3:	MOV	A,YEAR			;�����������ĿL
		MOV	B,#4
		DIV	AB
		ADD	A,R3			;W+L
		MOV	R3,A			
		MOV	A,YEAR
		ADD	A,R3			;(W+L)+YEAR
		MOV	R3,A			
		MOV	DPTR,#MONTH_TAB
		MOV	A,MONTH
		MOVC	A,@A+DPTR
		ADD	A,R3			;(W+L+YEAR)+MONTH_TAB 
		MOV	R3,A
		MOV	A,DATE
		ADD	A,R3			;(W+L+YEAR+MONTH_TAB+DATE)
		MOV	B,#7
		DIV	AB			;������Ϊ������
		MOV	WEEK,B	
		RET

;**********������жϺ���*********************
;�������������(YEAR)�ܱ�4�����������ܱ�100���������߱�400������
;�������ֻ���ǣ�00--99������ֻ�迼����(YEAR)�ܱ�4�������ɡ�
LEAP_PRO:	MOV	A,YEAR
		MOV	B,#4
		DIV	AB
		MOV	A,B
		JZ	LEAP_PRO_1	;�ܱ�4����
		CLR	LEAP		;ƽ�꣬����LEAP	
		LJMP	LEAP_PRO_E
LEAP_PRO_1:	SETB	LEAP		;���꣬��λLEAP
LEAP_PRO_E:		
		RET

;**********������ʾ������********************
;���R1,
UPDATE_BUF:	MOV	DIS_BUF_U0,R1	;����ʱ��"P",������������ʾһ�Զ����ַ�
		MOV	DIS_BUF_U1,#20H	;�ո�
		MOV	DIS_BUF_U2,#32H	;"2"
		MOV	DIS_BUF_U3,#30H	;"0"
		MOV	A,YEAR		;����������
		MOV	B,#10
		DIV	AB
		ADD	A,#48		;������ת��ΪASCMA��
		MOV	DIS_BUF_U4,A
		MOV	A,B
		ADD	A,#48
		MOV	DIS_BUF_U5,A
		MOV	DIS_BUF_U6,#2DH	;"-"
		MOV	A,MONTH		;����������
		MOV	B,#10
		DIV	AB
		ADD	A,#48		 
		MOV	DIS_BUF_U7,A
		MOV	A,B
		ADD	A,#48
		MOV	DIS_BUF_U8,A
		MOV	DIS_BUF_U9,#2DH	;"-"
		MOV	A,DATE		;����������
		MOV	B,#10
		DIV	AB
		ADD	A,#48		 
		MOV	DIS_BUF_U10,A
		MOV	A,B
		ADD	A,#48
		MOV	DIS_BUF_U11,A
		MOV	DIS_BUF_U12,#20H;�ո�
		MOV	B,WEEK		;������������
		MOV	A,#3
		MUL	AB
		MOV	B,A
		MOV	DPTR,#WEEK_TAB
		MOVC	A,@A+DPTR
		MOV	DIS_BUF_U13,A
		MOV	A,B
		INC	A
		MOVC	A,@A+DPTR
		MOV	DIS_BUF_U14,A
		MOV	A,B
		INC	A
		INC	A
		MOVC	A,@A+DPTR
		MOV	DIS_BUF_U15,A
		
		MOV	A,DIS_S0
		MOV	DIS_BUF_L0,A
		MOV	A,DIS_S1
		MOV	DIS_BUF_L1,A
		MOV	A,DIS_S2
	 	MOV	DIS_BUF_L2,A
		MOV	A,DIS_S3
		MOV	DIS_BUF_L3,A		
		MOV	A,DIS_S4
		MOV	DIS_BUF_L4,A		
		MOV	A,DIS_S5
		MOV	DIS_BUF_L5,A
		MOV	DIS_BUF_L6,#20H	;�ո�
		MOV	C,ALARM
		JC	UPDATE_BUF_1
		MOV	DIS_BUF_L7,#20H	;���ӽ���ʱ,��ʾ�ո�
		SJMP	UPDATE_BUF_2
UPDATE_BUF_1:	MOV	DIS_BUF_L7,#01H	;��������ʱ,��ʾС����
UPDATE_BUF_2:	MOV	A,DIS_H
		MOV	B,#10
		DIV	AB
		ADD	A,#48
		MOV	DIS_BUF_L8,A
		MOV	A,B
		ADD	A,#48
		MOV	DIS_BUF_L9,A
		MOV	DIS_BUF_L10,#3AH;":"	
		MOV	A,DIS_M
		MOV	B,#10
		DIV	AB
		ADD	A,#48 
		MOV	DIS_BUF_L11,A
		MOV	A,B
		ADD	A,#48
		MOV	DIS_BUF_L12,A
		MOV	DIS_BUF_L13,#3AH;":"
		MOV	A,DIS_S
		MOV	B,#10
		DIV	AB
		ADD	A,#48
		MOV	DIS_BUF_L14,A
		MOV	A,B
		ADD	A,#48
		MOV	DIS_BUF_L15,A
		RET

;************��ʾ�������*********************
DISPLAY_PRO:	MOV	R0,#00H
		LCALL	LCD_POS
		MOV	R0,DIS_BUF_U0
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_U1
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_U2
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_U3
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_U4
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_U5
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_U6
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_U7
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_U8
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_U9
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_U10
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_U11
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_U12
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_U13
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_U14
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_U15
		LCALL	LCD_WDAT

		MOV	R0,#40H
		LCALL	LCD_POS
		MOV	R0,DIS_BUF_L0
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_L1
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_L2
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_L3
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_L4
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_L5
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_L6
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_L7
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_L8
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_L9
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_L10
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_L11
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_L12
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_L13
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_L14
		LCALL	LCD_WDAT
		MOV	R0,DIS_BUF_L15
		LCALL	LCD_WDAT
		RET
	
;**********LCDæ��־BF���Գ���**************
BF_TEST:	PUSH 	ACC		;����ACC����
        	CLR     RS              ;RS=0 
        	SETB    RW 	        ;RW=1
        	SETB    EP              ;E=�ߵ�ƽ
		NOP
		NOP
		NOP
		NOP
		MOV	P0,#0FFH         ;��p0����1����֤����������ȷ���루�� P0�ڽṹ������
WT_BF:          NOP                      ; 
        	JB      P0.7,WT_BF       ;DB7=0  LCD����������,DB7=1  LCD������æ
        	CLR	EP
		POP 	ACC              ;�ͷ�ACC����
        	RET

;**********LCDָ��д�����******************
;������ڣ�R0
LCD_WCMD:	LCALL	BF_TEST		;���æ��־					
		CLR	RS
		CLR	RW
		CLR	EP
		NOP
		NOP
		MOV	P0,R0
		NOP
		NOP
		NOP
		NOP
		SETB	EP
		NOP
		NOP
		NOP
		NOP
		CLR 	EP
		RET

;**********LCD����д�����****************
;������ڣ�R0
LCD_WDAT:	LCALL	BF_TEST		;���æ��־
		SETB	RS
		CLR	RW
		CLR	EP
		NOP
		NOP
		MOV	P0,R0
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

;**********LCD����ָ��λ���ӳ���**************
;������ڣ�R0
LCD_POS:	MOV	A,R0
		ORL	A,#80H
		MOV	R0,A
		LCALL	LCD_WCMD
		RET
		
;**********��ʱԼ5ms�ӳ���********************
;����f=11.0592Mhz
;��ʱʱ��=(1+(1+2*100+2)*25)*12/11.0592=5507us(Լ5ms)
DELAY_5ms:	MOV	R7,#25
DELAY1:		MOV	R6,#100
DELAY2:		DJNZ	R6,DELAY2
		DJNZ	R7,DELAY1
		RET

;***********�����Զ������²α���**************
MONTH_TAB:	DB	0
		DB	0
		DB	3
		DB	3
		DB	6
		DB	1
		DB	4
		DB	6
		DB	2
		DB	5
		DB 	0
		DB	3
		DB	5

WEEK_TAB:	DB	'S','U','N'
		DB	'M','O','N'
		DB	'T','U','E'
		DB	'W','E','D'
		DB	'T','H','U'
		DB	'F','R','I'
		DB	'S','A','T'		


		END
