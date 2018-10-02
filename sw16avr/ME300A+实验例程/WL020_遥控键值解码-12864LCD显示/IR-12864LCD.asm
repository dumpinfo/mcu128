;********************************************************************************
;*  ����:  ME300ϵ�е�Ƭ������ϵͳ��ʾ���� - 12864LCD��ʾң�ؼ�ֵ��ȡ��         *
;*  Ӳ���� ME300A+,ME300B                                                       *
;*  �ļ�:  IR_12864LCD.asm                                                      *
;*  ����:  2005-3-20                                                            *
;*  �汾:  1.0                                                                  *
;*  ����:  gguoqing                                                             *
;*  ����:  gguoqing@willar.com                                                  *
;*  ��վ�� http://www.willar.com                                                *
;********************************************************************************
;*  ����:                                                                       *
;*         12864LCD(�����ֿ�)��ʾң�ؼ�ֵ��ȡ��                                 *
;*         P0��ΪTS12864A-3������ D0-D7                                         *
;*         K17�����£��̵������ϡ�K19�����£��̵����ر�                         *
;*         ��ʾ�������жϷ������֮��                                           *
;********************************************************************************
;*  �������ã�                                                                  *
;*     ME300A+    JP1 ȫ���̽ӣ�JP2�̽�1-2��                                    *
;*     ME300B     JP1 �̽ӣ�JP2�̽�1-2�ˣ�JP4��P32��Ҫ�̽�                      *  
;*                                                                              *
;********************************************************************************
;* ����Ȩ�� Copyright(C)ΰ�ɵ��� www.willar.com  All Rights Reserved            *
;* �������� �˳��������ѧϰ��ο���������ע����Ȩ��������Ϣ��                  *
;********************************************************************************


        IRCOM  EQU  20H       ;20H-23H IRʹ��
        X     EQU  26H        ;LCD ��ַ����

        IRIN   EQU  P3.2
        BEEP   EQU  P3.7
        RELAY  EQU  P1.3

        RS	EQU	P2.0
        RW	EQU	P2.1
        EN 	EQU	P2.2
        PSB	EQU	P2.3
        RST	EQU	P2.5
;------------------------------------------------
         ORG 0000H
         JMP  MAIN

         ORG 0003H         ;�ⲿ�ж�INT0��ڵ�ַ
         JMP  IR_IN        ;�жϷ������
;------------------------------------------------
MAIN:
          MOV   SP,#40H
          MOV   A,#00H
          MOV   R0,#20H
LOOP0:    MOV   @R0,A          ;20H-26H����
          INC   R0
          CJNE  R0,#27H,LOOP0
          MOV  IE,#81H       ;�������ж��ж�,ʹ�� INT0 �ⲿ�ж�
          MOV  TCON,#01H     ;������ʽΪ���帺���ش���
          SETB  IRIN
          SETB	RST
	  NOP
	  SETB	PSB            ;8λ���ݣ�����

          CALL  SET_LCD        ;��ʼ��TS12864A-3
          CALL  MENU1
          CALL  MENU2
          CALL  MENU3
          CALL  MENU4
LOOP1:
          MOV  A,22H
          CJNE  A,#40H,LOOP2    ;K17������
          CLR   RELAY           ;�̵�������
LOOP2:    CJNE  A,#04H,LOOP3    ;K19������
          SETB  RELAY           ;�̵����ر�
LOOP3:    JMP   LOOP1

;=============================================
;  LCD ��ʼ������
;=============================================-
SET_LCD:
          CLR  EN
          MOV  A,#34H     ;34H--����ָ�����
          CALL  WCOM
          CALL  DELAY1
          MOV  A,#30H     ;30H--����ָ�����
          CALL  WCOM
          CALL  DELAY1

          MOV  A,#0CH     ;����ʾ���ع�꣬
          CALL  WCOM
          CALL  DELAY1
          MOV  A,#01H     ;��� LCM ��ʾ��
          CALL  WCOM
          CALL  DELAY1
          RET
