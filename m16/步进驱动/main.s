	.module main.c
	.area data(ram, con, rel)
_data::
	.blkb 2
	.area idata
	.word 0
	.area data(ram, con, rel)
	.dbfile E:\新建文件夹\例程\m16\步进驱动\main.c
	.dbsym e data _data i
_choose::
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile E:\新建文件夹\例程\m16\步进驱动\main.c
	.dbsym e choose _choose c
_key::
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile E:\新建文件夹\例程\m16\步进驱动\main.c
	.dbsym e key _key c
	.area text(rom, con, rel)
	.dbfile E:\新建文件夹\例程\m16\步进驱动\main.c
	.dbfunc e port_init _port_init fV
	.even
_port_init::
	.dbline -1
	.dbline 21
; //ICC-AVR application builder : 2007-10-19 14:27:15
; // Target : M16
; // Crystal: 1.0000Mhz
; 
; //PA0~PA6：CKA,ENA,CWA,CKB,ENB,CWB
; 
; #include <iom16v.h>
; #include <macros.h>
; 
; #define CKA (1<<0)
; #define ENA (1<<1)
; #define CWA (1<<2)
; #define CKB (1<<3)
; #define ENB (1<<4)
; #define CWB (1<<5)
; 
; 
; unsigned int data = 0;
; unsigned char choose = 0,key = 0;
; void port_init(void)
; {
	.dbline 22
;  PORTA = 0x00;
	clr R2
	out 0x1b,R2
	.dbline 23
;  DDRA  = 0xFF;
	ldi R24,255
	out 0x1a,R24
	.dbline 24
;  PORTB = 0x00;
	out 0x18,R2
	.dbline 25
;  DDRB  = 0x00;
	out 0x17,R2
	.dbline 26
;  PORTC = 0x00; //m103 output only
	out 0x15,R2
	.dbline 27
;  DDRC  = 0x00;
	out 0x14,R2
	.dbline 28
;  PORTD = 0x00;
	out 0x12,R2
	.dbline 29
;  DDRD  = 0x00;
	out 0x11,R2
	.dbline -2
L1:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e timer0_init _timer0_init fV
	.even
_timer0_init::
	.dbline -1
	.dbline 37
; }
; 
; //TIMER0 initialize - prescale:1024
; // WGM: Normal
; // desired value: 200mSec
; // actual value: 199.680mSec (0.2%)
; void timer0_init(void)
; {
	.dbline 38
;  TCCR0 = 0x00; //stop
	clr R2
	out 0x33,R2
	.dbline 39
;  TCNT0 = 0x3D; //set count
	ldi R24,61
	out 0x32,R24
	.dbline 40
;  OCR0  = 0xC3;  //set compare
	ldi R24,195
	out 0x3c,R24
	.dbline 41
;  TCCR0 = 0x05; //start timer
	ldi R24,5
	out 0x33,R24
	.dbline -2
L2:
	.dbline 0 ; func end
	ret
	.dbend
	.area vector(rom, abs)
	.org 36
	jmp _timer0_ovf_isr
	.area text(rom, con, rel)
	.dbfile E:\新建文件夹\例程\m16\步进驱动\main.c
	.dbfunc e timer0_ovf_isr _timer0_ovf_isr fV
	.even
_timer0_ovf_isr::
	st -y,R2
	st -y,R24
	in R2,0x3f
	st -y,R2
	.dbline -1
	.dbline 46
; }
; 
; #pragma interrupt_handler timer0_ovf_isr:10
; void timer0_ovf_isr(void)
; {
	.dbline 47
;  TCNT0 = 0x3D; //reload counter value
	ldi R24,61
	out 0x32,R24
	.dbline 67
;  
;  /*if(choose == 0)
;   {data++;
;    if(data == 1000)
;     {choose = 1;
; 	 data = 0;
;     }
;    	PORTA |= CWA;
; 	PORTA &= ~CWB;
;   }
;  else
;   {data++;
;    if(data == 1000)
;     {choose = 0;
; 	 data = 0;
; 	}
; 	PORTA |= CWB;
; 	PORTA &= ~CWA;
;   } */
;   if(key == 0)
	lds R2,_key
	tst R2
	brne L4
	.dbline 68
;    {key = 1;
	.dbline 68
	ldi R24,1
	sts _key,R24
	.dbline 69
;     PORTA |= CKA;
	sbi 0x1b,0
	.dbline 70
; 	PORTA |= CKB;
	sbi 0x1b,3
	.dbline 71
;    }
	xjmp L5
L4:
	.dbline 73
	.dbline 73
	clr R2
	sts _key,R2
	.dbline 74
	cbi 0x1b,0
	.dbline 75
	cbi 0x1b,3
	.dbline 76
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
	.dbline 81
;    else
;    {key = 0;
;     PORTA &= ~CKA;
; 	PORTA &= ~CKB;
;    }
; }
; 
; //call this routine to initialize all peripherals
; void init_devices(void)
; {
	.dbline 83
;  //stop errant interrupts until set up
;  CLI(); //disable all interrupts
	cli
	.dbline 84
;  port_init();
	xcall _port_init
	.dbline 85
;  timer0_init();
	xcall _timer0_init
	.dbline 87
; 
;  MCUCR = 0x00;
	clr R2
	out 0x35,R2
	.dbline 88
;  GICR  = 0x00;
	out 0x3b,R2
	.dbline 89
;  TIMSK = 0x01; //timer interrupt sources
	ldi R24,1
	out 0x39,R24
	.dbline 90
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
	.dbline 96
;  //all peripherals are now initialized
; }
; 
; //
; void main(void)
; {
	.dbline 97
;  init_devices();
	xcall _init_devices
	.dbline 98
;  PORTA &= ~ENA;
	cbi 0x1b,1
	.dbline 99
;  PORTB &= ~ENB;
	cbi 0x18,4
	.dbline -2
L7:
	.dbline 0 ; func end
	ret
	.dbend
