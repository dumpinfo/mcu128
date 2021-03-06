ORG 0000H
AJMP START
ORG 000BH                ;定时器0的中断向量地址
AJMP TIME0               ;跳转到真正的定时器程序处
ORG 30H
START: MOV P0,#0FFH      ;关所有灯
MOV TMOD,#00000001B      ;定时/计数器0工作于方式1
MOV TH0,#15H 
MOV TL0,#0A0H            ;以上两行预置立即数5536
SETB EA                  ;开总中断允许
SETB ET0                 ;开定时/计数器0允许
SETB TR0                 ;定时/计数器0开始运行
LOOP: AJMP LOOP          ;真正工作时,这里可写任意程序
mov r7, #09H
djnz r7,start
TIME0:                   ;定时器0的中断处理程序
PUSH ACC                 ;将ACC推入堆栈保护
PUSH PSW                 ;将PSW推入堆栈保护
CPL P0.0                 ;取反P0.0
MOV TH0,#15H
MOV TL0,#0A0H            ;重置定时常数
POP PSW
POP ACC
RETI
END

