
;*******************************************************************
;*               ME300B单片机开发系统演示程序                      *
;*                                                                 *
;* 红外遥控式简单计算器演示程序                                    *
;* 用红外遥控器做输入（适用新式遥控器）                            *
;*                                                                 *
;* LCD1602显示方式：                                               *
;* LCD第一行显示：CALCULATOR                                       *
;* LCD第二行显示：运算过程                                         *
;*                                                                 *
;* 主要功能：                                                      *
;* 0－99两位数之间的加、减、乘、除整数运算                         *
;*                                                                 *
;* 邮箱：gguoqing@willar.com                                       *
;* 网站：http://www.willar.com                                     *
;* 作者：gguoqing                                                  *
;*                                                                 *
;* 创作时间： 2005/07/10                                           *
;* 修改时间： 2006/02/03                                           *
;*                                                                 *
;*【版权】COPYRIGHT(C)伟纳电子 www.willar.com ALL RIGHTS RESERVED  *
;*【声明】此程序仅用于学习与参考，引用请注明版权和作者信息！       *
;*                                                                 *
;*******************************************************************

;K1为清零键
;数字键:0,1,2,3,4,5,6,7,8,9
;功能键:+,-,*,/,=

;－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
           RELAY   EQU  P1.3
           BEEP    EQU  P3.7
           IRIN    EQU  P3.2
;－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
           LCD_RS  EQU  P2.0
           LCD_RW  EQU  P2.1
           LCD_EN  EQU  P2.2
           LCD_X   EQU  3FH       ;LCD 地址变量
;－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
           TEMP1   EQU  30H       ;临时暂存器
           TEMP2   EQU  31H
           TEMP3   EQU  32H
           TEMP4   EQU  33H

           RES_H   EQU  27H       ;输入被加（减、乘、除）数
           RES_L   EQU  28H       ;输入加（减、乘、除）数

           OUT_H   EQU  29H       ;运算结果高位
           OUT_L   EQU  2AH       ;运算结果低位

           IRCOM   EQU  22H       ;22H-25H IR使用

;－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
           ORG  0000H
           JMP  MAIN
           ORG  0030H
;－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
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

MAIN1:     CALL  IR_IN             ;大于9的数无效
           JNB  20H.0,MAIN1
           SUBB  A,#0AH
           JNC  MAIN1              ;C=0，无借位
           MOV  A,R3               ;重装键值
           JMP  LOOP_0
LOOP:
           CALL  IR_IN              ;送被（加、减、乘、除）数
           JNB  20H.0,LOOP          ;键标记
LOOP_0:
           INC  R1
           CJNE  R1,#01H,LOOP_1
           MOV  TEMP2,A             ;高位
           MOV  LCD_X,#2
           CALL  CONV0

LOOP_1:    CJNE  R1,#02H,LOOP
           SUBB  A,#0AH             ;判是否是功能键？
           JNC  LOOP_2              ;是，转LOOP_2
           MOV  TEMP1,TEMP2
           MOV  A,TEMP1
           MOV  LCD_X,#1
           CALL  CONV0
           MOV  A,R3                ;恢复有效键值
           MOV  TEMP2,A             ;低位
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

LOOP0A:    MOV  A,R3                 ;重装键值
           CJNE  A,#0AH,LOOP1        ;加运算
           CALL  CONV1
           SETB  20H.1               ;加运算标记
           AJMP  LOOP5
LOOP1:     CJNE  A,#0BH,LOOP2        ;减运算
           CALL  CONV2
           SETB  20H.2               ;减运算标记
           AJMP  LOOP5
LOOP2:     CJNE  A,#0CH,LOOP3        ;乘运算
           CALL  CONV3
           SETB  20H.3               ;乘运算标记
           AJMP  LOOP5
LOOP3:     CJNE  A,#0DH,LOOP4        ;除运算
           CALL  CONV4
           SETB  20H.4               ;除运算标记
           AJMP  LOOP5
LOOP4:     CJNE  A,#0FH,LOOP4A
           AJMP  MAIN

LOOP4A:    AJMP  LOOP0

LOOP5:     MOV  R1,#00H
           MOV  TEMP1,#00H
           MOV  TEMP2,#00H
           CLR  20H.0                ;送（加、减、乘、除）数

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
           SUBB  A,#0AH             ;判是否是功能键？
           JNC  LOOP5D              ;是，转LOOP5C
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
LOOP6A:    MOV  A,R3                ;重装键值
           CJNE  A,#0FH,LOOP6B
           AJMP  MAIN
