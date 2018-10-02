
;*******************************************************************
;*               ME300B��Ƭ������ϵͳ��ʾ����                      *
;*                                                                 *
;* ����ң��ʽ�򵥼�������ʾ����                                    *
;* �ú���ң���������루������ʽң������                            *
;*                                                                 *
;* LCD1602��ʾ��ʽ��                                               *
;* LCD��һ����ʾ��CALCULATOR                                       *
;* LCD�ڶ�����ʾ���������                                         *
;*                                                                 *
;* ��Ҫ���ܣ�                                                      *
;* 0��99��λ��֮��ļӡ������ˡ�����������                         *
;*                                                                 *
;* ���䣺gguoqing@willar.com                                       *
;* ��վ��http://www.willar.com                                     *
;* ���ߣ�gguoqing                                                  *
;*                                                                 *
;* ����ʱ�䣺 2005/07/10                                           *
;* �޸�ʱ�䣺 2006/02/03                                           *
;*                                                                 *
;*����Ȩ��COPYRIGHT(C)ΰ�ɵ��� www.willar.com ALL RIGHTS RESERVED  *
;*���������˳��������ѧϰ��ο���������ע����Ȩ��������Ϣ��       *
;*                                                                 *
;*******************************************************************

;K1Ϊ�����
;���ּ�:0,1,2,3,4,5,6,7,8,9
;���ܼ�:+,-,*,/,=

;��������������������������������������������������������������
           RELAY   EQU  P1.3
           BEEP    EQU  P3.7
           IRIN    EQU  P3.2
;��������������������������������������������������������������
           LCD_RS  EQU  P2.0
           LCD_RW  EQU  P2.1
           LCD_EN  EQU  P2.2
           LCD_X   EQU  3FH       ;LCD ��ַ����
;��������������������������������������������������������������
           TEMP1   EQU  30H       ;��ʱ�ݴ���
           TEMP2   EQU  31H
           TEMP3   EQU  32H
           TEMP4   EQU  33H

           RES_H   EQU  27H       ;���뱻�ӣ������ˡ�������
           RES_L   EQU  28H       ;����ӣ������ˡ�������

           OUT_H   EQU  29H       ;��������λ
           OUT_L   EQU  2AH       ;��������λ

           IRCOM   EQU  22H       ;22H-25H IRʹ��

;��������������������������������������������������������������
           ORG  0000H
           JMP  MAIN
           ORG  0030H
;��������������������������������������������������������������
MAIN:      MOV  SP,#60H
           MOV  R1,#00H
           MOV  TEMP1,#00H
           MOV  TEMP2,#00H
           MOV  TEMP3,#00H
           MOV  RES_L,#00H
           MOV  RES_H,#00H
           MOV  OUT_H,#00H
           MOV  OUT_L,#00H
           MOV  20H,#00H
           CALL  SET_LCD

MAIN1:     CALL  IR_IN             ;����9������Ч
           JNB  20H.0,MAIN1
           SUBB  A,#0AH
           JNC  MAIN1              ;C=0���޽�λ
           MOV  A,R3               ;��װ��ֵ
           JMP  LOOP_0
LOOP:
           CALL  IR_IN              ;�ͱ����ӡ������ˡ�������
           JNB  20H.0,LOOP          ;�����
LOOP_0:
           INC  R1
           CJNE  R1,#01H,LOOP_1
           MOV  TEMP2,A             ;��λ
           MOV  LCD_X,#2
           CALL  CONV0

LOOP_1:    CJNE  R1,#02H,LOOP
           SUBB  A,#0AH             ;���Ƿ��ǹ��ܼ���
           JNC  LOOP_2              ;�ǣ�תLOOP_2
           MOV  TEMP1,TEMP2
           MOV  A,TEMP1
           MOV  LCD_X,#1
           CALL  CONV0
           MOV  A,R3                ;�ָ���Ч��ֵ
           MOV  TEMP2,A             ;��λ
           MOV  LCD_X,#2
           CALL  CONV0
           MOV  A,TEMP1
           ANL  A,#0FH
           SWAP  A
           ORL  A,TEMP2
           MOV  RES_H,A
           JMP  LOOP0
