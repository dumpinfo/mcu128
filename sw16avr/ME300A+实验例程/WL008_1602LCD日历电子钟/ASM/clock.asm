;********************************************************************************
;ME300系列单片机开发系统演示程序－日历时钟
;********************************************************************************
;
;按K1,依次进入闹钟功能，闹钟时间，年,月,日和时,分,秒模式，直致退出设置状态
;按K2,调整是否起用闹钟和调节闹钟时,分,秒,年,月,日,时间的时,分,秒的数字
;闹钟响时，按K2即可停止闹钟的声响
;正常状态,上排最前面显示一自定义字符，下排最前面闪动"willar"
;设置状态,LCD上排最前面显示"P",下排最前面设置闹钟时显示"alarm:"，其他显示"time:"
;闹钟启用时，在LCD下排中间显示一小喇叭，闹钟禁用时，无此小喇叭
;年代变化2000--2099,星期自动转换
;程序中有自定义字符写入
;作者：chenming
;出处：伟纳电子论坛 www.willar.com
;
;********************************************************************************* 


;**************变量的定义***************** 
RS		BIT	P2.0		;LCD数据/命令选择端(H/L)
RW		BIT    	P2.1    	;LCD读/写选择端(H/L)
EP		BIT 	P2.2		;LCD使能控制
PRE		BIT  	P1.4		;调整键(K1)
ADJ		BIT	P1.5		;调整键(K2)
SPK		BIT    	P3.7		;闹钟声音输出口	

YEAR 		DATA	18H		;年,月,日变量
MONTH		DATA	19H
DATE		DATA 	1AH
WEEK		DATA 	1BH

HOUR		DATA 	1CH		;时,分,秒,百分之一秒变量
MIN		DATA	1DH
SEC		DATA	1EH
SEC100		DATA	1FH
		
HOUR_ARM	DATA 	20H		;闹钟时,分,秒,变量
MIN_ARM		DATA	21H
SEC_ARM		DATA	22H

STATE		DATA	23H
ALARM		BIT	STATE.0		;闹钟是否启用标志1--启用，0--禁止			
LEAP		BIT	STATE.1		;是否闰年标志1--闰年，0--平年

KEY_S		DATA	24H		;当前扫描键值
KEY_V		DATA	25H		;上次扫描键值

DIS_BUF_U0	DATA	26H		;LCD上排显示缓冲区	
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


DIS_BUF_L0	DATA	36H		;LCD下排显示缓冲区
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

FLAG		DATA	46H		;标识调整状态 0-闹钟功能，1-闹钟时，2-闹钟分，3-闹钟秒
					;4-年，5-月，6-日，7-时，8-分，9-秒，10-退出调整。
DIS_H		DATA	47H
DIS_M		DATA	48H
DIS_S		DATA	49H

DIS_S0		DATA	4AH						     
DIS_S1		DATA	4BH
DIS_S2		DATA	4CH
DIS_S3		DATA	4DH
DIS_S4		DATA	4EH
DIS_S5		DATA	4FH	