;===================================================
;�� LCM ������ʾ��Ϣ�ַ�
;===================================================
LCD_SHOW:

          CJNE  A,#1,LINE2  ;�ж��Ƿ�Ϊ��һ��
  LINE1:  MOV  A,#80H       ;���� LCD �ĵ�һ�е�ַ
          CALL  WCOM        ;д������
          CALL  CLR_LINE    ;��������ַ�����
          MOV  A,#80H       ;���� LCD �ĵ�һ�е�ַ
          CALL  WCOM        ;д������
          JMP  FILL

  LINE2:  CJNE  A,#2,LINE3  ;�ж��Ƿ�Ϊ������
          MOV  A,#090H      ;���� LCD �ĵ����е�ַ
          CALL  WCOM        ;д������
          CALL  CLR_LINE    ;��������ַ�����
          MOV  A,#090H      ;���� LCD �ĵ����е�ַ
          CALL  WCOM
          JMP  FILL

  LINE3:  CJNE  A,#3,LINE4  ;�ж��Ƿ�Ϊ������
          MOV  A,#088H      ;���� LCD �ĵ����е�ַ
          CALL  WCOM        ;д������
          CALL  CLR_LINE    ;��������ַ�����
          MOV  A,#088H      ;���� LCD �ĵ����е�ַ
          CALL  WCOM
          JMP  FILL

  LINE4:  CJNE  A,#4,LINE5  ;�ж��Ƿ�Ϊ������
          MOV  A,#098H      ;���� LCD �ĵ����е�ַ
          CALL  WCOM        ;д������
          CALL  CLR_LINE    ;��������ַ�����
          MOV  A,#098H      ;���� LCD �ĵ����е�ַ
          CALL  WCOM

  FILL:   CLR  A            ;�����ַ�
          MOVC  A,@A+DPTR   ;����Ϣ��ȡ���ַ�
          CJNE  A,#0,LC1    ;�ж��Ƿ�Ϊ������
  LINE5:  RET
  LC1:    CALL  WDATA       ;д������
          INC  DPTR         ;ָ���1
          JMP  FILL         ;���������ַ�
          RET
;=================================================
;������� LCM ���ַ�
;=================================================
CLR_LINE:
          MOV  R0,#16      ;
   CL1:   MOV  A,#' '
          CALL  WDATA
          DJNZ  R0,CL1
          RET
;==================================================
;LCM ��ʾ�����˵���Ϣ
;==================================================
MENU1:
         MOV   DPTR,#MENU1A
         MOV   A,#1         ;�ڵ�һ����ʾ��Ϣ
         CALL  LCD_SHOW
         RET
MENU1A:  DB  "����ң�����ȡ��",0

MENU2:
         MOV   DPTR,#MENU2A
         MOV   A,#2         ;�ڵڶ�����ʾ��Ϣ
         CALL  LCD_SHOW
         RET
MENU2A:  DB  "--www.willar.com",0

MENU3:
         MOV   DPTR,#MENU3A
         MOV   A,#3         ;�ڵ�������ʾ��Ϣ
         CALL  LCD_SHOW
         RET
MENU3A:  DB  "��ֵ���룺- - H",0

MENU4:
         MOV   DPTR,#MENU4A
         MOV   A,#4         ;�ڵ�������ʾ��Ϣ
         CALL  LCD_SHOW
         RET
MENU4A:  DB  "��ֵ���룺- - H",0

;==============================================
; дָ��ʹ���ӳ���
;RS=L,RW=L,D0-D7=ָ���룬E=������
;==============================================
WCOM:
          MOV  P0,A
          CLR RS
          CLR RW
          SETB EN
          CALL  DELAY0
          CLR EN
          RET
;=============================================
;д����ʹ���ӳ���
;RS=H,RW=L,D0-D7=���ݣ�E=������
;=============================================
WDATA:
          MOV   P0,A
          SETB  RS
          CLR   RW
          SETB  EN
          CALL  DELAY0
          CLR   EN
          RET

DELAY0:   MOV  R7,#250      ;��ʱ500΢��
          DJNZ  R7,$
          RET
;===============================================
;�� LCM �����С���������ʾ�ַ�
;A=ASC DATA, B=LINE X POS
;===============================================
LCDP3:                    ;��LCD�ĵ�������ʾ�ַ�
         PUSH  ACC        ;
         MOV  A,B         ;������ʾ��ַ
         ADD  A,#088H     ;����LCD�ĵ����е�ַ
         CALL  WCOM       ;д������
         POP  ACC         ;�ɶ�ջȡ��A
         CALL  WDATA      ;д������
         RET

LCDP4:                    ;��LCD�ĵ�������ʾ�ַ�
         PUSH  ACC        ;
         MOV  A,B         ;������ʾ��ַ
         ADD  A,#098H     ;����LCD�ĵ����е�ַ
         CALL  WCOM       ;д������
         POP  ACC         ;�ɶ�ջȡ��A
         CALL  WDATA      ;д������
         RET
;=================================================
; IR �����ӳ���
;�жϷ������
;=================================================
IR_IN:
          CLR EA         ;��ʱ�ر�CPU�������ж�����
          PUSH  ACC
          PUSH  PSW
          SETB  PSW.3     ;ѡ�����Ĵ�����1
          CLR   PSW.4

          MOV   R0,#IRCOM
          MOV  R1,#04H
