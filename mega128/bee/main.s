	.module main.c
	.area data(ram, con, rel)
_Data::
	.blkb 1
	.area idata
	.byte 254
	.area data(ram, con, rel)
	.dbfile F:\mega128包\mega128例程\蜂鸣器基本实验\main.c
	.dbsym e Data _Data c
	.area text(rom, con, rel)
	.dbfile F:\mega128包\mega128例程\蜂鸣器基本实验\main.c
	.dbfunc e port_init _port_init fV
	.even
_port_init::
	.dbline -1
	.dbline 13
; 
; //PA0输出频率波形
; //请将PA0口接到蜂鸣器控制端
; //ICC-AVR application builder : 2007-6-26 15:44:31
; // Target : M128
; // Crystal: 6.0000Mhz
; 
; #include <iom128v.h>
; #include <macros.h>
; unsigned char Data=0XFE;
;   
; void port_init(void)
; {
	.dbline 14
;  PORTA = 0xFF;
	ldi R24,255
	out 0x1b,R24
	.dbline 15
;  DDRA  = 0x00;
	clr R2
	out 0x1a,R2
	.dbline 16
;  PORTB = 0xFF;
	out 0x18,R24
	.dbline 17
;  DDRB  = 0x00;
	out 0x17,R2
	.dbline 18
;  PORTC = 0xFF; //m103 output only
	out 0x15,R24
	.dbline 19
;  DDRC  = 0x00;
	out 0x14,R2
	.dbline 20
;  PORTD = 0xFF;
	out 0x12,R24
	.dbline 21
;  DDRD  = 0x00;
	out 0x11,R2
	.dbline 22
;  PORTE = 0xFF;
	out 0x3,R24
	.dbline 23
;  DDRE  = 0x00;
	out 0x2,R2
	.dbline 24
;  PORTF = 0xFF;
	sts 98,R24
	.dbline 25
;  DDRF  = 0x00;
	sts 97,R2
	.dbline 26
;  PORTG = 0x1F;
	ldi R24,31
	sts 101,R24
	.dbline 27
;  DDRG  = 0x00;
	sts 100,R2
	.dbline -2
L1:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e timer0_init _timer0_init fV
	.even
_timer0_init::
	.dbline -1
	.dbline 35
; }
; 
; //TIMER0 initialisation - prescale:8
; // WGM: Normal
; // desired value: 10KHz
; // actual value: 10.000KHz (0.0%)
; void timer0_init(void)
; {
	.dbline 36
;  TCCR0 = 0x00; //stop
	clr R2
	out 0x33,R2
	.dbline 37
;  ASSR  = 0x00; //set async mode
	out 0x30,R2
	.dbline 38
;  TCNT0 = 0xB5; //set count
	ldi R24,181
	out 0x32,R24
	.dbline 39
;  OCR0  = 0x4B;
	ldi R24,75
	out 0x31,R24
	.dbline 40
;  TCCR0 = 0x02; //start timer
	ldi R24,2
	out 0x33,R24
	.dbline -2
L2:
	.dbline 0 ; func end
	ret
	.dbend
	.area vector(rom, abs)
	.org 64
	jmp _timer0_ovf_isr
	.area text(rom, con, rel)
	.dbfile F:\mega128包\mega128例程\蜂鸣器基本实验\main.c
	.dbfunc e timer0_ovf_isr _timer0_ovf_isr fV
	.even
_timer0_ovf_isr::
	st -y,R2
	st -y,R24
	in R2,0x3f
	st -y,R2
	.dbline -1
	.dbline 45
; }
; 
; #pragma interrupt_handler timer0_ovf_isr:17
; void timer0_ovf_isr(void)
; {
	.dbline 46
;  TCNT0 = 0xB5; //reload counter value
	ldi R24,181
	out 0x32,R24
	.dbline 47
;   PORTA = Data;
	lds R2,_Data
	out 0x1b,R2
	.dbline 48
;  if(Data ==0XFE)
	mov R24,R2
	cpi R24,254
	brne L4
	.dbline 49
;   Data = 0XFF;
	ldi R24,255
	sts _Data,R24
	xjmp L5
L4:
	.dbline 51
	ldi R24,254
	sts _Data,R24
L5:
	.dbline -2
L3:
	ld R2,y+
	out 0x3f,R2
	ld R24,y+
	ld R2,y+
	.dbline 0 ; func end
	reti
	.dbend
	.dbfunc e init_devices _init_devices fV
	.even
_init_devices::
	.dbline -1
	.dbline 56
;  else
;   Data = 0XFE;
; }
; 
; //call this routine to initialise all peripherals
; void init_devices(void)
; {
	.dbline 58
;  //stop errant interrupts until set up
;  CLI(); //disable all interrupts
	cli
	.dbline 59
;  XDIV  = 0x00; //xtal divider
	clr R2
	out 0x3c,R2
	.dbline 60
;  XMCRA = 0x00; //external memory
	sts 109,R2
	.dbline 61
;  port_init();
	xcall _port_init
	.dbline 62
;  timer0_init();
	xcall _timer0_init
	.dbline 64
; 
;  MCUCR = 0x00;
	clr R2
	out 0x35,R2
	.dbline 65
;  EICRA = 0x00; //extended ext ints
	sts 106,R2
	.dbline 66
;  EICRB = 0x00; //extended ext ints
	out 0x3a,R2
	.dbline 67
;  EIMSK = 0x00;
	out 0x39,R2
	.dbline 68
;  TIMSK = 0x01; //timer interrupt sources
	ldi R24,1
	out 0x37,R24
	.dbline 69
;  ETIMSK = 0x00; //extended timer interrupt sources
	sts 125,R2
	.dbline 70
;  SEI(); //re-enable interrupts
	sei
	.dbline -2
L6:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e main _main fV
	.even
_main::
	.dbline -1
	.dbline 76
;  //all peripherals are now initialised
; }
; 
; //
; void main(void)
; {
	.dbline 77
;  init_devices();
	xcall _init_devices
	.dbline -2
L7:
	.dbline 0 ; func end
	ret
	.dbend
