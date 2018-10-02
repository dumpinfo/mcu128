;********************************************************************************
;*  ����:  ME300ϵ�е�Ƭ������ϵͳ��ʾ���� - 1602LCD��ʾ���                    *
;*  Ӳ���� ME300A+,ME300B                                                       *
;*  �ļ�:  WL012.asm                                                            *
;*  ����:  2004-1-5                                                             *
;*  �汾:  1.0                                                                  *
;*  ����:  gguoqing                                                             *
;*  ����:  gguoqing@willar.com                                                  *
;*  ��վ�� http://www.willar.com                                                *
;********************************************************************************
;*  ����:                                                                       *
;*          1602LCD��ʾ���                                                     *
;*          K3 --- ���ư���                                                     *
;*                 ��һ�ΰ���ʱ,��ʼ��ʱ���ڶ��ΰ���ʱ,��ͣ��ʱ��               *
;*                 �����ΰ���ʱ,�ۼƼ�ʱ�����Ĵΰ���ʱ,��ͣ��ʱ��               *
;*          K4 --- ���㰴����                                                   *
;*                 ���κ�״̬�£���һ��K4���������㡣                           *
;********************************************************************************
;*  �������ã�                                                                  *
;*     ME300A+    JP1 ȫ���̽ӣ�JP2�̽�1-2��                                    *
;*     ME300B     JP1 �̽ӣ�JP2�̽�1-2��                                        *
;*                                                                              *
;********************************************************************************
;* ����Ȩ�� Copyright(C)ΰ�ɵ��� www.willar.com  All Rights Reserved            *
;* �������� �˳��������ѧϰ��ο���������ע����Ȩ��������Ϣ��                  *
;********************************************************************************


;---------------------------------------
;���� 11.0592M
;��ʱ��0,��ʽ1
;��ʱ�жϳ���ÿ��10ms�ж�һ��
;---------------------------------------
          TLOW   EQU  0CH     ;��ʱ����ֵ
          THIGH  EQU  0DCH

          HOUR   EQU  30H
          MIN    EQU  31H
          SEC    EQU  32H
          SEC0   EQU  33H     ;10ms����ֵ
          KEY_S  EQU  34H     ;Ϊ����ǰ�Ķ˿�״��
          KEY_V  EQU  35H     ;Ϊ���ϴεĶ˿�״��
          X      EQU  36H     ;LCD ��ַ����
          KEY_C  EQU  37H     ;��������Ԫ

          K1     EQU  P1.4
          K2     EQU  P1.5
          K3     EQU  P1.6
          K4     EQU  P1.7

          BEEP  EQU  P3.7
          RS    EQU  P2.0     ;LCD���ƶ˿ڶ���
          RW    EQU  P2.1
          EN    EQU  P2.2

;----------------------------------------------------
          ORG   0000H
          JMP  START
          ORG  0BH
          JMP  T0_INT
;----------------------------------------------------
START:    MOV  SP,#60H
          CLR  EN
          CALL  SET_LCD
          CALL  INIT            ;��ʼ������
          MOV  KEY_V,#01H
          CALL  INIT_TIMER      ;��ʼ����ʱ��
          CALL  MENU
LOOP:     CALL   CONV           ;ʱ���������
          CALL LOOP1
          CALL  SKEY            ;���Ƿ��м�����
          JZ  LOOP              ;�޼�����תLOOP
          CALL   CONV
          CALL  SKEY
          JZ  LOOP
          MOV  KEY_V,KEY_S      ;��������
          CALL  P_KEY
          JMP  LOOP
;-----------------------------------------------------
LOOP1:    JB  K4,LOOP2         ;��������Ƿ���
          CALL  BZ
          JMP  START
