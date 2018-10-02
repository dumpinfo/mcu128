	.module main.c
	.area lit(rom, con, rel)
_font::
	.byte 0,224
	.byte 16,8
	.byte 8,16
	.byte 224,0
	.byte 0,15
	.byte 16,32
	.byte 32,16
	.byte 15,0
	.byte 0,16
	.byte 16,248
	.byte 0,0
	.byte 0,0
	.byte 0,32
	.byte 32,63
	.byte 32,32
	.byte 0,0
	.byte 0,'p
	.byte 8,8
	.byte 8,136
	.byte 'p,0
	.byte 0,48
	.byte 40,36
	.byte 34,33
	.byte 48,0
	.byte 0,48
	.byte 8,136
	.byte 136,'H
	.byte 48,0
	.byte 0,24
	.byte 32,32
	.byte 32,17
	.byte 14,0
	.byte 0,0
	.byte 192,32
	.byte 16,248
	.byte 0,0
	.byte 0,7
	.byte 4,36
	.byte 36,63
	.byte 36,0
	.byte 0,248
	.byte 8,136
	.byte 136,8
	.byte 8,0
	.byte 0,25
	.byte 33,32
	.byte 32,17
	.byte 14,0
	.byte 0,224
	.byte 16,136
	.byte 136,24
	.byte 0,0
	.byte 0,15
	.byte 17,32
	.byte 32,17
	.byte 14,0
	.byte 0,56
	.byte 8,8
	.byte 200,56
	.byte 8,0
	.byte 0,0
	.byte 0,63
	.byte 0,0
	.byte 0,0
	.byte 0,'p
	.byte 136,8
	.byte 8,136
	.byte 'p,0
	.byte 0,28
	.byte 34,33
	.byte 33,34
	.byte 28,0
	.byte 0,224
	.byte 16,8
	.byte 8,16
	.byte 224,0
	.byte 0,0
	.byte 49,34
	.byte 34,17
	.byte 15,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,48
	.byte 48,0
	.byte 0,0
	.byte 0,0
	.byte 20,36
	.byte 'D,132
	.byte 'd,28
	.byte 32,24
	.byte 15,232
	.byte 8,8
	.byte 40,24
	.byte 8,0
	.byte 32,16
	.byte 'L,'C
	.byte 'C,44
	.byte 32,16
	.byte 12,3
	.byte 6,24
	.byte 48,96
	.byte 32,0
	.byte 64,'A
	.byte 206,4
	.byte 0,252
	.byte 4,2
	.byte 2,252
	.byte 4,4
	.byte 4,252
	.byte 0,0
	.byte 64,32
	.byte 31,32
	.byte 64,'G
	.byte 'B,'A
	.byte 64,95
	.byte 64,'B
	.byte 'D,'C
	.byte 64,0
	.byte 64,32
	.byte 240,28
	.byte 7,242
	.byte 148,148
	.byte 148,255
	.byte 148,148
	.byte 148,244
	.byte 4,0
	.byte 0,0
	.byte 127,0
	.byte 64,'A
	.byte 34,20
	.byte 12,19
	.byte 16,48
	.byte 32,'a
	.byte 32,0
	.byte 0,0
	.byte 0,254
	.byte 34,34
	.byte 34,34
	.byte 254,34
	.byte 34,34
	.byte 34,254
	.byte 0,0
	.byte 128,64
	.byte 48,15
	.byte 2,2
	.byte 2,2
	.byte 255,2
	.byte 2,'B
	.byte 130,127
	.byte 0,0
	.dbfile D:\mega16ѧϰ������\����\m16\12864/font.h
	.dbsym e font _font A[304:304]kc
	.area text(rom, con, rel)
	.dbfile D:\mega16ѧϰ������\����\m16\12864/font.h
	.dbfile D:\mega16ѧϰ������\����\m16\12864/12864.H
	.dbfunc e delay _delay fV
;              i -> R20,R21
;              j -> R22,R23
;              t -> R16,R17
	.even
_delay::
	xcall push_gset2
	.dbline -1
	.dbline 45
