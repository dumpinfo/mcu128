	.module second.c
	.area lit(rom, con, rel)
_seg_table::
	.byte 48,49
	.byte 50,51
	.byte 52,53
	.byte 54,55
	.byte 56,57
	.dbfile E:\新建文件夹\avr资料\例程\m16\2402v32/1602.h
	.dbsym e seg_table _seg_table A[10:10]kc
	.area text(rom, con, rel)
	.dbfile E:\新建文件夹\avr资料\例程\m16\2402v32/1602.h
	.dbfunc e lcd_init _lcd_init fV
	.even
_lcd_init::
	.dbline -1
	.dbline 37
; //ICC-AVR application builder : 2006-12-22 20:34:51
; // Target : M8
; // Crystal: 6.0000Mhz
; //1602占用了PA口作为数据口,PD2,PD3,PD4分别是RS,WR,E
; //按纽采用循环检测方式工作，不采用中断方式.
; 
; 
; #include <iom16v.h>
; #include <macros.h>
; #include "1602.h"
; unsigned char led_buff[]="WWW.OUREMBED.COM        ";
; unsigned char str1[]="oCAO XIAO YAN ZI DE EJIA ";
; 
; 
; void timer1_init(void);
; void init_devices(void);
; unsigned char KeyPress(void);
; void delay_ms(unsigned int time);
; void StartCount(void);
; void StopCount(void);
; void Clear(void);
; unsigned int hour=0,minute=0,second=0,ms=0;
; unsigned char c_next=0,choose=0;
; 
; void port_init(void) 
; {
;  PORTB = 0xFF;
;  DDRB  = 0xFF;
;  PORTC = 0xFF; //m103 output only
;  DDRC  = 0xFF;
;  PORTD = 0xFF;
;  DDRD  = 0xFF;
;  PORTA = 0xFF;
;  DDRA  = 0xFF;
; }
; 
; //TIMER1 initialisation - prescale:8
	.dbline 38
; // WGM: 0) Normal, TOP=0xFFFF
	ldi R16,100
	ldi R17,0
	rcall _delay_nms
	.dbline 39
; // desired value: 1mSec
	clr R18
	ldi R16,56
	rcall _lcd_write_command
	.dbline 40
; // actual value:  1.000mSec (0.0%)
	ldi R16,20
	ldi R17,0
	rcall _delay_nms
	.dbline 41
; void timer1_init(void)
	clr R18
	ldi R16,56
	rcall _lcd_write_command
	.dbline 42
; {
	ldi R16,20
	ldi R17,0
	rcall _delay_nms
	.dbline 43
;  TCCR1B = 0x00; //stop
	clr R18
	ldi R16,56
	rcall _lcd_write_command
	.dbline 44
;  TCNT1H = 0x63; //setup
	ldi R16,20
	ldi R17,0
	rcall _delay_nms
	.dbline 46
;  TCNT1L = 0xc0;
;  OCR1AH = 0x17;
	ldi R18,1
	ldi R16,56
	rcall _lcd_write_command
	.dbline 47
;  OCR1AL = 0x70;
	ldi R18,1
	ldi R16,8
	rcall _lcd_write_command
	.dbline 48
;  OCR1BH = 0x17;
	ldi R18,1
	ldi R16,1
	rcall _lcd_write_command
	.dbline 49
;  OCR1BL = 0x70;
	ldi R18,1
	ldi R16,6
	rcall _lcd_write_command
	.dbline 50
;  ICR1H  = 0x17;
	ldi R18,1
	ldi R16,12
	rcall _lcd_write_command
	.dbline -2
L1:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e delay_1ms _delay_1ms fV
;              i -> R16,R17
	.even
_delay_1ms::
	.dbline -1
	.dbline 56
;  ICR1L  = 0x70;
;  TCCR1A = 0x00;
;  TCCR1B = 0x00; //start Timer
; }
; 
; #pragma interrupt_handler timer1_ovf_isr:9
	.dbline 58
	clr R16
	clr R17
	rjmp L6
L3:
	.dbline 58
L4:
	.dbline 58
	subi R16,255  ; offset = 1
	sbci R17,255
L6:
	.dbline 58
