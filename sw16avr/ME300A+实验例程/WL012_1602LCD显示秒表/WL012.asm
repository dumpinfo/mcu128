;********************************************************************************
;*  标题:  ME300系列单片机开发系统演示程序 - 1602LCD显示秒表                    *
;*  硬件： ME300A+,ME300B                                                       *
;*  文件:  WL012.asm                                                            *
;*  日期:  2004-1-5                                                             *
;*  版本:  1.0                                                                  *
;*  作者:  gguoqing                                                             *
;*  邮箱:  gguoqing@willar.com                                                  *
;*  网站： http://www.willar.com                                                *
;********************************************************************************
;*  描述:                                                                       *
;*          1602LCD显示秒表                                                     *
;*          K3 --- 控制按键                                                     *
;*                 第一次按下时,开始计时，第二次按下时,暂停计时。               *
;*                 第三次按下时,累计计时，第四次按下时,暂停计时。               *
;*          K4 --- 清零按键：                                                   *
;*                 在任何状态下，按一下K4，均可清零。                           *
;********************************************************************************
;*  跳线设置：                                                                  *
;*     ME300A+    JP1 全部短接，JP2短接1-2端                                    *
;*     ME300B     JP1 短接，JP2短接1-2端                                        *
;*                                                                              *
;********************************************************************************
;* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
;* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
;********************************************************************************


;---------------------------------------
;晶振 11.0592M
;定时器0,方式1
;计时中断程序每隔10ms中断一次
;---------------------------------------
          TLOW   EQU  0CH     ;定时器初值
          THIGH  EQU  0DCH

          HOUR   EQU  30H
          MIN    EQU  31H
          SEC    EQU  32H
          SEC0   EQU  33H     ;10ms计数值
          KEY_S  EQU  34H     ;为键当前的端口状况
          KEY_V  EQU  35H     ;为键上次的端口状况
          X      EQU  36H     ;LCD 地址变量
          KEY_C  EQU  37H     ;键计数单元

          K1     EQU  P1.4
          K2     EQU  P1.5
          K3     EQU  P1.6
          K4     EQU  P1.7

          BEEP  EQU  P3.7
          RS    EQU  P2.0     ;LCD控制端口定义
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
          CALL  INIT            ;初始化变量
          MOV  KEY_V,#01H
          CALL  INIT_TIMER      ;初始化定时器
          CALL  MENU
LOOP:     CALL   CONV           ;时间计数处理
          CALL LOOP1
          CALL  SKEY            ;判是否有键按下
          JZ  LOOP              ;无键按下转LOOP
          CALL   CONV
          CALL  SKEY
          JZ  LOOP
          MOV  KEY_V,KEY_S      ;交换数据
          CALL  P_KEY
          JMP  LOOP
;-----------------------------------------------------
LOOP1:    JB  K4,LOOP2         ;判清零键是否按下
          CALL  BZ
          JMP  START
LOOP2:    RET
;-----------------------------------------------------
P_KEY:                          ;
          MOV  A,KEY_V
          JB  ACC.0,P_KEY3
          INC  KEY_C
          MOV  A,KEY_C          ;K3键是否第一次按下？
          CJNE  A,#01H,P_KEY1
          MOV    DPTR,#MADJ    ;显示执行信息
          MOV    A,#1          ;
          CALL   LCD_PRINT
          SETB  TR0            ;启动中断
          RET
P_KEY1:                          ;K3键是否第二次按下？
          MOV   A,KEY_C
          CJNE  A,#02H,P_KEY2
          MOV   DPTR,#MADJ1      ;显示执行信息
          MOV   A,#1
          CALL  LCD_PRINT
          CLR   TR0              ;停止中断
          RET
P_KEY2:                          ;K3键是否第三次按下？
          MOV   A,KEY_C
          CJNE  A,#03H,P_KEY3
          MOV   DPTR,#MADJ2      ;显示执行信息
          MOV   A,#1
          CALL  LCD_PRINT
          SETB   TR0             ;启动中断
          RET
P_KEY3:                          ;K3键是否第四次按下？
          MOV   A,KEY_C
          CJNE  A,#04H,P_KEY4
          MOV   DPTR,#MADJ3      ;显示执行信息
          MOV   A,#1
          CALL  LCD_PRINT
          CLR   TR0              ;启动中断