;******************初始化***********************
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
		LCALL	DELAY_5ms	;初始化LCD
		MOV	R0,#38H		;设置LCD为16X2显示,5X7点阵,八位数据接口
		LCALL	LCD_WCMD
		LCALL	DELAY_5ms
		MOV	R0,#0CH		;设置LCD开显示及光标形式(光标不闪烁,不显示"-")
		LCALL	LCD_WCMD		
		LCALL	DELAY_5ms
		MOV	R0,#06H		;LCD显示光标移动设置(光标地址指针加1,整屏显示不移动)	
		LCALL	LCD_WCMD
		LCALL	DELAY_5ms
		MOV	R0,#01H		;清除LCD的显示内容
		LCALL	LCD_WCMD
		LCALL	DELAY_5ms
		
		
					;第一自定义字符：
		MOV	R0,#40H
		LCALL	lcd_wcmd	;"01 000 000"第1行地址 (D7D6为地址设定命令形式D5D4D3为字符存放位置(0--7)，D2D1D0为字符行地址(0--7)）
		MOV	R0,#1FH
		LCALL	lcd_wdat	;"XXX 11111"第1行数据（D7D6D5为XXX，表示为任意数(一般用000），D4D3D2D1D0为字符行数据(1-点亮，0-熄灭）
		MOV	R0,#41H
		LCALL	lcd_wcmd 	;"01 000 001"第2行地址
		MOV	R0,#11H
		LCALL	lcd_wdat 	;"XXX 10001"第2行数据
		MOV	R0,#42H
		LCALL	lcd_wcmd	;"01 000 010"第3行地址
		MOV	R0,#15H
		LCALL	lcd_wdat 	;"XXX 10101"第3行数据
		MOV	R0,#43H
		LCALL	lcd_wcmd 	;"01 000 011"第4行地址
		MOV	R0,#11H
		LCALL	lcd_wdat	;"XXX 10001"第4行数据
		MOV	R0,#44H
		LCALL	lcd_wcmd	;"01 000 100"第5行地址
		MOV	R0,#1FH
		LCALL	lcd_wdat	;"XXX 11111"第5行数据
		MOV	R0,#45H
		LCALL	lcd_wcmd	;"01 000 101"第6行地址
		MOV	R0,#0AH
		LCALL  	lcd_wdat	;"XXX 01010"第6行数据
		MOV	R0,#46H
		LCALL	lcd_wcmd	;"01 000 110"第7行地址
		MOV	R0,#1FH
		LCALL  	lcd_wdat	;"XXX 11111"第7行数据
		MOV	R0,#47H
		LCALL	lcd_wcmd	;"01 000 111"第8行地址
		MOV	R0,#00H
		LCALL  	lcd_wdat	;"XXX 00000"第8行数据 

					;第二个自定义字符：
		MOV	R0,#48H
		LCALL	lcd_wcmd	;"01 001 000"第1行地址
		MOV	R0,#01H
		LCALL  	lcd_wdat	;"XXX 00001"第1行数据
		MOV	R0,#49H
		LCALL	lcd_wcmd	;"01 001 001"第2行地址
		MOV	R0,#1BH
		LCALL  	lcd_wdat	;"XXX 11011"第2行数据
		MOV	R0,#4AH
		LCALL	lcd_wcmd	;"01 001 010"第3行地址
		MOV	R0,#1DH
		LCALL  	lcd_wdat	;"XXX 11101"第3行数据
		MOV	R0,#4BH
		LCALL	lcd_wcmd	;"01 001 011"第4行地址
		MOV	R0,#19H
		LCALL  	lcd_wdat	;"XXX 11001"第4行数据
		MOV	R0,#4CH
		LCALL	lcd_wcmd	;"01 001 100"第5行地址
		MOV	R0,#1DH
		LCALL  	lcd_wdat	;"XXX 11101"第5行数据
		MOV	R0,#4DH
		LCALL	lcd_wcmd	;"01 001 101"第6行地址
		MOV	R0,#1BH
		LCALL  	lcd_wdat	;"XXX 11011"第6行数据
		MOV	R0,#4EH
		LCALL	lcd_wcmd	;"01 001 110"第7行地址
		MOV	R0,#01H
		LCALL	lcd_wdat	;"XXX 00001"第7行数据
		MOV	R0,#4FH
		LCALL	lcd_wcmd	;"01 001 111"第8行地址
		MOV	R0,#00H
		LCALL  	lcd_wdat	;"XXX 00000"第8行数据 

		MOV	YEAR,#5		;置年初值	
		MOV	MONTH,#1	;置月初值
		MOV	DATE,#1		;置日初值
		MOV	DIS_S0,#77H	;"w"
		MOV	DIS_S1,#69H	;"i"
		MOV	DIS_S2,#6CH	;"l"
		MOV	DIS_S3,#6CH	;"l"
		MOV	DIS_S4,#61H	;"a"
		MOV	DIS_S5,#72H	;"r"
		MOV	R1,#00H		;显示一自定义字符	
		LCALL	WEEK_PRO
		LCALL	UPDATE_BUF
		LCALL	DISPLAY_PRO	;屏显初始化

;*********************主程序********************* 
MAIN:		MOV	IE,#8AH		;CPU开中断,Timer0,Timer1开中断		
		MOV	TMOD,#11H 	;Timer0,Timer1工作于模式1, 16位定时方式
		MOV	TH0,#0DCH	;Timer0置10ms定时初值 	
		MOV	TL0,#00H        	 
		MOV	TH1,#0FFH	;Timer1置闹钟声音初值 
		MOV	TL1,#00H			 
		SETB	ALARM		;初始启动闹钟功能	
		CLR	TR1 		;Timer1禁止		
		SETB	TR0          	;Timer0启动
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
		CLR	TR0		;进入调整状态，禁止Timer0
		MOV	IE,#00H		;CPU禁止中断	
		LCALL	KEY_PRE_PRO	;PRE按键按下,调用PRE按键处理程序
		SJMP	MAIN_1
MAIN_2:		MOV	A,KEY_V
		XRL	A,#02H
		JNZ	MAIN_1
		LCALL	KEY_ADJ_PRO	;ADJ按键按下,调用PRE按键处理程序	
		SJMP	MAIN_1

;*******************按键扫描程序******************
KEY_SCAN:	CLR	A
		MOV	P3,#0FFH
		MOV	C,PRE
		MOV	ACC.1,C
		MOV	C,ADJ
		MOV	ACC.0,C
		MOV	KEY_S,A			;本次扫描键值存入KEY_S

		RET

;**************PRE按键处理程序*******************
KEY_PRE_PRO:	INC	FLAG
		MOV	R4,FLAG
		CJNE	R4,#1,KEY_PRE_1	;注意，该指令不改变操作
		MOV	R0,#0EH
		LCALL	LCD_WCMD	;显示光标"_",整个光标不闪烁
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
		LCALL	DISPLAY_PRO	;更新屏显内容
		MOV	R0,#47H
		LCALL	LCD_POS		;使光标位于第一个调整项下
		JMP	KEY_PRE_E
KEY_PRE_1:	CJNE	R4,#2,KEY_PRE_2	
		MOV	R0,#49H		
		LCALL	LCD_POS		;光标置小时报警设置位置
		JMP	KEY_PRE_E
KEY_PRE_2:	CJNE	R4,#3,KEY_PRE_3
		MOV	R0,#4CH	
		LCALL	LCD_POS		;光标置分钟报警设置位置
		JMP	KEY_PRE_E
KEY_PRE_3:	CJNE	R4,#4,KEY_PRE_4
		MOV	R0,#4FH		
		LCALL	LCD_POS		;光标置秒时报警设置位置
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
		LCALL	DISPLAY_PRO	;更新屏显内容
		MOV	R0,#05H
		LCALL	LCD_POS		;光标置年调整位置	
		JMP	KEY_PRE_E
KEY_PRE_5:	CJNE	R4,#6, KEY_PRE_6
		MOV	R0,#08H
		LCALL	LCD_POS		;光标置月调整位置
		JMP	KEY_PRE_E	
KEY_PRE_6:	CJNE	R4,#7,KEY_PRE_7
		MOV	R0,#0bH
		LCALL	LCD_POS		;光标置日调整位置
		JMP	KEY_PRE_E
KEY_PRE_7:	CJNE	R4,#8,KEY_PRE_8
		MOV	R0,#49H
		LCALL	LCD_POS		;光标置时调整位置
		JMP	KEY_PRE_E
KEY_PRE_8:	CJNE	R4,#9,KEY_PRE_9
		MOV	R0,#4cH
		LCALL	LCD_POS		;光标置分调整位置
		JMP	KEY_PRE_E
KEY_PRE_9:	CJNE	R4,#10,KEY_PRE_10
		MOV	R0,#4fH
		LCALL	LCD_POS		;光标置秒调整位置
		JMP	KEY_PRE_E
KEY_PRE_10:	MOV	FLAG,#0		;FLAG到11，就清零
		MOV	R0,#0CH
		LCALL	LCD_WCMD	;设置LCD开显示及光标不闪烁,不显示"-"
		MOV	R0,#01H
		LCALL	LCD_WCMD	;清除LCD的显示内容
		MOV	IE,#8AH		;CPU开中断,TIMER0,TIMER1开中断
		SETB	TR0		;启动TIMER0	
KEY_PRE_E:
		RET

;**************ADJ按键处理程序*******************
KEY_ADJ_PRO:	MOV	R5,FLAG
		CJNE	R5,#0,KEY_ADJ_0		;FLAG=0,如果有闹钟声音，就停止闹钟声音
		MOV	C,TR1
		JNC	KEY_ADJ_A
		CLR	TR1
KEY_ADJ_A:	JMP	KEY_ADJ_E
KEY_ADJ_0:	CJNE	R5,#1,KEY_ADJ_1		;FLAG=1，调整是否启用闹钟	
		CPL	ALARM
		LCALL	UPDATE_BUF
		LCALL	DISPLAY_PRO
		MOV	R0,#47H
		LCALL	LCD_POS
		JMP	KEY_ADJ_E	
KEY_ADJ_1:	CJNE	R5,#2,KEY_ADJ_2		;FLAG=2，调整闹钟时
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
KEY_ADJ_2:	CJNE	R5,#3,KEY_ADJ_3		;FLAG=3，调整闹钟分
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
KEY_ADJ_3:	CJNE	R5,#4,KEY_ADJ_4		;FLAG=4，调整闹钟秒
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
KEY_ADJ_4:	CJNE	R5,#5,KEY_ADJ_5		;FLAG=5，调整年
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
KEY_ADJ_5:	CJNE	R5,#6,KEY_ADJ_6		;FLAG=6，调整月
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
KEY_ADJ_6:	CJNE	R5,#7,KEY_ADJ_7		;FLAG=7，调整日
		INC	DATE			
		MOV	A,MONTH
		XRL	A,#2	
		JNZ	KEY_ADJ_6_2		;不是二月跳转
		MOV	A,DATE			;
		MOV	C,LEAP			;判断是否闰年
		JC	KEY_ADJ_6_1		
		XRL	A,#29			;平年二月日期28天	
		JNZ	KEY_ADJ_6_5			
		JMP	KEY_ADJ_6_4		
KEY_ADJ_6_1:	XRL	A,#30			;闰年二月日期29天
		JNZ	KEY_ADJ_6_5			
		JMP	KEY_ADJ_6_4		;跳转到月处理
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
		XRL	A,#32			;大月日期31天
		JNZ	KEY_ADJ_6_5
		JMP	KEY_ADJ_6_4	
KEY_ADJ_6_3:	MOV	A,DATE
		XRL	A,#31			;小月日期30天
		JNZ	KEY_ADJ_6_5
KEY_ADJ_6_4:	MOV	DATE,#1
KEY_ADJ_6_5:	LCALL	WEEK_PRO
		LCALL	UPDATE_BUF
		LCALL	DISPLAY_PRO
		MOV	R0,#0BH
		LCALL	LCD_POS
		JMP	KEY_ADJ_E 
KEY_ADJ_7:	CJNE	R5,#8,KEY_ADJ_8		;FLAG=8，调整时
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
KEY_ADJ_8:	CJNE	R5,#9,KEY_ADJ_9		;FLAG=9，调整分
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
KEY_ADJ_9:	CJNE	R5,#10,KEY_ADJ_E	;FLAG=10，调整秒
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

;***************Timer0定时中断程序*****************
TIMER0:		MOV  	TH0,#0DCH
		MOV	TL0,#00H
		INC  	SEC100	
		MOV  	A,SEC100
		CJNE	A,#100,TIMER0_E
		MOV	SEC100,#0
		LCALL	TIME_PRO
		MOV	A,SEC			;"willar显示1秒钟，消失一秒种，形成闪动
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


;***********Timer1定时中断程序******************
TIMER1:		MOV	TH1,#0FFH
		MOV	TL1,#00H
		CPL	SPK
		RETI

;**************时间日期处理函数******************
TIME_PRO:	INC	SEC			;秒处理
		MOV	A,SEC
		CJNE	A,#60,TIME_PRO_A
		MOV	SEC,#0
		INC	MIN			;分处理
		MOV	A,MIN
		CJNE	A,#60,TIME_PRO_A
		MOV	MIN,#0
		INC	HOUR			;时处理
		MOV	A,HOUR
		CJNE	A,#24,TIME_PRO_A
		MOV	HOUR,#0	
		INC	DATE			;日处理（日处理要考虑是否闰年，大月，小月）
		MOV	A,MONTH
		XRL	A,#2	
		JNZ	TIME_PRO_D2		;不是二月，转TIME_PRO_D2
		MOV	A,DATE			;
		MOV	C,LEAP			;判断是否闰年
		JC	TIME_PRO_D1		
		XRL	A,#29			;平年二月日期28天	
		JNZ	TIME_PRO_W			
		SJMP	TIME_PRO_M		;跳转到月处理
TIME_PRO_D1:	XRL	A,#30			;闰年二月日期29天
		JNZ	TIME_PRO_W			
		SJMP	TIME_PRO_M		;跳转到月处理
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
		XRL	A,#32			;大月日期31天
		JNZ	TIME_PRO_W
		SJMP	TIME_PRO_M		;跳转到月处理
TIME_PRO_D3:	MOV	A,DATE
		XRL	A,#31			;小月日期30天
		JNZ	TIME_PRO_W	
TIME_PRO_M:	MOV	DATE,#1
		INC	MONTH			;月处理
		MOV	A,MONTH
		CJNE	A,#13,TIME_PRO_W
		MOV	MONTH,#1
		INC	YEAR			;年处理
		MOV	A,YEAR
		CJNE	A,#100,TIME_PRO_W
		MOV	YEAR,#0
TIME_PRO_W:	LCALL	WEEK_PRO		;星期处理
		
TIME_PRO_A:	JNB	ALARM,TIME_PRO_E	;alarm=0,闹钟功能禁用，不判断闹钟时间是否到	
		MOV	A,SEC	
		CJNE	A,SEC_ARM,TIME_PRO_E	 ;alarm=1,闹钟功能启用，判断秒
		MOV	A,MIN
		CJNE	A,MIN_ARM,TIME_PRO_E	 ;alarm=1,闹钟功能启用，判断分
		MOV	A,HOUR                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
		CJNE	A,HOUR_ARM,TIME_PRO_E	;alarm=1,闹钟功能启用，判断时
		SETB	TR1		 	;闹钟时间到，启动Timer1(TR1=1)
TIME_PRO_E:			

		RET

;**********星期自动运算函数*********************
;星期运算常数W(5或6)
;闰年的数目L(0--99年:L=YEAR/4 整除)
;年数YEAR
;月参变数MONTH_TAB(0,3,3,6,1,4,6,2,5,0,3,5)
;日期DATE
;星期数=(W+L+YEAR+MONTH_TAB+DATE)%7 (求余)

WEEK_PRO:	MOV	A,MONTH			;确定星期运算常数W
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
WEEK_PRO_3:	MOV	A,YEAR			;计算闰年的数目L
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
		DIV	AB			;余数即为星期数
		MOV	WEEK,B	
		RET

;**********闰年的判断函数*********************
;闰年的条件：年(YEAR)能被4整除、但不能被100整除；或者被400整除。
;如果我们只考虑（00--99），则只需考虑年(YEAR)能被4整除即可。
LEAP_PRO:	MOV	A,YEAR
		MOV	B,#4
		DIV	AB
		MOV	A,B
		JZ	LEAP_PRO_1	;能被4整除
		CLR	LEAP		;平年，清零LEAP	
		LJMP	LEAP_PRO_E
LEAP_PRO_1:	SETB	LEAP		;闰年，置位LEAP
LEAP_PRO_E:		
		RET

;**********更新显示缓冲区********************
;入口R1,
UPDATE_BUF:	MOV	DIS_BUF_U0,R1	;调整时，"P",正常工作，显示一自定义字符
		MOV	DIS_BUF_U1,#20H	;空格
		MOV	DIS_BUF_U2,#32H	;"2"
		MOV	DIS_BUF_U3,#30H	;"0"
		MOV	A,YEAR		;更新年数据
		MOV	B,#10
		DIV	AB
		ADD	A,#48		;二进制转换为ASCMA码
		MOV	DIS_BUF_U4,A
		MOV	A,B
		ADD	A,#48
		MOV	DIS_BUF_U5,A
		MOV	DIS_BUF_U6,#2DH	;"-"
		MOV	A,MONTH		;更新月数据
		MOV	B,#10
		DIV	AB
		ADD	A,#48		 
		MOV	DIS_BUF_U7,A
		MOV	A,B
		ADD	A,#48
		MOV	DIS_BUF_U8,A
		MOV	DIS_BUF_U9,#2DH	;"-"
		MOV	A,DATE		;更新日数据
		MOV	B,#10
		DIV	AB
		ADD	A,#48		 
		MOV	DIS_BUF_U10,A
		MOV	A,B
		ADD	A,#48
		MOV	DIS_BUF_U11,A
		MOV	DIS_BUF_U12,#20H;空格
		MOV	B,WEEK		;更新星期数据
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
		MOV	DIS_BUF_L6,#20H	;空格
		MOV	C,ALARM
		JC	UPDATE_BUF_1
		MOV	DIS_BUF_L7,#20H	;闹钟禁用时,显示空格
		SJMP	UPDATE_BUF_2
UPDATE_BUF_1:	MOV	DIS_BUF_L7,#01H	;闹钟启用时,显示小喇叭
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

;************显示处理程序*********************
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
	
;**********LCD忙标志BF测试程序**************
BF_TEST:	PUSH 	ACC		;保护ACC数据
        	CLR     RS              ;RS=0 
        	SETB    RW 	        ;RW=1
        	SETB    EP              ;E=高电平
		NOP
		NOP
		NOP
		NOP
		MOV	P0,#0FFH         ;将p0口置1，保证后面数据正确读入（由 P0口结构决定）
WT_BF:          NOP                      ; 
        	JB      P0.7,WT_BF       ;DB7=0  LCD控制器空闲,DB7=1  LCD控制器忙
        	CLR	EP
		POP 	ACC              ;释放ACC数据
        	RET

;**********LCD指令写入程序******************
;程序入口：R0
LCD_WCMD:	LCALL	BF_TEST		;检测忙标志					
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

;**********LCD数据写入程序****************
;程序入口：R0
LCD_WDAT:	LCALL	BF_TEST		;检测忙标志
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

;**********LCD数据指针位置子程序**************
;程序入口：R0
LCD_POS:	MOV	A,R0
		ORL	A,#80H
		MOV	R0,A
		LCALL	LCD_WCMD
		RET
		
;**********延时约5ms子程序********************
;晶振f=11.0592Mhz
;延时时间=(1+(1+2*100+2)*25)*12/11.0592=5507us(约5ms)
DELAY_5ms:	MOV	R7,#25
DELAY1:		MOV	R6,#100
DELAY2:		DJNZ	R6,DELAY2
		DJNZ	R7,DELAY1
		RET

;***********星期自动运算月参变数**************
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