LOOP_2:
           MOV  RES_H,TEMP2
           AJMP  LOOP0A

LOOP0:     CALL  IR_IN
           JNB  20H.0,LOOP0

LOOP0A:    MOV  A,R3                 ;��װ��ֵ
           CJNE  A,#0AH,LOOP1        ;������
           CALL  CONV1
           SETB  20H.1               ;��������
           AJMP  LOOP5
LOOP1:     CJNE  A,#0BH,LOOP2        ;������
           CALL  CONV2
           SETB  20H.2               ;��������
           AJMP  LOOP5
LOOP2:     CJNE  A,#0CH,LOOP3        ;������
           CALL  CONV3
           SETB  20H.3               ;��������
           AJMP  LOOP5
LOOP3:     CJNE  A,#0DH,LOOP4        ;������
           CALL  CONV4
           SETB  20H.4               ;��������
           AJMP  LOOP5
LOOP4:     CJNE  A,#0FH,LOOP4A
           AJMP  MAIN

LOOP4A:    AJMP  LOOP0

LOOP5:     MOV  R1,#00H
           MOV  TEMP1,#00H
           MOV  TEMP2,#00H
           CLR  20H.0                ;�ͣ��ӡ������ˡ�������

LOOP5A:    CALL  IR_IN
           JNB  20H.0,LOOP5A
           ;CALL  BEEP_BL

           CJNE  A,#0FH,LOOP5B
           AJMP  MAIN

LOOP5B:    INC  R1
           CJNE  R1,#01H,LOOP5C
           MOV  TEMP2,A
           MOV  LCD_X,#6
           CALL  CONV0

LOOP5C:    CJNE  R1,#02H,LOOP5A
           SUBB  A,#0AH             ;���Ƿ��ǹ��ܼ���
           JNC  LOOP5D              ;�ǣ�תLOOP5C
           MOV  TEMP1,TEMP2
           MOV  A,TEMP1
           MOV  LCD_X,#6
           CALL  CONV0
           MOV  A,R3
           MOV  TEMP2,A
           MOV  LCD_X,#7
           CALL  CONV0
           MOV  A,TEMP1
           ANL  A,#0FH
           SWAP  A
           ORL  A,TEMP2
           MOV  RES_L,A
           JMP  LOOP6

LOOP5D:    MOV  RES_L,TEMP2
           JMP  LOOP6A

LOOP6:     CALL  IR_IN
LOOP6A:    MOV  A,R3                ;��װ��ֵ
           CJNE  A,#0FH,LOOP6B
           AJMP  MAIN
LOOP6B:    CJNE  A,#0EH,LOOP6       ;��ʾ��=��
           CALL  CONV5              ;��ʾ������
           ;CALL  BEEP_BL            
           JNB  20H.1,LOOP6C
           CALL  SUADD
LOOP6C:    JNB  20H.2,LOOP6D
           CALL  SUSUB
LOOP6D:    JNB  20H.3,LOOP6E
           CALL  SUMUL
LOOP6E:    JNB  20H.4,LOOP7
           CALL  SUDIV

LOOP7:     CALL  IR_IN
           CJNE  A,#0FH,LOOP7        ;��λ�����㣩
           AJMP  MAIN
;---------------------------------------------------
; IR �����ӳ���
;���ڣ�A��R3���ֵ
;---------------------------------------------------
IR_IN:
          MOV   R0,#IRCOM
 I1:      JNB  IRIN,I2       ;�ȴ� IR �źų���
          JMP  I1
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
 I5:      MOV  R2,#0         ;0.14MS ����
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
          CJNE  R0,#IRCOM+4,LL   ;�ռ���4�ֽ���
          ;JMP  OK
          JMP   IR_SHOW
 N1:      INC  R2
          CJNE  R2,#30,L1    ;0.14MS ����������ʱ�䵽�Զ��뿪
 OK:      RET
