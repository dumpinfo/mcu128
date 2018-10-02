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
	.dbfile F:\mega128包\mega128例程\12864/font.h
	.dbsym e font _font A[304:304]kc
	.area text(rom, con, rel)
	.dbfile F:\mega128包\mega128例程\12864/font.h
	.dbfile F:\mega128包\mega128例程\12864/12864.H
	.dbfunc e delay _delay fV
;              i -> R20,R21
;              j -> R22,R23
;              t -> R16,R17
	.even
_delay::
	xcall push_gset2
	.dbline -1
	.dbline 49
; //AM12864参考程序(st7920)
; /********************************************/
; /* AM12864系列测试程序 1.0for mega16 */
; /* Designed by ourembed.com */
; /* 2003.04.23 */
; /********************************************/
; //ICC-AVR application builder : 2006-11-7 18:33:11
; // Target : M16
; // Crystal: 4.0000Mhz
; //本站mega128学习板，单片机和12864默认引脚关系为：RS、WR、E、D0~D7、CS1、CS2、CS3分别
; //对应单片机的PD5、PD6、PD7、PC0~PC7、PA7、PA6、PA5
; //在12864.h文件的引脚定义中修改成对应关系 
; 
; #include <iom128v.h>
; #include <macros.h>
; 
; #include "12864.H"
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
;  PORTE = 0xFF;
;  DDRE  = 0xFF;
;  PORTF = 0xFF;
;  DDRF  = 0xFF;
;  PORTG = 0xFF;
;  DDRG  = 0xFF;
; }
; 
; //call this routine to initialise all peripherals
; void init_devices(void)
; {
;  //stop errant interrupts until set up
;  CLI(); //disable all interrupts
;  XDIV  = 0x00; //xtal divider
;  XMCRA = 0x00; //external memory
;  port_init();
; 
;  MCUCR = 0x00;
;  EICRA = 0x00; //extended ext ints
;  EICRB = 0x00; //extended ext ints
	.dbline 51
;  EIMSK = 0x00;
;  TIMSK = 0x00; //timer interrupt sources
	clr R20
	clr R21
	xjmp L5
L2:
	.dbline 52
;  ETIMSK = 0x00; //extended timer interrupt sources
	clr R22
	clr R23
	xjmp L9
L6:
	.dbline 53
L7:
	.dbline 52
	subi R22,255  ; offset = 1
	sbci R23,255
L9:
	.dbline 52
	cpi R22,10
	ldi R30,0
	cpc R23,R30
	brlo L6
L3:
	.dbline 51
	subi R20,255  ; offset = 1
	sbci R21,255
L5:
	.dbline 51
	cp R20,R16
	cpc R21,R17
	brlo L2
	.dbline -2
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
	.dbline 58
;  SEI(); //re-enable interrupts
;  //all peripherals are now initialised
; }
; 
; void main(void)
; {int i,j;
	.dbline 60
;  init_devices();
;  //insert your functional code here...
	cbi 0x12,5
	.dbline 61
;  init_lcd();
	cbi 0x12,6
	.dbline 62
;  Test(0x10);
	ldi R24,255
	out 0x14,R24
	.dbline 64
;  Test(0x23);
;  Test(0x35);
	out 0x15,R20
	.dbline 65
;  init_lcd();         //LCD初始化
	sbi 0x12,7
	.dbline 66
;  Testlcd2(0XA0,0XC1);//根据LCD12864自带字库，显示需要显示的汉字
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline 67
;  Testlcd2(0XA0,0XC1);
	cbi 0x12,7
	.dbline -2
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
	.dbline 73
;  Testlcd2(0XB6,0XBB);
;  Testlcd2(0XAD,0XD3);
;  Testlcd2(0XE2,0XB9);
;  Testlcd2(0XD9,0XC1);
;  Testlcd2(0XA0,0XC1);
;  Testlcd2(0XA0,0XC1);
	.dbline 75
;  Testlcd2(0XA0,0XC1);
;  Testlcd2(0XB6,0XC7);
	sbi 0x12,5
	.dbline 76
;  Testlcd2(0XEB,0XC8);
	cbi 0x12,6
	.dbline 77
;  Testlcd2(0XBD,0XCA);
	ldi R24,255
	out 0x14,R24
	.dbline 79
;  Testlcd2(0XAA,0XC1);
;  Testlcd2(0XCB,0XC3);/**/
	out 0x15,R20
	.dbline 80
;  
	sbi 0x12,7
	.dbline 81
;  
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline 82
; } 
	cbi 0x12,7
	.dbline -2
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
	.dbline 88
; 
; 
; 
; 
; 
; 
	.dbline 90
; 
; 
	clr R2
	out 0x14,R2
	.dbline 91
; 
	sbi 0x12,5
	.dbline 92
; 
	sbi 0x12,6
	.dbline 93
; 
	clr R16
	clr R17
	xcall _delay
	.dbline 94
; 
	sbi 0x12,7
	.dbline 95
; 
	clr R16
	clr R17
	xcall _delay
	.dbline 96
; 
	cbi 0x12,7
	.dbline 98
; 
; 
	in R20,0x13
	.dbline 100
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
	.dbline 104
; 
; 
; 
; 
	.dbline 105
; 
	sbi 0x1b,7
	.dbline 106
; 
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline 107
; 
	sbi 0x1b,5
	.dbline 108
; 
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline 110
; 
; 
	ldi R16,48
	xcall _write_com
	.dbline 111
; 
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline 112
; 
	ldi R16,48
	xcall _write_com
	.dbline 113
; 
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline 114
; 
	ldi R16,12
	xcall _write_com
	.dbline 115
