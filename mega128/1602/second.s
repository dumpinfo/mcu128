	.module second.c
	.area lit(rom, con, rel)
_seg_table::
	.byte 48,49
	.byte 50,51
	.byte 52,53
	.byte 54,55
	.byte 56,57
	.dbfile E:\avr资料\例程\mega128\1602/1602.h
	.dbsym e seg_table _seg_table A[10:10]kc
	.area text(rom, con, rel)
	.dbfile E:\avr资料\例程\mega128\1602/1602.h
	.dbfunc e lcd_init _lcd_init fV
	.even
_lcd_init::
	.dbline -1
	.dbline 37
; //ICC-AVR application builder : 2006-12-22 20:34:51
; // Target : M8
; // Crystal: 6.0000Mhz
; //1602占用了PC口作为数据口,PD5,PD6,PD7分别是RS,WR,E
; //按纽采用循环检测方式工作，不采用中断方式.
; 
; 
; //ICC-AVR application builder : 2007-6-26 15:29:01
; // Target : M128
; // Crystal: 6.0000Mhz
; 
; #include <iom128v.h>
; #include <macros.h>
; 
; #include "1602.h"
; unsigned char led_buff[]="qian ru shi LM! ";
; unsigned char str1[]="www.ourembed.com";
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
;  PORTA = 0xFF;
;  DDRA  = 0xFF;
;  PORTB = 0xFF;
;  DDRB  = 0xFF;
;  PORTC = 0xFF; //m103 output only
;  DDRC  = 0xFF;
	.dbline 38
;  PORTD = 0xFF;
	ldi R16,100
	ldi R17,0
	xcall _delay_nms
	.dbline 39
;  DDRD  = 0xFF;
	clr R18
	ldi R16,56
	xcall _lcd_write_command
	.dbline 40
;  PORTE = 0xFF;
	ldi R16,20
	ldi R17,0
	xcall _delay_nms
	.dbline 41
;  DDRE  = 0xFF;
	clr R18
	ldi R16,56
	xcall _lcd_write_command
	.dbline 42
;  PORTF = 0xFF;
	ldi R16,20
	ldi R17,0
	xcall _delay_nms
	.dbline 43
;  DDRF  = 0xFF;
	clr R18
	ldi R16,56
	xcall _lcd_write_command
	.dbline 44
;  PORTG = 0x1F;
	ldi R16,20
	ldi R17,0
	xcall _delay_nms
	.dbline 46
;  DDRG  = 0xFF;
; }
	ldi R18,1
	ldi R16,56
	xcall _lcd_write_command
	.dbline 47
; 
	ldi R18,1
	ldi R16,8
	xcall _lcd_write_command
	.dbline 48
; //call this routine to initialise all peripherals
	ldi R18,1
	ldi R16,1
	xcall _lcd_write_command
	.dbline 49
; void init_devices(void)
	ldi R18,1
	ldi R16,6
	xcall _lcd_write_command
	.dbline 50
; {
	ldi R18,1
	ldi R16,12
	xcall _lcd_write_command
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
;  //stop errant interrupts until set up
;  CLI(); //disable all interrupts
;  XDIV  = 0x00; //xtal divider
;  XMCRA = 0x00; //external memory
;  port_init();
; 
	.dbline 58
	clr R16
	clr R17
	xjmp L6
L3:
	.dbline 58
L4:
	.dbline 58
	subi R16,255  ; offset = 1
	sbci R17,255
L6:
	.dbline 58
;  MCUCR = 0x00;
;  EICRA = 0x00; //extended ext ints
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
	xcall push_gset2
	movw R22,R16
	.dbline -1
	.dbline 63
;  EICRB = 0x00; //extended ext ints
;  EIMSK = 0x00;
;  TIMSK = 0x00; //timer interrupt sources
;  ETIMSK = 0x00; //extended timer interrupt sources
;  SEI(); //re-enable interrupts
	.dbline 65
	clr R20
	clr R21
	xjmp L11
L8:
	.dbline 65
	xcall _delay_1ms
L9:
	.dbline 65
	subi R20,255  ; offset = 1
	sbci R21,255
L11:
	.dbline 65
;  //all peripherals are now initialised
; }
	cp R20,R22
	cpc R21,R23
	brlo L8
	.dbline -2