; //AM12864�ο�����(st7920)
; /********************************************/
; /* AM12864ϵ�в��Գ��� 1.0for mega16 */
; /* Designed by ourembed.com */
; /* 2003.04.23 */
; /********************************************/
; //ICC-AVR application builder : 2006-11-7 18:33:11
; // Target : M16
; // Crystal: 4.0000Mhz
; 
; #include <iom16v.h>
; #include <macros.h>
; 
; #include "12864.H"
; 
; 
; 
; 
; void port_init(void)
; {
;  PORTA = 0xFF;
;  DDRA  = 0xFF;
;  PORTB = 0xFF;
;  DDRB  = 0xFF;
;  PORTC = 0xFF; //m103 output only
;  DDRC  = 0xFF;
;  PORTD = 0xFF;
;  DDRD  = 0xFF;
; }
; 
; //call this routine to initialise all peripherals
; void init_devices(void)
; {
;  //stop errant interrupts until set up
;  CLI(); //disable all interrupts
;  port_init();
; 
;  MCUCR = 0x00;
;  GICR  = 0x00;
;  TIMSK = 0x00; //timer interrupt sources
;  SEI(); //re-enable interrupts
;  //all peripherals are now initialised
; }
; 
; //
	.dbline 47
; void main(void)
; {int i,j;
	clr R20
	clr R21
	xjmp L5
L2:
	.dbline 48
;  init_devices();
	clr R22
	clr R23
	xjmp L9
L6:
	.dbline 49
L7:
	.dbline 48
	subi R22,255  ; offset = 1
	sbci R23,255
L9:
	.dbline 48
	cpi R22,10
	ldi R30,0
	cpc R23,R30
	brlo L6
L3:
	.dbline 47
	subi R20,255  ; offset = 1
	sbci R21,255
L5:
	.dbline 47
	cp R20,R16
	cpc R21,R17
	brlo L2
	.dbline -2
	.dbline 50
;  //insert your functional code here...
;  init_lcd();
L1:
	xcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r i 20 i
	.dbsym r j 22 i
	.dbsym r t 16 i
	.dbend
	.dbfunc e write_com _write_com fV
;        cmdcode -> R20
	.even
_write_com::
	xcall push_gset1
	mov R20,R16
	.dbline -1
	.dbline 54
;  Test(0x10);
;  Test(0x23);
;  Test(0x35);
;  init_lcd();         //LCD��ʼ��
	.dbline 56
;  Testlcd2(0XA0,0XC1);//����LCD12864�Դ��ֿ⣬��ʾ��Ҫ��ʾ�ĺ���
;  Testlcd2(0XA0,0XC1);
	cbi 0x1b,6
	.dbline 57
;  Testlcd2(0XB6,0XBB);
	cbi 0x1b,5
	.dbline 58
;  Testlcd2(0XAD,0XD3);
	ldi R24,255
	out 0x17,R24
	.dbline 60
;  Testlcd2(0XE2,0XB9);
;  Testlcd2(0XD9,0XC1);
	out 0x18,R20
	.dbline 61
;  Testlcd2(0XA0,0XC1);
	sbi 0x1b,4
	.dbline 62
;  Testlcd2(0XA0,0XC1);
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline 63
;  Testlcd2(0XA0,0XC1);
	cbi 0x1b,4
	.dbline -2
	.dbline 64
;  Testlcd2(0XB6,0XC7);
L10:
	xcall pop_gset1
	.dbline 0 ; func end
	ret
	.dbsym r cmdcode 20 c
	.dbend
	.dbfunc e write_data _write_data fV
;       Dispdata -> R20
	.even
_write_data::
	xcall push_gset1
	mov R20,R16
	.dbline -1
	.dbline 69
;  Testlcd2(0XEB,0XC8);
;  Testlcd2(0XBD,0XCA);
;  Testlcd2(0XAA,0XC1);
;  Testlcd2(0XCB,0XC3);/**/
;  
	.dbline 71
;  
; } 
	sbi 0x1b,6
	.dbline 72
