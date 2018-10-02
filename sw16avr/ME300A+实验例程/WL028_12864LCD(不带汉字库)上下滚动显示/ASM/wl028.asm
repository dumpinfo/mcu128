;********************************************************************************
;*  ����:  ME300ϵ�е�Ƭ������ϵͳ��ʾ���� - 12864LCD(�����ֿ⣩������ʾ        *
;*  Ӳ���� ME300A+,ME300B                                                       *
;*  �ļ�:  wl028.asm                                                            *
;*  ����:  2005-8-19                                                            *
;*  �汾:  1.0                                                                  *
;*  ����:  gguoqing                                                             *
;*  ����:  gguoqing@willar.com                                                  *
;*  ��վ�� http://www.willar.com                                                *
;********************************************************************************
;*  ����:                                                                       *
;*          TS12864A-2 ���¹�����ʾ��ʾ����                                     *
;*                                                                              *
;*          �й��ɵظı���ʾ��ʼ�У�ʵ����ʾ������Ч��                          *
;********************************************************************************
;*  �������ã�                                                                  *
;*     ME300A+    JP1 ȫ���̽ӣ�JP2�̽�1-2�ˣ�                                  *
;*     ME300B     JP1 �̽ӣ�JP2�̽�1-2�ˣ�                                      *
;*                                                                              *
;********************************************************************************
;* ����Ȩ�� Copyright(C)ΰ�ɵ��� www.willar.com  All Rights Reserved            *
;* �������� �˳��������ѧϰ��ο���������ע����Ȩ��������Ϣ��                  *
;********************************************************************************

          CS2  BIT  P2.4
	  CS1  BIT  P2.3
	  E    BIT  P2.2
	  R_W  BIT  P2.1
	  D_I  BIT  P2.0
	  RST  BIT  P2.5
	  COM  EQU  20H ; ָ��Ĵ���
	  DAT  EQU  21H ; ���ݼĴ���

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

	  MOV COM,#3EH      ;����ʾ
	  LCALL WRITE_I
	  LCALL DELLY
	  MOV COM,#3FH      ;����ʾ
	  LCALL WRITE_I
	  LCALL DELLY

	  CLR CS2           ;�������
	  SETB CS1
	  LCALL CLEAR
	  CLR CS1           ;���Ұ���
	  SETB CS2
	  LCALL CLEAR

;==========================================
;д�����
;(R3)=ҳ��ַ, (R4)= �е�ַ
;=========================================
	  CLR CS2             ;��
	  SETB CS1
	  MOV DPTR,#HZ101
	  MOV R3,#0B8H       ;ҳ��ַ
	  MOV R4,#60H        ;�е�ַ
	  LCALL HZSHOW

	  MOV DPTR,#HZ102    ;ӭ
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

	  MOV DPTR,#HZ301   ;��
	  MOV R3,#0BCH
	  MOV R4,#40H
	  LCALL HZSHOW

	  MOV DPTR,#HZ302   ;Ƭ
	  MOV R3,#0BCH
	  MOV R4,#50H
	  LCALL HZSHOW

	  MOV DPTR,#HZ303   ;��
	  MOV R3,#0BCH
	  MOV R4,#60H
	  LCALL HZSHOW

	  MOV DPTR,#HZ304   ;��
	  MOV R3,#0BCH
	  MOV R4,#70H
	  LCALL HZSHOW

;==========================================
;д�Ұ���
;(R3)=ҳ��ַ, (R4)= �е�ַ
;=========================================
          ;LCALL DELLY
	  CLR CS1             ;ʹ
	  SETB CS2
	  MOV DPTR,#HZ103
	  MOV R3,#0B8H         ;ҳ��ַ
	  MOV R4,#40H          ;�е�ַ
	  LCALL HZSHOW

	  MOV DPTR,#HZ104    ;��
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

	  MOV DPTR,#HZ305   ;��
	  MOV R3,#0BCH
	  MOV R4,#40H
	  LCALL HZSHOW

	  MOV DPTR,#HZ306   ;ϵ
	  MOV R3,#0BCH
	  MOV R4,#50H
	  LCALL HZSHOW

	  MOV DPTR,#HZ307   ;ͳ
	  MOV R3,#0BCH
	  MOV R4,#60H
	  LCALL HZSHOW

	  MOV DPTR,#HZ308   ;��
	  MOV R3,#0BCH
	  MOV R4,#70H
	  LCALL HZSHOW

MAIN1:    call  SCAN_KEY
          JMP  MAIN1
;����������������������������������������������
;���ܼ��ӳ���
;����������������������������������������������
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
;������������������������������������������������
;���¹����ӳ���
;�й��ɵظı���ʾ��ʼ�е�ַ��ʵ����ʾ������Ч����
;������������������������������������������������
MOVE_DOWN:
          MOV  R7,#03FH    ;ƫ����
MOVE_DOWN1:
          MOV  A,#0C0H     ;��ʾ��ʼ�����ô���
          ORL  A,R7        ;��ƫ������򣬵��µĵ�ַ
          CLR CS2
	  SETB CS1         ;д�����
          MOV  COM,A
          LCALL WRITE_I
          CPL CS1
	  CPL CS2          ;д�Ұ���
	  MOV COM,A
	  LCALL WRITE_I
          LCALL  DELAY1
          lcall  key3
          DJNZ  R7,MOVE_DOWN1  ;ƫ������1
          LJMP  MOVE_DOWN

;��������������������������������������������
;���Ϲ����ӳ���
;�й��ɵظı���ʾ��ʼ�У�ʵ����ʾ������Ч����
;��������������������������������������������
MOVE_UP:
          MOV  R7,#00H
MOVE_UP1:
          MOV  A,#0C0H       ;��ʾ��ʼ�����ô���
          ORL  A,R7          ;��ƫ������򣬵��µĵ�ַ
          CLR CS2
	  SETB CS1           ;д�����
          MOV  COM,A
          LCALL WRITE_I
          CPL CS1
	  CPL CS2            ;д�Ұ���
	  MOV COM,A
	  LCALL WRITE_I
          LCALL  DELAY1
          lcall  key3
          INC  R7              ;ƫ������1
          CJNE  A,#0FFH,MOVE_UP1
          LJMP  MOVE_UP

;��������������������������������������������
;��������ʱʱ�䣬�ɸı�����ٶ�
;��������������������������������������������
 DELAY1:
          MOV  R6,#060H
          MOV  R5,#00H
 DELAY2:  NOP
          DJNZ  R5,DELAY2
          DJNZ  R6,DELAY2
          RET

;=========================================
;�����ӳ���
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
;16*16������ʾ���ӳ���
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
;12*16Ӣ����ʾ���ӳ���
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
;��ʱ
;=========================================
DELLY:
          MOV R7,#0A8H
  MS2:    MOV R6,#0FFH
  MS1:    DJNZ R6,MS1
	  DJNZ R7,MS2
	  RET

;==========================================
;дָ���ӳ���
;==========================================
WRITE_I:
          MOV R0,A
	  CLR D_I
	  SETB R_W
WRITE_IA:
          MOV P0,#0FFH
	  SETB E
	  MOV  A,P0       ;��״̬��
	  CLR  E
	  JB  ACC.7,WRITE_IA  ;�С�æ����־�Ƿ�Ϊ��0��
	  CLR  R_W
	  MOV  P0,COM     ;дָ�����
	  SETB  E
	  NOP
	  NOP
	  CLR E
	  MOV A,R0
	  RET

;=========================================
;д�����ӳ���
;=========================================
WRITE_D:
          MOV R0,A
          CLR D_I
	  SETB R_W
WRITE_DA:
          MOV P0,#0FFH
	  SETB E
	  MOV  A,P0        ;��״̬��
	  CLR  E
	  JB  ACC.7,WRITE_DA   ;�С�æ����־�Ƿ�Ϊ��0��
	  SETB D_I
	  CLR R_W
	  MOV P0,DAT       ;д����
          SETB  E
          NOP
          NOP
          CLR E
	  MOV A,R0
	  RET
;-----------------------------------------------
;��������һ���ӳ���
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
 DELAY3:                    ;��ʱR5��10MS
           MOV   R6,#50
  D1:      MOV   R7,#100
           DJNZ  R7,$
           DJNZ  R6,D1
           DJNZ  R5,DELAY3
           RET



;==================================================================================
HZ101:
;--  ����:  ��  --
;--  ����12;  �������¶�Ӧ�ĵ���Ϊ����X��=16X16   --
DB  014H,024H,044H,084H,064H,01CH,020H,018H,00FH,0E8H,008H,008H,028H,018H,008H,000H
DB  020H,010H,04CH,043H,043H,02CH,020H,010H,00CH,003H,006H,018H,030H,060H,020H,000H

HZ102:
;--  ����:  ӭ  --
;--  ����12;  �������¶�Ӧ�ĵ���Ϊ����X��=16X16   --
DB  040H,041H,0CEH,004H,000H,0FCH,004H,002H,002H,0FCH,004H,004H,004H,0FCH,000H,000H
DB  040H,020H,01FH,020H,040H,047H,042H,041H,040H,05FH,040H,042H,044H,043H,040H,000H

HZ103:
;--  ����:  ʹ  --
;--  ����12;  �������¶�Ӧ�ĵ���Ϊ����X��=16X16   --
DB  040H,020H,0F0H,01CH,007H,0F2H,094H,094H,094H,0FFH,094H,094H,094H,0F4H,004H,000H
DB  000H,000H,07FH,000H,040H,041H,022H,014H,00CH,013H,010H,030H,020H,061H,020H,000H

HZ104:
;--  ����:  ��  --
;--  ����12;  �������¶�Ӧ�ĵ���Ϊ����X��=16X16   --
DB  000H,000H,000H,0FEH,022H,022H,022H,022H,0FEH,022H,022H,022H,022H,0FEH,000H,000H
DB  080H,040H,030H,00FH,002H,002H,002H,002H,0FFH,002H,002H,042H,082H,07FH,000H,000H

;------------------------------------------------------------------------------------
ZM01:
;--  ����:  M  --
;--  SYSTEM12;  �������¶�Ӧ�ĵ���Ϊ����X��=12X16   --
DB  000H,0F8H,0F8H,0E0H,080H,000H,000H,080H,0E0H,0F8H,0F8H,000H,000H,01FH,01FH,001H
DB  007H,01EH,01EH,007H,001H,01FH,01FH,000H

ZM02:
;--  ����:  E  --
;--  SYSTEM12;  �������¶�Ӧ�ĵ���Ϊ����X��=12X16   --
DB  000H,0F8H,0F8H,088H,088H,088H,088H,008H,000H,000H,000H,000H,000H,01FH,01FH,010H
DB  010H,010H,010H,010H,000H,000H,000H,000H

ZM03:
;--  ����:  3  --
;--  SYSTEM12;  �������¶�Ӧ�ĵ���Ϊ����X��=12X16   --
DB  000H,010H,018H,088H,088H,0F8H,070H,000H,000H,000H,000H,000H,000H,008H,018H,010H
DB  010H,01FH,00FH,000H,000H,000H,000H,000H

ZM04:
;--  ����:  0  --
;--  SYSTEM12;  �������¶�Ӧ�ĵ���Ϊ����X��=12X16   --
DB  000H,0F0H,0F8H,008H,008H,0F8H,0F0H,000H,000H,000H,000H,000H,000H,00FH,01FH,010H
DB  010H,01FH,00FH,000H,000H,000H,000H,000H

ZM05:
;--  ����:  B  --
;--  SYSTEM12;  �������¶�Ӧ�ĵ���Ϊ����X��=12X16   --
DB  000H,0F8H,0F8H,088H,088H,088H,088H,0F8H,070H,000H,000H,000H,000H,01FH,01FH,010H
DB  010H,010H,010H,01FH,00FH,000H,000H,000H

;===================================================================================
HZ301:
;--  ����:  ��  --
;--  ����12;  �������¶�Ӧ�ĵ���Ϊ����X��=16X16   --
DB  000H,000H,0F8H,028H,029H,02EH,02AH,0F8H,028H,02CH,02BH,02AH,0F8H,000H,000H,000H
DB  008H,008H,00BH,009H,009H,009H,009H,0FFH,009H,009H,009H,009H,00BH,008H,008H,000H

HZ302:
;--  ����:  Ƭ  --
;--  ����12;  �������¶�Ӧ�ĵ���Ϊ����X��=16X16   --
DB  000H,000H,000H,0FEH,010H,010H,010H,010H,010H,01FH,010H,010H,010H,018H,010H,000H
DB  080H,040H,030H,00FH,001H,001H,001H,001H,001H,001H,001H,0FFH,000H,000H,000H,000H

HZ303:
;--  ����:  ��  --
;--  ����12;  �������¶�Ӧ�ĵ���Ϊ����X��=16X16   --
DB  008H,008H,0C8H,0FFH,048H,088H,008H,000H,0FEH,002H,002H,002H,0FEH,000H,000H,000H
DB  004H,003H,000H,0FFH,000H,041H,030H,00CH,003H,000H,000H,000H,03FH,040H,078H,000H

HZ304:
;--  ����:  ��  --
;--  ����12;  �������¶�Ӧ�ĵ���Ϊ����X��=16X16   --
DB  040H,042H,042H,042H,042H,0FEH,042H,042H,042H,042H,0FEH,042H,042H,042H,042H,000H
DB  000H,040H,020H,010H,00CH,003H,000H,000H,000H,000H,07FH,000H,000H,000H,000H,000H

HZ305:
;--  ����:  ��  --
;--  ����12;  �������¶�Ӧ�ĵ���Ϊ����X��=16X16   --
DB  000H,010H,03EH,010H,010H,0F0H,09FH,090H,090H,092H,094H,01CH,010H,010H,010H,000H
DB  040H,020H,010H,088H,087H,041H,046H,028H,010H,028H,027H,040H,0C0H,040H,000H,000H

HZ306:
;--  ����:  ϵ  --
;--  ����12;  �������¶�Ӧ�ĵ���Ϊ����X��=16X16   --
DB  000H,000H,002H,022H,0B2H,0AAH,066H,062H,022H,011H,04DH,081H,001H,001H,000H,000H
DB  000H,040H,021H,013H,009H,005H,041H,081H,07FH,001H,005H,009H,013H,062H,000H,000H

HZ307:
;--  ����:  ͳ  --
;--  ����12;  �������¶�Ӧ�ĵ���Ϊ����X��=16X16   --
DB  020H,030H,02CH,0A3H,060H,010H,084H,0C4H,0A4H,09DH,086H,084H,0A4H,0C4H,084H,000H
DB  020H,022H,023H,012H,012H,092H,040H,030H,00FH,000H,000H,03FH,040H,041H,070H,000H

HZ308:
;--  ����:  ��  --
;--  ����12;  �������¶�Ӧ�ĵ���Ϊ����X��=16X16   --
DB  010H,010H,0D0H,0FFH,050H,090H,000H,0FEH,062H,0A2H,022H,021H,0A1H,061H,000H,000H
DB  004H,003H,000H,07FH,000H,011H,00EH,041H,020H,011H,00AH,00EH,031H,060H,020H,000H

;====================================================================================

      END


