A_BIT EQU 20H                  ;个位数存放处
B_BIT EQU 21H                  ;十位数存放处
TEMP EQU 22H                   ;计数器寄存处
STAR: MOV TEMP,#0              ;初始化计数器
STLOP: ACALL DISPLAY           ;
       INC TEMP
       MOV A,TEMP
       CJNE A,#100,NEXT        ;等于100重来
       MOV TEMP,#0

    NEXT: LJMP STLOP

;显示子程序
DISPLAY: MOV A,TEMP
         MOV B,#10
	 DIV AB 
	 MOV B_BIT,A
	 MOV A_BIT,B
	 MOV DPTR,#NUMTAB
	 MOV R0,#4

DPL1:   MOV R1,#5
DPLOP:  MOV A,A_BIT
        MOVC A,@A+DPTR
	MOV P0,A
	CLR P2.7
	ACALL D1MS
	SETB P2.7
	MOV A,B_BIT
	MOVC A,@A+DPTR
	MOV P0,A
	CLR P2.6
	ACALL D1MS
	SETB P2.6
	DJNZ R1,DPLOP
	DJNZ R0,DPL1
	RET
D1MS:
   MOV R7,#50
   D1: MOV R6,#20
   D2: DJNZ R6,$
       DJNZ R7,D1
       RET

NUMTAB:
DB 0C0H,0F9H,0A4H,0B0H,99H,92H,82H,0F8H,80H,90H   ;013456789字形码


END