LOOP2:    RET
;-----------------------------------------------------
P_KEY:                          ;
          MOV  A,KEY_V
          JB  ACC.0,P_KEY3
          INC  KEY_C
          MOV  A,KEY_C          ;K3���Ƿ��һ�ΰ��£�
          CJNE  A,#01H,P_KEY1
          MOV    DPTR,#MADJ    ;��ʾִ����Ϣ
          MOV    A,#1          ;
          CALL   LCD_PRINT
          SETB  TR0            ;�����ж�
          RET
P_KEY1:                          ;K3���Ƿ�ڶ��ΰ��£�
          MOV   A,KEY_C
          CJNE  A,#02H,P_KEY2
          MOV   DPTR,#MADJ1      ;��ʾִ����Ϣ
          MOV   A,#1
          CALL  LCD_PRINT
          CLR   TR0              ;ֹͣ�ж�
          RET
P_KEY2:                          ;K3���Ƿ�����ΰ��£�
          MOV   A,KEY_C
          CJNE  A,#03H,P_KEY3
          MOV   DPTR,#MADJ2      ;��ʾִ����Ϣ
          MOV   A,#1
          CALL  LCD_PRINT
          SETB   TR0             ;�����ж�
          RET
P_KEY3:                          ;K3���Ƿ���Ĵΰ��£�
          MOV   A,KEY_C
          CJNE  A,#04H,P_KEY4
          MOV   DPTR,#MADJ3      ;��ʾִ����Ϣ
          MOV   A,#1
          CALL  LCD_PRINT
          CLR   TR0              ;�����ж�
P_KEY4:   RET
;-------------------------------------------------------
SKEY:     CLR  A                ;���Ƿ��м������ӳ���
          MOV  KEY_S,A
          MOV  C,K3
          RLC  A
          ORL  KEY_S,A
          MOV  A,KEY_S
          XRL  A,KEY_V          ;�м����£�A �����ݲ�Ϊ��
          RET
;--------------------------------------------------------
LMESS1:  DB  "                ",0  ;LCD ��һ����ʾ��Ϣ
LMESS2:  DB  "TIME            ",0  ;LCD �ڶ�����ʾ��Ϣ
;--------------------------------------------------------
INIT:    CLR  A
         MOV  KEY_C,A         ;��ʼ�����Ʊ���
         MOV  SEC0,A
         MOV  SEC,A
         MOV  MIN,A
         MOV  HOUR,A
         MOV  KEY_S,A
         MOV  KEY_V,A
         SETB  BEEP
         CLR  TR0
         RET
;------------------------------------------------------------
INIT_TIMER:                     ;��ʼ����ʱ���ӿ�
         MOV  TMOD,#01H         ;���ö�ʱ��0 ����ģʽΪģʽ1
         MOV  IE,  #82H         ;���ö�ʱ��0 �жϲ���
         MOV  TL0,#TLOW
         MOV  TH0,#THIGH
         RET
;-------------------------------------------------------------
T0_INT:
         PUSH  ACC           ;��ʱ��0��ʱ�жϳ���
         MOV  TL0,#TLOW
         MOV  TH0,#THIGH
         INC  SEC0
         MOV  A,SEC0         ;10ms ����ֵ��1
         CJNE  A,#100,TT
         MOV  SEC0,#0
         INC  SEC            ;���1
         MOV  A,SEC
         CJNE  A,#60,TT
         INC  MIN            ;�ּ�1
         MOV  SEC,#0
         MOV  A,MIN
         CJNE  A,#60,TT
         INC  HOUR           ;ʱ��1
         MOV  MIN,#0
         MOV  A,HOUR
         CJNE  A,#24,TT
         MOV  SEC0,#0
         MOV  SEC,#0          ;�롢�֡�ʱ��Ԫ��0
         MOV  MIN,#0
         MOV  HOUR,#0
 TT:     POP  ACC
         RETI
