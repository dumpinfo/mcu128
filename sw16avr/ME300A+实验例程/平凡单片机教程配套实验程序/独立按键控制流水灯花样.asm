; 使用独立按键K1，K2，K4，K4实现流水灯花样变化
; (K1）P1.4  开始按此键则灯开始流动(由左向右) 
;（K2）P1.5  停止按此键则停止流动所有灯为灭 
; (K3）P1.6  向左按此键则灯反向流动由右向左 
;（K4）P1.7  向右按此键则灯正向流动由左向右 

UpDown EQU 00H ;上下行标志
StartEnd EQU 01H ;起动及停止标志
LAMPCODE EQU 21H ;存放流动的数据代码
ORG 0000H
AJMP MAIN
ORG 30H
MAIN:
MOV SP,#5FH
MOV P0,#0FFH
CLR UpDown ;启动时处于向上的状态
CLR StartEnd ;启动时处于停止状态
MOV LAMPCODE,#0FEH ;单灯流动的代码 
LOOP:
ACALL KEY ;调用键盘程序
JNB F0,LNEXT ;如果无键按下，则继续
ACALL KEYPROC ;否则调用键盘处理程序
LNEXT:
ACALL LAMP ;调用灯显示程序
AJMP LOOP ;反复循环，主程序到此结束
;---------------------------------------
DELAY:
MOV R7,#100
D1: MOV R6,#100
DJNZ R6,$
DJNZ R7,D1
RET
;----------------------------------------延时程序，键盘处理中调用

KEYPROC:
MOV A,B ;从B寄存器中获取键值
JB ACC.4,KeyStart ;分析键的代码，某位被按下，则该位为1（因为在键盘程序中已取反）
JB ACC.5,KeyOver
JB ACC.6,KeyUp
JB ACC.7,KeyDown
AJMP KEY_RET
KeyStart:
SETB StartEnd ;第一个键按下后的处理
AJMP KEY_RET
KeyOver:
CLR StartEnd ;第二个键按下后的处理
AJMP KEY_RET
KeyUp: SETB UpDown ;第三个键按下后的处理
AJMP KEY_RET
KeyDown:
CLR UpDown ;第四个键按下后的处理
KEY_RET:RET
KEY:
CLR F0 ;清F0，表示无键按下。
ORL P1,#11110000B ;将P1口的接有键的四位置1
MOV A,P1 ;取P3的值
ORL A,#00001111B ;将其余4位置1
CPL A ;取反
JZ K_RET ;如果为0则一定无键按下
ACALL DELAY ;否则延时去键抖
ORL P1,#11110000B
MOV A,P1
ORL A,#00001111B
CPL A
JZ K_RET
MOV B,A ;确实有键按下，将键值存入B中
SETB F0 ;设置有键按下的标志
K_RET: 
ORL P1,#11110000B ;此处循环等待键的释放
MOV A,P1
ORL A,#00001111B
CPL A
JZ K_RET1 ;直到读取的数据取反后为0说明键释放了，才从键盘处理程序中返回
AJMP K_RET
K_RET1: 
RET
;----------------------------------- 
D500MS: ;流水灯的延迟时间
PUSH PSW
SETB RS0
MOV R7,#200
D51: MOV R6,#250
D52: NOP
NOP
NOP
NOP
DJNZ R6,D52
DJNZ R7,D51
POP PSW
RET 
;-----------------------------------
LAMP:
JB StartEnd,LampStart ;如果StartEnd=1，则启动
MOV P0,#0FFH
AJMP LAMPRET ;否则关闭所有显示，返回
LampStart:
JB UpDown,LAMPUP ;如果UpDown=1，则向上流动
MOV A,LAMPCODE
RL A ;实际就是左移位而已
MOV LAMPCODE,A 
MOV P0,A
LCALL D500MS
AJMP LAMPRET
LAMPUP:
MOV A,LAMPCODE
RR A ;向下流动实际就是右移
MOV LAMPCODE,A
MOV P0,A
LCALL D500MS
LAMPRET: 
RET
END