P_KEY4:   RET
;-------------------------------------------------------
SKEY:     CLR  A                ;判是否有键按下子程序
          MOV  KEY_S,A
          MOV  C,K3
          RLC  A
          ORL  KEY_S,A
          MOV  A,KEY_S
          XRL  A,KEY_V          ;有键按下，A 中内容不为零
          RET
;--------------------------------------------------------
LMESS1:  DB  "                ",0  ;LCD 第一行显示消息
LMESS2:  DB  "TIME            ",0  ;LCD 第二行显示消息
;--------------------------------------------------------
INIT:    CLR  A
         MOV  KEY_C,A         ;初始化控制变量
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
INIT_TIMER:                     ;初始化定时器接口
         MOV  TMOD,#01H         ;设置定时器0 工作模式为模式1
         MOV  IE,  #82H         ;启用定时器0 中断产生
         MOV  TL0,#TLOW
         MOV  TH0,#THIGH
         RET
;-------------------------------------------------------------
T0_INT:
         PUSH  ACC           ;定时器0计时中断程序
         MOV  TL0,#TLOW
         MOV  TH0,#THIGH
         INC  SEC0
         MOV  A,SEC0         ;10ms 计数值加1
         CJNE  A,#100,TT
         MOV  SEC0,#0
         INC  SEC            ;秒加1
         MOV  A,SEC
         CJNE  A,#60,TT
         INC  MIN            ;分加1
         MOV  SEC,#0
         MOV  A,MIN
         CJNE  A,#60,TT
         INC  HOUR           ;时加1
         MOV  MIN,#0
         MOV  A,HOUR
         CJNE  A,#24,TT
         MOV  SEC0,#0
         MOV  SEC,#0          ;秒、分、时单元清0
         MOV  MIN,#0
         MOV  HOUR,#0
 TT:     POP  ACC
         RETI
;-------------------------------------------------------
;   在第二行显示数字
;-------------------------------------------------------
SHOW_DIG2:                    ;在 LCD 的第二行显示数字
          MOV  B,#10         ;设置被除数
          DIV  AB            ;结果A存商数，B存余数
          ADD  A,#30H        ;A为十位数，转换为字符
          PUSH  B            ;B放入堆栈暂存
          MOV  B,X           ;设置 LCD 显示的位置
          CALL  LCDP2        ;由 LCD 显示出来
          POP  B             ;
          MOV  A,B           ;B为个位数
          ADD  A,#30H        ;转换为字符
          INC  X             ;LCD 显示位置加1
          MOV  B,X           ;设置 LCD 显示的位置
          CALL  LCDP2        ;由 LCD 显示出来
          RET
;-------------------------------------------
;转换为 ASCII 码并显示
;-------------------------------------------
CONV:
          MOV  A,HOUR        ;加载小时数据
          MOV  X,#5          ;设置位置
          CALL  SHOW_DIG2    ;显示数据
          INC  X             ;
          MOV  A,#':'        ;
          MOV  B,X           ;
          CALL  LCDP2        ;
          MOV  A,MIN         ;加载分钟数据
          INC  X             ;设置位置
          CALL  SHOW_DIG2    ;显示数据
          INC  X             ;
          MOV  A,#':'        ;
          MOV  B,X           ;
          CALL  LCDP2        ;
          MOV  A,SEC         ;加载秒数数据
          INC  X             ;设置位置
          CALL  SHOW_DIG2    ;显示数据
          INC  X             ;
          MOV  A,#':'        ;
          MOV  B,X           ;
          CALL  LCDP2        ;
          MOV  A,SEC0        ;加载秒数数据
          INC  X             ;设置位置
          CALL  SHOW_DIG2
          RET
;---------------------------------------------------------
;  LCD  CONTROL
;---------------------------------------------------------
SET_LCD:                     ;对 LCD 做初始化设置及测试
          CLR  EN
          CALL  INIT_LCD     ;初始化 LCD
          MOV  R5,#10
          CALL  DELAY
          MOV  DPTR,#LMESS1  ;指针指到显示消息1
          MOV  A,#1          ;显示在第一行
          CALL  LCD_PRINT
          MOV  DPTR,#LMESS2  ;指针指到显示消息2
          MOV  A,#2          ;显示在第二行
          CALL  LCD_PRINT
          RET
