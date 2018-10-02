						   ;使GPIO Port B作为输出口 
   AREA PROGRAM, CODE, READONLY

LEDFLASH    EQU	0x61
PORTADIR	    EQU	0xFF          
PORTDDIR	    EQU	0x00
PORTB	    EQU	0x0F
PORTA	    EQU	0xAA
PORTD	    EQU	0x2A                               ;Port A/B/D

SBADDR      EQU  0x80000000
rMEMCFG1    EQU  SBADDR+0x0180
rMEMCFG2    EQU  SBADDR+0x01C0

FlashBase	     EQU  0x70000000                ; Flash基址
HwRegBase	     EQU  0x80000000                ;寄存器基址
hw_syscon1  	EQU	  0x0100
hw_uart1	     EQU  0x0100                    ;串口
hw_9600		EQU	  0x0017
hw_sysflg1	     EQU  0x0140                    ;标志位
hw_sysflg2	     EQU  0x1140

hw_wrdlen8	     EQU  0x00060000
hw_ubrlcr1	     EQU  0x04c0
hw_uartdr1	     EQU	  0x0480
hw_uart1busy	EQU	  0x00000800                ;串口忙
hw_urxfe1	     EQU	  0x00400000
hw_utxff1	     EQU	  0x00800000
bootbase	     EQU	  0x00000000        ;引导基址
bootlength	     EQU  0x0080                    ;引导长度

	ENTRY                                       ;程序入口

MemConfig1value  EQU 0x00000004
MemConfig2value  EQU 0x00000000                     ;rom引导和内部SRAM忽略      
                                                    ; 配置nCS0-nCS3
        ldr r1,=MemConfig1value
        ldr r12,=rMEMCFG1
        str r1,[r12]                                ;MEMCFG1 = 0x8000.0180
                                                    ;配置nCS4 &nCS5
        ldr r1,=MemConfig2value
        ldr r12,=rMEMCFG2
        str r1,[r12]                                ;MEMCFG2 = 0x8000.01c0

	ldr	r0, =0x80002000
	mov r1,#LEDFLASH                            ;r1=0x61
	str r1,[r0,#0x2c0]
	ldr	r12, =0x80000000
	ldrb	r1,=PORTADIR
	strb 	r1,[r12,#0x40]
	ldrb	r1,=PORTDDIR
	strb	r1,[r12,#0x43]
	ldrb	r1,=PORTA
	strb	r1,[r12,#0x00]	
	ldrb	r1,=PORTD
	strb	r1,[r12,#0x03]
	mov r7,#'('
	str r7,[r12,#hw_uartdr1]

	mov r2,#FlashBase
	add r3,r2,#bootlength
sentloop 	                                    ;发送循环
	mov r4,#0x001
	mov r5,#0x100
	nop	
	wait
	ldr r4,[r12,#hw_sysflg1]
	ldrb	r1,=0x20
	strb	r1,[r12,#0x03]
	tst r4,#hw_utxff1                           ;测试位
	ldrb	r1,=0x08
	strb	r1,[r12,#0x03]	
	
	beq gopp                             	    ;相等跳转
	b wait                                      ;否则等待
gopp
	ldrb	r1,=0x40
	strb	r1,[r12,#0x03]
 	ldrb r7,[r2],#1
 	str r7,[r12,#hw_uartdr1]
	ldrb	r1,=0x10
	strb	r1,[r12,#0x03]

	cmp r2,r3                                   ;比较r2、r3
 	blt sentloop                                ;r2<r3，继续发送
 
	mov r7,#')'
	str r7,[r12,#hw_uartdr1] 
current	 	                                    ;原地跳转
	b current
	;
        END                                         ;程序结束
