	.module s.c
	.area data(ram, con, rel)
_data::
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile E:\新建文件夹\例程\m16\192128\s.c
	.dbsym e data _data c
	.area text(rom, con, rel)
	.dbfile E:\新建文件夹\例程\m16\192128\s.c
	.dbfunc e port_init _port_init fV
	.even
_port_init::
	.dbline -1
	.dbline 44
; //ICC-AVR application builder : 2007-10-25 22:16:04
; // Target : M16
; // Crystal: 6.0000Mhz
; 
; #include <iom16v.h>
; #include <macros.h>
; 
; #define LCD_DDR  DDRA
; #define LCD_PORT PORTA
; 
; #define LCD_SID (1<<0)
; #define LCD_DL  (1<<1)
; #define LCD_DM  (1<<2)
; #define LCD_DR  (1<<3)
; #define LCD_DLL (1<<4)
; #define LCD_M   (1<<5)
; #define LCD_CL1 (1<<6)
; #define LCD_CL2 (1<<7)
; 
; #define SET_LCD_SID()  (LCD_PORT |= LCD_SID)
; #define SET_LCD_DL()	(LCD_PORT |= LCD_DM)
; #define SET_LCD_DM()	(LCD_PORT |= LCD_DM)
; #define SET_LCD_DR()	(LCD_PORT |= LCD_DR)
; 
; #define SET_LCD_DLL()	 (LCD_PORT |= LCD_DLL)
; #define SET_LCD_M() 	 (LCD_PORT |= LCD_M)
; #define SET_LCD_CL1()	 (LCD_PORT |= LCD_CL1)
; #define SET_LCD_CL2()	 (LCD_PORT |= LCD_CL2)
; 
; 
; #define CLR_LCD_SID() (LCD_PORT &= ~LCD_SID)
; #define CLR_LCD_DL()	(LCD_PORT &= ~LCD_DM)
; #define CLR_LCD_DM()	(LCD_PORT &= ~LCD_DM)
; #define CLR_LCD_DR()	(LCD_PORT &= ~LCD_DR)
; 
; #define CLR_LCD_DLL()	 (LCD_PORT &= ~LCD_DLL)
; #define CLR_LCD_M()	 (LCD_PORT &= ~LCD_M)
; #define CLR_LCD_CL1()	 (LCD_PORT &= ~LCD_CL1)
; #define CLR_LCD_CL2()	 (LCD_PORT &= ~LCD_CL2)
; 
; unsigned char data = 0;
; 
; void port_init(void)
; {
	.dbline 45
;  PORTA = 0x00;
	clr R2
	out 0x1b,R2
	.dbline 46
;  DDRA  = 0xFF;
	ldi R24,255
	out 0x1a,R24
	.dbline 47
;  PORTB = 0x00;
	out 0x18,R2
	.dbline 48
;  DDRB  = 0x00;
	out 0x17,R2
	.dbline 49
;  PORTC = 0x00; //m103 output only
	out 0x15,R2
	.dbline 50
;  DDRC  = 0x00;
	out 0x14,R2
	.dbline 51
;  PORTD = 0x00;
	out 0x12,R2
	.dbline 52
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
	.dbline 60
; }
; 
; //TIMER0 initialize - prescale:1
; // WGM: Normal
; // desired value: 10uSec
; // actual value: 10.000uSec (0.0%)
; void timer0_init(void)
; {
	.dbline 61
;  TCCR0 = 0x00; //stop
	clr R2
	out 0x33,R2
	.dbline 62
;  TCNT0 = 0xC4; //set count
	ldi R24,196
	out 0x32,R24
	.dbline 63
;  OCR0  = 0x3C;  //set compare
	ldi R24,60
	out 0x3c,R24
	.dbline 64
;  TCCR0 = 0x04; //start timer
	ldi R24,4
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
	.dbfile E:\新建文件夹\例程\m16\192128\s.c
	.dbfunc e timer0_ovf_isr _timer0_ovf_isr fV
	.even
_timer0_ovf_isr::
	st -y,R2
	st -y,R24
	st -y,R25
	in R2,0x3f
	st -y,R2
	.dbline -1
	.dbline 69
; }
; 
; #pragma interrupt_handler timer0_ovf_isr:10
; void timer0_ovf_isr(void)
; {
	.dbline 70
;  TCNT0 = 0xC4; //reload counter value
	ldi R24,196
	out 0x32,R24
	.dbline 71
;  data++;
	lds R24,_data
	subi R24,255    ; addi 1
	sts _data,R24
	.dbline 72
;  if(data == 2)
	cpi R24,2
	brne L4
	.dbline 73
;  {
	.dbline 74
;  SET_LCD_DLL();
	sbi 0x1b,4
	.dbline 75
;  data = 0;
	clr R2
	sts _data,R2
	.dbline 76
;  }
	xjmp L5
L4:
	.dbline 78
;  else
;  CLR_LCD_DLL();
	cbi 0x1b,4
L5:
	.dbline 80
;  
;  SET_LCD_CL1();
	sbi 0x1b,6
	.dbline 81
;  CLR_LCD_CL1();
	cbi 0x1b,6
	.dbline 83
;  
;  LCD_PORT = 0X0;     //装载数据
	clr R2
	out 0x1b,R2
	.dbline 84
;  CLR_LCD_CL2();
	cbi 0x1b,7
	.dbline 85
;  SET_LCD_CL2();
	sbi 0x1b,7
	.dbline -2
L3:
	ld R2,y+
	out 0x3f,R2
	ld R25,y+
	ld R24,y+
	ld R2,y+
	.dbline 0 ; func end
	reti
	.dbend
	.dbfunc e timer1_init _timer1_init fV
	.even
_timer1_init::
	.dbline -1
	.dbline 95
;  
;  
; }
; 
; //TIMER1 initialize - prescale:1
; // WGM: 0) Normal, TOP=0xFFFF
; // desired value: 1KHz
; // actual value:  1.000KHz (0.0%)
; void timer1_init(void)
; {
	.dbline 96
;  TCCR1B = 0x00; //stop
	clr R2
	out 0x2e,R2
	.dbline 97
;  TCNT1H = 0xE8; //setup
	ldi R24,232
	out 0x2d,R24
	.dbline 98
;  TCNT1L = 0x90;
	ldi R24,144
	out 0x2c,R24
	.dbline 99
;  OCR1AH = 0x17;
	ldi R24,23
	out 0x2b,R24
	.dbline 100
;  OCR1AL = 0x70;
	ldi R24,112
	out 0x2a,R24
	.dbline 101
;  OCR1BH = 0x17;
	ldi R24,23
	out 0x29,R24
	.dbline 102
;  OCR1BL = 0x70;
	ldi R24,112
	out 0x28,R24
	.dbline 103
;  ICR1H  = 0x17;
	ldi R24,23
	out 0x27,R24
	.dbline 104
;  ICR1L  = 0x70;
	ldi R24,112
	out 0x26,R24
	.dbline 105
;  TCCR1A = 0x00;
	out 0x2f,R2
	.dbline 106
;  TCCR1B = 0x01; //start Timer
	ldi R24,1
	out 0x2e,R24
	.dbline -2
L6:
	.dbline 0 ; func end
	ret
	.dbend
	.area vector(rom, abs)
	.org 32
	jmp _timer1_ovf_isr
	.area text(rom, con, rel)
	.dbfile E:\新建文件夹\例程\m16\192128\s.c
	.dbfunc e timer1_ovf_isr _timer1_ovf_isr fV
	.even
_timer1_ovf_isr::
	st -y,R24
	in R24,0x3f
	st -y,R24
	.dbline -1
	.dbline 111
; }
; 
; #pragma interrupt_handler timer1_ovf_isr:9
; void timer1_ovf_isr(void)
; {
	.dbline 113
;  //TIMER1 has overflowed
;  TCNT1H = 0xE8; //reload counter high value
	ldi R24,232
	out 0x2d,R24
	.dbline 114
;  TCNT1L = 0x90; //reload counter low value
	ldi R24,144
	out 0x2c,R24
	.dbline -2
L7:
	ld R24,y+
	out 0x3f,R24
	ld R24,y+
	.dbline 0 ; func end
	reti
	.dbend
	.dbfunc e init_devices _init_devices fV
	.even
_init_devices::
	.dbline -1
	.dbline 119
; }
; 
; //call this routine to initialize all peripherals
; void init_devices(void)
; {
	.dbline 121
;  //stop errant interrupts until set up
;  CLI(); //disable all interrupts
	cli
	.dbline 122
;  port_init();
	xcall _port_init
	.dbline 123
;  timer0_init();
	xcall _timer0_init
	.dbline 124
;  timer1_init();
	xcall _timer1_init
	.dbline 126
; 
;  MCUCR = 0x00;
	clr R2
	out 0x35,R2
	.dbline 127
;  GICR  = 0x00;
	out 0x3b,R2
	.dbline 128
;  TIMSK = 0x05; //timer interrupt sources
	ldi R24,5
	out 0x39,R24
	.dbline 129
;  SEI(); //re-enable interrupts
	sei
	.dbline -2
L8:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e main _main fV
	.even
_main::
	.dbline -1
	.dbline 135
;  //all peripherals are now initialized
; }
; 
; //
; void main(void)
; {
	.dbline 136
;  init_devices();
	xcall _init_devices
	.dbline 137
;  SET_LCD_CL2();
	sbi 0x1b,7
	.dbline -2
L9:
	.dbline 0 ; func end
	ret
	.dbend
