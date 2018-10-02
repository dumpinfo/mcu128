	.module C_LEDPMD.C
	.area data(ram, con, rel)
_data::
	.blkb 1
	.area idata
	.byte 1
	.area data(ram, con, rel)
	.dbfile F:\工程文件\avr\例程\mega128\LED跑马灯\C_LEDPMD.C
	.dbsym e data _data c
	.area text(rom, con, rel)
	.dbfile F:\工程文件\avr\例程\mega128\LED跑马灯\C_LEDPMD.C
	.dbfunc e port_init _port_init fV
	.even
_port_init::
	.dbline -1
	.dbline 15
; //ICC-AVR application builder : 2007-3-14 9:32:42
; // Target : M16
; // Crystal: 7.3728Mhz
; // Designed by solo       转载请注明
; // http://www.ourembed.com     
; // qq:15537031 phone:13879805760
; //该程序使用了PD口，请将PD口接到LED的脚上，然后运行程序
; //显示结果应该是循环点亮LED，
; //请注意主频
; #include <iom128v.h>
; #include <macros.h>
; 
; unsigned char data = 1;
; void port_init(void)
; {
	.dbline 16
;  PORTA = 0x00;
	clr R2
	out 0x1b,R2
	.dbline 17
;  DDRA  = 0x00;
	out 0x1a,R2
	.dbline 18
;  PORTB = 0x00;
	out 0x18,R2
	.dbline 19
;  DDRB  = 0x00;
	out 0x17,R2
	.dbline 20
;  PORTC = 0x00; //m103 output only
	out 0x15,R2
	.dbline 21
;  DDRC  = 0x00;
	out 0x14,R2
	.dbline 22
;  PORTD = 0x88;
	ldi R24,136
	out 0x12,R24
	.dbline 23
;  DDRD  = 0xFF;
	ldi R24,255
	out 0x11,R24
	.dbline 24
;  PORTE = 0x00;
	out 0x3,R2
	.dbline 25
;  DDRE  = 0x00;
	out 0x2,R2
	.dbline 26
;  PORTF = 0x00;
	sts 98,R2
	.dbline 27
;  DDRF  = 0x00;
	sts 97,R2
	.dbline 28
;  PORTG = 0x00;
	sts 101,R2
	.dbline 29
;  DDRG  = 0x00;
	sts 100,R2
	.dbline -2
	.dbline 30
; }
L1:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e timer1_init _timer1_init fV
	.even
_timer1_init::
	.dbline -1
	.dbline 37
; 
; //TIMER1 initialize - prescale:64
; // WGM: 0) Normal, TOP=0xFFFF
; // desired value: 1Hz
; // actual value:  1.000Hz (0.0%)
; void timer1_init(void)
; {
	.dbline 38
;  TCCR1B = 0x00; //stop
	clr R2
	out 0x2e,R2
	.dbline 39
;  TCNT1H = 0x0B; //setup
	ldi R24,11
	out 0x2d,R24
	.dbline 40
;  TCNT1L = 0xDC;
	ldi R24,220
	out 0x2c,R24
	.dbline 41
;  OCR1AH = 0xF4;
	ldi R24,244
	out 0x2b,R24
	.dbline 42
;  OCR1AL = 0x24;
	ldi R24,36
	out 0x2a,R24
	.dbline 43
;  OCR1BH = 0xF4;
	ldi R24,244
	out 0x29,R24
	.dbline 44
;  OCR1BL = 0x24;
	ldi R24,36
	out 0x28,R24
	.dbline 45
;  OCR1CH = 0xF4;
	ldi R24,244
	sts 121,R24
	.dbline 46
;  OCR1CL = 0x24;
	ldi R24,36
	sts 120,R24
	.dbline 47
;  ICR1H  = 0xF4;
	ldi R24,244
	out 0x27,R24
	.dbline 48
;  ICR1L  = 0x24;
	ldi R24,36
	out 0x26,R24
	.dbline 49
;  TCCR1A = 0x00;
	out 0x2f,R2
	.dbline 50
;  TCCR1B = 0x03; //start Timer
	ldi R24,3
	out 0x2e,R24
	.dbline -2
	.dbline 51
; }
L2:
	.dbline 0 ; func end
	ret
	.dbend
	.area vector(rom, abs)
	.org 56
	jmp _timer1_ovf_isr
	.area text(rom, con, rel)
	.dbfile F:\工程文件\avr\例程\mega128\LED跑马灯\C_LEDPMD.C
	.dbfunc e timer1_ovf_isr _timer1_ovf_isr fV
	.even
_timer1_ovf_isr::
	st -y,R2
	st -y,R24
	in R2,0x3f
	st -y,R2
	.dbline -1
	.dbline 55
	.dbline 57
	ldi R24,11
	out 0x2d,R24
	.dbline 58
	ldi R24,220
	out 0x2c,R24
	.dbline 60
	lds R2,_data
	out 0x12,R2
	.dbline 61
	lsl R2
	sts _data,R2
	.dbline 62
	tst R2
	brne L4
	.dbline 63
	ldi R24,1
	sts _data,R24
L4:
	.dbline -2
	.dbline 66
; 
; #pragma interrupt_handler timer1_ovf_isr:15
; void timer1_ovf_isr(void)
; {
;  //TIMER1 has overflowed
;  TCNT1H = 0x0B; //reload counter high value
;  TCNT1L = 0xDC; //reload counter low value
;  
;  PORTD = data;  //
;  data = data<<1;
;  if (data == 0)
;   data = 1;
;  
;  
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
	.dbline 70
; 
; //call this routine to initialize all peripherals
; void init_devices(void)
; {
	.dbline 72
;  //stop errant interrupts until set up
;  CLI(); //disable all interrupts
	cli
	.dbline 73
;  XDIV  = 0x00; //xtal divider
	clr R2
	out 0x3c,R2
	.dbline 74
;  XMCRA = 0x00; //external memory
	sts 109,R2
	.dbline 75
;  port_init();
	xcall _port_init
	.dbline 76
;  timer1_init();
	xcall _timer1_init
	.dbline 78
; 
;  MCUCR = 0x00;
	clr R2
	out 0x35,R2
	.dbline 79
;  EICRA = 0x00; //extended ext ints
	sts 106,R2
	.dbline 80
;  EICRB = 0x00; //extended ext ints
	out 0x3a,R2
	.dbline 81
;  EIMSK = 0x00;
	out 0x39,R2
	.dbline 82
;  TIMSK = 0x04; //timer interrupt sources
	ldi R24,4
	out 0x37,R24
	.dbline 83
;  ETIMSK = 0x00; //extended timer interrupt sources
	sts 125,R2
	.dbline 84
;  SEI(); //re-enable interrupts
	sei
	.dbline -2
	.dbline 86
;  //all peripherals are now initialized
; }
L6:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e main _main fV
	.even
_main::
	.dbline -1
	.dbline 90
; 
; //
; void main(void)
; {
	.dbline 91
;  init_devices();
	.dbline -2
	.dbline 93
;  //insert your functional code here...
; }
L7:
	.dbline 0 ; func end
	xjmp _init_devices
	.dbend
