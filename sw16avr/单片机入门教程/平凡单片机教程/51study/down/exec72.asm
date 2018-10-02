        org     0000H
	AJMP	START
        org     0023h
        AJMP    SERIAL  ;
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
        SETB	EA		;开总中断
        SETB	ES		;开串口中断
        SJMP    $        
SERIAL:
        MOV     A,SBUF		
        MOV     P1,A
        CLR     RI		
        RETI
        END