; void timer1_ovf_isr(void)
; {
	cpi R16,64
	ldi R30,6
	cpc R17,R30
	brlo L3
	.dbline -2
L2:
	.dbline 0 ; func end
	ret
	.dbsym r i 16 i
	.dbend
	.dbfunc e delay_nms _delay_nms fV
;              i -> R20,R21
;              n -> R22,R23
	.even
_delay_nms::
	rcall push_gset2
	movw R22,R16
	.dbline -1
	.dbline 63
;  //TIMER1 has overflowed
;  TCNT1H = 0x63; //reload counter high value
;  TCNT1L = 0xc0; //reload counter low value
; }
; 
	.dbline 65
	clr R20
	clr R21
	rjmp L11
L8:
	.dbline 65
	rcall _delay_1ms
L9:
	.dbline 65
	subi R20,255  ; offset = 1
	sbci R21,255
L11:
	.dbline 65
; //call this routine to initialise all peripherals
; void init_devices(void)
	cp R20,R22
	cpc R21,R23
	brlo L8
	.dbline -2
L7:
	rcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r i 20 i
	.dbsym r n 22 i
	.dbend
	.dbfunc e lcd_write_command _lcd_write_command fV
;        wait_en -> R22
;        command -> R20
	.even
_lcd_write_command::
	rcall push_gset2
	mov R22,R18
	mov R20,R16
	.dbline -1
	.dbline 70
; {
;  //stop errant interrupts until set up
;  CLI(); //disable all interrupts
;  port_init();
;  timer1_init();
	.dbline 71
; 
	tst R22
	breq L13
	.dbline 71
	rcall _wait_enable
L13:
	.dbline 72
;  MCUCR = 0x0A;
	cbi 0x12,0
	.dbline 73
;  GICR  = 0x00;
	cbi 0x12,1
	.dbline 74
;  TIMSK = 0x04; //timer interrupt sources
	cbi 0x12,2
	.dbline 75
;  SEI(); //re-enable interrupts
	nop
	.dbline 76
;  //all peripherals are now initialised
	sbi 0x12,2
	.dbline 77
; }
	out 0x1b,R20
	.dbline 78
; 
	cbi 0x12,2
	.dbline -2
L12:
	rcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r wait_en 22 c
	.dbsym r command 20 c
	.dbend
	.dbfunc e display_a_char _display_a_char fV
;   position_tem -> R22
;      char_data -> R20
;       position -> R10
	.even
_display_a_char::
	rcall push_gset3
	mov R20,R18
	mov R10,R16
	.dbline -1
	.dbline 84
; //
; void main(void)
; {
;  init_devices();
;  lcd_init();
;  //insert your functional code here...
	.dbline 86
;  display_a_string(0,led_buff);
;  display_a_string(1,str1);
	mov R24,R10
	cpi R24,24
	brlo L16
	.dbline 87
;  
	mov R22,R24
	subi R22,88    ; addi 168
	rjmp L17
L16:
	.dbline 89
; 
; }
	mov R22,R10
	subi R22,128    ; addi 128
L17:
	.dbline 90
; 
	ldi R18,1
	mov R16,R22
	rcall _lcd_write_command
	.dbline 91
; //延时
	mov R16,R20
	rcall _lcd_write_data
	.dbline -2
L15:
	rcall pop_gset3
	.dbline 0 ; func end
	ret
	.dbsym r position_tem 22 c
	.dbsym r char_data 20 c
	.dbsym r position 10 c
	.dbend
	.dbfunc e display_a_string _display_a_string fV
;        col_tem -> R20
;              i -> R22
;            ptr -> R10,R11
;            col -> R20
	.even
_display_a_string::
	rcall push_gset3
	movw R10,R18
	mov R20,R16
	.dbline -1
	.dbline 97
; void delay_ms(unsigned int time)
; { unsigned int i,j;
;   
;   for(j=0;j<time;j++)
;   { for(i=0;i<1000;i++)
;      time=time;
	.dbline 99
;   }
; }
	ldi R24,24
	mul R24,R20
	mov R20,R0
	.dbline 100
; 
	clr R22
	rjmp L22
