;********************************************************************************
;*  标题:  ME300系列单片机开发系统演示程序 - 12864LCD(不带字库）滚动显示        *
;*  硬件： ME300A+,ME300B                                                       *
;*  文件:  wl028.asm                                                            *
;*  日期:  2005-8-19                                                            *
;*  版本:  1.0                                                                  *
;*  作者:  gguoqing                                                             *
;*  邮箱:  gguoqing@willar.com                                                  *
;*  网站： http://www.willar.com                                                *
;********************************************************************************
;*  描述:                                                                       *
;*          TS12864A-2 上下滚动显示演示程序                                     *
;*                                                                              *
;*          有规律地改变显示起始行，实现显示滚动的效果                          *
;********************************************************************************
;*  跳线设置：                                                                  *
;*     ME300A+    JP1 全部短接，JP2短接1-2端，                                  *
;*     ME300B     JP1 短接，JP2短接1-2端，                                      *
;*                                                                              *
;********************************************************************************
;* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
;* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
;********************************************************************************

          CS2  BIT  P2.4
	  CS1  BIT  P2.3
	  E    BIT  P2.2
	  R_W  BIT  P2.1
	  D_I  BIT  P2.0
	  RST  BIT  P2.5
	  COM  EQU  20H ; 指令寄存器
	  DAT  EQU  21H ; 数据寄存器

          K1   EQU  P1.4
          K2   EQU  P1.5
          K3   EQU  P1.6
          K4   EQU  P1.7
          BEEP  EQU  P3.7

	  ORG 0000H
	  AJMP MAIN

;------------------------------------------
	  ORG 0050H
MAIN:
          mov  sp,#50h
	  SETB RST          ;

	  MOV COM,#3EH      ;关显示
	  LCALL WRITE_I
	  LCALL DELLY
	  MOV COM,#3FH      ;开显示
	  LCALL WRITE_I
	  LCALL DELLY

	  CLR CS2           ;清左半屏
	  SETB CS1
	  LCALL CLEAR
	  CLR CS1           ;清右半屏
	  SETB CS2
	  LCALL CLEAR

;==========================================
;写左半屏
;(R3)=页地址, (R4)= 列地址
;=========================================
	  CLR CS2             ;欢
	  SETB CS1
	  MOV DPTR,#HZ101
	  MOV R3,#0B8H       ;页地址
	  MOV R4,#60H        ;列地址
	  LCALL HZSHOW

	  MOV DPTR,#HZ102    ;迎
	  MOV R3,#0B8H
	  MOV R4,#70H
	  LCALL HZSHOW

	  MOV DPTR,#ZM01     ;M
	  MOV R3,#0BAH
	  MOV R4,#50H
	  LCALL YWSHOW

	  MOV DPTR,#ZM02     ;E
	  MOV R3,#0BAH
	  MOV R4,#60H
	  LCALL YWSHOW

	  MOV DPTR,#ZM03     ;3
	  MOV R3,#0BAH
	  MOV R4,#70H
	  LCALL YWSHOW

	  MOV DPTR,#HZ301   ;单
	  MOV R3,#0BCH
	  MOV R4,#40H
	  LCALL HZSHOW

	  MOV DPTR,#HZ302   ;片
	  MOV R3,#0BCH
	  MOV R4,#50H
	  LCALL HZSHOW

	  MOV DPTR,#HZ303   ;机
	  MOV R3,#0BCH
	  MOV R4,#60H
	  LCALL HZSHOW

	  MOV DPTR,#HZ304   ;开
	  MOV R3,#0BCH
	  MOV R4,#70H
	  LCALL HZSHOW

;==========================================
;写右半屏
;(R3)=页地址, (R4)= 列地址
;=========================================
          ;LCALL DELLY
	  CLR CS1             ;使
	  SETB CS2
	  MOV DPTR,#HZ103
	  MOV R3,#0B8H         ;页地址
	  MOV R4,#40H          ;列地址
	  LCALL HZSHOW

	  MOV DPTR,#HZ104    ;用
	  MOV R3,#0B8H
	  MOV R4,#50H
	  LCALL HZSHOW

	  MOV DPTR,#ZM04     ;0
	  MOV R3,#0BAH
	  MOV R4,#40H
	  LCALL YWSHOW

	  MOV DPTR,#ZM04     ;0
	  MOV R3,#0BAH
	  MOV R4,#50H
	  LCALL YWSHOW

	  MOV DPTR,#ZM05     ;B
	  MOV R3,#0BAH
	  MOV R4,#60H
	  LCALL YWSHOW

	  MOV DPTR,#HZ305   ;发
	  MOV R3,#0BCH
	  MOV R4,#40H
	  LCALL HZSHOW

	  MOV DPTR,#HZ306   ;系
	  MOV R3,#0BCH
	  MOV R4,#50H
	  LCALL HZSHOW

	  MOV DPTR,#HZ307   ;统
	  MOV R3,#0BCH
	  MOV R4,#60H
	  LCALL HZSHOW

	  MOV DPTR,#HZ308   ;板
	  MOV R3,#0BCH
	  MOV R4,#70H
	  LCALL HZSHOW

MAIN1:    call  SCAN_KEY
          JMP  MAIN1
;－－－－－－－－－－－－－－－－－－－－－－－
;功能键子程序
;－－－－－－－－－－－－－－－－－－－－－－－
SCAN_KEY:
          JB  K1, KEY2
          CALL  BEEP_BL
          LCALL  MOVE_UP

KEY2:     JB  K2, KEY3
          CALL BEEP_BL
          LCALL  MOVE_DOWN

KEY3:     JB  K3,KEY4
          CALL  BEEP_BL
          jmp  MAIN
KEY4:     RET
;－－－－－－－－－－－－－－－－－－－－－－－－
;向下滚动子程序
;有规律地改变显示起始行地址，实现显示滚动的效果。
;－－－－－－－－－－－－－－－－－－－－－－－－
MOVE_DOWN:
          MOV  R7,#03FH    ;偏移数
MOVE_DOWN1:
          MOV  A,#0C0H     ;显示起始行设置代码
          ORL  A,R7        ;与偏移数相或，得新的地址
          CLR CS2
	  SETB CS1         ;写左半屏
          MOV  COM,A
          LCALL WRITE_I
          CPL CS1
	  CPL CS2          ;写右半屏
	  MOV COM,A
	  LCALL WRITE_I
          LCALL  DELAY1
          lcall  key3
          DJNZ  R7,MOVE_DOWN1  ;偏移数减1
          LJMP  MOVE_DOWN

;－－－－－－－－－－－－－－－－－－－－－－
;向上滚屏子程序
;有规律地改变显示起始行，实现显示滚屏的效果。
;－－－－－－－－－－－－－－－－－－－－－－
MOVE_UP:
          MOV  R7,#00H
MOVE_UP1:
          MOV  A,#0C0H       ;显示起始行设置代码
          ORL  A,R7          ;与偏移数相或，得新的地址
          CLR CS2
	  SETB CS1           ;写左半屏
          MOV  COM,A
          LCALL WRITE_I
          CPL CS1
	  CPL CS2            ;写右半屏
	  MOV COM,A
	  LCALL WRITE_I
          LCALL  DELAY1
          lcall  key3
          INC  R7              ;偏移数加1
          CJNE  A,#0FFH,MOVE_UP1
          LJMP  MOVE_UP

;－－－－－－－－－－－－－－－－－－－－－－
;调整此延时时间，可改变滚屏速度
;－－－－－－－－－－－－－－－－－－－－－－
 DELAY1:
          MOV  R6,#060H
          MOV  R5,#00H
 DELAY2:  NOP
          DJNZ  R5,DELAY2
          DJNZ  R6,DELAY2
          RET

;=========================================
;清屏子程序
;========================================
CLEAR:
          MOV R3,#0B8H
	  MOV COM,R3
	  LCALL WRITE_I
	  MOV COM,#40H
	  LCALL WRITE_I
	  MOV R1,#00H
	  MOV R2,#00H
CLEAR1:   MOV DAT,#00H
	  LCALL WRITE_D
	  INC R1
	  CJNE R1,#40H,CLEAR1
	  MOV R1,#00H
	  INC R2
	  INC R3
	  MOV COM,R3
	  LCALL WRITE_I
	  MOV COM,#40H
	  LCALL WRITE_I
	  CJNE R2,#08H,CLEAR1
	  RET

;=========================================
;16*16汉字显示的子程序
;=========================================
HZSHOW:
          MOV COM,R3
	  LCALL WRITE_I
	  MOV COM,R4
	  LCALL WRITE_I
	  MOV R2,#20H
	  MOV R1,#00H
LOOP:     CJNE R2,#10H,LOOP1
	  INC R3
	  MOV COM,R3
	  LCALL WRITE_I
	  MOV COM,R4
	  LCALL WRITE_I
LOOP1:    MOV A,R1
	  MOVC A,@A+DPTR
	  MOV DAT,A
	  LCALL WRITE_D
	  INC R1
	  DJNZ R2,LOOP
	  RET

;==========================================
;12*16英文显示的子程序
;==========================================
YWSHOW:
	  MOV COM,R3
	  LCALL WRITE_I
	  MOV COM,R4
	  LCALL WRITE_I
	  MOV R2,#18H
	  MOV R1,#00H
LOOP2:    CJNE R2,#0CH,LOOP22
	  INC R3
	  MOV COM,R3
	  LCALL WRITE_I
	  MOV COM,R4
	  LCALL WRITE_I
LOOP22:   MOV A,R1
	  MOVC A,@A+DPTR
	  MOV DAT,A
	  LCALL WRITE_D
	  INC R1
	  DJNZ R2,LOOP2
	  RET

;=========================================
;延时
;=========================================
DELLY:
          MOV R7,#0A8H
  MS2:    MOV R6,#0FFH
  MS1:    DJNZ R6,MS1
	  DJNZ R7,MS2
	  RET

;==========================================
;写指令子程序
;==========================================
WRITE_I:
          MOV R0,A
	  CLR D_I
	  SETB R_W
WRITE_IA:
          MOV P0,#0FFH
	  SETB E
	  MOV  A,P0       ;读状态字
	  CLR  E
	  JB  ACC.7,WRITE_IA  ;判“忙”标志是否为“0”
	  CLR  R_W
	  MOV  P0,COM     ;写指令代码
	  SETB  E
	  NOP
	  NOP
	  CLR E
	  MOV A,R0
	  RET

;=========================================
;写数据子程序
;=========================================
WRITE_D:
          MOV R0,A
          CLR D_I
	  SETB R_W
WRITE_DA:
          MOV P0,#0FFH
	  SETB E
	  MOV  A,P0        ;读状态字
	  CLR  E
	  JB  ACC.7,WRITE_DA   ;判“忙”标志是否为“0”
	  SETB D_I
	  CLR R_W
	  MOV P0,DAT       ;写数据
          SETB  E
          NOP
          NOP
          CLR E
	  MOV A,R0
	  RET
;-----------------------------------------------
;蜂鸣器响一声子程序
;-----------------------------------------------
BEEP_BL:
           MOV   R6,#100
  BL1:     CALL  DEX1
           CPL   BEEP
           DJNZ  R6,BL1
           MOV   R5,#25
           CALL  DELAY2
           RET
 DEX1:     MOV   R7,#180
 DEX2:     NOP
           DJNZ  R7,DEX2
           RET
 DELAY3:                    ;延时R5×10MS
           MOV   R6,#50
  D1:      MOV   R7,#100
           DJNZ  R7,$
           DJNZ  R6,D1
           DJNZ  R5,DELAY3
           RET



;==================================================================================
HZ101:
;--  文字:  欢  --
;--  宋体12;  此字体下对应的点阵为：宽X高=16X16   --
DB  014H,024H,044H,084H,064H,01CH,020H,018H,00FH,0E8H,008H,008H,028H,018H,008H,000H
DB  020H,010H,04CH,043H,043H,02CH,020H,010H,00CH,003H,006H,018H,030H,060H,020H,000H

HZ102:
;--  文字:  迎  --
;--  宋体12;  此字体下对应的点阵为：宽X高=16X16   --
DB  040H,041H,0CEH,004H,000H,0FCH,004H,002H,002H,0FCH,004H,004H,004H,0FCH,000H,000H
DB  040H,020H,01FH,020H,040H,047H,042H,041H,040H,05FH,040H,042H,044H,043H,040H,000H

HZ103:
;--  文字:  使  --
;--  宋体12;  此字体下对应的点阵为：宽X高=16X16   --
DB  040H,020H,0F0H,01CH,007H,0F2H,094H,094H,094H,0FFH,094H,094H,094H,0F4H,004H,000H
DB  000H,000H,07FH,000H,040H,041H,022H,014H,00CH,013H,010H,030H,020H,061H,020H,000H

HZ104:
;--  文字:  用  --
;--  宋体12;  此字体下对应的点阵为：宽X高=16X16   --
DB  000H,000H,000H,0FEH,022H,022H,022H,022H,0FEH,022H,022H,022H,022H,0FEH,000H,000H
DB  080H,040H,030H,00FH,002H,002H,002H,002H,0FFH,002H,002H,042H,082H,07FH,000H,000H

;------------------------------------------------------------------------------------
ZM01:
;--  文字:  M  --
;--  SYSTEM12;  此字体下对应的点阵为：宽X高=12X16   --
DB  000H,0F8H,0F8H,0E0H,080H,000H,000H,080H,0E0H,0F8H,0F8H,000H,000H,01FH,01FH,001H
DB  007H,01EH,01EH,007H,001H,01FH,01FH,000H

ZM02:
;--  文字:  E  --
;--  SYSTEM12;  此字体下对应的点阵为：宽X高=12X16   --
DB  000H,0F8H,0F8H,088H,088H,088H,088H,008H,000H,000H,000H,000H,000H,01FH,01FH,010H
DB  010H,010H,010H,010H,000H,000H,000H,000H

ZM03:
;--  文字:  3  --
;--  SYSTEM12;  此字体下对应的点阵为：宽X高=12X16   --
DB  000H,010H,018H,088H,088H,0F8H,070H,000H,000H,000H,000H,000H,000H,008H,018H,010H
DB  010H,01FH,00FH,000H,000H,000H,000H,000H

ZM04:
;--  文字:  0  --
;--  SYSTEM12;  此字体下对应的点阵为：宽X高=12X16   --
DB  000H,0F0H,0F8H,008H,008H,0F8H,0F0H,000H,000H,000H,000H,000H,000H,00FH,01FH,010H
DB  010H,01FH,00FH,000H,000H,000H,000H,000H

ZM05:
;--  文字:  B  --
;--  SYSTEM12;  此字体下对应的点阵为：宽X高=12X16   --
DB  000H,0F8H,0F8H,088H,088H,088H,088H,0F8H,070H,000H,000H,000H,000H,01FH,01FH,010H
DB  010H,010H,010H,01FH,00FH,000H,000H,000H

;===================================================================================
HZ301:
;--  文字:  单  --
;--  宋体12;  此字体下对应的点阵为：宽X高=16X16   --
DB  000H,000H,0F8H,028H,029H,02EH,02AH,0F8H,028H,02CH,02BH,02AH,0F8H,000H,000H,000H
DB  008H,008H,00BH,009H,009H,009H,009H,0FFH,009H,009H,009H,009H,00BH,008H,008H,000H

HZ302:
;--  文字:  片  --
;--  宋体12;  此字体下对应的点阵为：宽X高=16X16   --
DB  000H,000H,000H,0FEH,010H,010H,010H,010H,010H,01FH,010H,010H,010H,018H,010H,000H
DB  080H,040H,030H,00FH,001H,001H,001H,001H,001H,001H,001H,0FFH,000H,000H,000H,000H

HZ303:
;--  文字:  机  --
;--  宋体12;  此字体下对应的点阵为：宽X高=16X16   --
DB  008H,008H,0C8H,0FFH,048H,088H,008H,000H,0FEH,002H,002H,002H,0FEH,000H,000H,000H
DB  004H,003H,000H,0FFH,000H,041H,030H,00CH,003H,000H,000H,000H,03FH,040H,078H,000H

HZ304:
;--  文字:  开  --
;--  宋体12;  此字体下对应的点阵为：宽X高=16X16   --
DB  040H,042H,042H,042H,042H,0FEH,042H,042H,042H,042H,0FEH,042H,042H,042H,042H,000H
DB  000H,040H,020H,010H,00CH,003H,000H,000H,000H,000H,07FH,000H,000H,000H,000H,000H

HZ305:
;--  文字:  发  --
;--  宋体12;  此字体下对应的点阵为：宽X高=16X16   --
DB  000H,010H,03EH,010H,010H,0F0H,09FH,090H,090H,092H,094H,01CH,010H,010H,010H,000H
DB  040H,020H,010H,088H,087H,041H,046H,028H,010H,028H,027H,040H,0C0H,040H,000H,000H

HZ306:
;--  文字:  系  --
;--  宋体12;  此字体下对应的点阵为：宽X高=16X16   --
DB  000H,000H,002H,022H,0B2H,0AAH,066H,062H,022H,011H,04DH,081H,001H,001H,000H,000H
DB  000H,040H,021H,013H,009H,005H,041H,081H,07FH,001H,005H,009H,013H,062H,000H,000H

HZ307:
;--  文字:  统  --
;--  宋体12;  此字体下对应的点阵为：宽X高=16X16   --
DB  020H,030H,02CH,0A3H,060H,010H,084H,0C4H,0A4H,09DH,086H,084H,0A4H,0C4H,084H,000H
DB  020H,022H,023H,012H,012H,092H,040H,030H,00FH,000H,000H,03FH,040H,041H,070H,000H

HZ308:
;--  文字:  板  --
;--  宋体12;  此字体下对应的点阵为：宽X高=16X16   --
DB  010H,010H,0D0H,0FFH,050H,090H,000H,0FEH,062H,0A2H,022H,021H,0A1H,061H,000H,000H
DB  004H,003H,000H,07FH,000H,011H,00EH,041H,020H,011H,00AH,00EH,031H,060H,020H,000H

;====================================================================================

      END


