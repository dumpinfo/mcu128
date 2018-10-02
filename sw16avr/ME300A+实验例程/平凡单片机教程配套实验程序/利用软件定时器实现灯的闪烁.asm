;用软件定时器实现P0.0口所接灯按1S/次而P0.1口所接灯按2S/次闪烁
ORG 0000H
AJMP START
ORG 000BH                ;定时器0的中断向量地址
AJMP TIME0               ;跳转到真正的定时器程序处
ORG 0030H
START: MOV P0,#0FFH      ;关所有灯
MOV 30H,#00H             ;软件计数器清零
MOV TMOD,#00000001B      ;定时/计数器0工作于方式1
MOV TH0,#3CH 
MOV TL0,#0A0H            ;以上两行预置立即数15536
SETB EA                  ;开总中断允许
SETB ET0                 ;开定时/计数器0允许
SETB TR0                 ;定时/计数器0开始运行
LOOP: AJMP LOOP          ;真正工作时,这里可写任意程序
TIME0:                   ;定时器0的中断处理程序
PUSH ACC                 ;将ACC推入堆栈保护
PUSH PSW                 ;将PSW推入堆栈保护
INC 30H
INC 31H                  ;两个计数器都加1
MOV A,30H
CJNE A,#255,TNEXT         ;30H单元中的值到了20了吗         
CPL P0.0                 ;到了，取反P0.0
MOV 30H,#0               ;清软件计数器
TNEXT:MOV A,31H
CJNE A,#40,TRET           ;31H单元中的值到了40了吗
CPL P0.1
MOV 31H,#0                ;到了，取反P1.1并清零计数器，返回
TRET: MOV TH0,#15H        ;重置定时常数
MOV TL0,#9FH            
POP PSW
POP ACC
RETI
END

