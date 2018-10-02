	.module key_bee.c
	.area data(ram, con, rel)
_chabiao::
	.blkb 2
	.area idata
	.byte 0,1
	.area data(ram, con, rel)
	.blkb 2
	.area idata
	.byte 2,0
	.area data(ram, con, rel)
	.blkb 2
	.area idata
	.byte 3,0
	.area data(ram, con, rel)
	.blkb 2
	.area idata
	.byte 0,0
	.area data(ram, con, rel)
	.blkb 1
	.area idata
	.byte 4
	.area data(ram, con, rel)
	.dbfile F:\工程文件\avr\例程\mega128\key_bee\key_bee.c
	.dbsym e chabiao _chabiao A[9:9]c
	.area text(rom, con, rel)
	.dbfile F:\工程文件\avr\例程\mega128\key_bee\key_bee.c
	.dbfunc e port_init _port_init fV
	.even
_port_init::
	.dbline -1
	.dbline 21
; //ICC-AVR application builder : 2008-1-14 9:09:01
; // Target : M128
; // Crystal: 2.0000Mhz
; //该程序采用了键盘扫描的方法
; //PD口作为键盘控制端
; //PC0作为蜂鸣器输出端
; 
; 
; #include <iom128v.h>
; #include <macros.h>
; 
; #define port_key  PORTD
; #define ddr_key   DDRD
; #define pin_key   PIND
; #define port_bee  PORTC
; void delay(int ms);
; unsigned char key(unsigned char number);
;  unsigned char chabiao[]={0,1,2,0,3,0,0,0,4};
; 
; void port_init(void)
; {
	.dbline 22
;  PORTA = 0xFF;
	ldi R24,255
	out 0x1b,R24
	.dbline 23
;  DDRA  = 0x00;
	clr R2
	out 0x1a,R2
	.dbline 24
;  PORTB = 0xFF;
	out 0x18,R24
	.dbline 25
;  DDRB  = 0x00;
	out 0x17,R2
	.dbline 26
;  PORTC = 0x0; 
	out 0x15,R2
	.dbline 27
;  DDRC  = 0xFF;
	out 0x14,R24
	.dbline 28
;  PORTD = 0x0;
	out 0x12,R2
	.dbline 29
;  DDRD  = 0xFF;
	out 0x11,R24
	.dbline 30
;  PORTE = 0xFF;
	out 0x3,R24
	.dbline 31
;  DDRE  = 0x00;
	out 0x2,R2
	.dbline 32
;  PORTF = 0xFF;
	sts 98,R24
	.dbline 33
;  DDRF  = 0x00;
	sts 97,R2
	.dbline 34
;  PORTG = 0x1F;
	ldi R24,31
	sts 101,R24
	.dbline 35
;  DDRG  = 0x00;
	sts 100,R2
	.dbline -2
	.dbline 36
; }
L1:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e init_devices _init_devices fV
	.even
_init_devices::
	.dbline -1
	.dbline 40
; 
; //call this routine to initialise all peripherals
; void init_devices(void)
; {
	.dbline 42
;  //stop errant interrupts until set up
;  CLI(); //disable all interrupts
	cli
	.dbline 43
;  XDIV  = 0x00; //xtal divider
	clr R2
	out 0x3c,R2
	.dbline 44
;  XMCRA = 0x00; //external memory
	sts 109,R2
	.dbline 45
;  port_init();
	xcall _port_init
	.dbline 47
; 
;  MCUCR = 0x00;
	clr R2
	out 0x35,R2
	.dbline 48
;  EICRA = 0x00; //extended ext ints
	sts 106,R2
	.dbline 49
;  EICRB = 0x00; //extended ext ints
	out 0x3a,R2
	.dbline 50
;  EIMSK = 0x00;
	out 0x39,R2
	.dbline 51
;  TIMSK = 0x00; //timer interrupt sources
	out 0x37,R2
	.dbline 52
;  ETIMSK = 0x00; //extended timer interrupt sources
	sts 125,R2
	.dbline 53
;  SEI(); //re-enable interrupts
	sei
	.dbline -2
	.dbline 55
;  //all peripherals are now initialised
; }
L2:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e main _main fV
;             kk -> R20
	.even
_main::
	.dbline -1
	.dbline 59
; 
; //
; void main(void)
; { 
	.dbline 61
;   unsigned char kk;
;  init_devices();
	xcall _init_devices
	xjmp L5
L4:
	.dbline 63
;  while(1)
;   {if(key(2)!=0)
	.dbline 63
	ldi R16,2
	xcall _key
	tst R16
	breq L7
	.dbline 64
;    kk=key(2);
	ldi R16,2
	xcall _key
	mov R20,R16
L7:
	.dbline 65
	out 0x15,R20
	.dbline 66
L5:
	.dbline 62
	xjmp L4
X0:
	.dbline -2
	.dbline 69
;   PORTC = kk;
;   }
;    
;    
;  }
L3:
	.dbline 0 ; func end
	ret
	.dbsym r kk 20 c
	.dbend
	.dbfunc e delay _delay fV
