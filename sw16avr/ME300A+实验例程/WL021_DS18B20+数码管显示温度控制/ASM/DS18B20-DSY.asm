;********************************************************************************
;*  标题:  ME300系列单片机开发系统演示程序 - DS18B20温度控制数码管显示          *
;*  硬件： ME300A+,ME300B                                                       *
;*  文件:  DS18B20-DSY.asm                                                      *
;*  日期:  2005-3-20                                                            *
;*  版本:  1.0                                                                  *
;*  作者:  gguoqing                                                             *
;*  邮箱:  gguoqing@willar.com                                                  *
;*  网站： http://www.willar.com                                                *
;********************************************************************************
;*  描述:                                                                       *
;*          DS18B20温度控制数码管显示                                           *
;*        1、K3 → 进入设定温度报警值 TL 状态:                                   *
;*           L－－20                                                            *
;*        2、K3 → 进入设定温度报警值 TH 状态:                                   *
;*           H－－28                                                            *
;*        3、K3 → 返回                                                          *
;*        4、设定过程： K1 →加键 （UP）， K2 →减键 （DOWN），可快速调。         *
;********************************************************************************
;*  跳线设置：                                                                  *
;*     ME300A+    JP1 全部短接，JP2短接2-3端                                    *
;*     ME300B     JP1 短接，JP2短接2-3端，JP4的P13需要短接                      *  
;*                                                                              *
;********************************************************************************
;* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
;* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
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
          MOV  TMOD,#01H        ;T0,方式1
          MOV  TIMER_L,#00H     ;50ms定时值
          MOV  TIMER_H,#4CH
          MOV  TIMER_COUN,#00H  ;中断计数
          MOV  IE,#82H          ;EA=1,ET0=1
          LCALL  READ_E2
          ;LCALL  RE_18B20
          MOV  20H,#00H
          SETB   BEEP
          SETB   RELAY
          MOV  7FH,#0AH         ;熄灭符

          CALL RESET            ;复位与检测DS18B20
          JNB FLAG1,MAIN1       ;FLAG1=0，DS18B20不存在
          JMP  START

MAIN1:    CALL RESET
          JB FLAG1,START
          LCALL  BEEP_BL        ;DS18B20错误，报警
          JMP  MAIN1
START:
          MOV A,#0CCH         ; 跳过ROM匹配
          CALL WRITE
          MOV A,#044H         ; 发出温度转换命令
          CALL WRITE

          CALL RESET
          MOV A,#0CCH         ; 跳过ROM匹配
          CALL WRITE
          MOV A,#0BEH         ; 发出读温度命令
          CALL WRITE

          CALL  READ           ;读温度数据
          CALL  CONVTEMP
          CALL  DISPBCD
          CALL  DISP1
          CALL  SCANKEY
          LCALL  TEMP_COMP
          JMP   MAIN1

;=====================================================
;DS18B20 复位与检测子程序
;FLAG1=1 OK, FLAG1=0 ERROR
;======================================================
RESET:
          SETB DATA_LINE
          NOP
          CLR DATA_LINE
          MOV R0,#64H            ;主机发出延时600微秒的复位低脉冲
          MOV R1,#03H
RESET1:   DJNZ R0,$
          MOV R0,#64H
          DJNZ R1,RESET1
          SETB DATA_LINE        ;然后拉高数据线
          NOP
          MOV R0,#25H
RESET2:   JNB DATA_LINE,RESET3  ;等待DS18B20回应
          DJNZ R0,RESET2
          JMP RESET4            ; 延时
RESET3:   SETB FLAG1            ; 置标志位,表示DS1820存在
          JMP RESET5
RESET4:   CLR FLAG1             ; 清标志位,表示DS1820不存在
          JMP RESET6
RESET5:   MOV R0,#064H
          DJNZ R0,$             ; 时序要求延时一段时间
RESET6:   SETB DATA_LINE
          RET
;===========================================================
;
;===========================================================
WRITE:  MOV R2,#8            ;一共8位数据
        CLR CY
