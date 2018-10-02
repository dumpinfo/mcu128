;********************************************************************************
;*  ����:  ME300ϵ�е�Ƭ������ϵͳ��ʾ���� - DS18B20�¶ȿ����������ʾ          *
;*  Ӳ���� ME300A+,ME300B                                                       *
;*  �ļ�:  DS18B20-DSY.asm                                                      *
;*  ����:  2005-3-20                                                            *
;*  �汾:  1.0                                                                  *
;*  ����:  gguoqing                                                             *
;*  ����:  gguoqing@willar.com                                                  *
;*  ��վ�� http://www.willar.com                                                *
;********************************************************************************
;*  ����:                                                                       *
;*          DS18B20�¶ȿ����������ʾ                                           *
;*        1��K3 �� �����趨�¶ȱ���ֵ TL ״̬:                                   *
;*           L����20                                                            *
;*        2��K3 �� �����趨�¶ȱ���ֵ TH ״̬:                                   *
;*           H����28                                                            *
;*        3��K3 �� ����                                                          *
;*        4���趨���̣� K1 ���Ӽ� ��UP���� K2 ������ ��DOWN�����ɿ��ٵ���         *
;********************************************************************************
;*  �������ã�                                                                  *
;*     ME300A+    JP1 ȫ���̽ӣ�JP2�̽�2-3��                                    *
;*     ME300B     JP1 �̽ӣ�JP2�̽�2-3�ˣ�JP4��P13��Ҫ�̽�                      *  
;*                                                                              *
;********************************************************************************
;* ����Ȩ�� Copyright(C)ΰ�ɵ��� www.willar.com  All Rights Reserved            *
;* �������� �˳��������ѧϰ��ο���������ע����Ȩ��������Ϣ��                  *
;********************************************************************************


          TIMER_L     DATA  23H
          TIMER_H     DATA  24H
          TIMER_COUN  DATA  25H

          TEMPL       DATA  26H
          TEMPH       DATA  27H
          TEMP_TH     DATA  28H
          TEMP_TL     DATA  29H

          TEMPHC      DATA  2AH
          TEMPLC      DATA  2BH
          TEMP_ZH     DATA  2CH

          BEEP        EQU   P3.7
          DATA_LINE   EQU   P3.3
          RELAY       EQU   P1.3

          FLAG1       EQU   20H.0
          FLAG2       EQU   20H.1

;-------------------------------------------------
          K1   EQU  P1.4
          K2   EQU  P1.5
          K3   EQU  P1.6
          K4   EQU  P1.7
;=================================================
          ORG 0000H
          JMP  MAIN

          ORG  000BH
          AJMP  INT_T0
;--------------------------------------------------
MAIN:     MOV SP,#30H
          MOV  TMOD,#01H        ;T0,��ʽ1
          MOV  TIMER_L,#00H     ;50ms��ʱֵ
          MOV  TIMER_H,#4CH
          MOV  TIMER_COUN,#00H  ;�жϼ���
          MOV  IE,#82H          ;EA=1,ET0=1
          LCALL  READ_E2
          ;LCALL  RE_18B20
          MOV  20H,#00H
          SETB   BEEP
          SETB   RELAY
          MOV  7FH,#0AH         ;Ϩ���

          CALL RESET            ;��λ����DS18B20
          JNB FLAG1,MAIN1       ;FLAG1=0��DS18B20������
          JMP  START

MAIN1:    CALL RESET
          JB FLAG1,START
          LCALL  BEEP_BL        ;DS18B20���󣬱���
          JMP  MAIN1
START:
          MOV A,#0CCH         ; ����ROMƥ��
          CALL WRITE
          MOV A,#044H         ; �����¶�ת������
          CALL WRITE

          CALL RESET
          MOV A,#0CCH         ; ����ROMƥ��
          CALL WRITE
          MOV A,#0BEH         ; �������¶�����
          CALL WRITE

          CALL  READ           ;���¶�����
          CALL  CONVTEMP
          CALL  DISPBCD
          CALL  DISP1
          CALL  SCANKEY
          LCALL  TEMP_COMP
          JMP   MAIN1

;=====================================================
;DS18B20 ��λ�����ӳ���
;FLAG1=1 OK, FLAG1=0 ERROR
;======================================================
RESET:
          SETB DATA_LINE
          NOP
          CLR DATA_LINE
          MOV R0,#64H            ;����������ʱ600΢��ĸ�λ������
          MOV R1,#03H
