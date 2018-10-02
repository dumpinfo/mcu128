	.module main.c
	.area data(ram, con, rel)
_Data::
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile D:\mega16学习板资料\例程\m16\蜂鸣器基本实验\main.c
	.dbsym e Data _Data c
	.area text(rom, con, rel)
	.dbfile D:\mega16学习板资料\例程\m16\蜂鸣器基本实验\main.c
	.dbfunc e port_init _port_init fV
	.even
_port_init::
	.dbline -1
	.dbline 10
; //ICC-AVR application builder : 2007-4-12 9:38:39
; // Target : M16
; // Crystal: 7.3728Mhz
; //PA0输出频率波形
; #include <iom16v.h>
; #include <macros.h>
; 
; unsigned char Data=0;
; void port_init(void)
; {
	.dbline 11
;  PORTA = 0xFF;
	ldi R24,255
	out 0x1b,R24
	.dbline 12
;  DDRA  = 0xFF;
	out 0x1a,R24
	.dbline 13
;  PORTB = 0xFF;
	out 0x18,R24
	.dbline 14
;  DDRB  = 0x00;
	clr R2
	out 0x17,R2
	.dbline 15
;  PORTC = 0xFF; 
	out 0x15,R24
	.dbline 16
;  DDRC  = 0x00;
	out 0x14,R2
	.dbline 17
;  PORTD = 0xFF;
	out 0x12,R24
	.dbline 18
;  DDRD  = 0x00;
	out 0x11,R2
	.dbline -2
	.dbline 19
; }
L1:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e timer0_init _timer0_init fV
	.even
_timer0_init::
	.dbline -1
	.dbline 26
; 
; //TIMER0 initialisation - prescale:64
; // WGM: Normal
; // desired value: 1KHz
; // actual value:  1.002KHz (0.2%)
; void timer0_init(void)
; {
	.dbline 27
;  TCCR0 = 0x00; //stop
	clr R2
	out 0x33,R2
	.dbline 28
;  TCNT0 = 0x8D; //set count
	ldi R24,141
	out 0x32,R24
	.dbline 29
;  OCR0  = 0x73;  //set compare
	ldi R24,115
	out 0x3c,R24
	.dbline 30
;  TCCR0 = 0x03; //start timer
	ldi R24,3
	out 0x33,R24
	.dbline -2
	.dbline 31
; }
L2:
	.dbline 0 ; func end
	ret
	.dbend
	.area vector(rom, abs)
	.org 36
	jmp _timer0_ovf_isr
	.area text(rom, con, rel)
	.dbfile D:\mega16学习板资料\例程\m16\蜂鸣器基本实验\main.c
	.dbfunc e timer0_ovf_isr _timer0_ovf_isr fV
	.even
_timer0_ovf_isr::
	st -y,R2
	st -y,R24
	in R2,0x3f
	st -y,R2
	.dbline -1
	.dbline 35
; 
; #pragma interrupt_handler timer0_ovf_isr:10
; void timer0_ovf_isr(void)
; {
	.dbline 36
;  TCNT0 = 0x8D; //reload counter value
	ldi R24,141
	out 0x32,R24
	.dbline 37
;  PORTA = Data;
	lds R2,_Data
	out 0x1b,R2
	.dbline 38
;  if(Data ==0)
	tst R2
	brne L4
	.dbline 39
;   Data = 1;
	ldi R24,1
	sts _Data,R24
	xjmp L5
L4:
	.dbline 41
	clr R2
	sts _Data,R2
L5:
	.dbline -2
	.dbline 42
;  else
;   Data = 0;
; }
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
	.dbline 46
; 
; //call this routine to initialise all peripherals
; void init_devices(void)
; {
	.dbline 48
;  //stop errant interrupts until set up
;  CLI(); //disable all interrupts
	cli
	.dbline 49
;  port_init();
	xcall _port_init
	.dbline 50
;  timer0_init();
	xcall _timer0_init
	.dbline 52
; 
;  MCUCR = 0x00;
	clr R2
	out 0x35,R2
	.dbline 53
;  GICR  = 0x00;
	out 0x3b,R2
	.dbline 54
;  TIMSK = 0x01; //timer interrupt sources
	ldi R24,1
	out 0x39,R24
	.dbline 55
;  SEI(); //re-enable interrupts
	sei
	.dbline -2
	.dbline 57
;  //all peripherals are now initialised
; }
L6:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e main _main fV
	.even
_main::
	.dbline -1
	.dbline 61
; 
; //
; void main(void)
; {
	.dbline 62
;  init_devices();
	.dbline -2
	.dbline 64
;  //insert your functional code here...
; }
L7:
	.dbline 0 ; func end
	xjmp _init_devices
	.dbend