I1:       JNB  IRIN,I2       ;�ȴ� IR �źų���
          LCALL CONV
          DJNZ  R1,I1
          JMP  IR_OUT
 I2:      MOV  R4,#20
 I20:     CALL  DEL
          DJNZ  R4,I20
          JB  IRIN,I1        ;ȷ��IR�źų���
 I21:     JB  IRIN,I3        ;�� IR ��Ϊ�ߵ�ƽ
          CALL  DEL
          JMP  I21
 I3:      MOV  R3,#0         ;8λ����Ϊ0
 LL:      JNB  IRIN,I4       ;�� IR ��Ϊ�͵�ƽ
          CALL  DEL
          JMP  LL
 I4:      JB  IRIN,I5        ;�� IR ��Ϊ�ߵ�ƽ
          CALL  DEL
          JMP  I4
 I5:      MOV  R2,#0         ;0.14ms ����
 L1:      CALL  DEL
          JB  IRIN, N1       ;�� IR ��Ϊ�ߵ�ƽ
                             ;IR=0�����R2�еļ���ֵ
          MOV  A,#8
          CLR  C
          SUBB  A,R2         ;�жϸߵ�λ
                             ;IF C=0  BIT=0
          MOV  A,@R0
          RRC  A
          MOV  @R0,A         ;������һλ
          INC  R3
          CJNE  R3,#8,LL     ;�账����8λ
          MOV  R3,#0
          INC  R0
          CJNE  R0,#24H,LL   ;�ռ���4�ֽ���
          JMP   IR_SHOW
 N1:      INC  R2
          CJNE  R2,#30,L1    ;0.14ms ����������ʱ�䵽�Զ��뿪

IR_OUT:   POP  PSW
          POP  ACC
          SETB  EA
          RETI

;------------------------------------------------------------------
IR_SHOW:
          MOV A,22H
          CPL A                ;��22Hȡ�����23H�Ƚ�
          CJNE A,23H,IR_SHOW1  ;������ȱ�ʾ�������ݷ�������,������
          CALL   CONV
          CALL  BEEP_BL        ;�����������ʾ����ɹ�
IR_SHOW1:
          JMP  IR_OUT
;===============================================
;����ת��Ϊ ASCII �벢��ʾ
;===============================================
CONV:
          MOV   X,#5        ;������ʾ��ʼλ��
          MOV   A,22H
          ANL   A,#0F0H      ;ȡ������λ��������
          SWAP  A            ;����λ�����λ����
          PUSH  ACC          ;ѹ���ջ
          CLR   C            ;C=0
          SUBB  A,#0AH       ;��10
          POP   ACC          ;������ջ
          JC    ASCII0       ;����С��10��תASCII0
          ADD   A,#07H       ;����10��������37H
ASCII0:   ADD   A,#30H       ;С��10��������30H
          MOV   B,X
          CALL  LCDP3

          MOV   A,22H
          ANL   A,#0FH        ;ȡ������λ��������
          PUSH  ACC
          CLR   C
          SUBB  A,#0AH        ;��10
          POP   ACC
          JC    ASCII1        ;����С��10��תASCII0
          ADD   A,#07H        ;����10��������37H
ASCII1:   ADD   A,#30H        ;С��10��������30H
          INC   X
          MOV   B,X
          CALL  LCDP3

          MOV   X,#5         ;������ʾ��ʼλ��
          MOV   A,23H        ;����
          ANL   A,#0F0H      ;ȡ������λ��������
          SWAP  A            ;����λ�����λ����
          PUSH  ACC          ;ѹ���ջ
          CLR   C            ;C=0
          SUBB  A,#0AH       ;��10
          POP   ACC          ;������ջ
          JC    ASCII2       ;����С��10��תASCII0
          ADD   A,#07H       ;����10��������37H
ASCII2:   ADD   A,#30H       ;С��10��������30H
          MOV   B,X
          CALL  LCDP4

          MOV   A,23H
          ANL   A,#0FH        ;ȡ������λ��������
          PUSH  ACC
          CLR   C
          SUBB  A,#0AH        ;��10
          POP   ACC
          JC    ASCII3        ;����С��10��תASCII0
          ADD   A,#07H        ;����10��������37H
ASCII3:   ADD   A,#30H        ;С��10��������30H
          INC   X
          MOV   B,X
          CALL  LCDP4
          RET
;===================================================
;��������һ���ӳ���
;===================================================
BEEP_BL:
         MOV  R6,#100
  BL1:   CALL  DEX1
         CPL  BEEP
         DJNZ  R6,BL1
         MOV  R5,#25
         CALL  DELAY
         RET
 DEX1:   MOV  R7,#180
 DEX2:   NOP
         DJNZ  R7,DEX2
         RET
 DELAY:                    ;��ʱR5��10MS
         MOV  R6,#50
  D1:    MOV  R7,#100
         DJNZ  R7,$
         DJNZ  R6,D1
         DJNZ  R5,DELAY
         RET
;===============================================
; DELAY  R5*0.14MS
DEL:
          MOV  R5,#1       ;IR����ʹ��
DEL0:     MOV  R6,#2
DEL1:     MOV  R7,#32
DEL2:     DJNZ  R7,DEL2
          DJNZ  R6,DEL1
          DJNZ  R5,DEL0
          RET

DELAY1:                    ;��ʱ5MS
         MOV  R6,#25
  DL2:   MOV  R7,#100
         DJNZ  R7,$
         DJNZ  R6,DL2
         RET
;================================================
        END