RESET1:   DJNZ R0,$
          MOV R0,#64H
          DJNZ R1,RESET1
          SETB DATA_LINE        ;Ȼ������������
          NOP
          MOV R0,#25H
RESET2:   JNB DATA_LINE,RESET3  ;�ȴ�DS18B20��Ӧ
          DJNZ R0,RESET2
          JMP RESET4            ; ��ʱ
RESET3:   SETB FLAG1            ; �ñ�־λ,��ʾDS1820����
          JMP RESET5
RESET4:   CLR FLAG1             ; ���־λ,��ʾDS1820������
          JMP RESET6
RESET5:   MOV R0,#064H
          DJNZ R0,$             ; ʱ��Ҫ����ʱһ��ʱ��
RESET6:   SETB DATA_LINE
          RET
;===========================================================
;
;===========================================================
WRITE:  MOV R2,#8            ;һ��8λ����
        CLR CY
WR1:
        CLR DATA_LINE        ;��ʼд��DS18B20����Ҫ���ڸ�λ���ͣ�״̬
        MOV R3,#09
        DJNZ R3,$            ;���߸�λ����18΢������
        RRC A                ;��һ���ֽ�DATA �ֳ�8��BIT���Ƹ�C
        MOV DATA_LINE,C      ;д��һ��BIT
        MOV R3,#23
        DJNZ R3,$            ;�ȴ�46΢��
        SETB DATA_LINE       ;�����ͷ�����
        NOP
        DJNZ R2,WR1          ;д����һ��BIT
        SETB DATA_LINE
        RET
;============================================================
;��DS18B20�ж����¶ȵ�λ����λ�ͱ���ֵTH��TL
;����26H��27H��28H��29H
;============================================================
READ:    MOV R4,#4            ; ���¶ȸ�λ�͵�λ��DS18B20�ж���
         MOV R1,#26H          ; ����26H��27H��28H��29H
RE00:    MOV R2,#8
RE01:    CLR C
         SETB DATA_LINE
         NOP
         NOP
         CLR DATA_LINE        ;��ǰ���߱���Ϊ��
         NOP
         NOP
         NOP
         SETB DATA_LINE       ;��ʼ�������ͷ�
         MOV R3,#09           ;��ʱ18΢��
         DJNZ R3,$
         MOV C,DATA_LINE      ;��DS18B20���߶���һ��BIT
         MOV R3,#23
         DJNZ R3,$            ;�ȴ�46΢��
         RRC A                ;�Ѷ��õ�λֵ���Ƹ�A
         DJNZ R2,RE01         ;����һ��BIT
         MOV @R1,A
         INC R1
         DJNZ R4,RE00
         RET        
;--------------------------------------------
;200ms���������ȡ��һ��
;--------------------------------------------
INT_T0:
          PUSH  ACC
          PUSH  PSW
          MOV  TL0,TIMER_L
          MOV  TH0,TIMER_H
          INC  TIMER_COUN
          MOV  A,TIMER_COUN
          CJNE  A,#04H,INT_END
          MOV  TIMER_COUN,#00H
          CPL  FLAG2
INT_END:
          POP  PSW
          POP  ACC
          RETI
;==========================================================
;���¶� DS18B20 ��ʼ��
;���趨���¶ȱ���ֵд�� DS18B20
;==========================================================
RE_18B20:
        JB  FLAG1,RE_18B20A
        RET