; 
	cbi 0x1b,5
	.dbline 73
; 
	ldi R24,255
	out 0x17,R24
	.dbline 75
; 
; 
	out 0x18,R20
	.dbline 76
; 
	sbi 0x1b,4
	.dbline 77
; 
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline 78
; 
	cbi 0x1b,4
	.dbline -2
	.dbline 79
; 
L11:
	xcall pop_gset1
	.dbline 0 ; func end
	ret
	.dbsym r Dispdata 20 c
	.dbend
	.dbfunc e read_data _read_data fc
;          tmpin -> R20
	.even
_read_data::
	xcall push_gset1
	.dbline -1
	.dbline 84
; 
; 
; 
; 
; 
	.dbline 86
; 
; 
	clr R2
	out 0x17,R2
	.dbline 87
; 
	sbi 0x1b,6
	.dbline 88
; 
	sbi 0x1b,5
	.dbline 89
; 
	clr R16
	clr R17
	xcall _delay
	.dbline 90
; 
	sbi 0x1b,4
	.dbline 91
; 
	clr R16
	clr R17
	xcall _delay
	.dbline 92
; 
	cbi 0x1b,4
	.dbline 94
; 
; 
	in R20,0x16
	.dbline 96
; 
; 
	mov R16,R20
	.dbline -2
L12:
	xcall pop_gset1
	.dbline 0 ; func end
	ret
	.dbsym r tmpin 20 c
	.dbend
	.dbfunc e init_lcd _init_lcd fV
	.even
_init_lcd::
	.dbline -1
	.dbline 100
; 
; 
; 
; 
	.dbline 101
; 
	sbi 0x1b,3
	.dbline 102
; 
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline 103
; 
	sbi 0x1b,1
	.dbline 104
; 
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline 106
; 
; 
	ldi R16,48
	xcall _write_com
	.dbline 107
; 
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline 108
; 
	ldi R16,48
	xcall _write_com
	.dbline 109
; 
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline 110
; 
	ldi R16,12
	xcall _write_com
	.dbline 111
; 
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline 112
; 
	ldi R16,1
	xcall _write_com
	.dbline 113
; 
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline 114
; 
	ldi R16,6
	xcall _write_com
	.dbline 115
; 
	ldi R16,100
	ldi R17,0
	.dbline -2
	.dbline 116
; 
L13:
	.dbline 0 ; func end
	xjmp _delay
	.dbend
	.dbfunc e ClearDisplay _ClearDisplay fV
;              i -> R20
;              j -> R22
	.even
_ClearDisplay::
	xcall push_gset2
	.dbline -1
	.dbline 155
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
	.dbline 157
; 
; 
	clr R20
	xjmp L18
L15:
	.dbline 158
; 
	.dbline 158
	mov R16,R20
	subi R16,72    ; addi 184
	xcall _write_com
	.dbline 159
; 
	ldi R16,64
	xcall _write_com
	.dbline 160
; 
	clr R22
	xjmp L22
L19:
	.dbline 161
	clr R16
	xcall _write_data
L20:
	.dbline 160
	inc R22
L22:
	.dbline 160
	cpi R22,64
	brlo L19
	.dbline 162
L16:
	.dbline 157
	inc R20
L18:
	.dbline 157
	cpi R20,8
	brlo L15
	.dbline -2
	.dbline 163
; 
; 
; 
L14:
	xcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r i 20 c
	.dbsym r j 22 c
	.dbend
	.dbfunc e Test _Test fV
;              K -> R20,R21
;       lcd_data -> R22,R23
	.even
_Test::
	xcall push_gset2
	movw R22,R16
	.dbline -1
	.dbline 166
; 
; 
; 
	.dbline 167
; 
	ldi R16,1
	xcall _write_com
	.dbline 168
; 
	ldi R16,64
	xcall _write_com
	.dbline 169
; 
	clr R20
	clr R21
	xjmp L27
L24:
	.dbline 170
	.dbline 170
	mov R16,R22
	xcall _write_data
	.dbline 171
