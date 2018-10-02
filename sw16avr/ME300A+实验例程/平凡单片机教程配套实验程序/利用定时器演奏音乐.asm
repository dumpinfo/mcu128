ORG  001BH   ;定时器T1的中断入口 
MOV  TH1,R1  ;重装定时初值 
MOV  TL1,R0  ; 
CPL  P3.7      ;P1.0输出方波 
RETI           ;中断返回 
ORG  100H     ;主程序 
START:MOV  TMOD,#01H ;定时器T1工作方式1 
MOV  IE,#88H           ;允许T1中断 
MOV  DPTR,#TAB        ;表格首地址 
LOOP:CLR  A           ; 
MOVC  A,@A+DPTR     ;查表 
MOV  R1,A              ;定时器高8为存R1 
INC  DPTR              ; 
CLR  A                 ; 
MOVC  A,@A+DPTR     ;查表 
MOV  R0,A              ;定时器低8为存R0 
ORL  A,R1               ; 
JZ  NEXT0               ;全0为休止符 
MOV  A,R0              ; 
ANL  A,R1               ; 
CJNE  A,#0FFH,NEXT     ;全1表示乐曲结束 
SJMP  START              ;从头开始循环演奏 
NEXT:MOV  TH1,R1       ;装入定时值 
MOV  TL1,R0             ; 
SETB  TR1                ;启动定时器 
SJMP  NEXT1             ; 
NEXT0:CLR  TR1          ;关闭定时器停止发音 
NEXT1:CLR  A            ; 
INC  DPTR                ; 
MOVC  A,@A+DPTR       ;查延迟常数 
MOV  R2,A                ; 
LOOP1:LCALL  D200       ;调用延时200mS子程序 
DJNZ  R2,LOOP1           ;控制延迟次数 
INC  DPTR                 ; 
AJMP  LOOP               ;处理下一个音符 
D200:MOV  R4,#81H        ;延时20mS子程序 
D200B:MOV  A,#0FFH      ; 
D200A:DEC  A             ; 
JNZ  D200A                ; 
DEC  R4                   ; 
CJNE  R4,#00H,D200B       ; 
RET                        ; 
TAB:      DB  0FEH,25H,02H,0FEH,25H,02H;   
          DB  0FEH,84H,02H,0FEH,84H,02H; 
          DB  0FEH,84H,04H,0FEH,25H,04H;    
	  DB  0FEH,25H,02H,0FEH,84H,02H; 
          DB  0FEH,0C0H,04H,0FEH,0C0H,04H; 
	  DB  0FEH,98H,02H,0FEH,84H,02H; 
          DB  0FEH,57H,08H,00H,00H,04H;     
	  DB  0FFH,0FFH; 
          END 