L19:
	.dbline 101
	mov R30,R22
	clr R31
	add R30,R10
	adc R31,R11
	ldd R18,z+0
	mov R2,R20
	subi R20,255    ; addi 1
	mov R16,R2
	rcall _display_a_char
L20:
	.dbline 100
	inc R22
L22:
	.dbline 100
	cpi R22,24
	brlo L19
	.dbline -2
L18:
	rcall pop_gset3
	.dbline 0 ; func end
	ret
	.dbsym r col_tem 20 c
	.dbsym r i 22 c
	.dbsym r ptr 10 pc
	.dbsym r col 20 c
	.dbend
	.dbfunc e lcd_write_data _lcd_write_data fV
;      char_data -> R20
	.even
_lcd_write_data::
	rcall push_gset1
	mov R20,R16
	.dbline -1
	.dbline 106
; //键盘
; 
; 
; 
; 
; 
	.dbline 107
; 
	rcall _wait_enable
	.dbline 108
; 
	sbi 0x12,0
	.dbline 109
; 
	cbi 0x12,1
	.dbline 110
; 
	cbi 0x12,2
	.dbline 111
; 
	nop
	.dbline 112
; 
	sbi 0x12,2
	.dbline 113
; 
	out 0x1b,R20
	.dbline 114
; 
	cbi 0x12,2
	.dbline -2
L23:
	rcall pop_gset1
	.dbline 0 ; func end
	ret
	.dbsym r char_data 20 c
	.dbend
	.dbfunc e wait_enable _wait_enable fV
	.even
_wait_enable::
	.dbline -1
	.dbline 120
; 
; 
; 
; 
; 
; 
	.dbline 121
; 
	cbi 0x1a,7
	.dbline 122
; 
	cbi 0x12,0
	.dbline 123
; 
	sbi 0x12,1
	.dbline 124
; 
	nop
	.dbline 125
; 
	sbi 0x12,2
L25:
	.dbline 126
L26:
	.dbline 126
; 
	sbic 0x19,7
	rjmp L25
	.dbline 127
; 
	cbi 0x12,2
	.dbline 128
; 
	sbi 0x1a,7
	.dbline -2
L24:
	.dbline 0 ; func end
	ret
	.dbend
	.area data(ram, con, rel)
	.dbfile E:\新建文件夹\avr资料\例程\m16\2402v32/1602.h
_led_buff::
	.blkb 25
	.area idata
	.byte 'W,'W,'W,46,'O,'U,'R,'E,'M,'B,'E,'D,46,'C,'O,'M
	.byte 32,32,32,32,32,32,32,32,0
	.area data(ram, con, rel)
	.dbfile E:\新建文件夹\avr资料\例程\m16\2402v32/1602.h
	.dbfile E:\新建文件夹\avr资料\例程\m16\2402v32\second.c
	.dbsym e led_buff _led_buff A[25:25]c
_str1::
	.blkb 26
	.area idata
	.byte 'o,'C,'A,'O,32,'X,'I,'A,'O,32,'Y,'A,'N,32,'Z,'I
	.byte 32,'D,'E,32,'E,'J,'I,'A,32,0
	.area data(ram, con, rel)
	.dbfile E:\新建文件夹\avr资料\例程\m16\2402v32\second.c
	.dbsym e str1 _str1 A[26:26]c
_hour::
	.blkb 2
	.area idata
	.word 0
	.area data(ram, con, rel)
	.dbfile E:\新建文件夹\avr资料\例程\m16\2402v32\second.c
	.dbsym e hour _hour i
_minute::
	.blkb 2
	.area idata
	.word 0
	.area data(ram, con, rel)
	.dbfile E:\新建文件夹\avr资料\例程\m16\2402v32\second.c
	.dbsym e minute _minute i
_second::
	.blkb 2
	.area idata
	.word 0
	.area data(ram, con, rel)
	.dbfile E:\新建文件夹\avr资料\例程\m16\2402v32\second.c
	.dbsym e second _second i
_ms::
	.blkb 2
	.area idata
	.word 0
	.area data(ram, con, rel)
	.dbfile E:\新建文件夹\avr资料\例程\m16\2402v32\second.c
	.dbsym e ms _ms i
_c_next::
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile E:\新建文件夹\avr资料\例程\m16\2402v32\second.c
	.dbsym e c_next _c_next c
