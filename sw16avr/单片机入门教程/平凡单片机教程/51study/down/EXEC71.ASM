	org	0000H
	AJMP	START
	ORG	30H
START:                           
        mov     SP,#5fh         ;
        mov     TMOD,#20h       ;T1: 工作模式2
        mov     PCON,#80h       ;SMOD=1
        mov     TH1,#0FDH       ;初始化波特率（参见表）
        mov     SCON,#50h       ;Standard UART settings
        MOV     R0,#0AAH	;准备送出的数
	SETB	REN		;允许接收
        SETB    TR1		;T1开始工作
WAIT:
        MOV     A,R0		
        CPL     A
        MOV     R0,A
        MOV     SBUF,A
        LCALL   DELAY   
        JBC     TI,WAIT1        ;如果TI等于1，则清TI并转WAIT1
        AJMP    WAIT
WAIT1:  JBC     RI,READ		;如果RI等于1，则清RI并转READ
        AJMP    WAIT1
READ:
        MOV     A,SBUF		;将取得的数送P1口
        MOV     P1,A
        LJMP    WAIT
DELAY:				;延时子程序
        MOV     R7,#0ffH
        DJNZ    R7,$
        RET
        END
