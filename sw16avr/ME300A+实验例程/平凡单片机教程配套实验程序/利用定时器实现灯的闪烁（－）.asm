ORG 0000H
AJMP START
ORG 30H
START: MOV P0,#0FFH  ;关闭所有的灯
MOV TMOD,#00000001B  ;定时/计数器0工作于方式1
MOV TH0,#15H
MOV TL0,#0A0H        ;以上两行预置计数5336（15A0H）
SETB TR0             ;定时/计数器0开始运行
LOOP: JBC TF0,NEXT   ;如果TF0等于1，则将TF0清0并转next处
AJMP LOOP            ;否则跳转到LOOP处运行
NEXT: CPL P0.0       ;点亮P0.0灯
MOV TH0,#15H         ;
MOV TL0,#0A0H        ;重置定时/计数器的初值
AJMP LOOP
END

