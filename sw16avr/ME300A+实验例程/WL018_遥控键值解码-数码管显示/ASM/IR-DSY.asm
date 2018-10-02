;********************************************************************************
;*  标题:  伟纳电子ME300B单片机开发系统演示程序 - 遥控键值解码-数码管显示       *
;*  文件:  IR-DSY.asm                                                           *
;*  日期:  2005-3-20                                                            *
;*  版本:  1.0                                                                  *
;*  作者:  gguoqing                                                             *
;*  邮箱:  gguoqing@willar.com                                                  *
;*  网站： http://www.willar.com                                                *
;********************************************************************************
;*  描述:                                                                       *
;*          ME300B 遥控键值读取器                                               *
;*         数码管显示, P0口为数码管的数据口                                     *
;*                                                                              *
;*         K17键按下，继电器吸合。K19键按下，继电器关闭。                       *
;*                                                                              *
;********************************************************************************
;* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
;* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
;********************************************************************************

;-----------------------------------------------
       IRCOM  EQU  20H       ;20H-23H IR使用

       IRIN   EQU  P3.2
       BEEP   EQU  P3.7
       RELAY  EQU  P1.3
;------------------------------------------------
         ORG 0000H
         JMP  MAIN

         ORG 0003H         ;外部中断INT0入口地址
         JMP  IR_IN
;------------------------------------------------
MAIN:
          MOV   SP,#60H
          MOV   A,#00H
          MOV   R0,#20H
LOOP0:    MOV   @R0,A          ;20H-27H清零
          INC   R0
          CJNE  R0,#28H,LOOP0
          MOV  IE,#81H       ;允许总中断中断,使能 INT0 外部中断
          MOV  TCON,#01H     ;触发方式为脉冲负边沿触发

          SETB  IRIN
          SETB  BEEP
          SETB  RELAY
          CALL  IR_SHOW

LOOP1:
          CALL  IR_SHOW
          MOV  A,22H
          CJNE  A,#40H,LOOP2    ;K17键按下
          CLR   RELAY           ;继电器吸合
LOOP2:    CJNE  A,#04H,LOOP3    ;K19键按下
          SETB  RELAY           ;继电器关闭
LOOP3:    JMP   LOOP1

;---------------------------------------------------
; IR 译码子程序
;---------------------------------------------------
IR_IN:
          CLR EA         ;暂时关闭CPU的所有中断请求
          PUSH  ACC
          PUSH  PSW
          SETB  PSW.3     ;选择工作寄存器组1
          CLR   PSW.4
          MOV   R2,#04H
          MOV   R0,#IRCOM
 I1:      JNB  IRIN,I2       ;等待 IR 信号出现
          DJNZ  R2,I1
          JMP  IR_OUT        ;IR信号没出现，退出。
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
 I5:      MOV  R2,#0         ;0.14ms 计数
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
          CJNE  R0,#24H,LL   ;收集到4字节了
          JMP  IR_COMP
 N1:      INC  R2
          CJNE  R2,#30,L1    ;0.14ms 计数过长则时间到自动离开

IR_OUT:   POP  PSW
          POP  ACC
          SETB  EA
          RETI
;---------------------------------------------------------------
;键值比较与键值数据处理
;22H存入用户编码，23H存入用户编码的反码
;---------------------------------------------------------------
IR_COMP:
          MOV A,22H
          CPL A                ;将22H取反后和23H比较
          CJNE A,23H,IR_OUT    ;如果不等表示接收数据发生错误,放弃
IR_CHULI:
          MOV  A,22H
          ANL  A,#0FH
          MOV  25H,A           ;送个位显示单元
          MOV  A,22H
          ANL  A,#0F0H
          SWAP  A
          MOV  26H,A           ;送十位显示单元
          CALL  IR_SHOW        ;显示键值
          CALL  BEEP_BL        ;蜂鸣器鸣响表示解码成功
          JMP  IR_OUT

;=======================================================
;键值显示
;=======================================================
IR_SHOW:
             MOV   A,25H               ;取显示数据到A
             MOV   DPTR,#TAB           ;取段码表地址
             MOVC  A,@A+DPTR           ;查显示数据对应段码
             MOV   P0,A                ;段码放入P0口
             CLR   P2.7
             SETB  P2.6
             LCALL  DELAY1
             MOV   A,26H               ;取显示数据到A
             MOV   DPTR,#TAB           ;取段码表地址
             MOVC  A,@A+DPTR           ;查显示数据对应段码
             MOV   P0,A                ;段码放入P0口
             CLR   P2.6
             SETB  P2.7
             LCALL  DELAY1
             RET
;-----------------------------------------------------
TAB:
 DB  0C0H,0F9H,0A4H,0B0H,99H,92H,82H,0F8H
 DB  80H,90H,88h,83h,0c6h,0a1h,86h,8eh        ;0－F
;-----------------------------------------------------

;--------------------------------------------------------
;蜂鸣器响一声子程序
;--------------------------------------------------------
BEEP_BL:
         MOV  R6,#100
  BL1:   CALL  DEX1
         CPL  BEEP
         DJNZ  R6,BL1
         MOV  R5,#20
         CALL  DELAY
         RET
 DEX1:   MOV  R7,#180
 DEX2:   NOP
         DJNZ  R7,DEX2
         RET
 DELAY:                    ;延时R5×10MS
         MOV  R6,#25
  D1:    MOV  R7,#100
         DJNZ  R7,$
         DJNZ  R6,D1
         DJNZ  R5,DELAY
         RET
;------------------------------------------------
; DELAY  R5*0.14MS
DEL:
          MOV  R5,#1       ;IR解码使用
DEL0:     MOV  R6,#2
DEL1:     MOV  R7,#32
DEL2:     DJNZ  R7,DEL2
          DJNZ  R6,DEL1
          DJNZ  R5,DEL0
          RET
;-------------------------------------------------
DELAY1:                    ;数码管延时4MS

         MOV  R6,#20
  DL2:   MOV  R7,#100
         DJNZ  R7,$
         DJNZ  R6,DL2
         RET
;-------------------------------------------------
        END               ;结束

;================================
;DT9122D 遥控器（伟纳电子）

;******  红外遥控器键值表  ******

;  10     03      01      06
;  09     1D      1F      0D
;  19     1B      11      15
;  17     12      16      4C
;  40     48      04      00
;  02     05      54      4D
;  0A     1E      0E      1A
;  1C     14      0F      0C
;================================

