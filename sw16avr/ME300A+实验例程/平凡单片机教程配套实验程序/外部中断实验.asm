;
ORG 0000H 
AJMP START 
ORG 0003H              ;�ⲿ�жϵ�ֱ��� 
AJMP INTO 
ORG 30H 
START: MOV SP,#5FH 
MOV P0,#0FFH           ;��ȫ�� 
MOV P3,#0FFH           ;P3���øߵ�ƽ 
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


