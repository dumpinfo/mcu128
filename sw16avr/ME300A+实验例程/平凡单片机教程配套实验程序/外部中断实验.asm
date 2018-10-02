;
ORG 0000H 
AJMP START 
ORG 0003H              ;外部中断地直入口 
AJMP INTO 
ORG 30H 
START: MOV SP,#5FH 
MOV P0,#0FFH           ;灯全灭 
MOV P3,#0FFH           ;P3口置高电平 
SETB EA 
SETB EX0 
AJMP $ 
INTO: 
PUSH ACC 
PUSH PSW 
CPL P0.0 
POP PSW 
POP ACC 
RETI 
END 


