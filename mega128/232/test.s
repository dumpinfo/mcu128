	.module test.c
	.area lit(rom, con, rel)
_buffer::
	.byte 'h,'t,'t,'p,58,47,47,'w,'w,'w,46,'a,'v,'r,'v,'i
	.byte 46,'c,'o,'m,0
	.dbfile F:\工程文件\avr\例程\mega128\232\test.c
	.dbsym e buffer _buffer A[21:21]kc
	.area text(rom, con, rel)
	.dbfile F:\工程文件\avr\例程\mega128\232\test.c
	.dbfunc e USART0_Init _USART0_Init fV
;            tmp -> R10,R11
;           baud -> R10,R11
	.even
_USART0_Init::
	xcall push_gset3
	movw R10,R16
	.dbline -1
	.dbline 8
; #include <iom128v.h>
; #include <macros.h>
; 
; #define F_CPU 2000000
; const unsigned char buffer[]="http://www.avrvi.com";
; 
; void USART0_Init( unsigned int baud )
; {
	.dbline 11
; unsigned int tmp;
; /* 设置波特率*/
; tmp= F_CPU/baud/16-1;
	movw R2,R10
	clr R4
	clr R5
	ldi R20,128
	ldi R21,132
	ldi R22,30
	ldi R23,0
	st -y,R5
	st -y,R4
	st -y,R3
	st -y,R2
	movw R16,R20
	movw R18,R22
	xcall div32s
	ldi R20,16
	ldi R21,0
	ldi R22,0
	ldi R23,0
	st -y,R23
	st -y,R22
	st -y,R21
	st -y,R20
	xcall div32s
	movw R2,R16
	movw R4,R18
	ldi R20,1
	ldi R21,0
	ldi R22,0
	ldi R23,0
	sub R2,R20
	sbc R3,R21
	sbc R4,R22
	sbc R5,R23
	movw R10,R2
	.dbline 12
; UBRR0H = (unsigned char)(tmp>>8);
	mov R2,R3
	clr R3
	sts 144,R2
	.dbline 13
; UBRR0L = (unsigned char)tmp;
	out 0x9,R10
	.dbline 15
; /* 接收器与发送器使能*/
; UCSR0B = (1<<RXEN0)|(1<<TXEN0);
	ldi R24,24
	out 0xa,R24
	.dbline 17
; /* 设置帧格式: 8 个数据位, 1个停止位*/
; UCSR0C = (1<<UCSZ00)|(1<<UCSZ01);
	ldi R24,6
	sts 149,R24
	.dbline -2
	.dbline 18
; }
L1:
	xcall pop_gset3
	.dbline 0 ; func end
	ret
	.dbsym r tmp 10 i
	.dbsym r baud 10 i
	.dbend
	.dbfunc e USART0_Transmit _USART0_Transmit fV
;           data -> R16
	.even
_USART0_Transmit::
	.dbline -1
	.dbline 22
; 
; // 数据发送【发送5 到8 位数据位的帧】
; void USART0_Transmit( unsigned char data )
; {
L3:
	.dbline 25
L4:
	.dbline 24
; /* 等待发送缓冲器为空 */
; while ( !( UCSR0A & (1<<UDRE0)) )
	sbis 0xb,5
	rjmp L3
	.dbline 27
; ;
; /* 将数据放入缓冲器，发送数据 */
; UDR0 = data;
	out 0xc,R16
	.dbline -2
	.dbline 28
; } 
L2:
	.dbline 0 ; func end
	ret
	.dbsym r data 16 c
	.dbend
	.dbfunc e USART0_Receive _USART0_Receive fc
	.even
_USART0_Receive::
	.dbline -1
	.dbline 33
; 
; 
; // 数据接收【以5 到8 个数据位的方式接收数 据帧】
; unsigned char USART0_Receive( void )
; {
L7:
	.dbline 36
L8:
	.dbline 35
; /* 等待接收数据*/
; while ( !(UCSR0A & (1<<RXC0)) )
	sbis 0xb,7
	rjmp L7
	.dbline 38
; ;
; /* 从缓冲器中获取并返回数据*/
; return UDR0;
	in R16,0xc
	.dbline -2
L6:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e main _main fV
;              n -> R20
;            tmp -> R20
	.even
_main::
	.dbline -1
	.dbline 45
; } 
; 
; 
; 
; 
; void main(void)
; {
	.dbline 46
; unsigned char n=0,tmp=0;
	clr R20
	.dbline 46
	.dbline 48
; 
; USART0_Init(9600); //波特率9600 初始化串口
	ldi R16,9600
	ldi R17,37
	xcall _USART0_Init
	xjmp L12
L11:
	.dbline 52
; // uart0_init();
; 
; while(1)
; {
	.dbline 53
; if(UCSR0A&(1<<RXC0)) //如果接收缓存区有数据
	sbis 0xb,7
	rjmp L14
	.dbline 54
; {
	.dbline 55
; tmp=USART0_Receive(); //接收数据
	xcall _USART0_Receive
	mov R20,R16
	.dbline 56
; USART0_Transmit(tmp); //发送数据
	xcall _USART0_Transmit
	.dbline 58
; 
; }
L14:
	.dbline 59
L12:
	.dbline 51
	xjmp L11
X0:
	.dbline -2
	.dbline 60
; }
; }
L10:
	.dbline 0 ; func end
	ret
	.dbsym r n 20 c
	.dbsym r tmp 20 c
	.dbend