;              j -> R20,R21
;              i -> R22,R23
;             ms -> R16,R17
	.even
_delay::
	xcall push_gset2
	.dbline -1
	.dbline 71
; void delay(int ms)
; {int i,j;
	.dbline 72
;   for(j=0;j<ms;j++)
	clr R20
	clr R21
	xjmp L13
L10:
	.dbline 73
	clr R22
	clr R23
L14:
	.dbline 73
L15:
	.dbline 73
	subi R22,255  ; offset = 1
	sbci R23,255
	.dbline 73
	cpi R22,100
	ldi R30,0
	cpc R23,R30
	brlt L14
L11:
	.dbline 72
	subi R20,255  ; offset = 1
	sbci R21,255
L13:
	.dbline 72
	cp R20,R16
	cpc R21,R17
	brlt L10
	.dbline -2
	.dbline 74
;   for(i=0;i<100;i++);
; }
L9:
	xcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r j 20 I
	.dbsym r i 22 I
	.dbsym r ms 16 I
	.dbend
	.dbfunc e key _key fc
;        key_out -> <dead>
;             ky -> R20,R21
;       key_data -> y+0
;        key_in1 -> R22,R23
;        key_in3 -> R10,R11
;        key_in2 -> R12,R13
;         key_in -> R14,R15
;              i -> R20,R21
;         number -> y+12
	.even
_key::
	st -y,r17
	st -y,r16
	xcall push_gset5
	sbiw R28,2
	.dbline -1
	.dbline 78
; 
; //number表示键盘列数，比如共有2列,number=2
; unsigned char key(unsigned char number)
; { 
	.dbline 79
;   unsigned key_data=0,ky=1,key_out,i = 0,key_in1,key_in2,key_in3,key_in;
	clr R0
	clr R1
	std y+1,R1
	std y+0,R0
	.dbline 79
	ldi R20,1
	ldi R21,0
	.dbline 79
	clr R20
	.dbline 80
;   ddr_key = 0Xff;//低4位输入，高4位输出
	ldi R24,255
	out 0x11,R24
	.dbline 82
;   
;   for(i = 0;i<number; i++)
	xjmp L22
L19:
	.dbline 83
;    {port_key = 1<<(i+4);
	.dbline 83
	movw R18,R20
	subi R18,252  ; offset = 4
	sbci R19,255
	ldi R16,1
	ldi R17,0
	xcall lsl16
	out 0x12,R16
	.dbline 84
;     key_in1 = pin_key&0xf;
	in R22,0x10
	clr R23
	andi R22,15
	andi R23,0
	.dbline 85
; 	delay(1);
	ldi R16,1
	ldi R17,0
	xcall _delay
	.dbline 86
; 	key_in2 = pin_key&0xf;
	in R24,0x10
	clr R25
	andi R24,15
	andi R25,0
	movw R12,R24
	.dbline 87
; 	delay(1);
	ldi R16,1
	ldi R17,0
	xcall _delay
	.dbline 88
; 	key_in3 = pin_key&0xf;
	in R24,0x10
	clr R25
	andi R24,15
	andi R25,0
	movw R10,R24
	.dbline 89
; 	key_in = key_in2&key_in3;
	movw R14,R12
	and R14,R24
	and R15,R25
	.dbline 90
; 	if(key_in != 0)
	tst R14
	brne X1
	tst R15
	breq L23
X1:
	.dbline 91
; 	 key_data = key_in<<(i*4);
	ldi R16,4
	ldi R17,0
	movw R18,R20
	xcall empy16s
	movw R18,R16
	movw R16,R14
	xcall lsl16
	std y+1,R17
	std y+0,R16
L23:
	.dbline 93
L20:
	.dbline 82
	subi R20,255  ; offset = 1
	sbci R21,255
L22:
	.dbline 82
	ldd R2,y+12
	clr R3
	cp R20,R2
	cpc R21,R3
	brlo L19
	.dbline 95
; 	
;    }
;    //key_data = pin_key;
;     return key_data;
	ldd R16,y+0
	ldd R17,y+1
	.dbline -2
L18:
	adiw R28,2
	xcall pop_gset5
	adiw R28,2
	.dbline 0 ; func end
	ret
	.dbsym l key_out 1 i
	.dbsym r ky 20 i
	.dbsym l key_data 0 i
	.dbsym r key_in1 22 i
	.dbsym r key_in3 10 i
	.dbsym r key_in2 12 i
	.dbsym r key_in 14 i
	.dbsym r i 20 i
	.dbsym l number 12 c
	.dbend