WR1:
        CLR DATA_LINE        ;开始写入DS18B20总线要处于复位（低）状态
        MOV R3,#09
        DJNZ R3,$            ;总线复位保持18微妙以上
        RRC A                ;把一个字节DATA 分成8个BIT环移给C
        MOV DATA_LINE,C      ;写入一个BIT
        MOV R3,#23
        DJNZ R3,$            ;等待46微妙
        SETB DATA_LINE       ;重新释放总线
        NOP
        DJNZ R2,WR1          ;写入下一个BIT
        SETB DATA_LINE
        RET
;============================================================
;从DS18B20中读出温度低位、高位和报警值TH、TL
;存入26H、27H、28H、29H
;============================================================
READ:    MOV R4,#4            ; 将温度高位和低位从DS18B20中读出
         MOV R1,#26H          ; 存入26H、27H、28H、29H
RE00:    MOV R2,#8
RE01:    CLR C
         SETB DATA_LINE
         NOP
         NOP
         CLR DATA_LINE        ;读前总线保持为低
         NOP
         NOP
         NOP
         SETB DATA_LINE       ;开始读总线释放
         MOV R3,#09           ;延时18微妙
         DJNZ R3,$
         MOV C,DATA_LINE      ;从DS18B20总线读得一个BIT
         MOV R3,#23
         DJNZ R3,$            ;等待46微妙
         RRC A                ;把读得的位值环移给A
         DJNZ R2,RE01         ;读下一个BIT
         MOV @R1,A
         INC R1
         DJNZ R4,RE00
         RET        
;--------------------------------------------
;200ms对闪动标记取反一次
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
;重新对 DS18B20 初始化
;将设定的温度报警值写入 DS18B20
;==========================================================
RE_18B20:
        JB  FLAG1,RE_18B20A
        RET