RE_18B20A:
        CALL  RESET
        MOV  A,#0CCH       ;����ROMƥ��
        LCALL  WRITE
        MOV  A,#4EH        ;д�ݴ�Ĵ���
        LCALL  WRITE
        MOV  A,TEMP_TH     ;TH(�������ޣ�
        LCALL  WRITE
        MOV  A,TEMP_TL     ;TL(�������ޣ�
        LCALL  WRITE
        MOV  A,#7FH        ;12λ��ȷ��
        LCALL  WRITE
        RET

;====================================================
;���ܼ�ɨ���ӳ���
;====================================================
SCANKEY:
              MOV  P1,#0F0H
              JB  K1,SCAN_K2
              CALL  BEEP_BL
SCAN_K1:      CALL  ALERT_TL
              CALL  ALERT_PLAY
              JB   K1,SCAN_K1
              CALL  BEEP_BL
SCAN_K11:     CALL  ALERT_TH
              CALL  ALERT_PLAY
              JB    K1,SCAN_K11
              CALL  BEEP_BL
SCAN_K2:      JB  K2,SCAN_K3
              CALL  BEEP_BL
SCAN_K3:      JB  K3,SCAN_K4
              CALL  BEEP_BL
              LCALL  RESET_ALERT
              LCALL  RE_18B20
              LCALL  WRITE_E2
SCAN_K4:      JB  K4,SCAN_END
              CALL  BEEP_BL
SCAN_END:     RET

;================================================
;�����¶ȱ���ֵ
;================================================
RESET_ALERT:
          CALL  ALERT_TL
          CALL  ALERT_PLAY
          JNB K3,$              ;K3Ϊλ�Ƽ�
          SETB  TR0
RESET_TL:
          CALL  ALERT_PLAY
          JNB  FLAG2,R_TL01
          mov  75H,7fh          ;����Ϩ���
          mov  76H,7fh
          CALL  ALERT_PLAY
          JMP   R_TL02
R_TL01:   CALL  ALERT_TL
          mov  75h,7Eh          ;���趨ֵ
          mov  76h,7Dh
          CALL  ALERT_PLAY      ;��ʾ�趨ֵ
R_TL02:   JNB  K1,K011A
          JNB  K2,K011B
          JNB  K3,RESET_TH
          JMP  RESET_TL
K011A:
          INC  TEMP_TL
          MOV  A,TEMP_TL
          CJNE  A,#120,K012A    ;û�е��趨����ֵ��ת
          MOV  TEMP_TL,#0
K012A:    CALL  TL_DEL
          JMP   RESET_TL
K011B:
          DEC  TEMP_TL
          MOV  A,TEMP_TL
          CJNE  A,#00H,K012B   ;û�е��趨����ֵ��ת
          MOV  TEMP_TL,#119
K012B:    CALL  TL_DEL
          JMP   RESET_TL
;-------------------------------------------------------
RESET_TH:
           CALL  BEEP_BL
           JNB  K3,$
RESET_TH1:
          CALL  ALERT_PLAY
          JNB  FLAG2,R_TH01
          mov  75H,7fh          ;����Ϩ���
          mov  76H,7fh
          CALL  ALERT_PLAY
          JMP   R_TH02
R_TH01:   CALL  ALERT_TH
          mov  75h,7Eh          ;
          mov  76h,7Dh
          CALL  ALERT_PLAY
R_TH02:   JNB  K1,K021A
          JNB  K2,K021B
          JNB  K3,K002
          JMP  RESET_TH1
K021A:
          INC  TEMP_TH
          MOV  A,TEMP_TH
          CJNE  A,#120,K022A   ;û�е��趨����ֵ��ת
          MOV  TEMP_TH,#0
K022A:     CALL  TH_DEL
          JMP   RESET_TH1

K021B:
          DEC  TEMP_TH         ;��1
          MOV  A,TEMP_TH
          CJNE  A,#00H,K022B   ;û�е��趨����ֵ��ת
          MOV  TEMP_TH,#119
K022B:    CALL  TH_DEL
          JMP   RESET_TH1

K002:     CALL  BEEP_BL
          CLR  TR0             ;�ر��ж�
          RET
;-----------------------------------------------------
;����ʱ�ӳ���
;��ε��ñ���ֵ��ʾ��������ʱ
;-----------------------------------------------------
TL_DEL:                        ;������ֵ��ʱ
          MOV  R2,#0AH
TL_DEL1:  CALL  ALERT_TL
          CALL  ALERT_PLAY
          DJNZ  R2,TL_DEL1
          RET
TH_DEL:                        ;������ֵ��ʱ
          MOV  R2,#0AH
TH_DEL1:  CALL  ALERT_TH
          CALL  ALERT_PLAY
          DJNZ  R2,TH_DEL1
          RET
;====================================================
;ʵʱ�¶�ֵ���趨�����¶�ֵ TH��TL �Ƚ��ӳ���
;��ʵ���¶ȴ��� TH ���趨ֵʱ����ʾ��H�����̵����رա�
;��ʵ���¶�С�� TH ���趨ֵʱ����ʾ��O�����̵������ϡ�
;��ʵ���¶�С�� TL ���趨ֵʱ����ʾ��L����
;������ʾ��Ƿ� H��L��O
;====================================================
TEMP_COMP:
          SETB  TR0             ;�����ж�
          MOV  A,TEMP_TH
          SUBB  A,TEMP_ZH       ;����>����������
          JC  CHULI1            ;��λ��־λC=1��ת
          MOV  A,TEMP_ZH
          SUBB  A,TEMP_TL       ;����>����������
          JC  CHULI2            ;��λ��־λC=1��ת
          JNB  FLAG2,T_COMP1    ;FLAG2=0,��ʾ����ַ�
          MOV  74H,#0AH         ;Ϩ���
          LCALL  DISP1
          JMP  T_COMP2
T_COMP1:  MOV  74H,#00H
          LCALL  DISP1          ;��ʾ"O"
T_COMP2:  CLR   RELAY           ;�̵�������
          CLR  TR0              ;�ر��ж�
          RET
;---------------------------------------------
;���´���
;---------------------------------------------
CHULI1:
          SETB  RELAY           ;�̵����ر�
          JNB  FLAG2,CHULI10
          MOV  74H,#0AH         ;Ϩ���
          LCALL  DISP1
          JMP  CHULI11
CHULI10:  MOV  74H,#0DH         
          LCALL  DISP1          ;��ʾ"H"
          ;CALL  BEEP_BL        ;��������
CHULI11:
          CLR  TR0              ;�ر��ж�
          RET
;---------------------------------------------
;Ƿ�´���
;---------------------------------------------
CHULI2:                         ;Ƿ�´���
          JNB  FLAG2,CHULI20
          MOV  74H,#0AH         ;Ϩ���
          LCALL  DISP1
          JMP  CHULI21
CHULI20:  MOV  74H,#0CH         
          LCALL  DISP1          ;��ʾ"L"
          ;CALL  BEEP_BL        ;��������
CHULI21:  CLR  TR0              ;�ر��ж�
          RET
;------------------------------------------------------------
;�� DS18B20 �ݴ�������¶ȱ���ֵ������EEROM
;------------------------------------------------------------
WRITE_E2:
        CALL  RESET
        MOV  A,#0CCH        ;����ROMƥ��
        LCALL  WRITE
        MOV  A,#48H         ;�¶ȱ���ֵ������EEROM
        LCALL  WRITE
        RET
;--------------------------------------------------------------
;�� DS18B20 EEROM ����¶ȱ���ֵ�������ݴ���
;-------------------------------------------------------------
READ_E2:
        CALL  RESET
        MOV  A,#0CCH        ;����ROMƥ��
        LCALL  WRITE
        MOV  A,#0B8H        ;�¶ȱ���ֵ�������ݴ���
        CALL  WRITE
        RET

;*****************************************************
;  �����¶� BCD ���ӳ���
;****************************************************
CONVTEMP:      MOV  A,TEMPH       ;���¶��Ƿ�����
               ANL  A,#80H
               JZ  TEMPC1         ;�¶�����ת
               CLR  C
               MOV  A,TEMPL       ;���������󲹣�˫�ֽڣ�
               CPL  A             ;ȡ����1
               ADD  A,#01H
               MOV  TEMPL,A
               MOV  A,TEMPH       ;��
               CPL  A
               ADDC  A,#00H
               MOV  TEMPH,A          ;TEMPHC HI =����λ
               MOV  TEMPHC,#0BH
               SJMP  TEMPC11

TEMPC1:        MOV  TEMPHC,#0AH     ;
TEMPC11:       MOV  A,TEMPHC
               SWAP  A
               MOV  TEMPHC,A
               MOV  A,TEMPL
               ANL  A,#0FH             ;��0.0625
               MOV  DPTR,#TEMPDOTTAB
               MOVC  A,@A+DPTR
               MOV  TEMPLC,A            ;TEMPLC  LOW=С������ BCD

               MOV  A,TEMPL             ;��������
               ANL  A,#0F0H
               SWAP  A
               MOV  TEMPL,A
               MOV  A,TEMPH
               ANL  A,#0FH
               SWAP  A
               ORL  A,TEMPL
               MOV  TEMP_ZH,A           ;��Ϻ��ֵ����TEMP_ZH
               LCALL  HEX2BCD1
               MOV  TEMPL,A
               ANL  A,#0F0H
               SWAP  A
               ORL  A,TEMPHC            ;TEMPHC LOW = ʮλ�� BCD
               MOV  TEMPHC,A
               MOV  A,TEMPL
               ANL  A,#0FH
               SWAP  A                  ;TEMPLC HI = ��λ�� BCD
               ORL  A,TEMPLC
               MOV  TEMPLC,A
               MOV  A,R7
               JZ  TEMPC12
               ANL  A,#0FH
               SWAP  A
               MOV  R7,A
               MOV  A,TEMPHC            ;TEMPHC HI = ��λ�� BCD
               ANL  A,#0FH
               ORL  A,R7
               MOV  TEMPHC,A
TEMPC12:       RET
;-----------------------------------------------------------
;  С���������
;-----------------------------------------------------------
TEMPDOTTAB:  DB   00H,01H,01H,02H,03H,03H,04H,04H,05H,06H
             DB   06H,07H,08H,08H,09H,09H

;===========================================================

;��ʾ�� BCD ���¶�ֵˢ���ӳ���

;===========================================================

DISPBCD:      MOV  A,TEMPLC
              ANL  A,#0FH
              MOV  70H,A                 ;С��λ
              MOV  A,TEMPLC
              SWAP  A
              ANL  A,#0FH
              MOV  71H,A                 ;��λ
              MOV  A,TEMPHC
              ANL  A,#0FH
              MOV  72H,A                 ;ʮλ
              MOV  A,TEMPHC
              SWAP  A
              ANL  A,#0FH
              MOV  73H,A                 ;��λ
              MOV  A,TEMPHC
              ANL  A,#0F0H
              CJNE  A,#010H,DISPBCD0
              SJMP  DISPBCD2

DISPBCD0:     MOV  A,TEMPHC
              ANL  A,#0FH
              JNZ  DISPBCD2               ;ʮλ����0
              MOV  A,TEMPHC
              SWAP  A
              ANL  A,#0FH
              MOV  73H,#0AH               ;����λ����ʾ
              MOV  72H,A                  ;ʮλ����ʾ����
DISPBCD2:     RET

;***************************************************************

;     �¶���ʾ�ӳ���

;***************************************************************
;��ʾ������70H �� 73H ��Ԫ�ڣ���4λ�����������ʾ��P0������������ݣ�
;P2 ����ɨ����ƣ�ÿ�� LED ������� 2MS ʱ������λѭ����

DISP1:       MOV  R1,#70H             ;ָ����ʾ������ַ
             MOV  R5,#7FH            ;ɨ������ֳ�ֵ
PLAY:        MOV  P0,#0FFH
             MOV  A,R5                ;ɨ���ַ���A
             MOV  P2,A
             MOV  A,@R1               ;ȡ��ʾ���ݵ�A
             MOV  DPTR,#TAB           ;ȡ������ַ
             MOVC  A,@A+DPTR          ;����ʾ���ݶ�Ӧ����
             MOV  P0,A                ;�������P0��
             MOV  A,R5
             JB   ACC.6,LOOP5         ;С���㴦��
             CLR  P0.7
LOOP5:       LCALL  DL_MS              ;��ʾ2MS
             INC  R1                   ;ָ����һ����ַ
             MOV  A,R5                 ;�Ż� R5 ��
             JNB  ACC.3,ENDOUT        ;ACC.3=0ʱһ����ʾ����
             RR  A                    ;A ������ѭ������
             MOV  R5,A                ;���� R5 ��
             AJMP  PLAY               ;���� PLAY ѭ��
ENDOUT:      MOV  P0,#0FFH            ;һ����ʾ������P0�ڸ�λ
             MOV  P2,#0FFH            ;P2�ڸ�λ
             RET

TAB:
 DB  0C0H,0F9H,0A4H,0B0H,99H,92H,82H,0F8H,80H,90H,0FFH,0BFH,0C7H,89H
;   ��0"  ��1" ��2" ��3" ��4"��5"��6"��7"��8"��9"����" ��-" ��L����H"

DL_MS:      MOV  R6,#0AH         ;2MS��ʱ����LED ��ʾ������
DL1:        MOV  R7,#64H
DL2:        DJNZ  R7,DL2
            DJNZ  R6,DL1
            RET

;******************************************************
;���ֽ�ʮ������ת BCD
;******************************************************
HEX2BCD1:   MOV  B,#064H          
            DIV  AB               
            MOV  R7,A             
            MOV  A,#0AH
            XCH  A,B
            DIV  AB               
            SWAP  A
            ORL  A,B
            RET
;===============================================
;����ֵ TH��TL ����ת��
;===============================================
ALERT_TL:
             MOV  79H,#0CH
             MOV  78H,#0BH
             MOV  A,TEMP_TL
             MOV  R0,#77H
             MOV  B,#064H
             DIV  AB
             CJNE  A,#01H,ALERT_TL1
             MOV  @R0,A
             JMP  ALERT_TL2
ALERT_TL1:   MOV  A,#0BH           ;��ʾ������
             MOV  @R0,A
ALERT_TL2:   MOV  A,#0AH
             XCH  A,B
             DIV  AB
             DEC  R0
             MOV  @R0,A
             MOV  7DH,A
             DEC  R0
             MOV  @R0,B
             MOV  7EH,B
             RET
;-----------------------------------------------
ALERT_TH:
             MOV  79H,#0DH
             MOV  78H,#0BH
             MOV  A,TEMP_TH
             MOV  R0,#77H
             MOV  B,#064H
             DIV  AB
             CJNE  A,#01H,ALERT_TH1
             MOV  @R0,A
             JMP  ALERT_TH2
ALERT_TH1:   MOV  A,#0BH             ;��ʾ������
             MOV  @R0,A
ALERT_TH2:   MOV  A,#0AH
             XCH  A,B
             DIV  AB
             DEC  R0
             MOV  @R0,A
             MOV  7DH,A
             DEC  R0
             MOV  @R0,B
             MOV  7EH,B
             RET
;===============================================
;����ֵ��ʾ�ӳ���
;===============================================
ALERT_PLAY:
             MOV  R1,#75H             ;ָ����ʾ������ַ
             MOV  R5,#7FH            ;ɨ������ֳ�ֵ
A_PLAY:      MOV  P0,#0FFH
             MOV  A,R5                ;ɨ���ַ���A
             MOV  P2,A
             MOV  A,@R1               ;ȡ��ʾ���ݵ�A
             MOV  DPTR,#ALERT_TAB     ;ȡ������ַ
             MOVC  A,@A+DPTR          ;����ʾ���ݶ�Ӧ����
             MOV  P0,A                ;�������P0��
             LCALL  DL_MS1            ;��ʾ2MS
             INC  R1                  ;ָ����һ����ַ
             MOV  A,R5
             JNB  ACC.3,ENDOUT1
             RR  A                    ;A ������ѭ������
             MOV  R5,A                ;���� R5 ��
             AJMP  A_PLAY             ;���� PLAY ѭ��
ENDOUT1:     MOV  P0,#0FFH            ;һ����ʾ������P0�ڸ�λ
             MOV  P2,#0FFH            ;P2�ڸ�λ
             RET

ALERT_TAB:
 DB 0C0H,0F9H,0A4H,0B0H,99H,92H,82H,0F8H,80H,90H,0FFH,0BFH,0C7H,89H
;��������� ��0"  ��1" ��2" ��3" ��4"��5"��6"��7"��8"��9"����" ��-"

DL_MS1:      MOV  R6,#0AH         ;2MS��ʱ����LED ��ʾ������
ADL1:        MOV  R7,#64H
ADL2:        DJNZ  R7,ADL2
             DJNZ  R6,ADL1
             RET
;===============================================
;��������һ���ӳ���
;P3.7=0,��������
;===============================================
BEEP_BL:
         MOV  R6,#100
 BL2:    CALL  DEX1
         CPL  BEEP        ;�� P3.7 ȡ��
         DJNZ  R6,BL2
         MOV  R5,#10
         CALL  DELAY
         RET
 DEX1:   MOV  R7,#180
 DE2:    NOP
         DJNZ  R7,DE2
         RET
DELAY:                    ;(R5)*��ʱ10MS
         MOV  R6,#50
 DEL1:   MOV  R7,#100
         DJNZ  R7,$
         DJNZ  R6,DEL1
         DJNZ  R5,DELAY
         RET
;==================================================
         END