;----------------------------------------------------------
INIT_LCD1:                   ;LCD 控制指令初始化
          MOV  A,#38H        ;双列显示，字形5*7点阵
          CALL  WCOM         ;
          call  delay1
          MOV  A,#0CH        ;开显示，显示光标，光标不闪烁
          CALL  WCOM         ;
          call  delay1
          MOV  A,#01H        ;清除 LCD 显示屏
          CALL  WCOM         ;
          call  delay1
          RET
;----------------------------------------------------------
ENABLE:                       ;写指令
          CLR RS              ;RS=L,RW=L,E=高脉冲
          CLR RW              ;D0-D7=指令码
          SETB EN
          ACALL DELAY1          
          CLR EN
          RET
;----------------------------------------------------------
LCD_PRINT:       ;在LCD的第一行或第二行显示字符

          CJNE  A,#1,LINE2  ;判断是否为第一行
  LINE1:  MOV  A,#80H       ;设置 LCD 的第一行地址
          CALL  WCOM        ;写入命令
          CALL  CLR_LINE    ;清除该行字符数据
          MOV  A,#80H       ;设置 LCD 的第一行地址
          CALL  WCOM        ;写入命令
          JMP  FILL
  LINE2:  MOV  A,#0C0H      ;设置 LCD 的第二行地址
          CALL  WCOM        ;写入命令
          CALL  CLR_LINE    ;清除该行字符数据
          MOV  A,#0C0H      ;设置 LCD 的第二行地址
          CALL  WCOM
  FILL:   CLR  A            ;填入字符
          MOVC  A,@A+DPTR   ;由消息区取出字符
          CJNE  A,#0,LC1    ;判断是否为结束码
          RET
  LC1:    CALL  WDATA       ;写入数据
          INC  DPTR         ;指针加1
          JMP  FILL         ;继续填入字符
          RET
;-------------------------------------------------------
CLR_LINE:                  ;清除该行 LCD 的字符
          MOV  R0,#24
   CL1:   MOV  A,#' '
          CALL  WDATA
          DJNZ  R0,CL1
          RET
;-------------------------------------------------------
   DE:    MOV  R7,#250      ;延时500微秒
          DJNZ  R7,$
          RET
;-------------------------------------------------------
   EN1:
          CLR   RW
          SETB  EN         ;短脉冲产生启用信号
          CALL  DE
          CLR  EN
          CALL  DE
          RET
;------------------------------------------------------
INIT_LCD:                  ;8位I/O控制 LCD 接口初始化
          MOV  P0,#38H     ;双列显示，字形5*7点阵
          call  enable
          call  delay1
          MOV  P0,#38H     ;双列显示，字形5*7点阵
          call  enable
          call  delay1
          MOV  P0,#38H     ;双列显示，字形5*7点阵
          call  enable
          call  delay1
          CALL  INIT_LCD1
          RET
;-----------------------------------------------------
WCOM:                     ;以8位控制方式将命令写至LCD
          MOV  P0,A       ;写入命令
          call  enable
          RET
;-----------------------------------------------------
WDATA:                    ;以8位控制方式将数据写至LCD
          MOV  P0,A       ;写入数据
          SETB  RS        ;设置写入数据
          CALL  EN1
          RET
;-----------------------------------------------------
;第二行显示字符
;-----------------------------------------------------
LCDP2:                    ;在LCD的第二行显示字符
         PUSH  ACC        ;
         MOV  A,B         ;设置显示地址
         ADD  A,#0C0H     ;设置LCD的第二行地址
         CALL  WCOM       ;写入命令
         POP  ACC         ;由堆栈取出A
         CALL  WDATA      ;写入数据
         RET
;----------------------------------------------------
DELAY:                    ;延时10MS
         MOV  R6,#50
  D1:    MOV  R7,#100
         DJNZ  R7,$
         DJNZ  R6,D1
         DJNZ  R5,DELAY
         RET
;-----------------------------------------------------
DELAY1:                    ;延时5MS
         MOV  R6,#25
  D2:    MOV  R7,#100
         DJNZ  R7,$
         DJNZ  R6,D2
         RET
;-----------------------------------------------------
BZ:                        ;蜂鸣器
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
MENU:                      ;LCD 显示工作菜单消息
         MOV  DPTR,#MMENU
         MOV  A,#1
         CALL  LCD_PRINT
         RET
;-------------------------------------------------
         END