_choose::
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile E:\新建文件夹\avr资料\例程\m16\2402v32\second.c
	.dbsym e choose _choose c
	.area text(rom, con, rel)
	.dbfile E:\新建文件夹\avr资料\例程\m16\2402v32\second.c
	.dbfunc e port_init _port_init fV
	.even
_port_init::
	.dbline -1
	.dbline 26
	.dbline 27
	ldi R24,255
	out 0x18,R24
	.dbline 28
	out 0x17,R24
	.dbline 29
	out 0x15,R24
	.dbline 30
	out 0x14,R24
	.dbline 31
	out 0x12,R24
	.dbline 32
	out 0x11,R24
	.dbline 33
	out 0x1b,R24
	.dbline 34
	out 0x1a,R24
	.dbline -2
L28:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e timer1_init _timer1_init fV
	.even
_timer1_init::
	.dbline -1
	.dbline 42
	.dbline 43
	clr R2
	out 0x2e,R2
	.dbline 44
	ldi R24,99
	out 0x2d,R24
	.dbline 45
	ldi R24,192
	out 0x2c,R24
	.dbline 46
	ldi R24,23
	out 0x2b,R24
	.dbline 47
	ldi R24,112
	out 0x2a,R24
	.dbline 48
	ldi R24,23
	out 0x29,R24
	.dbline 49
	ldi R24,112
	out 0x28,R24
	.dbline 50
	ldi R24,23
	out 0x27,R24
	.dbline 51
	ldi R24,112
	out 0x26,R24
	.dbline 52
	out 0x2f,R2
	.dbline 53
	out 0x2e,R2
	.dbline -2
L29:
	.dbline 0 ; func end
	ret
	.dbend
	.area vector(rom, abs)
	.org 16
	rjmp _timer1_ovf_isr
	.area text(rom, con, rel)
	.dbfile E:\新建文件夹\avr资料\例程\m16\2402v32\second.c
	.dbfunc e timer1_ovf_isr _timer1_ovf_isr fV
	.even
_timer1_ovf_isr::
	st -y,R24
	in R24,0x3f
	st -y,R24
	.dbline -1
	.dbline 58
	.dbline 60
	ldi R24,99
	out 0x2d,R24
	.dbline 61
	ldi R24,192
	out 0x2c,R24
	.dbline -2
L30:
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
	.dbline 66
	.dbline 68
	cli
	.dbline 69
	rcall _port_init
	.dbline 70
	rcall _timer1_init
	.dbline 72
	ldi R24,10
	out 0x35,R24
	.dbline 73
	clr R2
	out 0x3b,R2
	.dbline 74
	ldi R24,4
	out 0x39,R24
	.dbline 75
	sei
	.dbline -2
L31:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e main _main fV
	.even
_main::
	.dbline -1
	.dbline 81
	.dbline 82
	rcall _init_devices
	.dbline 83
	rcall _lcd_init
	.dbline 85
	ldi R18,<_led_buff
	ldi R19,>_led_buff
	clr R16
	rcall _display_a_string
	.dbline 86
	ldi R18,<_str1
	ldi R19,>_str1
	ldi R16,1
	rcall _display_a_string
	.dbline -2
L32:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e delay_ms _delay_ms fV
;              j -> R20,R21
;              i -> R22,R23
;           time -> R16,R17
	.even
_delay_ms::
	rcall push_gset2
	.dbline -1
	.dbline 93
	.dbline 95
	clr R20
	clr R21
	rjmp L37
L34:
	.dbline 96
	.dbline 96
	clr R22
	clr R23
	rjmp L41
L38:
	.dbline 97
L39:
	.dbline 96
	subi R22,255  ; offset = 1
	sbci R23,255
L41:
	.dbline 96
	cpi R22,232
	ldi R30,3
	cpc R23,R30
	brlo L38
	.dbline 98
L35:
	.dbline 95
	subi R20,255  ; offset = 1
	sbci R21,255
L37:
	.dbline 95
	cp R20,R16
	cpc R21,R17
	brlo L34
	.dbline -2
L33:
	rcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r j 20 i
	.dbsym r i 22 i
	.dbsym r time 16 i
	.dbend
