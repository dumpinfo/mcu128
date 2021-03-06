;********************************************************************************
;*  标题:  ME300系列单片机开发系统演示程序 - 12864LCD(带汉字库）演示            *
;*  硬件： ME300A+,ME300B                                                       *
;*  文件:  wl016.asm                                                            *
;*  日期:  2005-3-20                                                            *
;*  版本:  1.0                                                                  *
;*  作者:  gguoqing                                                             *
;*  邮箱:  gguoqing@willar.com                                                  *
;*  网站： http://www.willar.com                                                *
;********************************************************************************
;*  描述:                                                                       *
;*         12864LCD(带汉字库）演示程序                                          *
;*         控制器ST7920                                                         *
;*         LCD型号：TS12864A-3（带汉字库）或兼容型号                            *
;*         MCU:AT89S52 ,晶体频率：11.0592MHz                                    *
;********************************************************************************
;*  跳线设置：                                                                  *
;*     ME300A+    JP1 全部短接，JP2短接1-2端                                    *
;*     ME300B     JP1 短接，JP2短接1-2端                                        *   
;*                                                                              *
;********************************************************************************
;* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
;* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
;********************************************************************************
   
                               
;****************TS12864A-3 并口****************
                                   
          RS	EQU	P2.0       
          RW	EQU	P2.1
          E 	EQU	P2.2
          PSB	EQU	P2.3
          RST	EQU	P2.5
;-----------------------------------------------
          LCD_X	 EQU	30H
          LCD_Y	 EQU	31H
          COUNT	 EQU	32H
          COUNT1 EQU	33H
          COUNT2 EQU	34H
          COUNT3 EQU	35H
;-----------------------------------------------
       LCD_DATA  EQU	36H
       LCD_DATA1 EQU	37H
       LCD_DATA2 EQU	38H
          STORE	 EQU	39H

;-----------------------------------------------
		ORG	0000H
		LJMP	MAIN
		ORG	0100H
;-----------------------------------------------
MAIN:
	    MOV	SP,#5FH
            CLR  RST             ;复位
            LCALL DELAY4
            SETB RST
	    NOP
            SETB PSB             ;通讯方式为8位数据并口

;********************初始化**********************
LGS0:	    MOV	A,#34H		;34H--扩充指令操作
	    LCALL SEND_I
	    MOV	A,#30H		;30H--基本指令操作
	    LCALL SEND_I
	    MOV	A,#01H		;清除显示
	    LCALL SEND_I
            MOV	A,#06H		;指定在资料写入或读取时，光标的移动方向
	    LCALL SEND_I        ;DDRAM 的地址计数器(AC)加1
	    MOV	A,#0CH		;开显示,关光标,不闪烁
	    LCALL SEND_I
;===============================================
TU_PLAY1:
            MOV  DPTR,#TU_TAB1	     ;显示图形
	    LCALL PHO_DISP
	    LCALL DELAY3
            
;===============================================
;显示汉字和字符
;加入80ms的延时，使你能够看清楚显示的过程
;根据汉字显示坐标写入 (隔行写入）
;===============================================
HAN_WR1:
            LCALL CLEAR_P
            MOV	DPTR,#TAB1      ;显示汉字和字符
	    MOV	COUNT,#40H      ;地址计数器设为最大值 64。
	    MOV	A,#80H          ;起始地址
	    LCALL SEND_I
            LCALL QUSHU
 	    LCALL DELAY3
            LCALL FLASH
;=================================================
;;显示汉字和字符
;加入80ms的延时，使你能够看清楚显示的过程
;根据汉字显示坐标分段写入（顺序写入）
;=================================================
HAN_WR2:
            LCALL CLEAR_P
HAN_WR2A:
            MOV	DPTR,#TAB1A	;显示汉字和字符
	    MOV	COUNT,#10H      ;地址计数器设为16。
	    MOV	A,#80H          ;第一行起始地址
	    LCALL SEND_I
            LCALL   QUSHU
HAN_WR2B:
            MOV	DPTR,#TAB1B	;显示汉字和字符
	    MOV	COUNT,#10H      ;地址计数器设为16。
	    MOV	A,#90H          ;第二行起始地址
	    LCALL SEND_I
            LCALL QUSHU
HAN_WR2C:
            MOV	DPTR,#TAB1C	;显示汉字和字符
	    MOV	COUNT,#10H      ;地址计数器设为16。
	    MOV	A,#88H          ;第三行起始地址
	    LCALL SEND_I
            LCALL QUSHU
HAN_WR2D:
            MOV	DPTR,#TAB1D	 ;显示汉字和字符
	    MOV	COUNT,#10H       ;地址计数器设为16。
	    MOV	A,#98H           ;第四行起始地址
	    LCALL SEND_I
            LCALL QUSHU
            LCALL DELAY3
            LCALL FLASH
            LCALL CLEAR_P
            JMP  TU_PLAY2
;----------------------------------------------
;TU_PLAY1:
            MOV  DPTR,#TU_TAB1	     ;显示图形
	    LCALL PHO_DISP
	    LCALL DELAY3
            ;LCALL   FLASH
;----------------------------------------------
TU_PLAY2:
	    MOV	DPTR,#TU_TAB2   ;显示图形
	    LCALL PHO_DISP
	    LCALL DELAY3
            ;LCALL   FLASH
;----------------------------------------------
TU_PLAY3:
	    MOV	DPTR,#TU_TAB3   ;显示图形
	    LCALL PHO_DISP
	    LCALL DELAY3
            ;LCALL   FLASH
;-----------------------------------------------
;显示点阵
;-----------------------------------------------
LATPLAY1:
            MOV	A,#01H         ;清屏
            LCALL SEND_I
	    MOV	LCD_DATA1,#0CCH	 ;显示点阵
	    MOV	LCD_DATA2,#0CCH
	    LCALL LAT_DISP
	    LCALL DELAY3
            LCALL CLEAR_P
	    ;LJMP  TU_PLAY1
;===============================================
;调字库半角字符显示
;===============================================
KU_PLAY1:
            LCALL  CLEAR_P
            MOV  COUNT,#40H
            MOV  A,#80H
            LCALL SEND_I
            MOV  R1,#10H
LATPLAY11:
            MOV  A,R1
            LCALL  SEND_D
            INC  R1
            DJNZ  COUNT,LATPLAY11
            LCALL  DELAY3
            LCALL  CLEAR_P
            ;LJMP  TU_PLAY1

;===============================================
;调字库汉字显示
;从 B9F3 “贵”字处开始显示
;===============================================
KU_PLAY2:
            LCALL  CLEAR_P
            MOV  COUNT,#40H
            MOV  A,#80H
            LCALL SEND_I
            MOV  R1,#0F3H
KU_PLAY21:
            MOV  A,#0B9H
            LCALL  SEND_D        ;写入第一字节数据（高位）
            MOV  A,R1
            LCALL  SEND_D        ;写入第二字节数据（低位）
            INC  R1
            DJNZ  COUNT,KU_PLAY21
            LCALL  DELAY3
            LCALL  CLEAR_P
            LJMP  TU_PLAY1
            ;JMP  $
;===============================================
;全屏显示图形子程序
;===============================================
PHO_DISP:
    	    MOV  COUNT3,#02H
	    MOV  LCD_X,#80H
PHO_DISP1:
    	    MOV  LCD_Y,#80H
	    MOV  COUNT2,#20H
PHO_DISP2:
    	    MOV  COUNT1,#10H
	    LCALL WR_ZB
PHO_DISP3:
            CLR	A
	    MOVC A,@A+DPTR
	    LCALL SEND_D
	    INC	DPTR
	    DJNZ COUNT1,PHO_DISP3
	    INC	LCD_Y
	    DJNZ COUNT2,PHO_DISP2
	    MOV	LCD_X,#88H
	    DJNZ COUNT3,PHO_DISP1

	    MOV	A,#36H
	    LCALL SEND_I
	    MOV	A,#30H
	    LCALL SEND_I
            RET
;----------------------------------------------
CLRRAM:
     	    MOV	LCD_DATA1,#00H		;GDRAM写0子程序
	    MOV	LCD_DATA2,#00H
	    LCALL LAT_DISP
	    RET
;==============================================
;显示点阵子程序
;==============================================
LAT_DISP:
    	    MOV	COUNT3,#02H
	    MOV	LCD_X,#80H
LAT_DISP1:
    	    MOV	LCD_Y,#80H
	    CLR	F0
	    MOV	COUNT2,#20H
LAT_DISP2:
    	    MOV	COUNT1,#10H
	    LCALL WR_ZB
LAT_DISP3:
    	    JB	F0,LAT_DISP32
	    MOV	LCD_DATA,LCD_DATA1
	    AJMP LAT_DISP31
LAT_DISP32:
    	    MOV	LCD_DATA,LCD_DATA2
LAT_DISP31:
    	    MOV	A,LCD_DATA
	    LCALL SEND_D
	    DJNZ COUNT1,LAT_DISP31
	    INC	LCD_Y
	    CPL	F0
	    DJNZ COUNT2,LAT_DISP2
	    MOV	LCD_X,#88H
	    DJNZ COUNT3,LAT_DISP1

	    MOV	A,#36H
	    LCALL SEND_I
	    MOV	A,#30H
	    LCALL SEND_I
	    RET
;---------------------------------------------
WR_ZB:
    	    MOV	A,#34H
	    LCALL SEND_I
	    MOV	A,LCD_Y
	    LCALL SEND_I
	    MOV	A,LCD_X
	    LCALL SEND_I
	    MOV	A,#30H
	    LCALL SEND_I
	    RET

;===============================================
FLASH:
            MOV  A,#08H       ;关闭显示
            LCALL SEND_I
            LCALL  DELAY5
            MOV  A,#0CH	  ;开显示,关光标,不闪烁
	    LCALL SEND_I
            LCALL  DELAY5
            MOV  A,#08H       ;关闭显示
            LCALL SEND_I
            LCALL  DELAY5
            MOV  A,#0CH	  ;开显示,关光标,不闪烁
	    LCALL SEND_I
            LCALL  DELAY5
            MOV  A,#08H       ;关闭显示
            LCALL SEND_I
            LCALL  DELAY5
                RET
;==================================================
;清屏
;==================================================
CLEAR_P:
            MOV	A,#01H           ;清屏
	    LCALL SEND_I
            MOV	A,#34H
	    LCALL SEND_I
	    MOV	A,#30H
	    LCALL SEND_I
            RET
;==================================================
;查表取数据送显示
;==================================================
QUSHU:
            CLR	A
	    MOVC A,@A+DPTR       ;查表取数据
	    LCALL SEND_D          ;送显示
	    INC	DPTR
            LCALL DELAY4           ;延时80ms,
            DJNZ COUNT,QUSHU
	    RET

;===============================================
;写数据子程序
;RS=1,RW=0,E=高脉冲,D0-D7=数据
;===============================================
SEND_D:
	    LCALL	CHK_BUSY    ;写数据子程序
	    SETB	RS
	    CLR	RW
	    MOV	P0,A
	    SETB	E
	    NOP
	    NOP
	    CLR	E
	    RET
;===============================================
;写指令子程序
;RS=0,RW=0,E=高脉冲,D0-D7=指令码
;===============================================
SEND_I:
	    LCALL CHK_BUSY
	    CLR	RS
	    CLR	RW
	    MOV	P0,A
	    SETB E
	    NOP
	    NOP
	    CLR	E
	    RET
;================================================
;读数据子程序
;RS=1,RW=1,E=H,D0-D7=数据
;================================================
READ_D:
	   LCALL CHK_BUSY    ;读数据子程序
	   SETB	RS
	   SETB	RW
	   SETB	E
	   NOP
	   MOV	A,P0
	   CLR	E
	   MOV	STORE,A
	   RET
;================================================
;;测忙碌子程序
;RS=0,RW=1,E=H,D0-D7=状态字
;================================================
CHK_BUSY:
    	   MOV	P0,#0FFH    ;测忙碌子程序
	   CLR	RS
	   SETB	RW
	   SETB	E
	   JB	P0.7,$
	   CLR	E
	   RET
;================================================
;延时子程序
;================================================
DELAY3:
	   MOV	R5,#16H
DEL31:	   MOV	R6,#0FFH
DEL32:	   MOV	R7,#0FFH
DEL33:	   DJNZ	R7,DEL33
	   DJNZ	R6,DEL32
	   DJNZ	R5,DEL31
	   RET

DELAY2:
           MOV	R6,#0CH
DEL21:	   MOV	R7,#18H
DEL22:	   DJNZ	R7,DEL22
	   DJNZ	R6,DEL21
	   RET

DELAY1:
           MOV	R6,#06H
DEL11:	   MOV	R7,#08H
DEL12:	   DJNZ	R7,DEL12
	   DJNZ	R6,DEL11
           RET

DELAY4:
           MOV	R6,#200
DEL41:	   MOV	R7,#200
DEL42:	   DJNZ	R7,DEL42
	   DJNZ	R6,DEL41
	   RET

DELAY5:
           MOV	R5,#05H
DEL51:	   MOV	R6,#0FFH
DEL52:	   MOV	R7,#0FFH
DEL53:	   DJNZ	R7,DEL53
	   DJNZ	R6,DEL52
	   DJNZ	R5,DEL51
	   RET
;***********************************************
TAB1:
TAB1A:     DB  '    伟纳电子    '    ;显示在第一行
TAB1C:     DB  '单片机学习开发板'    ;显示在第三行
TAB1B:     DB  ' WWW.WILLAR.COM '    ;显示在第二行
TAB1D:     DB  'TEL:0663-6888048'    ;显示在第四行


TAB3:
           DB '     ME300B     '     ;显示在第一行
    	   DB '片机知识最佳选择'     ;显示在第三行
           DB '是您学习和掌握单'     ;显示在第二行
           DB '－－欢迎使用－－'     ;显示在第四行

;==================================================================================
TU_TAB1:             ;伟纳电子图片
DB  0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,008H,010H,000H,000H,002H,000H,002H,000H,001H
DB  080H,000H,000H,000H,000H,004H,080H,088H,011H,0E1H,0FFH,01AH,041H,0FCH,010H,041H
DB  088H,0BEH,071H,0C7H,03CH,01FH,0E0H,088H,011H,020H,048H,012H,040H,028H,013H,0F1H
DB  088H,0A0H,08AH,028H,0A2H,012H,020H,088H,03DH,020H,048H,03FH,0F0H,04CH,02CH,081H
DB  08DH,0A0H,00AH,028H,0A2H,01FH,0E0H,0F6H,011H,020H,048H,004H,000H,0F0H,039H,021H
DB  08DH,0BCH,032H,028H,0BCH,012H,020H,080H,019H,023H,0FFH,007H,0E0H,046H,013H,0F1H
DB  08AH,0A0H,00AH,028H,0A2H,01FH,0E0H,0FCH,035H,020H,048H,00AH,041H,0FFH,021H,041H
DB  08AH,0A0H,08AH,028H,0A2H,002H,000H,084H,031H,020H,048H,01AH,040H,012H,039H,041H
DB  08AH,0A0H,08AH,028H,0A2H,03FH,0F1H,004H,012H,020H,088H,031H,080H,096H,001H,041H
DB  08AH,0BEH,071H,0C7H,03CH,002H,001H,004H,012H,031H,088H,023H,0C3H,013H,03DH,051H
DB  080H,000H,000H,000H,000H,002H,003H,004H,016H,031H,008H,01CH,030H,030H,006H,071H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,060H,000H,000H,000H,002H,000H,000H,000H,001H
DB  080H,01FH,087H,0E0H,0FCH,000H,018H,060H,000H,083H,000H,002H,000H,001H,0FFH,081H
DB  080H,01FH,087H,0E0H,0FCH,000H,077H,0FEH,001H,083H,000H,0FFH,0F8H,003H,083H,081H
DB  080H,01FH,087H,0E0H,0FCH,001H,0F4H,060H,002H,03FH,0F0H,0E6H,018H,000H,01EH,001H
DB  080H,01FH,0C3H,0E0H,0FCH,001H,0B3H,0FEH,00CH,0DBH,030H,0C6H,018H,000H,00CH,001H
DB  080H,01FH,0C3H,0E0H,0FFH,080H,034H,060H,00FH,093H,030H,0FFH,0F8H,01FH,0FFH,0F9H
DB  080H,01FH,0C3H,0E7H,0FFH,0E0H,037H,0FFH,082H,013H,030H,0C6H,018H,01EH,00CH,0F9H
DB  080H,01FH,0C3H,0FFH,0FFH,0E0H,03EH,061H,087H,097H,0B0H,07FH,0F8H,000H,00CH,001H
DB  080H,00FH,0C3H,0F8H,078H,070H,030H,063H,006H,01CH,0F0H,07AH,010H,000H,00CH,001H
DB  080H,00FH,0CFH,0F0H,078H,070H,030H,06EH,001H,0F8H,030H,003H,000H,080H,00CH,001H
DB  080H,00FH,0FFH,0F0H,078H,060H,030H,070H,03EH,030H,030H,003H,0FFH,080H,01CH,001H
DB  080H,00FH,0FDH,0F0H,038H,0E0H,030H,060H,010H,0E0H,030H,001H,0FFH,001H,0F8H,001H
DB  080H,007H,0F1H,0F0H,039H,0E0H,020H,060H,000H,000H,000H,000H,03EH,000H,070H,001H
DB  080H,007H,0E1H,0F0H,03BH,0C0H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,00FH,0E1H,0F8H,03BH,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,01FH,0E0H,0F8H,03FH,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,03FH,0F0H,0F8H,01CH,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,077H,0F0H,0F8H,03CH,000H,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0F1H
DB  081H,0C7H,0F0H,0F8H,0F8H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  081H,0C3H,0F0H,0F9H,0F0H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  083H,083H,0F0H,0FFH,0D0H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  087H,003H,0F0H,0FFH,090H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  08EH,003H,0F0H,0FEH,010H,000H,000H,000H,000H,001H,024H,000H,000H,000H,000H,001H
DB  08EH,001H,0F0H,0FCH,010H,000H,000H,000H,000H,000H,024H,000H,000H,000H,000H,001H
DB  08CH,001H,0F3H,0FCH,000H,011H,088H,0C4H,044H,045H,024H,071H,043H,00EH,02CH,0C1H
DB  09CH,001H,0FFH,0FCH,000H,011H,088H,0C4H,044H,045H,024H,089H,084H,091H,033H,021H
DB  09EH,001H,0FFH,0FCH,000H,00AH,055H,02AH,082H,0A9H,024H,009H,004H,011H,022H,021H
DB  08FH,0FFH,0F8H,07CH,000H,00AH,055H,02AH,082H,0A9H,024H,079H,004H,011H,022H,021H
DB  083H,0FFH,0F8H,07EH,000H,00AH,055H,02AH,082H,0A9H,024H,089H,004H,011H,022H,021H
DB  080H,001H,0FCH,07EH,000H,004H,022H,011H,001H,011H,024H,099H,004H,091H,022H,021H
DB  080H,000H,0FCH,07EH,000H,004H,022H,011H,011H,011H,024H,069H,023H,00EH,022H,021H
DB  080H,000H,0FCH,03EH,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,0FCH,03EH,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH
;以上您调入了一幅图象: 长度x宽度=128x64,  调整后为: 128x64

;==================================================================================

TU_TAB2:       ;伟纳电子－300B介绍图片
DB  0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,008H,010H,000H,000H,002H,000H,002H,000H,001H
DB  080H,000H,000H,000H,000H,004H,080H,088H,011H,0E1H,0FFH,01AH,041H,0FCH,010H,041H
DB  088H,0BEH,071H,0C7H,03CH,01FH,0E0H,088H,011H,020H,048H,012H,040H,028H,013H,0F1H
DB  088H,0A0H,08AH,028H,0A2H,012H,020H,088H,03DH,020H,048H,03FH,0F0H,04CH,02CH,081H
DB  08DH,0A0H,00AH,028H,0A2H,01FH,0E0H,0F6H,011H,020H,048H,004H,000H,0F0H,039H,021H
DB  08DH,0BCH,032H,028H,0BCH,012H,020H,080H,019H,023H,0FFH,007H,0E0H,046H,013H,0F1H
DB  08AH,0A0H,00AH,028H,0A2H,01FH,0E0H,0FCH,035H,020H,048H,00AH,041H,0FFH,021H,041H
DB  08AH,0A0H,08AH,028H,0A2H,002H,000H,084H,031H,020H,048H,01AH,040H,012H,039H,041H
DB  08AH,0A0H,08AH,028H,0A2H,03FH,0F1H,004H,012H,020H,088H,031H,080H,096H,001H,041H
DB  08AH,0BEH,071H,0C7H,03CH,002H,001H,004H,012H,031H,088H,023H,0C3H,013H,03DH,051H
DB  080H,000H,000H,000H,000H,002H,003H,004H,016H,031H,008H,01CH,030H,030H,006H,071H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,008H,01EH,020H,000H,004H,020H,06FH,080H,000H,024H,000H,080H,001H
DB  080H,000H,000H,0FFH,0C2H,020H,000H,005H,0FDH,0C8H,080H,000H,042H,01FH,0F8H,001H
DB  080H,000H,000H,080H,04AH,050H,000H,009H,004H,048H,080H,000H,07FH,0C7H,0E0H,001H
DB  080H,000H,001H,024H,08AH,088H,000H,013H,0FDH,0EFH,080H,000H,0C4H,004H,020H,001H
DB  080H,000H,000H,014H,00BH,074H,000H,01DH,000H,040H,000H,001H,047H,087H,0E0H,001H
DB  080H,000H,000H,044H,01EH,000H,000H,009H,0FCH,0DFH,0C0H,000H,044H,084H,020H,001H
DB  080H,000H,000H,024H,002H,0A8H,000H,017H,054H,0E2H,000H,000H,044H,087H,0E0H,001H
DB  080H,000H,001H,0FFH,0C6H,0A9H,000H,019H,0FDH,04FH,090H,000H,048H,084H,021H,001H
DB  080H,000H,000H,00AH,01AH,0A8H,0C0H,005H,055H,042H,00CH,000H,048H,09FH,0FCH,0C1H
DB  080H,000H,000H,011H,002H,010H,040H,01BH,054H,042H,004H,000H,050H,082H,020H,041H
DB  080H,000H,000H,0E0H,08DH,0FCH,000H,005H,00CH,05FH,0C0H,000H,063H,01CH,018H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,002H,000H,088H,010H,020H,020H,000H,028H,000H,041H,004H,004H,081H
DB  080H,000H,000H,07FH,0F3H,0FEH,013H,0F0H,050H,000H,028H,007H,0E1H,024H,008H,0C1H
DB  08FH,09EH,0F0H,040H,010H,020H,02AH,020H,088H,003H,0EFH,084H,041H,025H,009H,021H
DB  082H,022H,048H,01FH,0C3H,0FEH,04AH,021H,004H,000H,028H,004H,043H,0BFH,09AH,011H
DB  082H,020H,048H,000H,000H,020H,073H,0E6H,0FBH,000H,028H,006H,043H,024H,02DH,029H
DB  082H,018H,070H,000H,007H,0FFH,012H,020H,000H,001H,0EFH,005H,041H,044H,009H,021H
DB  082H,004H,040H,07FH,0F0H,020H,02AH,020H,000H,000H,028H,005H,041H,03FH,089H,021H
DB  082H,002H,040H,009H,003H,0FEH,073H,0E1H,0FCH,000H,028H,004H,049H,004H,009H,021H
DB  082H,022H,040H,009H,010H,050H,00AH,021H,004H,033H,0EFH,088H,049H,004H,009H,021H
DB  08FH,0BCH,0E0H,011H,010H,088H,032H,021H,004H,030H,028H,010H,049H,004H,00AH,021H
DB  080H,000H,000H,061H,0F7H,007H,04FH,0F1H,0FCH,030H,028H,020H,079H,07FH,08CH,021H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,060H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  082H,010H,000H,051H,000H,008H,000H,081H,020H,04FH,084H,050H,008H,004H,000H,001H
DB  082H,010H,000H,029H,00FH,0FCH,0FFH,0C9H,011H,0F0H,084H,050H,07FH,084H,000H,061H
DB  082H,011H,001H,0FFH,0C2H,008H,022H,009H,000H,081H,01EH,090H,040H,09FH,07CH,0F1H
DB  082H,012H,001H,000H,041H,008H,022H,01FH,0FCH,0C2H,084H,088H,040H,085H,044H,0F1H
DB  083H,0DCH,001H,07EH,081H,008H,022H,002H,001H,044H,045H,008H,07FH,085H,044H,0F1H
DB  082H,010H,000H,004H,000H,009H,0FFH,0C3H,0F1H,0F8H,04EH,024H,040H,089H,044H,061H
DB  082H,010H,000H,008H,000H,068H,022H,002H,090H,04FH,094H,020H,040H,089H,044H,061H
DB  082H,011H,001H,0FFH,0C1H,088H,022H,004H,0A0H,072H,014H,040H,07FH,08DH,044H,001H
DB  082H,051H,018H,008H,01EH,008H,022H,004H,041H,0C2H,004H,050H,040H,082H,044H,061H
DB  083H,091H,018H,008H,008H,008H,042H,009H,0B0H,042H,004H,088H,040H,085H,07CH,061H
DB  082H,01FH,018H,038H,000H,071H,082H,016H,00CH,05FH,0C5H,0F8H,07FH,098H,000H,001H
DB  080H,000H,030H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH
;以上您调入了一幅图象: 长度x宽度=128x64,  调整后为: 128x64


;====================================================================================
TU_TAB3:        ;我的文档、我的电脑图片

DB  0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,03FH,0FFH,0F0H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,040H,000H,018H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,0BFH,0FFH,0DCH,000H,001H
DB  080H,000H,01FH,0FFH,0FFH,000H,000H,000H,000H,000H,000H,0BFH,0FFH,0BCH,000H,001H
DB  080H,000H,030H,000H,001H,080H,000H,000H,000H,000H,001H,07FH,0FFH,0B8H,000H,001H
DB  080H,000H,030H,000H,000H,080H,000H,000H,000H,000H,001H,07FH,0FFH,078H,000H,001H
DB  080H,000H,019H,0FFH,0FEH,0C0H,000H,000H,000H,000H,002H,0FFH,0FFH,070H,000H,001H
DB  080H,000H,018H,000H,000H,040H,000H,000H,000H,000H,002H,0FFH,0FEH,0F0H,000H,001H
DB  080H,000H,00CH,001H,0FFH,060H,000H,000H,000H,000H,005H,0FFH,0FEH,0E0H,000H,001H
DB  080H,000H,00CH,07FH,0D0H,020H,000H,000H,000H,000H,005H,0FFH,0FDH,0E0H,000H,001H
DB  080H,000H,006H,000H,00FH,0B0H,000H,000H,000H,000H,00BH,0FFH,0FDH,0C0H,000H,001H
DB  080H,000H,006H,003H,0FCH,010H,000H,000H,000H,000H,00BH,0FFH,0FBH,0C0H,000H,001H
DB  080H,000H,003H,01FH,000H,018H,000H,000H,000H,000H,017H,0FFH,0FBH,080H,000H,001H
DB  080H,000H,003H,000H,000H,008H,000H,000H,000H,000H,017H,0FFH,0F7H,080H,000H,001H
DB  080H,000H,001H,080H,000H,00CH,000H,000H,000H,000H,017H,0FFH,0F7H,000H,000H,001H
DB  080H,000H,001H,080H,000H,004H,000H,000H,000H,000H,009H,0FFH,0EFH,000H,000H,001H
DB  080H,000H,000H,0C0H,000H,0F6H,000H,000H,000H,000H,006H,07FH,0EEH,000H,000H,001H
DB  080H,000H,000H,0C0H,003H,0C2H,000H,000H,000H,000H,001H,09FH,0DEH,000H,000H,001H
DB  080H,000H,000H,060H,000H,03BH,000H,000H,000H,000H,000H,067H,0DFH,000H,000H,001H
DB  080H,000H,000H,060H,000H,0E3H,000H,000H,000H,000H,000H,019H,0BFH,000H,000H,001H
DB  080H,000H,000H,030H,003H,08EH,000H,000H,000H,000H,000H,006H,03FH,000H,000H,001H
DB  080H,000H,000H,030H,006H,03CH,000H,000H,000H,000H,000H,001H,0FFH,000H,000H,001H
DB  080H,000H,000H,018H,000H,0F0H,000H,000H,000H,000H,000H,000H,0FFH,000H,000H,001H
DB  080H,000H,000H,018H,003H,0C0H,000H,000H,000H,000H,000H,00FH,07FH,080H,000H,001H
DB  080H,000H,000H,00CH,00FH,000H,000H,000H,000H,000H,000H,030H,01FH,0C0H,000H,001H
DB  080H,000H,000H,00CH,03CH,000H,000H,000H,000H,000H,000H,040H,007H,0E0H,000H,001H
DB  080H,000H,000H,006H,0F0H,000H,000H,000H,000H,000H,000H,0E0H,01FH,0E0H,000H,001H
DB  080H,000H,000H,007H,0C0H,000H,000H,000H,000H,000H,000H,0F8H,03FH,0C0H,000H,001H
DB  080H,000H,000H,003H,000H,000H,000H,000H,000H,000H,000H,07EH,0FFH,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,01FH,0FCH,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,007H,0F0H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H,0C0H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,005H,040H,088H,004H,001H,008H,000H,000H,00AH,081H,010H,004H,000H,020H,001H
DB  080H,079H,021H,008H,002H,021H,049H,000H,000H,0F2H,042H,010H,004H,047H,010H,001H
DB  080H,009H,007H,0DFH,07FH,0F7H,0AAH,000H,000H,012H,00FH,0BEH,07FH,0E5H,0FEH,001H
DB  080H,07FH,0F4H,051H,008H,081H,02CH,000H,000H,0FFH,0E8H,0A2H,044H,047H,000H,001H
DB  080H,009H,004H,061H,008H,081H,07FH,000H,000H,012H,008H,0C2H,07FH,0C5H,04AH,001H
DB  080H,00BH,024H,051H,008H,083H,081H,000H,000H,016H,048H,0A2H,044H,045H,06AH,001H
DB  080H,01DH,047H,0C9H,005H,005H,001H,000H,000H,03AH,08FH,092H,044H,047H,052H,001H
DB  080H,068H,084H,049H,005H,005H,07FH,000H,000H,0D1H,008H,092H,07FH,0C5H,06AH,001H
DB  080H,009H,094H,041H,002H,001H,001H,000H,000H,013H,028H,082H,044H,005H,04AH,001H
DB  080H,00EH,057H,0C1H,00DH,081H,001H,000H,000H,01CH,0AFH,082H,004H,029H,042H,001H
DB  080H,038H,034H,04EH,070H,071H,07FH,000H,000H,070H,068H,09CH,003H,0EBH,07EH,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  080H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,000H,001H
DB  0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH

;==================================================================================
TU_TAB4:

DB  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DB  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DB  00,00,00,00,01H,80H,00,60H,04H,00,38H,00,00,00,00,00

DB  00,00,00,00,03H,0E0H,30H,78H,0FH,00,78H,00,00,00,00,00
DB  00,00,00,00,06H,0A0H,38H,0F8H,0FH,00,78H,0FFH,0E0H,00,00,00
DB  00,00,00,00,1DH,20H,3CH,18H,0EH,00,60H,80H,10H,00,00,00
DB  00,00,00,00,19H,30H,07H,00,08H,00,40H,80H,18H,00,00,00
DB  00,00,00,00,30H,10H,07H,0FH,0F8H,00,00,40H,0CH,00,00,00
DB  00,00,00,00,60H,0F0H,00,7FH,8CH,00,00,40H,03H,00,00,00
DB  00,00,00,00,0C1H,80,01H,0C0H,0F7H,0F0H,00,40H,01H,80H,00,00
DB  00,00,00,01H,86H,03H,0FFH,00,10H,1CH,00,0C0H,00,0C0H,00,00
DB  00,00,00,01H,04H,3FH,0FFH,0C0H,10H,01H,0C0H,0C0H,40H,70H,0FH,00
DB  00,00,00,01H,0FH,0FFH,0FFH,0F3H,0DFH,0F8H,70H,80H,60H,1EH,7FH,00
DB  00,00,3CH,01H,8FH,0FFH,0FFH,0FFH,0C0H,02H,18H,80H,40H,02H,00,00
DB  00,00,1FH,00,0FFH,0FFH,0FFH,0FFH,38H,03H,86H,80H,0C0H,01H,00,00
DB  00,00,03H,0E0H,0FFH,0FFH,0FFH,0FFH,0F8H,00,83H,00,0C0H,01H,80H,00
DB  00,00,00,00,3FH,0FFH,0FFH,0FFH,0E0H,00,83H,03H,80H,00,80H,00
DB  00,0FH,0F0H,00H,7FH,0FFH,0FFH,0FFH,0F8H,00,83H,07H,02H,00,80,00
DB  00,03H,0E0H,00,7FH,0F0H,07H,0FFH,0FCH,01H,83H,0FEH,06H,03H,80H,00
DB  00,00,00,00,7FH,0F8H,01H,0FFH,0FEH,01H,02H,06H,0EH,0FH,80H,00
DB  00,00,00,00,7FH,0FCH,00H,7FH,0FFH,0FFH,0EH,03H,1CH,0EH,00,00
DB  00,00,00,00,7FH,0FFH,00,7FH,0FFH,0F8H,00,01H,0E8H,0C6H,00,00
DB  00,03H,0FFH,0C0H,7FH,0FFH,0C0H,3FH,0FFH,0FCH,00,00H,63H,83H,00,00
DB  00,01H,0FEH,00,3FH,0FFH,0F8H,3FH,0FFH,0FFH,80H,00,3EH,03H,00,00
DB  00,00,00,00,1FH,0FFH,0FEH,1FH,0FFH,0FFH,0C0H,00,1CH,01H,80H,00
DB  00,00,00,00,1FH,0FFH,0FFH,0FFH,0FFH,0FFH,0F0H,00,0CH,00,80H,00
DB  00,00,00,00,0FH,0FFH,0FFH,0FFH,0FFH,0FFH,0F0H,00,07H,0F0H,80H,00
DB  00,00,00,00,0FH,0FFH,0FFH,0FFH,0FFH,0FFH,0FCH,00,03H,80H,80H,0FEH
DB  00,00,00,00,18H,0FFH,0FFH,0FFH,0FFH,0FFH,0FCH,00,1FH,0C0H,83H,82H
DB  00,00,00,00,33H,0BFH,0FFH,0FFH,0FFH,0FFH,0C4H,00,41H,0FFH,0FEH,06H
DB  00,00,00,00,0E6H,0FH,0FFH,0FFH,0FFH,0FFH,0FH,00,70H,00,00,3CH
DB  00,00,00,01H,8CH,0DH,0FFH,0FFH,0FFH,0F8H,09H,80H,1FH,0E0H,00,3CH
DB  00,00,00,03H,1FH,8EH,00,0FFH,0FFH,80H,19H,80H,00,3FH,0F0H,04H
DB  00,00,00,0CH,77H,0F3H,0E0H,07H,0FFH,00,71H,80H,00,33H,18H,04H
DB  00,00,00,39H,0C7H,0E0H,38H,00,00,00,0C1H,80H,00,22H,04H,0CH
DB  00,00,00,67H,07H,0C0H,0FH,00,00,07H,81H,80H,00,46H,03H,0F8H
DB  00,00,03H,0FCH,07H,0FCH,00,0E0H,00,0CH,01H,80H,00,1CH,00,00
DB  00,0FCH,07H,0E0H,03H,0FFH,00,1FH,0FFH,0F0H,01H,80H,00,30H,00,00
DB  3BH,0FFH,0FFH,80H,00,0FFH,0C0H,00,00,00,01H,80H,00,60H,00,00
DB  7FH,0FFH,0F8H,0F8H,00,7FH,0F8H,00,00,00,03H,0C0H,00,60H,00,00
DB  7FH,0FFH,0FEH,0EH,00,3FH,0FEH,00,00,00,0FH,0C0H,00,0C0H,00,00
DB  3FH,0FFH,0F9H,0FCH,0FFH,0CFH,0FFH,80,00,00,1FH,0C0H,00,80H,00,00
DB  07H,0FFH,0C0H,7BH,0E0H,7FH,0FFH,0E0H,00,00,3FH,00,03H,87H,0FFH,0E0H
DB  00,00,01H,0C0H,3FH,83H,0FFH,0FEH,00H,03H,0FEH,00,0EH,04H,7FH,0E0H
DB  00,00,07H,00,00,7EH,0FH,0FFH,0FFH,0FFH,0FCH,00,38H,00,7FH,00
DB  00,00,1FH,00,00,7FH,0FEH,7FH,0FFH,0FFH,0F8H,00,60H,00,00,00
DB  00,00,3FH,0E0H,07H,0FFH,83H,0FFH,0DFH,0FFH,0C0H,01H,80H,00,00,00
DB  00,00,3FH,0FCH,7CH,7FH,0C0H,00,3FH,0FDH,00,03H,00,00,00,00
DB  00,00,7FH,0FFH,80H,7FH,0E0H,00,00,06H,03H,0FEH,00,00,00,00
DB  00,00,0FFH,0FFH,80H,7FH,0E0H,00,03H,0E3H,07H,0E0H,00,00,00,00
DB  00,00,0FFH,0FEH,00,3FH,0E0H,00,3EH,3FH,8CH,00,00,00,00,00
DB  00,00,0FFH,0FEH,00,08H,60H,00,0E0H,0BH,0FFH,80H,00,00,00,00
DB  00,00,7FH,0FFH,00,38H,60H,01H,80H,7FH,0F8H,0FFH,00,00,00,00
DB  00,00,7FH,0FFH,0FFH,0C0H,0E0H,00,0F0H,0C0H,1EH,00,0C0H,00,00,00
DB  00,00,30H,00,0FH,0E0H,0C0H,00,67H,00,03H,0C6H,60H,00,00,00
DB  00,00,18H,00,0FH,0FFH,80H,00,3CH,00,00,23H,30H,00,00,00
DB  00,00,0CH,00,0FH,0FFH,00,00,00,00,00,19H,10H,00,00,00
DB  00,00,03H,0C0H,0FH,0F8H,00,00,00,00,00,08H,10H,00,00,00
DB  00,00,00,7FH,0FFH,0E0H,00,00,00,00,00,07H,0F0H,00,00,00
DB  00,00,00,0FH,0FCH,00,00,00,00,00,00,00,00,00,00,00
DB  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DB  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DB  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DB  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00

		END