; 
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline 116
; 
	ldi R16,1
	xcall _write_com
	.dbline 117
; 
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline 118
; 
	ldi R16,6
	xcall _write_com
	.dbline 119
; 
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline -2
L13:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e ClearDisplay _ClearDisplay fV
;              i -> R20
;              j -> R22
	.even
_ClearDisplay::
	xcall push_gset2
	.dbline -1
	.dbline 159
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
; 
	.dbline 161
; 
; 
	clr R20
	xjmp L18
L15:
	.dbline 162
; 
	.dbline 162
	mov R16,R20
	subi R16,72    ; addi 184
	xcall _write_com
	.dbline 163
; 
	ldi R16,64
	xcall _write_com
	.dbline 164
; 
	clr R22
	xjmp L22
L19:
	.dbline 165
	clr R16
	xcall _write_data
L20:
	.dbline 164
	inc R22
L22:
	.dbline 164
	cpi R22,64
	brlo L19
	.dbline 166
L16:
	.dbline 161
	inc R20
L18:
	.dbline 161
	cpi R20,8
	brlo L15
	.dbline -2
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
	.dbline 170
; 
; 
; 
; 
; 
; 
	.dbline 171
; 
	ldi R16,1
	xcall _write_com
	.dbline 172
; 
	ldi R16,64
	xcall _write_com
	.dbline 173
; 
	clr R20
	clr R21
	xjmp L27
L24:
	.dbline 174
	.dbline 174
	mov R16,R22
	xcall _write_data
	.dbline 175
L25:
	.dbline 173
	subi R20,255  ; offset = 1
	sbci R21,255
L27:
	.dbline 173
	cpi R20,148
	ldi R30,0
	cpc R21,R30
	brlo L24
	.dbline -2
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
	.dbline 179
; 
; 
; 
; 
; 
; 
	.dbline 179
	mov R16,R22
	xcall _write_data
	.dbline 180
; 
	ldi R16,100
	ldi R17,0
	xcall _delay
	.dbline 181
; 
	mov R16,R20
	xcall _write_data
	.dbline -2
L28:
	xcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r lcd_datal 22 c
	.dbsym r lcd_datah 20 c
	.dbend
	.dbfile F:\mega128包\mega128例程\12864\main.c
	.dbfunc e port_init _port_init fV
	.even
_port_init::
	.dbline -1
	.dbline 21
	.dbline 22
	ldi R24,255
	out 0x1b,R24
	.dbline 23
	out 0x1a,R24
	.dbline 24
	out 0x18,R24
	.dbline 25
	out 0x17,R24
	.dbline 26
	out 0x15,R24
	.dbline 27
	out 0x14,R24
	.dbline 28
	out 0x12,R24
	.dbline 29
	out 0x11,R24
	.dbline 30
	out 0x3,R24
	.dbline 31
	out 0x2,R24
	.dbline 32
	sts 98,R24
	.dbline 33
	sts 97,R24
	.dbline 34
	sts 101,R24
	.dbline 35
	sts 100,R24
	.dbline -2
L29:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e init_devices _init_devices fV
	.even
_init_devices::
	.dbline -1
	.dbline 40
	.dbline 42
	cli
	.dbline 43
	clr R2
	out 0x3c,R2
	.dbline 44
	sts 109,R2
	.dbline 45
	xcall _port_init
	.dbline 47
	clr R2
	out 0x35,R2
	.dbline 48
	sts 106,R2
	.dbline 49
	out 0x3a,R2
	.dbline 50
	out 0x39,R2
	.dbline 51
	out 0x37,R2
	.dbline 52
	sts 125,R2
	.dbline 53
	sei
	.dbline -2
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
	.dbline 58
	.dbline 59
	xcall _init_devices
	.dbline 61
	xcall _init_lcd
	.dbline 62
	ldi R16,16
	ldi R17,0
	xcall _Test
	.dbline 63
	ldi R16,35
	ldi R17,0
	xcall _Test
	.dbline 64
	ldi R16,53
	ldi R17,0
	xcall _Test
	.dbline 65
	xcall _init_lcd
	.dbline 66
	ldi R18,193
	ldi R16,160
	xcall _Testlcd2
	.dbline 67
	ldi R18,193
	ldi R16,160
	xcall _Testlcd2
	.dbline 68
	ldi R18,187
	ldi R16,182
	xcall _Testlcd2
	.dbline 69
	ldi R18,211
	ldi R16,173
	xcall _Testlcd2
	.dbline 70
	ldi R18,185
	ldi R16,226
	xcall _Testlcd2
	.dbline 71
	ldi R18,193
	ldi R16,217
	xcall _Testlcd2
	.dbline 72
	ldi R18,193
	ldi R16,160
	xcall _Testlcd2
	.dbline 73
	ldi R18,193
	ldi R16,160
	xcall _Testlcd2
	.dbline 74
	ldi R18,193
	ldi R16,160
	xcall _Testlcd2
	.dbline 75
	ldi R18,199
	ldi R16,182
	xcall _Testlcd2
	.dbline 76
	ldi R18,200
	ldi R16,235
	xcall _Testlcd2
	.dbline 77
	ldi R18,202
	ldi R16,189
	xcall _Testlcd2
	.dbline 78
	ldi R18,193
	ldi R16,170
	xcall _Testlcd2
	.dbline 79
	ldi R18,195
	ldi R16,203
	xcall _Testlcd2
	.dbline -2
L31:
	.dbline 0 ; func end
	ret
	.dbsym l j 1 I
	.dbsym l i 1 I
	.dbend
