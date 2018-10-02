;按压K1（P1.4）,D00交替亮灭。按压K2（P1.5），D01交替亮灭
ORG 000H
AJMP START
ORG 30H
START: MOV SP,5FH
MOV P0,#0FFH
MOV P1,#0FFH
L1: JNB P1.4,L2      ;按下按键开关K1，取反一次P0.0（灯亮），再按一下灭
JNB P1.5,L3          ;按下按键开关K2，取反一次P0.1（灯亮），再按一下灭
LJMP L1
L2: CPL P0.0
LJMP L1
L3: CPL P0.1
LJMP L1
END
