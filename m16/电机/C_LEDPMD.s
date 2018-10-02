	.module C_LEDPMD.C
	.area data(ram, con, rel)
_LM_Data::
	.blkb 2
	.area idata
	.word 1
	.area data(ram, con, rel)
	.dbfile E:\新建文件夹\avr资料\例程\m16\电机\C_LEDPMD.C
	.dbsym e LM_Data _LM_Data i
	.area text(rom, con, rel)
	.dbfile E:\新建文件夹\avr资料\例程\m16\电机\C_LEDPMD.C
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
; //该程序使用了PA口，请将PA口接到LED的脚上，然后运行程序
; //显示结果应该是循环点亮LED，
; //请注意主频
; #include <iom16v.h>
; #include <macros.h>
; 
; unsigned LM_Data=1;
; void port_init(void)
; {
	.dbline 16
;  PORTA = 0xFF;
	ldi R24,255
	out 0x1b,R24
	.dbline 17
;  DDRA  = 0xFF;
	out 0x1a,R24
	.dbline 18
;  PORTB = 0x00;
	clr R2
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
;  PORTD = 0x00;
	out 0x12,R2
	.dbline 23
;  DDRD  = 0x00;
	out 0x11,R2
	.dbline -2
L1:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e timer1_init _timer1_init fV
	.even
_timer1_init::
	.dbline -1
	.dbline 31
; }
; 
; //TIMER1 initialize - prescale:256
; // WGM: 0) Normal, TOP=0xFFFF
; // desired value: 1Sec
; // actual value:  1.000Sec (0.0%)
; void timer1_init(void)
; {
	.dbline 32
;  TCCR1B = 0x00; //stop
	clr R2
	out 0x2e,R2
	.dbline 33
;  TCNT1H = 0xcF; //setup
	ldi R24,207
	out 0x2d,R24
	.dbline 34
;  TCNT1L = 0xc1;
	ldi R24,193
	out 0x2c,R24
	.dbline 35
;  OCR1AH = 0x70;
	ldi R24,112
	out 0x2b,R24
	.dbline 36
;  OCR1AL = 0x7F;
	ldi R24,127
	out 0x2a,R24
	.dbline 37
;  OCR1BH = 0x70;
	ldi R24,112
	out 0x29,R24
	.dbline 38
;  OCR1BL = 0x7F;
	ldi R24,127
	out 0x28,R24
	.dbline 39
;  ICR1H  = 0x70;
	ldi R24,112
	out 0x27,R24
	.dbline 40
;  ICR1L  = 0x7F;
	ldi R24,127
	out 0x26,R24
	.dbline 41
;  TCCR1A = 0x00;
	out 0x2f,R2
	.dbline 42
;  TCCR1B = 0x02; //start Timer
	ldi R24,2
	out 0x2e,R24
	.dbline -2
L2:
	.dbline 0 ; func end
	ret
	.dbend
	.area vector(rom, abs)
	.org 32
	jmp _timer1_ovf_isr
	.area text(rom, con, rel)
	.dbfile E:\新建文件夹\avr资料\例程\m16\电机\C_LEDPMD.C
	.dbfunc e timer1_ovf_isr _timer1_ovf_isr fV
	.even
_timer1_ovf_isr::
	st -y,R2
	st -y,R3
	st -y,R24
	st -y,R25
	st -y,R30
	in R2,0x3f
	st -y,R2
	.dbline -1
	.dbline 47
; }
; 
; #pragma interrupt_handler timer1_ovf_isr:9
; void timer1_ovf_isr(void)
; {
	.dbline 49
;  //TIMER1 has overflowed
;  TCNT1H = 0xeF; //reload counter high value
	ldi R24,239
	out 0x2d,R24
	.dbline 50
;  TCNT1L = 0xff; //reload counter low value
	ldi R24,255
	out 0x2c,R24
	.dbline 51
;  PORTA = LM_Data;
	lds R2,_LM_Data
	lds R3,_LM_Data+1
	out 0x1b,R2
	.dbline 53
;  
;  switch (LM_Data)
	movw R24,R2
	cpi R24,1
	ldi R30,0
	cpc R25,R30
	breq L6
	cpi R24,2
	ldi R30,0
	cpc R25,R30
	breq L8
	cpi R24,3
	ldi R30,0
	cpc R25,R30
	breq L7
	cpi R24,4
	ldi R30,0
	cpc R25,R30
	breq L10
	cpi R24,6
	ldi R30,0
	cpc R25,R30
	breq L9
	cpi R24,8
	ldi R30,0
	cpc R25,R30
	breq L12
	cpi R24,9
	ldi R30,0
	cpc R25,R30
	breq L13
	cpi R24,12
	ldi R30,0
	cpc R25,R30
	breq L11
	xjmp L4
X0:
	.dbline 54
;  {
L6:
	.dbline 55
;   case 1: LM_Data = 3;
	ldi R24,3
	ldi R25,0
	sts _LM_Data+1,R25
	sts _LM_Data,R24
	.dbline 56
;           break;
	xjmp L5
L7:
	.dbline 58
; 		  
;   case 3: LM_Data = 2;
	ldi R24,2
	ldi R25,0
	sts _LM_Data+1,R25
	sts _LM_Data,R24
	.dbline 59
;           break;
	xjmp L5
L8:
	.dbline 60
;   case 2: LM_Data = 6;
	ldi R24,6
	ldi R25,0
	sts _LM_Data+1,R25
	sts _LM_Data,R24
	.dbline 61
;           break;
	xjmp L5
L9:
	.dbline 62
;   case 6: LM_Data = 4;
	ldi R24,4
	ldi R25,0
	sts _LM_Data+1,R25
	sts _LM_Data,R24
	.dbline 63
;           break;
	xjmp L5
L10:
	.dbline 64
;   case 4: LM_Data = 12;
	ldi R24,12
	ldi R25,0
	sts _LM_Data+1,R25
	sts _LM_Data,R24
	.dbline 65
;           break;
	xjmp L5
L11:
	.dbline 66
;   case 12:	LM_Data = 8;
	ldi R24,8
	ldi R25,0
	sts _LM_Data+1,R25
	sts _LM_Data,R24
	.dbline 67
;           break;
	xjmp L5
L12:
	.dbline 68
;   case 8: 	LM_Data = 9;
	ldi R24,9
	ldi R25,0
	sts _LM_Data+1,R25
	sts _LM_Data,R24
	.dbline 69
;           break;
	xjmp L5
L13:
	.dbline 70
;   case 9: 	LM_Data = 1;
	ldi R24,1
	ldi R25,0
	sts _LM_Data+1,R25
	sts _LM_Data,R24
	.dbline 71
;           break;
L4:
L5:
	.dbline -2
L3:
	ld R2,y+
	out 0x3f,R2
	ld R30,y+
	ld R25,y+
	ld R24,y+
	ld R3,y+
	ld R2,y+
	.dbline 0 ; func end
	reti
	.dbend
	.dbfunc e init_devices _init_devices fV
	.even
_init_devices::
	.dbline -1
	.dbline 78
; 	 
;  }
; }
; 
; //call this routine to initialize all peripherals
; void init_devices(void)
; {
	.dbline 80
;  //stop errant interrupts until set up
;  CLI(); //disable all interrupts
	cli
	.dbline 81
;  port_init();
	xcall _port_init
	.dbline 82
;  timer1_init();
	xcall _timer1_init
	.dbline 84
; 
;  MCUCR = 0x00;
	clr R2
	out 0x35,R2
	.dbline 85
;  GICR  = 0x00;
	out 0x3b,R2
	.dbline 86
;  TIMSK = 0x04; //timer interrupt sources
	ldi R24,4
	out 0x39,R24
	.dbline 87
;  SEI(); //re-enable interrupts
	sei
	.dbline -2
L14:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e main _main fV
	.even
_main::
	.dbline -1
	.dbline 93
;  //all peripherals are now initialized
; }
; 
; //
; void main(void)
; {
	.dbline 94
;  init_devices();
	xcall _init_devices
	.dbline -2
L15:
	.dbline 0 ; func end
	ret
	.dbend