;-------------------------------------------------------
;   �ڵڶ�����ʾ����
;-------------------------------------------------------
SHOW_DIG2:                    ;�� LCD �ĵڶ�����ʾ����
          MOV  B,#10         ;���ñ�����
          DIV  AB            ;���A��������B������
          ADD  A,#30H        ;AΪʮλ����ת��Ϊ�ַ�
          PUSH  B            ;B�����ջ�ݴ�
          MOV  B,X           ;���� LCD ��ʾ��λ��
          CALL  LCDP2        ;�� LCD ��ʾ����
          POP  B             ;
          MOV  A,B           ;BΪ��λ��
          ADD  A,#30H        ;ת��Ϊ�ַ�
          INC  X             ;LCD ��ʾλ�ü�1
          MOV  B,X           ;���� LCD ��ʾ��λ��
          CALL  LCDP2        ;�� LCD ��ʾ����
          RET
;-------------------------------------------
;ת��Ϊ ASCII �벢��ʾ
;-------------------------------------------
CONV:
          MOV  A,HOUR        ;����Сʱ����
          MOV  X,#5          ;����λ��
          CALL  SHOW_DIG2    ;��ʾ����
          INC  X             ;
          MOV  A,#':'        ;
          MOV  B,X           ;
          CALL  LCDP2        ;
          MOV  A,MIN         ;���ط�������
          INC  X             ;����λ��
          CALL  SHOW_DIG2    ;��ʾ����
          INC  X             ;
          MOV  A,#':'        ;
          MOV  B,X           ;
          CALL  LCDP2        ;
          MOV  A,SEC         ;������������
          INC  X             ;����λ��
          CALL  SHOW_DIG2    ;��ʾ����
          INC  X             ;
          MOV  A,#':'        ;
          MOV  B,X           ;
          CALL  LCDP2        ;
          MOV  A,SEC0        ;������������
          INC  X             ;����λ��
          CALL  SHOW_DIG2
          RET
;---------------------------------------------------------
;  LCD  CONTROL
;---------------------------------------------------------
SET_LCD:                     ;�� LCD ����ʼ�����ü�����
          CLR  EN
          CALL  INIT_LCD     ;��ʼ�� LCD
          MOV  R5,#10
          CALL  DELAY
          MOV  DPTR,#LMESS1  ;ָ��ָ����ʾ��Ϣ1
          MOV  A,#1          ;��ʾ�ڵ�һ��
          CALL  LCD_PRINT
          MOV  DPTR,#LMESS2  ;ָ��ָ����ʾ��Ϣ2
          MOV  A,#2          ;��ʾ�ڵڶ���
          CALL  LCD_PRINT
          RET
;----------------------------------------------------------
INIT_LCD1:                   ;LCD ����ָ���ʼ��
          MOV  A,#38H        ;˫����ʾ������5*7����
          CALL  WCOM         ;
          call  delay1
          MOV  A,#0CH        ;����ʾ����ʾ��꣬��겻��˸
          CALL  WCOM         ;
          call  delay1
          MOV  A,#01H        ;��� LCD ��ʾ��
          CALL  WCOM         ;
          call  delay1
          RET
;----------------------------------------------------------
ENABLE:                       ;дָ��
          CLR RS              ;RS=L,RW=L,E=������
          CLR RW              ;D0-D7=ָ����
          SETB EN
          ACALL DELAY1          
          CLR EN
          RET
;----------------------------------------------------------
LCD_PRINT:       ;��LCD�ĵ�һ�л�ڶ�����ʾ�ַ�

          CJNE  A,#1,LINE2  ;�ж��Ƿ�Ϊ��һ��
  LINE1:  MOV  A,#80H       ;���� LCD �ĵ�һ�е�ַ
          CALL  WCOM        ;д������
          CALL  CLR_LINE    ;��������ַ�����
          MOV  A,#80H       ;���� LCD �ĵ�һ�е�ַ
          CALL  WCOM        ;д������
          JMP  FILL
  LINE2:  MOV  A,#0C0H      ;���� LCD �ĵڶ��е�ַ
          CALL  WCOM        ;д������
          CALL  CLR_LINE    ;��������ַ�����
          MOV  A,#0C0H      ;���� LCD �ĵڶ��е�ַ
          CALL  WCOM
  FILL:   CLR  A            ;�����ַ�
          MOVC  A,@A+DPTR   ;����Ϣ��ȡ���ַ�
          CJNE  A,#0,LC1    ;�ж��Ƿ�Ϊ������
          RET
  LC1:    CALL  WDATA       ;д������
          INC  DPTR         ;ָ���1
          JMP  FILL         ;���������ַ�
          RET
