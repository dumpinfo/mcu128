        org     0000H
	AJMP	START
        org     0023h
        AJMP    SERIAL  ;
	ORG	30H
START:                           
        mov     SP,#5fh         ;
        mov     TMOD,#20h       ;T1: ����ģʽ2
        mov     PCON,#80h       ;SMOD=1
        mov     TH1,#0FDH       ;��ʼ�������ʣ��μ���
        mov     SCON,#50h       ;Standard UART settings
        MOV     R0,#0AAH	;׼���ͳ�����
	SETB	REN		;�������
        SETB    TR1		;T1��ʼ����
        SETB	EA		;�����ж�
        SETB	ES		;�������ж�
        SJMP    $        
SERIAL:
        MOV     A,SBUF		
        MOV     P1,A
        CLR     RI		
        RETI
        END