LOOP6B:    CJNE  A,#0EH,LOOP6       ;显示（=）
           CALL  CONV5              ;显示运算结果
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
           CJNE  A,#0FH,LOOP7        ;复位（清零）
           AJMP  MAIN
;---------------------------------------------------
; IR 译码子程序
;出口：A、R3存键值
;---------------------------------------------------
IR_IN:
          MOV   R0,#IRCOM
 I1:      JNB  IRIN,I2       ;等待 IR 信号出现
          JMP  I1
 I2:      MOV  R4,#20
 I20:     CALL  DEL
          DJNZ  R4,I20
          JB  IRIN,I1        ;确认IR信号出现

 I21:     JB  IRIN,I3        ;等 IR 变为高电平
          CALL  DEL
          JMP  I21
 I3:      MOV  R3,#0         ;8位数清为0
 LL:      JNB  IRIN,I4       ;等 IR 变为低电平
          CALL  DEL
          JMP  LL
 I4:      JB  IRIN,I5        ;等 IR 变为高电平
          CALL  DEL
          JMP  I4
 I5:      MOV  R2,#0         ;0.14MS 计数
 L1:      CALL  DEL
          JB  IRIN, N1       ;等 IR 变为高电平
                             ;IR=0，检查R2中的计数值
          MOV  A,#8
          CLR  C
          SUBB  A,R2         ;判断高低位
                             ;IF C=0  BIT=0
          MOV  A,@R0
          RRC  A
          MOV  @R0,A         ;处理完一位
          INC  R3
          CJNE  R3,#8,LL     ;需处理完8位
          MOV  R3,#0
          INC  R0
          CJNE  R0,#IRCOM+4,LL   ;收集到4字节了
          ;JMP  OK
          JMP   IR_SHOW
 N1:      INC  R2
          CJNE  R2,#30,L1    ;0.14MS 计数过长则时间到自动离开
 OK:      RET
;--------------------------------------------------------------------
IR_SHOW:
           MOV A,IRCOM+3
           CPL A                    ;将25H取反后和24H比较
           CJNE A,IRCOM+2,IR_SHOW1  ;如果不等表示接收数据发生错误,放弃。
           SETB  20H.0              ;解码成功20H.0置1。
           MOV  A,IRCOM+2
           MOV  B,A
           MOV  DPTR,#IR_TABLE_NEW
           MOV  R3,#0FFH
IR_IN1:    INC  R3
           MOV  A,R3
           MOVC  A,@A+DPTR
           CJNE  A,B,IR_IN2
           MOV  A,R3                ;找到，取顺序码
           CALL  BEEP_BL            ;蜂鸣器鸣响表示解码成功
           RET
IR_IN2:    CJNE  A,#0FFH,IR_IN1  ;末完，继续查
IR_SHOW1:  RET
;---------------------------------------------------------
;红外遥控器键值码
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
          MOV  R5,#1       ;IR解码使用
DEL0:     MOV  R6,#2
DEL1:     MOV  R7,#32
DEL2:     DJNZ  R7,DEL2
          DJNZ  R6,DEL1
          DJNZ  R5,DEL0
          RET
;－－－－－－－－－－－－－－－－－－－－－－－－
;加法运算子程序
;入口：R0-被加数,R1-加数
;出口：R4(高)、R2(低)为和值
;－－－－－－－－－－－－－－－－－－－－－－－－
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
;－－－－－－－－－－－－－－－－－－－－－－－－
;减法运算子程序
;入口：R0-被减数,R1-减数
;出口：R2－差值
;－－－－－－－－－－－－－－－－－－－－－－－－
SUSUB:
          MOV  R1,RES_L
          MOV  R0,RES_H
          CLR  C
          MOV  A,#9AH
          SUBB  A,R1       ;减数十进制求补
          ADD  A,R0
          DA  A
          MOV  R2,A        ;差值送R2
          JC  POSI         ;C=1，表示差值为正
 NEGA:    MOV  A,#9AH      ;差值为负，求补后得差值的绝对值
          SUBB  A,R2
          MOV  R2,A
          SETB  20H.5      ;显示负号标记
 POSI:    MOV  OUT_H,#00H
          MOV  OUT_L,R2
          CALL  T_CONV
          RET
