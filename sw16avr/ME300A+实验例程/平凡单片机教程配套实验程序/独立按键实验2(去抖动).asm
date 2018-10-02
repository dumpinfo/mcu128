;按压K1（P1.4）,D00交替亮灭。按压K2（P1.5），D01交替亮灭,加入去抖动功能
ORG 000H
AJMP START
ORG 30H
START: MOV SP,5FH
MOV P0,#0FFH
MOV P1,#0FFH
L1: JB P1.4,L2        ;P1.4为1，不做处理，转P1.5，否则说明有键按下
LCALL D10MS           ;调用延时程序，去除抖动
JB P1.4,L1            ;p1.4为0，说明此键被按下了
CPL P0.0              ;取反P0.0
L3: JNB P1.4,L3       ;直到P1.4释放后去判断第二个键
L2: JB P1.5,L1        ;P1.5为1,返回去继续处理P1.4
LCALL D10MS           ;调用延时程序，去除抖动
  JB P1.5,L2          ;p1.5为0，说明此键被按下了
  CPL P0.1            ;取反P0.1
L4: JNB P1.5,L4       ;直到P1.5释放为止
LJMP L1               ;返回

D10MS: MOV R7,#50     ;延时的时间一般为5-20ms
     D1:MOV R6,#100
     D2:DJNZ R6,D2
     DJNZ R7,D1
     RET

 END