L7:
	xcall pop_gset2
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
	xcall push_gset2
	mov R22,R18
	mov R20,R16
	.dbline -1
	.dbline 70
; 
; 
; 
; 
; 
	.dbline 71
; //
	tst R22
	breq L13
	.dbline 71
	xcall _wait_enable
L13:
	.dbline 72
; void main(void)
	cbi 0x12,5
	.dbline 73
; {
	cbi 0x12,6
	.dbline 74
;  init_devices();
	cbi 0x12,7
	.dbline 75
;  lcd_init();
	nop
	.dbline 76
;  //insert your functional code here...
	sbi 0x12,7
	.dbline 77
;  display_a_string(0,led_buff);
	out 0x15,R20
	.dbline 78
;  display_a_string(1,str1);
	cbi 0x12,7
	.dbline -2
L12:
	xcall pop_gset2
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
	xcall push_gset3
	mov R20,R18
	mov R10,R16
	.dbline -1
	.dbline 84
;  
; 
; }
; 
; //延时
; void delay_ms(unsigned int time)
	.dbline 86
; { unsigned int i,j;
;   
	mov R24,R10
	cpi R24,16
	brlo L16
	.dbline 87
;   for(j=0;j<time;j++)
	mov R22,R24
	subi R22,80    ; addi 176
	xjmp L17
L16:
	.dbline 89
;   { for(i=0;i<1000;i++)
;      time=time;
	mov R22,R10
	subi R22,128    ; addi 128
L17:
	.dbline 90
;   }
	ldi R18,1
	mov R16,R22
	xcall _lcd_write_command
	.dbline 91
; }
	mov R16,R20
	xcall _lcd_write_data
	.dbline -2
L15:
	xcall pop_gset3
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
	xcall push_gset3
	movw R10,R18
	mov R20,R16
	.dbline -1
	.dbline 97
; 
; //键盘
; 
; 
; 
; 
	.dbline 99
; 
; 
	mov R24,R20
	andi R24,#0x0F
	swap R24
	mov R20,R24
	.dbline 100
; 
	clr R22
	xjmp L22
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
	xcall _display_a_char
L20:
	.dbline 100
	inc R22
L22:
	.dbline 100
	cpi R22,16
	brlo L19
	.dbline -2
L18:
	xcall pop_gset3
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
	xcall push_gset1
	mov R20,R16
	.dbline -1
	.dbline 106
; 
; 
; 
; 
; 
; 
	.dbline 107
; 
	xcall _wait_enable
	.dbline 108
; 
	sbi 0x12,5
	.dbline 109
; 
	cbi 0x12,6
	.dbline 110
; 
	cbi 0x12,7
	.dbline 111
; 
	nop
	.dbline 112
; 
	sbi 0x12,7
	.dbline 113
; 
	out 0x15,R20
	.dbline 114
; 
	cbi 0x12,7
	.dbline -2
L23:
	xcall pop_gset1
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
	cbi 0x14,7
	.dbline 122
; 
	cbi 0x12,5
	.dbline 123
; 
	sbi 0x12,6
	.dbline 124
; 
	nop
	.dbline 125
; 
	sbi 0x12,7
L25:
	.dbline 126
L26:
	.dbline 126
; 
	sbic 0x13,7
	rjmp L25
	.dbline 127
; 
	cbi 0x12,7
	.dbline 128
; 
	sbi 0x14,7
	.dbline -2
L24:
	.dbline 0 ; func end
	ret
	.dbend
	.area data(ram, con, rel)
	.dbfile E:\avr资料\例程\mega128\1602/1602.h
_led_buff::
	.blkb 17
	.area idata
	.byte 'q,'i,'a,'n,32,'r,'u,32,'s,'h,'i,32,'L,'M,33,32
	.byte 0
	.area data(ram, con, rel)
	.dbfile E:\avr资料\例程\mega128\1602/1602.h
	.dbfile E:\avr资料\例程\mega128\1602\second.c
	.dbsym e led_buff _led_buff A[17:17]c
_str1::
	.blkb 17
	.area idata
	.byte 'w,'w,'w,46,'o,'u,'r,'e,'m,'b,'e,'d,46,'c,'o,'m
	.byte 0
	.area data(ram, con, rel)
	.dbfile E:\avr资料\例程\mega128\1602\second.c
	.dbsym e str1 _str1 A[17:17]c