L25:
	.dbline 169
	subi R20,255  ; offset = 1
	sbci R21,255
L27:
	.dbline 169
	cpi R20,148
	ldi R30,0
	cpc R21,R30
	brlo L24
	.dbline -2
	.dbline 173
; 
; 
; 
; 
L23:
	xcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r K 20 i
	.dbsym r lcd_data 22 i
	.dbend
	.dbfunc e Testlcd2 _Testlcd2 fV
;      lcd_datal -> R22
;      lcd_datah -> R20
	.even
_Testlcd2::
	xcall push_gset2
	mov R22,R18
	mov R20,R16
	.dbline -1
	.dbline 175
; 
; 
	.dbline 175
	mov R16,R22
	xcall _write_data
	.dbline 176
; 
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline 177
; 
	mov R16,R20
	xcall _write_data
	.dbline -2
	.dbline 178
; 
L28:
	xcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r lcd_datal 22 c
	.dbsym r lcd_datah 20 c
	.dbend
	.dbfile D:\mega16ѧϰ������\����\m16\12864\main.c
	.dbfunc e port_init _port_init fV
	.even
_port_init::
	.dbline -1
	.dbline 20
	.dbline 21
	ldi R24,255
	out 0x1b,R24
	.dbline 22
	out 0x1a,R24
	.dbline 23
	out 0x18,R24
	.dbline 24
	out 0x17,R24
	.dbline 25
	out 0x15,R24
	.dbline 26
	out 0x14,R24
	.dbline 27
	out 0x12,R24
	.dbline 28
	out 0x11,R24
	.dbline -2
	.dbline 29
L29:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e init_devices _init_devices fV
	.even
_init_devices::
	.dbline -1
	.dbline 33
	.dbline 35
	cli
	.dbline 36
	xcall _port_init
	.dbline 38
	clr R2
	out 0x35,R2
	.dbline 39
	out 0x3b,R2
	.dbline 40
	out 0x39,R2
	.dbline 41
	sei
	.dbline -2
	.dbline 43
L30:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e main _main fV
;              j -> <dead>
;              i -> <dead>
	.even
_main::
	.dbline -1
	.dbline 47
	.dbline 48
	xcall _init_devices
	.dbline 50
	xcall _init_lcd
	.dbline 51
	ldi R16,16
	ldi R17,0
	xcall _Test
	.dbline 52
	ldi R16,35
	ldi R17,0
	xcall _Test
	.dbline 53
	ldi R16,53
	ldi R17,0
	xcall _Test
	.dbline 54
	xcall _init_lcd
	.dbline 55
	ldi R18,193
	ldi R16,160
	xcall _Testlcd2
	.dbline 56
	ldi R18,193
	ldi R16,160
	xcall _Testlcd2
	.dbline 57
	ldi R18,187
	ldi R16,182
	xcall _Testlcd2
	.dbline 58
	ldi R18,211
	ldi R16,173
	xcall _Testlcd2
	.dbline 59
	ldi R18,185
	ldi R16,226
	xcall _Testlcd2
	.dbline 60
	ldi R18,193
	ldi R16,217
	xcall _Testlcd2
	.dbline 61
	ldi R18,193
	ldi R16,160
	xcall _Testlcd2
	.dbline 62
	ldi R18,193
	ldi R16,160
	xcall _Testlcd2
	.dbline 63
	ldi R18,193
	ldi R16,160
	xcall _Testlcd2
	.dbline 64
	ldi R18,199
	ldi R16,182
	xcall _Testlcd2
	.dbline 65
	ldi R18,200
	ldi R16,235
	xcall _Testlcd2
	.dbline 66
	ldi R18,202
	ldi R16,189
	xcall _Testlcd2
	.dbline 67
	ldi R18,193
	ldi R16,170
	xcall _Testlcd2
	.dbline 68
	ldi R18,195
	ldi R16,203
	.dbline -2
	.dbline 71
L31:
	.dbline 0 ; func end
	xjmp _Testlcd2
	.dbsym l j 1 I
	.dbsym l i 1 I
	.dbend
