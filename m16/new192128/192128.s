	.module _192128.c
	.area data(ram, con, rel)
_data::
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile E:\avr资料\例程\m16\new192128\192128.c
	.dbsym e data _data c
	.area text(rom, con, rel)
	.dbfile E:\avr资料\例程\m16\new192128\192128.c
	.dbfunc e port_init _port_init fV
	.even
_port_init::
	.dbline -1
	.dbline 47
; //ICC-AVR application builder : 2008-01-04 16:13:23
; // Target : M128
; // Crystal: 2.0000Mhz
; 
; #include <iom128v.h>
; #include <macros.h>
; 
; 
; #define LCD_DDR  DDRC
; #define LCD_PORT PORTC
; 
; #define DATA_DDR  DDRD
; #define DATA_PORT PORTD
; 
; 
; //#define LCD_SID (1<<7)   //PIN8  data0
; //#define LCD_DL  (1<<6)   //PIN7  data1 
; //#define LCD_DM  (1<<1)   //PIN2  data2
; //#define LCD_DR  (1<<0)   //PIN1  data3
; 
; 
; #define LCD_DLL (1<<0)   //PIN3  
; #define LCD_M   (1<<1)   //PIN4  
; #define LCD_CL1 (1<<2)   //PIN5
; #define LCD_CL2 (1<<3)   //PIN6
;                          //PIN9  VCC
;                          //PIN10 GND
;                          //PIN11 VEE(-5~-10V)
;                          //PIN12 NC
;                          //PIN13 BLK~
;                          //PIN14 BLK~
; #define SET_LCD_DLL()	 (LCD_PORT |= LCD_DLL)
; #define SET_LCD_M() 	 (LCD_PORT |= LCD_M)
; #define SET_LCD_CL1()	 (LCD_PORT |= LCD_CL1)
; #define SET_LCD_CL2()	 (LCD_PORT |= LCD_CL2)
; 
;  
; 
; #define CLR_LCD_DLL()	 (LCD_PORT &= ~LCD_DLL)
; #define CLR_LCD_M()	 (LCD_PORT &= ~LCD_M)
; #define CLR_LCD_CL1()	 (LCD_PORT &= ~LCD_CL1)
; #define CLR_LCD_CL2()	 (LCD_PORT &= ~LCD_CL2)
; 
; 
; unsigned char  data=0,data1;
; void port_init(void)
; {
	.dbline 48
;  PORTA = 0x00;
	clr R2
	out 0x1b,R2
	.dbline 49
;  DDRA  = 0x00;
	out 0x1a,R2
	.dbline 50
;  PORTB = 0x00;
	out 0x18,R2
	.dbline 51
;  DDRB  = 0x00;
	out 0x17,R2
	.dbline 52
;  PORTC = 0x00; //m103 output only
	out 0x15,R2
	.dbline 53
;  DDRC  = 0xFF;
	ldi R24,255
	out 0x14,R24
	.dbline 54
;  PORTD = 0x00;
	out 0x12,R2
	.dbline 55
;  DDRD  = 0xFF;
	out 0x11,R24
	.dbline 56
;  PORTE = 0x00;
	out 0x3,R2
	.dbline 57
;  DDRE  = 0x00;
	out 0x2,R2
	.dbline 58
;  PORTF = 0x00;
	sts 98,R2
	.dbline 59
;  DDRF  = 0x00;
	sts 97,R2
	.dbline 60
;  PORTG = 0x00;
	sts 101,R2
	.dbline 61
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
	.dbline 71
; }
; 
; 
; 
; //TIMER0 initialize - prescale:1024
; // WGM: Normal
; // desired value: 100mSec
; // actual value: 99.840mSec (0.2%)
; void timer0_init(void)
; {
	.dbline 72
;  TCCR0 = 0x00; //stop
	clr R2
	out 0x33,R2
	.dbline 73
;  ASSR  = 0x00; //set async mode
	out 0x30,R2
	.dbline 74
;  TCNT0 = 0x3D; //set count
	ldi R24,61
	out 0x32,R24
	.dbline 75
;  OCR0  = 0xC3;
	ldi R24,195
	out 0x31,R24
	.dbline 76
;  TCCR0 = 0x07; //start timer
	ldi R24,7
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
	.dbfile E:\avr资料\例程\m16\new192128\192128.c
	.dbfunc e timer0_ovf_isr _timer0_ovf_isr fV
	.even
_timer0_ovf_isr::
	st -y,R24
	in R24,0x3f
	st -y,R24
	.dbline -1
	.dbline 81
; }
; 
; #pragma interrupt_handler timer0_ovf_isr:17
; void timer0_ovf_isr(void)
; {
	.dbline 82
;  TCNT0 = 0x3D; //reload counter value
	ldi R24,61
	out 0x32,R24
	.dbline -2
L3:
	ld R24,y+
	out 0x3f,R24
	ld R24,y+
	.dbline 0 ; func end
	reti
	.dbend
	.dbfunc e timer1_init _timer1_init fV
	.even
_timer1_init::
	.dbline -1
	.dbline 94
;  
; 
; }
; 
; 
; 
; //TIMER1 initialize - prescale:64
; // WGM: 0) Normal, TOP=0xFFFF
; // desired value: 1Sec
; // actual value:  1.000Sec (0.0%)
; void timer1_init(void)
; {
	.dbline 95
;  TCCR1B = 0xFF; //stop
	ldi R24,255
	out 0x2e,R24
	.dbline 96
;  TCNT1H = 0x85; //setup
	ldi R24,133
	out 0x2d,R24
	.dbline 98
;  
;  TCNT1L = 0xEE;
	ldi R24,238
	out 0x2c,R24
	.dbline 99
;  OCR1AH = 0x7A;
	ldi R24,122
	out 0x2b,R24
	.dbline 100
;  OCR1AL = 0x12;
	ldi R24,18
	out 0x2a,R24
	.dbline 101
;  OCR1BH = 0x7A;
	ldi R24,122
	out 0x29,R24
	.dbline 102
;  OCR1BL = 0x12;
	ldi R24,18
	out 0x28,R24
	.dbline 104
; 
;  ICR1H  = 0x7A;
	ldi R24,122
	out 0x27,R24
	.dbline 105
;  ICR1L  = 0x12;
	ldi R24,18
	out 0x26,R24
	.dbline 106
;  TCCR1A = 0x00;
	clr R2
	out 0x2f,R2
	.dbline 107
;  TCCR1B = 0x03; //start Timer
	ldi R24,3
	out 0x2e,R24
	.dbline -2
L4:
	.dbline 0 ; func end
	ret
	.dbend
	.area vector(rom, abs)
	.org 32
	jmp _timer1_ovf_isr
	.area text(rom, con, rel)
	.dbfile E:\avr资料\例程\m16\new192128\192128.c
	.dbfunc e timer1_ovf_isr _timer1_ovf_isr fV
	.even
_timer1_ovf_isr::
	st -y,R2
	st -y,R24
	st -y,R25
	in R2,0x3f
	st -y,R2
	.dbline -1
	.dbline 112
; }
; 
; #pragma interrupt_handler timer1_ovf_isr:9
; void timer1_ovf_isr(void)
; {
	.dbline 114
;  //TIMER1 has overflowed
;  TCNT1H = 0x85; //reload counter high value
	ldi R24,133
	out 0x2d,R24
	.dbline 115
;  TCNT1L = 0xEE; //reload counter low value
	ldi R24,238
	out 0x2c,R24
	.dbline 116
;   data++;
	lds R24,_data
	subi R24,255    ; addi 1
	sts _data,R24
	.dbline 117
;  if(data == 2)
	cpi R24,2
	brne L6
	.dbline 118
;  {
	.dbline 119
;  SET_LCD_DLL();
	sbi 0x15,0
	.dbline 120
;  data = 0;
	clr R2
	sts _data,R2
	.dbline 121
;  }
	xjmp L7
L6:
	.dbline 123
;  else
;  CLR_LCD_DLL();
	cbi 0x15,0
L7:
	.dbline 126
;  
;  
;  SET_LCD_CL1();
	sbi 0x15,2
	.dbline 127
;  CLR_LCD_CL1();
	cbi 0x15,2
	.dbline 129
;  
;  DATA_PORT = 0Xf;     //装载数据
	ldi R24,15
	out 0x12,R24
	.dbline 130
;  CLR_LCD_CL2();
	cbi 0x15,3
	.dbline 131
;  SET_LCD_CL2();
	sbi 0x15,3
	.dbline -2
L5:
	ld R2,y+
	out 0x3f,R2
	ld R25,y+
	ld R24,y+
	ld R2,y+
	.dbline 0 ; func end
	reti
	.dbend
	.dbfunc e init_devices _init_devices fV
	.even
_init_devices::
	.dbline -1
	.dbline 140
;  }
;   
; 
; 
; 
; 
; //call this routine to initialize all peripherals
; void init_devices(void)
; {
	.dbline 142
;  //stop errant interrupts until set up
;  CLI(); //disable all interrupts
	cli
	.dbline 143
;  XDIV  = 0x00; //xtal divider
	clr R2
	out 0x3c,R2
	.dbline 144
;  XMCRA = 0x00; //external memory
	sts 109,R2
	.dbline 145
;  port_init();
	xcall _port_init
	.dbline 146
;  timer0_init();
	xcall _timer0_init
	.dbline 147
;  timer1_init();
	xcall _timer1_init
	.dbline 149
; 
;  MCUCR = 0x00;
	clr R2
	out 0x35,R2
	.dbline 150
;  EICRA = 0x00; //extended ext ints
	sts 106,R2
	.dbline 151
;  EICRB = 0x00; //extended ext ints
	out 0x3a,R2
	.dbline 152
;  EIMSK = 0x00;
	out 0x39,R2
	.dbline 153
;  TIMSK = 0x05; //timer interrupt sources
	ldi R24,5
	out 0x37,R24
	.dbline 155
;   
;  SEI(); //re-enable interrupts
	sei
	.dbline -2
L8:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e main _main fV
;              j -> <dead>
;              i -> <dead>
	.even
_main::
	.dbline -1
	.dbline 161
;  //all peripherals are now initialized
; }
; 
; //
; void main(void)
; {
	.dbline 163
;  int i,j;
;  init_devices();
	xcall _init_devices
	.dbline -2
L9:
	.dbline 0 ; func end
	ret
	.dbsym l j 1 I
	.dbsym l i 1 I
	.dbend
	.area bss(ram, con, rel)
	.dbfile E:\avr资料\例程\m16\new192128\192128.c
_data1::
	.blkb 1
	.dbsym e data1 _data1 c