_hour::
	.blkb 2
	.area idata
	.word 0
	.area data(ram, con, rel)
	.dbfile E:\avr资料\例程\mega128\1602\second.c
	.dbsym e hour _hour i
_minute::
	.blkb 2
	.area idata
	.word 0
	.area data(ram, con, rel)
	.dbfile E:\avr资料\例程\mega128\1602\second.c
	.dbsym e minute _minute i
_second::
	.blkb 2
	.area idata
	.word 0
	.area data(ram, con, rel)
	.dbfile E:\avr资料\例程\mega128\1602\second.c
	.dbsym e second _second i
_ms::
	.blkb 2
	.area idata
	.word 0
	.area data(ram, con, rel)
	.dbfile E:\avr资料\例程\mega128\1602\second.c
	.dbsym e ms _ms i
_c_next::
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile E:\avr资料\例程\mega128\1602\second.c
	.dbsym e c_next _c_next c
_choose::
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile E:\avr资料\例程\mega128\1602\second.c
	.dbsym e choose _choose c
	.area text(rom, con, rel)
	.dbfile E:\avr资料\例程\mega128\1602\second.c
	.dbfunc e port_init _port_init fV
	.even
_port_init::
	.dbline -1
	.dbline 31
	.dbline 32
	ldi R24,255
	out 0x1b,R24
	.dbline 33
	out 0x1a,R24
	.dbline 34
	out 0x18,R24
	.dbline 35
	out 0x17,R24
	.dbline 36
	out 0x15,R24
	.dbline 37
	out 0x14,R24
	.dbline 38
	out 0x12,R24
	.dbline 39
	out 0x11,R24
	.dbline 40
	out 0x3,R24
	.dbline 41
	out 0x2,R24
	.dbline 42
	sts 98,R24
	.dbline 43
	sts 97,R24
	.dbline 44
	ldi R24,31
	sts 101,R24
	.dbline 45
	ldi R24,255
	sts 100,R24
	.dbline -2
L28:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e init_devices _init_devices fV
	.even
_init_devices::
	.dbline -1
	.dbline 50
	.dbline 52
	cli
	.dbline 53
	clr R2
	out 0x3c,R2
	.dbline 54
	sts 109,R2
	.dbline 55
	xcall _port_init
	.dbline 57
	clr R2
	out 0x35,R2
	.dbline 58
	sts 106,R2
	.dbline 59
	out 0x3a,R2
	.dbline 60
	out 0x39,R2
	.dbline 61
	out 0x37,R2
	.dbline 62
	sts 125,R2
	.dbline 63
	sei
	.dbline -2
L29:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e main _main fV
	.even
_main::
	.dbline -1
	.dbline 73
	.dbline 74
	xcall _init_devices
	.dbline 75
	xcall _lcd_init
	.dbline 77
	ldi R18,<_led_buff
	ldi R19,>_led_buff
	clr R16
	xcall _display_a_string
	.dbline 78
	ldi R18,<_str1
	ldi R19,>_str1
	ldi R16,1
	xcall _display_a_string
	.dbline -2
L30:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e delay_ms _delay_ms fV
;              j -> R20,R21
;              i -> R22,R23
;           time -> R16,R17
	.even
_delay_ms::
	xcall push_gset2
	.dbline -1
	.dbline 85
	.dbline 87
	clr R20
	clr R21
	xjmp L35
L32:
	.dbline 88
	.dbline 88
	clr R22
	clr R23
	xjmp L39
L36:
	.dbline 89
L37:
	.dbline 88
	subi R22,255  ; offset = 1
	sbci R23,255
L39:
	.dbline 88
	cpi R22,232
	ldi R30,3
	cpc R23,R30
	brlo L36
	.dbline 90
L33:
	.dbline 87
	subi R20,255  ; offset = 1
	sbci R21,255
L35:
	.dbline 87
	cp R20,R16
	cpc R21,R17
	brlo L32
	.dbline -2
L31:
	xcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r j 20 i
	.dbsym r i 22 i
	.dbsym r time 16 i
	.dbend