;--------------------------------------------------------------------
IR_SHOW:
           MOV A,IRCOM+3
           CPL A                    ;��25Hȡ�����24H�Ƚ�
           CJNE A,IRCOM+2,IR_SHOW1  ;������ȱ�ʾ�������ݷ�������,������
           SETB  20H.0              ;����ɹ�20H.0��1��
           MOV  A,IRCOM+2
           MOV  B,A
           MOV  DPTR,#IR_TABLE_NEW
           MOV  R3,#0FFH
IR_IN1:    INC  R3
           MOV  A,R3
           MOVC  A,@A+DPTR
           CJNE  A,B,IR_IN2
           MOV  A,R3                ;�ҵ���ȡ˳����
           CALL  BEEP_BL            ;�����������ʾ����ɹ�
           RET
IR_IN2:    CJNE  A,#0FFH,IR_IN1  ;ĩ�꣬������
IR_SHOW1:  RET
;---------------------------------------------------------
;����ң������ֵ��
;---------------------------------------------------------
IR_TABLE_NEW:
     DB   40H,48H,04H,00H,02H,05H,54H,4DH,0AH,1EH
     DB   09H,1FH,17H,16H,4CH,10H,0FFH
;IR_TABLE:
;    DB   1BH,10H,03H,01H,06H,09H,1DH,1FH,0DH,19H
;    DB   1CH,14H,0FH,0CH,40H,04H,0FFH
;---------------------------------------------------------
; DELAY  R5*0.14MS
DEL:
          MOV  R5,#1       ;IR����ʹ��
DEL0:     MOV  R6,#2
DEL1:     MOV  R7,#32
DEL2:     DJNZ  R7,DEL2
          DJNZ  R6,DEL1
          DJNZ  R5,DEL0
          RET
;������������������������������������������������
;�ӷ������ӳ���
;��ڣ�R0-������,R1-����
;���ڣ�R4(��)��R2(��)Ϊ��ֵ
;������������������������������������������������
SUADD:     
           MOV  R1,RES_L
           MOV  R0,RES_H

           MOV  A,R0
           ADD  A,R1
           DA  A
           MOV  R2,A
           CLR  A
           ADDC  A,#00H
           MOV  R4,A
           MOV  OUT_H,R4
           MOV  OUT_L,R2
           CALL T_CONV
           RET
;������������������������������������������������
;���������ӳ���
;��ڣ�R0-������,R1-����
;���ڣ�R2����ֵ
;������������������������������������������������
SUSUB:
          MOV  R1,RES_L
          MOV  R0,RES_H
          CLR  C
          MOV  A,#9AH
          SUBB  A,R1       ;����ʮ������
          ADD  A,R0
          DA  A
          MOV  R2,A        ;��ֵ��R2
          JC  POSI         ;C=1����ʾ��ֵΪ��
 NEGA:    MOV  A,#9AH      ;��ֵΪ�����󲹺�ò�ֵ�ľ���ֵ
          SUBB  A,R2
          MOV  R2,A
          SETB  20H.5      ;��ʾ���ű��
 POSI:    MOV  OUT_H,#00H
          MOV  OUT_L,R2
          CALL  T_CONV
          RET
