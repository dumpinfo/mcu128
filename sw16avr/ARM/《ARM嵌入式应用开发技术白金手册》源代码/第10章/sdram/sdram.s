;Enable GPIO Port B as Outputs, 

 AREA PROGRAM, CODE, READONLY



LEDFLASH	EQU	0x61
PORTADIR	EQU	0xFF
PORTDDIR	EQU	0x00
PORTB	EQU	0x0F
PORTA	EQU	0xAA
PORTD	EQU	0x2A

SBADDR        EQU 0x80000000
rMEMCFG1      EQU SBADDR+0x0180
rMEMCFG2      EQU SBADDR+0x01C0

SdramBase	EQU	0xC0000000
FlashBase	EQU	0x70000000
HwRegBase	EQU	0x80000000
hw_syscon1	equ	0x0100
hw_syscon3	equ	0x2200
hw_uart1	equ	0x0100
hw_9600		equ	0x0017
hw_sysflg1	equ	0x0140
hw_sysflg2	equ	0x1140

hw_wrdlen8	equ	0x00060000
hw_ubrlcr1	equ 0x04c0
hw_uartdr1	equ	0x0480
hw_uart1busy	equ	0x00000800
hw_urxfe1	equ	0x00400000
hw_utxff1	equ	0x00800000


bootbase	equ	0x00000000
bootlength	equ	0x0080


	;
 ENTRY
 
MemConfig1value  EQU 0x00000004
MemConfig2value  EQU 0x00000000     ;boot rom and internal SRAM are ignored         
        ;
        ; configure nCS0-nCS3
        ;
        ldr r1,=MemConfig1value
        ldr r12,=rMEMCFG1
        str r1,[r12]                ;MEMCFG1 = 0x8000.0180
        ;
        ; configure nCS4 &nCS5
        ;
        ldr r1,=MemConfig2value
        ldr r12,=rMEMCFG2
        str r1,[r12]                ;MEMCFG2 = 0x8000.01c0


 ;Init SDRAM READ
 
DRAMZ	equ	0x00000004

	ldr r0,=HwRegBase;	
	ldr r3,=0x2000;	Local offset of memory
	add r4,r3,r0;
	ldr r1,[r4,#0x200]
	orr r1, r1 , #DRAMZ
	str r1,[r4,#0x200];
	
	ldr r0,=HwRegBase;	
	ldr r3,=0x2000;	Local offset of memory
	add r4,r3,r0;
	ldr r1,=0x5C3;  CAS=3, 128Mbit, 32 bits width
	str r1,[r4,#0x300];
	ldr r1,=0x100;
	str r1,[r4,#0x340];

	ldr	r0, =0x80002000
	mov r1,#LEDFLASH
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
	
	mov r12,#HwRegBase	
	ldr r7,[r12,#hw_syscon1]
	orr r7,r7,#hw_uart1
	str	r7,[r12,#hw_syscon1]
	mov r7,#hw_9600
	orr r7,r7,#hw_wrdlen8
	str r7,[r12,#hw_ubrlcr1]
 	

	mov r7,#'('
	str r7,[r12,#hw_uartdr1]

	mov r2,#SdramBase
	add r3,r2,#bootlength
	
sentloop 	
	mov r4,#0x001
	mov r5,#0x100
	nop	
wait
	ldr r4,[r12,#hw_sysflg1]
	ldrb	r1,=0x20
	strb	r1,[r12,#0x03]
	tst r4,#hw_utxff1
	ldrb	r1,=0x08
	strb	r1,[r12,#0x03]	
;	beq wait

;	add r4,r4,#0x01
;	cmp r4,r5
	
	beq gopp
	b wait

gopp
	ldrb	r1,=0x40
	strb	r1,[r12,#0x03]

 	ldrb r7,[r2],#1
 	str r7,[r12,#hw_uartdr1]

	ldrb	r1,=0x10
	strb	r1,[r12,#0x03]

	cmp r2,r3
 	blt sentloop
 
	mov r7,#')'
	str r7,[r12,#hw_uartdr1] 
	


	ldrb r7, =0x00
	mov r2,#SdramBase
	add r3,r2,#bootlength
	
setloop 	

	strb r7,[r2],#1
	add r7,r7,#2
	
	cmp r2,r3
 	blt setloop
 
	

	mov r2,#SdramBase
	add r3,r2,#bootlength
	
sentloop2
	mov r4,#0x001
	mov r5,#0x100
	nop	
wait2
	ldr r4,[r12,#hw_sysflg1]
	ldrb	r1,=0x20
	strb	r1,[r12,#0x03]
	tst r4,#hw_utxff1
	ldrb	r1,=0x08
	strb	r1,[r12,#0x03]	
;	beq wait

;	add r4,r4,#0x01
;	cmp r4,r5
	
	beq gopp2
	b wait2

gopp2
	ldrb	r1,=0x40
	strb	r1,[r12,#0x03]

 	ldrb r7,[r2],#1
 	str r7,[r12,#hw_uartdr1]

	ldrb	r1,=0x10
	strb	r1,[r12,#0x03]

	cmp r2,r3
 	blt sentloop2
 
	mov r7,#')'
	str r7,[r12,#hw_uartdr1] 
	
	
current	 	
	b current

	;
 END