;－－－－－－－－－－－－－－－－－－－－－－－－－
;乘法运算子程序
;单字节BCD码乘法子程序
;入口: R0(被乘数)、R1(乘数）
;出口: R3(高)、R2(低)，积为双字节，BCD码形式的积
;从乘数高位开始进行BCD码移位乘法
;－－－－－－－－－－－－－－－－－－－－－－－－－
SUMUL:
            MOV  R1,RES_L
            MOV  R0,RES_H
BCDMUL:
            CLR  A             ;积单元清零
            MOV  R2,A
            MOV  R3,A
            MOV  A,R1
            JZ  RETURN
            ANL  A,#0F0H        ;取乘数高位
            JZ  LBCD            ;乘数高位是否为0？
            SWAP  A
            MOV  R4,A
            ACALL  DDBCDM
            SWAP  A             ;BCD码左移一位
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
 LBCD:      MOV  A,R1            ;取乘数低位
            ANL  A,#0FH
            JZ  RETURN           ;乘数低位是否为0？
            MOV  R4,A
            ACALL  DDBCDM
RETURN:     MOV  OUT_H,R3
            MOV  OUT_L,R2
            CALL T_CONV
            RET

DDBCDM:                          ;一位BCD码乘法
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
;除法运算子程序

;单字节BCD码除法
;入口：R0(被除数)、R1(非零除数)
;出口：R2(商)、R3(余数)
;《MCS-51系列单片机实用子程序集锦》PAGE 73
;-----------------------------------------------
SUDIV:
              MOV  R1,RES_L
              MOV  R0,RES_H
BCDDIV:
              MOV  R2,#00H      ;商单元清零
              MOV  A,R1         ;除数求补
              CPL  A
              ADD  A,#9BH
              MOV  R1,A
              MOV  A,R0          ;被除数高位移入
              ANL  A,#0F0H       ;部分余单元
              SWAP  A
   LP0:       MOV  R3,A          ;做除法
              ADD  A,R1
              DA  A
              JNC  LP1           ;部分余数>=除数？
              INC  R2            ;商加1
              SJMP  LP0
   LP1:       MOV  A,R3          ;
              SWAP  A
              MOV  R3,A
              MOV  A,R2          ;商左移一位
              SWAP  A
              MOV  R2,A
              MOV  A,R0           ;移位
              ANL  A,#0FH
              ORL  A,R3
  LP2:        MOV  R3,A           ;做除法
              ADD  A,R1
              DA  A
              JNC  LP3
              INC  R2             ;商加1
              SJMP  LP2
  LP3:        MOV  A,R3           ;四舍五人
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
;  LCD 初始化设置
;-----------------------------------------------------
SET_LCD:
          CLR  LCD_EN
          CALL  INIT_LCD     ;初始化 LCD
          CALL  DELAY1
          MOV  DPTR,#INFO1   ;指针指到显示信息1
          MOV  A,#1          ;显示在第一行
          CALL  LCD_SHOW
          MOV  DPTR,#INFO2   ;指针指到显示信息2
          MOV  A,#2          ;显示在第二行
          CALL  LCD_SHOW
          RET
;-----------------------------------------------------
INFO1:  DB  "   CALCULATOR   ",0  ;LCD 第一行显示信息
INFO2:  DB  "                ",0  ;LCD 第二行显示信息
;----------------------------------------------------
INIT_LCD:                 ;8位I/O控制 LCD 接口初始化
          MOV  A,#38H     ;双列显示，字形5*7点阵
          CALL  WCOM
          CALL  DELAY1
          MOV  A,#38H     ;双列显示，字形5*7点阵
          CALL  WCOM
          CALL  DELAY1
          MOV  A,#38H     ;双列显示，字形5*7点阵
          CALL  WCOM
          CALL  DELAY1
          MOV  A,#0CH     ;开显示，关光标，
          CALL  WCOM
          CALL  DELAY1
          MOV  A,#01H     ;清除 LCD 显示屏
          CALL  WCOM
          CALL  DELAY1
          RET
;----------------------------------------------------
LCD_SHOW:       ;在LCD的第一行或第二行显示信息字符

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
          MOVC  A,@A+DPTR   ;由信息区取出字符
          CJNE  A,#0,LC1    ;判断是否为结束码
          RET
  LC1:    CALL  WDATA       ;写入数据
          INC  DPTR         ;指针加1
          JMP  FILL         ;继续填入字符
          RET
;---------------------------------------------------
CLR_LINE:                  ;清除该行 LCD 的字符
          MOV  R0,#24
   CL1:   MOV  A,#' '
          CALL  WDATA
          DJNZ  R0,CL1
          RET
;-----------------------------------------------------
; 写指令子程序
;RS=L,RW=L,D0-D7=指令码，E=高脉冲
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
;写数据子程序
;RS=H,RW=L,D0-D7=数据，E=高脉冲
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
;延时250微秒
;-----------------------------------------------------
DELAY0:
          MOV   R7,#125
          DJNZ  R7,$
          RET
;---------------------------------------------------
;在 LCD 第二行显示字符
;A=ASC DATA, B=LINE X POS
;---------------------------------------------------
LCDP2:
         PUSH  ACC        ;
         MOV  A,B         ;设置显示地址
         ADD  A,#0C0H     ;设置LCD的第二行地址
         CALL  WCOM       ;写入命令
         POP  ACC         ;由堆栈取出A
         CALL  WDATA      ;写入数据
         RET

;－－－－－－－－－－－－－－－－－－－－－－－－
;在指定位置显示运算数字与符号子程序
;－－－－－－－－－－－－－－－－－－－－－－－－
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
;－－－－－－－－－－－－－－－－－－－－－－－－－－
;
;－－－－－－－－－－－－－－－－－－－－－－－－－－
CONV:
          MOV   LCD_X,#3        ;设置显示起始位置
          MOV   A,R3
          ANL   A,#0FH      ;取出低四位二进制数
          PUSH  ACC          ;压入堆栈
          CLR   C            ;C=0
          SUBB  A,#0AH       ;减10
          POP   ACC          ;弹出堆栈
          JC    ASCII0       ;该数小于10，转ASCII0
          ;JMP  ASCII1
          ADD   A,#07H       ;大于10的数加上37H
ASCII0:   ADD   A,#30H       ;小于10的数加上30H
          MOV   B,LCD_X
          CALL  LCDP2
ASCII1:   ;MOV  A,R3
          RET

;-------------------------------------------------------
T_CONV:

          MOV   A,OUT_H          ;取高位数
          MOV  LCD_X,#11
          CJNE  A,#00H,T_CONV1   ;判高位数是否为0？
          SETB  20H.6            ;为0，20H.6置1
          JMP  T_CONV3           ;转取低位数
                                 ;高位数不为0，则
T_CONV1:  ANL A,#0F0H            ;判高位数的高四位是否为0？
          CJNE  A,#00H,T_CONV2   ;不为0，2位数都显示
          SETB  20H.6            ;为0，20H.6置1，只显示低四位
T_CONV2:  MOV  A,OUT_H
          CALL  SHOW_DIG2
          INC  LCD_X
          CLR  20H.6             ;清显示标记位

T_CONV3:  MOV  A,OUT_L           ;取低位数
          JNB  20H.6,T_CONV5     ;高位数有显示，则不判低位数。
          ANL  A,#0F0H           ;高位数无显示，则判低位数。
          CJNE  A,#00H,T_CONV4   ;判低位数的高四位是否为0？
          SETB  20H.6            ;为0，20H.6置1，只显示低四位
          MOV  A,OUT_L
          JMP  T_CONV5
T_CONV4:  CLR  20H.6             ;低位数不为0，2位数都显示
          MOV  A,OUT_L

T_CONV5:  CALL  SHOW_DIG2
          CLR  20H.6             ;清显示标记位
          RET
;－－－－－－－－－－－－－－－－－－－－－－－－－－－－
;在 LCD 的第二行显示数字与符号
;－－－－－－－－－－－－－－－－－－－－－－－－－－－－
SHOW_DIG2:
          JNB  20H.5,DIG2    ;符号标记
          MOV  TEMP3,A
          MOV  A,#2DH        ;显示负号
          MOV  B,LCD_X
          CALL  LCDP2
          MOV  A,TEMP3
          INC  LCD_X
 DIG2:    MOV  B,#16         ;设置被除数
          DIV  AB            ;结果A存商数，B存余数
          JNB  20H.6,DIG3    ;显示位标记
          MOV  A,#20H
          JMP  DIG4
DIG3:     ADD  A,#30H        ;A为十位数，转换为字符
DIG4:     PUSH  B            ;B放入堆栈暂存
          MOV  B,LCD_X           ;设置 LCD 显示的位置
          CALL  LCDP2        ;由 LCD 显示出来
          POP  B             ;
          MOV  A,B           ;B为个位数
          ADD  A,#30H        ;转换为字符
          INC  LCD_X             ;LCD 显示位置加1
          MOV  B,LCD_X           ;设置 LCD 显示的位置
          CALL  LCDP2        ;由 LCD 显示出来
          RET
;--------------------------------------------------------
;蜂鸣器响一声子程序
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
;延时R5×10MS
;-----------------------------------------------------
DELAY:
         MOV  R6,#50
  D1:    MOV  R7,#100
         DJNZ  R7,$
         DJNZ  R6,D1
         DJNZ  R5,DELAY
         RET
;-----------------------------------------------------
;延时5MS
;-----------------------------------------------------
DELAY1:
         MOV  R6,#25
  D2:    MOV  R7,#100
         DJNZ  R7,$
         DJNZ  R6,D2
         RET
;-----------------------------------------------------
         END