;-------------------------------------------------------
CLR_LINE:                  ;������� LCD ���ַ�
          MOV  R0,#24
   CL1:   MOV  A,#' '
          CALL  WDATA
          DJNZ  R0,CL1
          RET
;-------------------------------------------------------
   DE:    MOV  R7,#250      ;��ʱ500΢��
          DJNZ  R7,$
          RET
;-------------------------------------------------------
   EN1:
          CLR   RW
          SETB  EN         ;��������������ź�
          CALL  DE
          CLR  EN
          CALL  DE
          RET
;------------------------------------------------------
INIT_LCD:                  ;8λI/O���� LCD �ӿڳ�ʼ��
          MOV  P0,#38H     ;˫����ʾ������5*7����
          call  enable
          call  delay1
          MOV  P0,#38H     ;˫����ʾ������5*7����
          call  enable
          call  delay1
          MOV  P0,#38H     ;˫����ʾ������5*7����
          call  enable
          call  delay1
          CALL  INIT_LCD1
          RET
;-----------------------------------------------------
WCOM:                     ;��8λ���Ʒ�ʽ������д��LCD
          MOV  P0,A       ;д������
          call  enable
          RET
;-----------------------------------------------------
WDATA:                    ;��8λ���Ʒ�ʽ������д��LCD
          MOV  P0,A       ;д������
          SETB  RS        ;����д������
          CALL  EN1
          RET
;-----------------------------------------------------
;�ڶ�����ʾ�ַ�
;-----------------------------------------------------
LCDP2:                    ;��LCD�ĵڶ�����ʾ�ַ�
         PUSH  ACC        ;
         MOV  A,B         ;������ʾ��ַ
         ADD  A,#0C0H     ;����LCD�ĵڶ��е�ַ
         CALL  WCOM       ;д������
         POP  ACC         ;�ɶ�ջȡ��A
         CALL  WDATA      ;д������
         RET
;----------------------------------------------------
DELAY:                    ;��ʱ10MS
         MOV  R6,#50
  D1:    MOV  R7,#100
         DJNZ  R7,$
         DJNZ  R6,D1
         DJNZ  R5,DELAY
         RET
;-----------------------------------------------------
DELAY1:                    ;��ʱ5MS
         MOV  R6,#25
  D2:    MOV  R7,#100
         DJNZ  R7,$
         DJNZ  R6,D2
         RET
;-----------------------------------------------------
BZ:                        ;������
         MOV  R6,#100
  B1:    CALL  DEX
         CPL  BEEP
         DJNZ  R6,B1
         MOV  R5,#10
         CALL  DELAY
         RET
 DEX:    MOV  R7,#180
 DE1:    NOP
         DJNZ  R7,DE1
         RET

;-------------------------------------------------
MMENU:  DB  " SECOND-CLOCK 0 ",0
MADJ:   DB  " BEGIN COUNT  1 ",0
MADJ1:  DB  " PAUST COUNT  2 ",0
MADJ2:  DB  " BEGIN COUNT  3 ",0
MADJ3:  DB  " PAUST COUNT  4 ",0
;-------------------------------------------------
MENU:                      ;LCD ��ʾ�����˵���Ϣ
         MOV  DPTR,#MMENU
         MOV  A,#1
         CALL  LCD_PRINT
         RET
;-------------------------------------------------
         END