;��������������������������������������������������
;�˷������ӳ���
;���ֽ�BCD��˷��ӳ���
;���: R0(������)��R1(������
;����: R3(��)��R2(��)����Ϊ˫�ֽڣ�BCD����ʽ�Ļ�
;�ӳ�����λ��ʼ����BCD����λ�˷�
;��������������������������������������������������
SUMUL:
            MOV  R1,RES_L
            MOV  R0,RES_H
BCDMUL:
            CLR  A             ;����Ԫ����
            MOV  R2,A
            MOV  R3,A
            MOV  A,R1
            JZ  RETURN
            ANL  A,#0F0H        ;ȡ������λ
            JZ  LBCD            ;������λ�Ƿ�Ϊ0��
            SWAP  A
            MOV  R4,A
            ACALL  DDBCDM
            SWAP  A             ;BCD������һλ
            MOV  R3,A
            MOV  A,R2
            SWAP  A
            MOV  R2,A
            ANL  A,#0FH
            ORL  A,R3
            MOV  R3,A
            MOV  A,R2
            ANL  A,#0F0H
            MOV  R2,A
 LBCD:      MOV  A,R1            ;ȡ������λ
            ANL  A,#0FH
            JZ  RETURN           ;������λ�Ƿ�Ϊ0��
            MOV  R4,A
            ACALL  DDBCDM
RETURN:     MOV  OUT_H,R3
            MOV  OUT_L,R2
            CALL T_CONV
            RET

DDBCDM:                          ;һλBCD��˷�
            MOV  A,R2
            ADD  A,R0
            DA  A
            MOV  R2,A
            MOV  A,R3
            ADDC  A,#00H
            DA  A
            MOV  R3,A
            DJNZ  R4,DDBCDM
            RET
;------------------------------------------------
;���������ӳ���

;���ֽ�BCD�����
;��ڣ�R0(������)��R1(�������)
;���ڣ�R2(��)��R3(����)
;��MCS-51ϵ�е�Ƭ��ʵ���ӳ��򼯽���PAGE 73
;-----------------------------------------------
SUDIV:
              MOV  R1,RES_L
              MOV  R0,RES_H
BCDDIV:
              MOV  R2,#00H      ;�̵�Ԫ����
              MOV  A,R1         ;������
              CPL  A
              ADD  A,#9BH
              MOV  R1,A
              MOV  A,R0          ;��������λ����
              ANL  A,#0F0H       ;�����൥Ԫ
              SWAP  A
   LP0:       MOV  R3,A          ;������
              ADD  A,R1
              DA  A
              JNC  LP1           ;��������>=������
              INC  R2            ;�̼�1
              SJMP  LP0
   LP1:       MOV  A,R3          ;
              SWAP  A
              MOV  R3,A
              MOV  A,R2          ;������һλ
              SWAP  A
              MOV  R2,A
              MOV  A,R0           ;��λ
              ANL  A,#0FH
              ORL  A,R3
  LP2:        MOV  R3,A           ;������
              ADD  A,R1
              DA  A
              JNC  LP3
              INC  R2             ;�̼�1
              SJMP  LP2
  LP3:        MOV  A,R3           ;��������
              ADD  A,R3
              DA  A
              JC  LP4
              ADD  A,R1
              DA  A
              JNC  RETURN1
  LP4:        MOV  A,R2
              ADDC  A,#00H
              DA  A
              MOV  R2,A
 RETURN1:     MOV  OUT_H,#00H
              MOV  OUT_L,R2
              CALL T_CONV
              RET
;-----------------------------------------------------
;  LCD ��ʼ������
;-----------------------------------------------------
SET_LCD:
          CLR  LCD_EN
          CALL  INIT_LCD     ;��ʼ�� LCD
          CALL  DELAY1
          MOV  DPTR,#INFO1   ;ָ��ָ����ʾ��Ϣ1
          MOV  A,#1          ;��ʾ�ڵ�һ��
          CALL  LCD_SHOW
          MOV  DPTR,#INFO2   ;ָ��ָ����ʾ��Ϣ2
          MOV  A,#2          ;��ʾ�ڵڶ���
          CALL  LCD_SHOW
          RET
;-----------------------------------------------------
INFO1:  DB  "   CALCULATOR   ",0  ;LCD ��һ����ʾ��Ϣ
INFO2:  DB  "                ",0  ;LCD �ڶ�����ʾ��Ϣ
;----------------------------------------------------
INIT_LCD:                 ;8λI/O���� LCD �ӿڳ�ʼ��
          MOV  A,#38H     ;˫����ʾ������5*7����
          CALL  WCOM
          CALL  DELAY1
          MOV  A,#38H     ;˫����ʾ������5*7����
          CALL  WCOM
          CALL  DELAY1
          MOV  A,#38H     ;˫����ʾ������5*7����
          CALL  WCOM
          CALL  DELAY1
          MOV  A,#0CH     ;����ʾ���ع�꣬
          CALL  WCOM
          CALL  DELAY1
          MOV  A,#01H     ;��� LCD ��ʾ��
          CALL  WCOM
          CALL  DELAY1
          RET
;----------------------------------------------------
LCD_SHOW:       ;��LCD�ĵ�һ�л�ڶ�����ʾ��Ϣ�ַ�

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
;---------------------------------------------------
CLR_LINE:                  ;������� LCD ���ַ�
          MOV  R0,#24
   CL1:   MOV  A,#' '
          CALL  WDATA
          DJNZ  R0,CL1
          RET
;-----------------------------------------------------
; дָ���ӳ���
;RS=L,RW=L,D0-D7=ָ���룬E=������
;-----------------------------------------------------
WCOM:
          MOV   P0,A
          CLR   LCD_RS
          CLR   LCD_RW
          SETB  LCD_EN
          CALL  DELAY0
          CLR   LCD_EN
          RET
;-----------------------------------------------------
;д�����ӳ���
;RS=H,RW=L,D0-D7=���ݣ�E=������
;-----------------------------------------------------
WDATA:
          MOV   P0,A
          SETB  LCD_RS
          CLR   LCD_RW
          SETB  LCD_EN
          CALL  DELAY0
          CLR   LCD_EN
          RET
;-----------------------------------------------------
;��ʱ250΢��
;-----------------------------------------------------
DELAY0:
          MOV   R7,#125
          DJNZ  R7,$
          RET
;---------------------------------------------------
;�� LCD �ڶ�����ʾ�ַ�
;A=ASC DATA, B=LINE X POS
;---------------------------------------------------
LCDP2:
         PUSH  ACC        ;
         MOV  A,B         ;������ʾ��ַ
         ADD  A,#0C0H     ;����LCD�ĵڶ��е�ַ
         CALL  WCOM       ;д������
         POP  ACC         ;�ɶ�ջȡ��A
         CALL  WDATA      ;д������
         RET

;������������������������������������������������
;��ָ��λ����ʾ��������������ӳ���
;������������������������������������������������
CONV0:
          ADD A,#30H
          MOV  B,LCD_X
          CALL  LCDP2
          RET
CONV1:
          MOV  LCD_X,#4
          MOV  A,#2BH        ;+
          MOV  B,LCD_X
          CALL  LCDP2
          RET

CONV2:
          MOV  LCD_X,#4
          MOV  A,#2DH        ;-
          MOV  B,LCD_X
          CALL  LCDP2
          RET
CONV3:
          MOV  LCD_X,#4
          MOV  A,#2AH        ;*
          MOV  B,LCD_X
          CALL  LCDP2
          RET
CONV4:
          MOV  LCD_X,#4
          MOV  A,#2FH        ;/
          MOV  B,LCD_X
          CALL  LCDP2
          RET
CONV5:
          MOV  LCD_X,#09H
          MOV  A,#3DH        ;=
          MOV  B,LCD_X
          CALL  LCDP2
          RET
;����������������������������������������������������
;
;����������������������������������������������������
CONV:
          MOV   LCD_X,#3        ;������ʾ��ʼλ��
          MOV   A,R3
          ANL   A,#0FH      ;ȡ������λ��������
          PUSH  ACC          ;ѹ���ջ
          CLR   C            ;C=0
          SUBB  A,#0AH       ;��10
          POP   ACC          ;������ջ
          JC    ASCII0       ;����С��10��תASCII0
          ;JMP  ASCII1
          ADD   A,#07H       ;����10��������37H
ASCII0:   ADD   A,#30H       ;С��10��������30H
          MOV   B,LCD_X
          CALL  LCDP2
ASCII1:   ;MOV  A,R3
          RET

;-------------------------------------------------------
T_CONV:

          MOV   A,OUT_H          ;ȡ��λ��
          MOV  LCD_X,#11
          CJNE  A,#00H,T_CONV1   ;�и�λ���Ƿ�Ϊ0��
          SETB  20H.6            ;Ϊ0��20H.6��1
          JMP  T_CONV3           ;תȡ��λ��
                                 ;��λ����Ϊ0����
T_CONV1:  ANL A,#0F0H            ;�и�λ���ĸ���λ�Ƿ�Ϊ0��
          CJNE  A,#00H,T_CONV2   ;��Ϊ0��2λ������ʾ
          SETB  20H.6            ;Ϊ0��20H.6��1��ֻ��ʾ����λ
T_CONV2:  MOV  A,OUT_H
          CALL  SHOW_DIG2
          INC  LCD_X
          CLR  20H.6             ;����ʾ���λ

T_CONV3:  MOV  A,OUT_L           ;ȡ��λ��
          JNB  20H.6,T_CONV5     ;��λ������ʾ�����е�λ����
          ANL  A,#0F0H           ;��λ������ʾ�����е�λ����
          CJNE  A,#00H,T_CONV4   ;�е�λ���ĸ���λ�Ƿ�Ϊ0��
          SETB  20H.6            ;Ϊ0��20H.6��1��ֻ��ʾ����λ
          MOV  A,OUT_L
          JMP  T_CONV5
T_CONV4:  CLR  20H.6             ;��λ����Ϊ0��2λ������ʾ
          MOV  A,OUT_L

T_CONV5:  CALL  SHOW_DIG2
          CLR  20H.6             ;����ʾ���λ
          RET
;��������������������������������������������������������
;�� LCD �ĵڶ�����ʾ���������
;��������������������������������������������������������
SHOW_DIG2:
          JNB  20H.5,DIG2    ;���ű��
          MOV  TEMP3,A
          MOV  A,#2DH        ;��ʾ����
          MOV  B,LCD_X
          CALL  LCDP2
          MOV  A,TEMP3
          INC  LCD_X
 DIG2:    MOV  B,#16         ;���ñ�����
          DIV  AB            ;���A��������B������
          JNB  20H.6,DIG3    ;��ʾλ���
          MOV  A,#20H
          JMP  DIG4
DIG3:     ADD  A,#30H        ;AΪʮλ����ת��Ϊ�ַ�
DIG4:     PUSH  B            ;B�����ջ�ݴ�
          MOV  B,LCD_X           ;���� LCD ��ʾ��λ��
          CALL  LCDP2        ;�� LCD ��ʾ����
          POP  B             ;
          MOV  A,B           ;BΪ��λ��
          ADD  A,#30H        ;ת��Ϊ�ַ�
          INC  LCD_X             ;LCD ��ʾλ�ü�1
          MOV  B,LCD_X           ;���� LCD ��ʾ��λ��
          CALL  LCDP2        ;�� LCD ��ʾ����
          RET
;--------------------------------------------------------
;��������һ���ӳ���
;--------------------------------------------------------
BEEP_BL:
         MOV  R6,#100
  BL1:   CALL  DEX1
         CPL  BEEP
         DJNZ  R6,BL1
         MOV  R5,#10
         CALL  DELAY
         RET
 DEX1:   MOV  R7,#180
 DEX2:   NOP
         DJNZ  R7,DEX2
         RET
;-----------------------------------------------------
;��ʱR5��10MS
;-----------------------------------------------------
DELAY:
         MOV  R6,#50
  D1:    MOV  R7,#100
         DJNZ  R7,$
         DJNZ  R6,D1
         DJNZ  R5,DELAY
         RET
;-----------------------------------------------------
;��ʱ5MS
;-----------------------------------------------------
DELAY1:
         MOV  R6,#25
  D2:    MOV  R7,#100
         DJNZ  R7,$
         DJNZ  R6,D2
         RET
;-----------------------------------------------------
         END