RE_18B20A:
        CALL  RESET
        MOV  A,#0CCH       ;跳过ROM匹配
        LCALL  WRITE
        MOV  A,#4EH        ;写暂存寄存器
        LCALL  WRITE
        MOV  A,TEMP_TH     ;TH(报警上限）
        LCALL  WRITE
        MOV  A,TEMP_TL     ;TL(报警下限）
        LCALL  WRITE
        MOV  A,#7FH        ;12位精确度
        LCALL  WRITE
        RET

;====================================================
;功能键扫描子程序
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
;设置温度报警值
;================================================
RESET_ALERT:
          CALL  ALERT_TL
          CALL  ALERT_PLAY
          JNB K3,$              ;K3为位移键
          SETB  TR0
RESET_TL:
          CALL  ALERT_PLAY
          JNB  FLAG2,R_TL01
          mov  75H,7fh          ;送入熄灭符
          mov  76H,7fh
          CALL  ALERT_PLAY
          JMP   R_TL02
R_TL01:   CALL  ALERT_TL
          mov  75h,7Eh          ;送设定值
          mov  76h,7Dh
          CALL  ALERT_PLAY      ;显示设定值
R_TL02:   JNB  K1,K011A
          JNB  K2,K011B
          JNB  K3,RESET_TH
          JMP  RESET_TL
K011A:
          INC  TEMP_TL
          MOV  A,TEMP_TL
          CJNE  A,#120,K012A    ;没有到设定上限值，转
          MOV  TEMP_TL,#0
K012A:    CALL  TL_DEL
          JMP   RESET_TL
K011B:
          DEC  TEMP_TL
          MOV  A,TEMP_TL
          CJNE  A,#00H,K012B   ;没有到设定下限值，转
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
          mov  75H,7fh          ;送入熄灭符
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
          CJNE  A,#120,K022A   ;没有到设定上限值，转
          MOV  TEMP_TH,#0
K022A:     CALL  TH_DEL
          JMP   RESET_TH1

K021B:
          DEC  TEMP_TH         ;减1
          MOV  A,TEMP_TH
          CJNE  A,#00H,K022B   ;没有到设定下限值，转
          MOV  TEMP_TH,#119
K022B:    CALL  TH_DEL
          JMP   RESET_TH1

K002:     CALL  BEEP_BL
          CLR  TR0             ;关闭中断
          RET
;-----------------------------------------------------
;键延时子程序
;多次调用报警值显示程序来延时
;-----------------------------------------------------
TL_DEL:                        ;报警低值延时
          MOV  R2,#0AH
TL_DEL1:  CALL  ALERT_TL
          CALL  ALERT_PLAY
          DJNZ  R2,TL_DEL1
          RET
TH_DEL:                        ;报警高值延时
          MOV  R2,#0AH
TH_DEL1:  CALL  ALERT_TH
          CALL  ALERT_PLAY
          DJNZ  R2,TH_DEL1
          RET
;====================================================
;实时温度值与设定报警温度值 TH、TL 比较子程序
;当实际温度大于 TH 的设定值时，显示“H”，继电器关闭。
;当实际温度小于 TH 的设定值时，显示“O”，继电器吸合。
;当实际温度小于 TL 的设定值时，显示“L”。
;闪动显示标记符 H、L、O
;====================================================
TEMP_COMP:
          SETB  TR0             ;启动中断
          MOV  A,TEMP_TH
          SUBB  A,TEMP_ZH       ;减数>被减数，则
          JC  CHULI1            ;借位标志位C=1，转
          MOV  A,TEMP_ZH
          SUBB  A,TEMP_TL       ;减数>被减数，则
          JC  CHULI2            ;借位标志位C=1，转
          JNB  FLAG2,T_COMP1    ;FLAG2=0,显示标记字符
          MOV  74H,#0AH         ;熄灭符
          LCALL  DISP1
          JMP  T_COMP2
T_COMP1:  MOV  74H,#00H
          LCALL  DISP1          ;显示"O"
T_COMP2:  CLR   RELAY           ;继电器吸合
          CLR  TR0              ;关闭中断
          RET
;---------------------------------------------
;超温处理
;---------------------------------------------
CHULI1:
          SETB  RELAY           ;继电器关闭
          JNB  FLAG2,CHULI10
          MOV  74H,#0AH         ;熄灭符
          LCALL  DISP1
          JMP  CHULI11
CHULI10:  MOV  74H,#0DH         
          LCALL  DISP1          ;显示"H"
          ;CALL  BEEP_BL        ;蜂鸣器响
CHULI11:
          CLR  TR0              ;关闭中断
          RET
;---------------------------------------------
;欠温处理
;---------------------------------------------
CHULI2:                         ;欠温处理
          JNB  FLAG2,CHULI20
          MOV  74H,#0AH         ;熄灭符
          LCALL  DISP1
          JMP  CHULI21
CHULI20:  MOV  74H,#0CH         
          LCALL  DISP1          ;显示"L"
          ;CALL  BEEP_BL        ;蜂鸣器响
CHULI21:  CLR  TR0              ;关闭中断
          RET
;------------------------------------------------------------
;把 DS18B20 暂存器里的温度报警值拷贝到EEROM
;------------------------------------------------------------
WRITE_E2:
        CALL  RESET
        MOV  A,#0CCH        ;跳过ROM匹配
        LCALL  WRITE
        MOV  A,#48H         ;温度报警值拷贝到EEROM
        LCALL  WRITE
        RET
;--------------------------------------------------------------
;把 DS18B20 EEROM 里的温度报警值拷贝回暂存器
;-------------------------------------------------------------
READ_E2:
        CALL  RESET
        MOV  A,#0CCH        ;跳过ROM匹配
        LCALL  WRITE
        MOV  A,#0B8H        ;温度报警值拷贝回暂存器
        CALL  WRITE
        RET

;*****************************************************
;  处理温度 BCD 码子程序
;****************************************************
CONVTEMP:      MOV  A,TEMPH       ;判温度是否零下
               ANL  A,#80H
               JZ  TEMPC1         ;温度零上转
               CLR  C
               MOV  A,TEMPL       ;二进制数求补（双字节）
               CPL  A             ;取反加1
               ADD  A,#01H
               MOV  TEMPL,A
               MOV  A,TEMPH       ;－
               CPL  A
               ADDC  A,#00H
               MOV  TEMPH,A          ;TEMPHC HI =符号位
               MOV  TEMPHC,#0BH
               SJMP  TEMPC11

TEMPC1:        MOV  TEMPHC,#0AH     ;
TEMPC11:       MOV  A,TEMPHC
               SWAP  A
               MOV  TEMPHC,A
               MOV  A,TEMPL
               ANL  A,#0FH             ;乘0.0625
               MOV  DPTR,#TEMPDOTTAB
               MOVC  A,@A+DPTR
               MOV  TEMPLC,A            ;TEMPLC  LOW=小数部分 BCD

               MOV  A,TEMPL             ;整数部分
               ANL  A,#0F0H
               SWAP  A
               MOV  TEMPL,A
               MOV  A,TEMPH
               ANL  A,#0FH
               SWAP  A
               ORL  A,TEMPL
               MOV  TEMP_ZH,A           ;组合后的值存入TEMP_ZH
               LCALL  HEX2BCD1
               MOV  TEMPL,A
               ANL  A,#0F0H
               SWAP  A
               ORL  A,TEMPHC            ;TEMPHC LOW = 十位数 BCD
               MOV  TEMPHC,A
               MOV  A,TEMPL
               ANL  A,#0FH
               SWAP  A                  ;TEMPLC HI = 个位数 BCD
               ORL  A,TEMPLC
               MOV  TEMPLC,A
               MOV  A,R7
               JZ  TEMPC12
               ANL  A,#0FH
               SWAP  A
               MOV  R7,A
               MOV  A,TEMPHC            ;TEMPHC HI = 百位数 BCD
               ANL  A,#0FH
               ORL  A,R7
               MOV  TEMPHC,A
TEMPC12:       RET
;-----------------------------------------------------------
;  小数部分码表
;-----------------------------------------------------------
TEMPDOTTAB:  DB   00H,01H,01H,02H,03H,03H,04H,04H,05H,06H
             DB   06H,07H,08H,08H,09H,09H

;===========================================================

;显示区 BCD 码温度值刷新子程序

;===========================================================

DISPBCD:      MOV  A,TEMPLC
              ANL  A,#0FH
              MOV  70H,A                 ;小数位
              MOV  A,TEMPLC
              SWAP  A
              ANL  A,#0FH
              MOV  71H,A                 ;个位
              MOV  A,TEMPHC
              ANL  A,#0FH
              MOV  72H,A                 ;十位
              MOV  A,TEMPHC
              SWAP  A
              ANL  A,#0FH
              MOV  73H,A                 ;百位
              MOV  A,TEMPHC
              ANL  A,#0F0H
              CJNE  A,#010H,DISPBCD0
              SJMP  DISPBCD2

DISPBCD0:     MOV  A,TEMPHC
              ANL  A,#0FH
              JNZ  DISPBCD2               ;十位数是0
              MOV  A,TEMPHC
              SWAP  A
              ANL  A,#0FH
              MOV  73H,#0AH               ;符号位不显示
              MOV  72H,A                  ;十位数显示符号
DISPBCD2:     RET

;***************************************************************

;     温度显示子程序

;***************************************************************
;显示数据在70H － 73H 单元内，用4位共阳数码管显示，P0口输出段码数据，
;P2 口作扫描控制，每个 LED 数码管亮 2MS 时间再逐位循环。

DISP1:       MOV  R1,#70H             ;指向显示数据首址
             MOV  R5,#7FH            ;扫描控制字初值
PLAY:        MOV  P0,#0FFH
             MOV  A,R5                ;扫描字放入A
             MOV  P2,A
             MOV  A,@R1               ;取显示数据到A
             MOV  DPTR,#TAB           ;取段码表地址
             MOVC  A,@A+DPTR          ;查显示数据对应段码
             MOV  P0,A                ;段码放入P0口
             MOV  A,R5
             JB   ACC.6,LOOP5         ;小数点处理
             CLR  P0.7
LOOP5:       LCALL  DL_MS              ;显示2MS
             INC  R1                   ;指向下一个地址
             MOV  A,R5                 ;放回 R5 内
             JNB  ACC.3,ENDOUT        ;ACC.3=0时一次显示结束
             RR  A                    ;A 中数据循环左移
             MOV  R5,A                ;放入 R5 中
             AJMP  PLAY               ;跳回 PLAY 循环
ENDOUT:      MOV  P0,#0FFH            ;一次显示结束，P0口复位
             MOV  P2,#0FFH            ;P2口复位
             RET

TAB:
 DB  0C0H,0F9H,0A4H,0B0H,99H,92H,82H,0F8H,80H,90H,0FFH,0BFH,0C7H,89H
;   “0"  “1" “2" “3" “4"“5"“6"“7"“8"“9"“灭" “-" “L”“H"

DL_MS:      MOV  R6,#0AH         ;2MS延时程序，LED 显示程序用
DL1:        MOV  R7,#64H
DL2:        DJNZ  R7,DL2
            DJNZ  R6,DL1
            RET

;******************************************************
;单字节十六进制转 BCD
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
;报警值 TH、TL 数据转换
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
ALERT_TL1:   MOV  A,#0BH           ;显示“－”
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
ALERT_TH1:   MOV  A,#0BH             ;显示“－”
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
;报警值显示子程序
;===============================================
ALERT_PLAY:
             MOV  R1,#75H             ;指向显示数据首址
             MOV  R5,#7FH            ;扫描控制字初值
A_PLAY:      MOV  P0,#0FFH
             MOV  A,R5                ;扫描字放入A
             MOV  P2,A
             MOV  A,@R1               ;取显示数据到A
             MOV  DPTR,#ALERT_TAB     ;取段码表地址
             MOVC  A,@A+DPTR          ;查显示数据对应段码
             MOV  P0,A                ;段码放入P0口
             LCALL  DL_MS1            ;显示2MS
             INC  R1                  ;指向下一个地址
             MOV  A,R5
             JNB  ACC.3,ENDOUT1
             RR  A                    ;A 中数据循环左移
             MOV  R5,A                ;放入 R5 中
             AJMP  A_PLAY             ;跳回 PLAY 循环
ENDOUT1:     MOV  P0,#0FFH            ;一次显示结束，P0口复位
             MOV  P2,#0FFH            ;P2口复位
             RET

ALERT_TAB:
 DB 0C0H,0F9H,0A4H,0B0H,99H,92H,82H,0F8H,80H,90H,0FFH,0BFH,0C7H,89H
;共阳段码表 “0"  “1" “2" “3" “4"“5"“6"“7"“8"“9"“灭" “-"

DL_MS1:      MOV  R6,#0AH         ;2MS延时程序，LED 显示程序用
ADL1:        MOV  R7,#64H
ADL2:        DJNZ  R7,ADL2
             DJNZ  R6,ADL1
             RET
;===============================================
;蜂鸣器响一声子程序
;P3.7=0,蜂鸣器响
;===============================================
BEEP_BL:
         MOV  R6,#100
 BL2:    CALL  DEX1
         CPL  BEEP        ;对 P3.7 取反
         DJNZ  R6,BL2
         MOV  R5,#10
         CALL  DELAY
         RET
 DEX1:   MOV  R7,#180
 DE2:    NOP
         DJNZ  R7,DE2
         RET
DELAY:                    ;(R5)*延时10MS
         MOV  R6,#50
 DEL1:   MOV  R7,#100
         DJNZ  R7,$
         DJNZ  R6,DEL1
         DJNZ  R5,DELAY
         RET
;==================================================
         END
