	.module huomen.c
	.area lit(rom, con, rel)
_font::
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
	.byte 16,12
	.byte 132,'D
	.byte 36,20
	.byte 5,6
	.byte 4,20
	.byte 36,'D
	.byte 132,20
	.byte 12,0
	.byte 0,64
	.byte 64,'A
	.byte 'A,'A
	.byte 'A,127
	.byte 'A,'A
	.byte 'A,'A
	.byte 64,64
	.byte 0,0
	.byte 32,33
	.byte 238,4
	.byte 0,0
	.byte 255,41
	.byte 169,191
	.byte 169,169
	.byte 1,255
	.byte 0,0
	.byte 0,0
	.byte 31,136
	.byte 'D,48
	.byte 15,0
	.byte 15,4
	.byte 4,'O
	.byte 128,127
	.byte 0,0
	.byte 8,8
	.byte 248,'I
	.byte 'N,200
	.byte 136,64
	.byte 56,207
	.byte 10,8
	.byte 136,'x
	.byte 8,0
	.byte 64,48
	.byte 15,64
	.byte 128,127
	.byte 0,64
	.byte 32,16
	.byte 11,14
	.byte 49,96
	.byte 32,0
	.byte 32,32
	.byte 32,32
	.byte 32,32
	.byte 160,127
	.byte 160,32
	.byte 32,32
	.byte 32,32
	.byte 32,0
	.byte 0,128
	.byte 64,32
	.byte 16,12
	.byte 3,0
	.byte 1,6
	.byte 8,48
	.byte 96,192
	.byte 64,0
	.byte 64,64
	.byte 'O,'I
	.byte 'I,201
	.byte 207,'p
	.byte 192,207
	.byte 'I,'Y
	.byte 'i,'O
	.byte 0,0
	.byte 2,2
	.byte 126,'E
	.byte 'E,'D
	.byte 124,0
	.byte 124,'D
	.byte 'E,'E
	.byte 126,6
	.byte 2,0
	.byte 8,136
	.byte 'h,255
	.byte 40,'H
	.byte 16,'H
	.byte 'D,'C
	.byte 'D,'H
	.byte 'P,16
	.byte 16,0
	.byte 2,1
	.byte 0,127
	.byte 0,32
	.byte 34,44
	.byte 33,46
	.byte 48,40
	.byte 39,34
	.byte 32,0
	.byte 8,49
	.byte 134,96
	.byte 0,254
	.byte 2,242
	.byte 2,254
	.byte 0,248
	.byte 0,0
	.byte 255,0
	.byte 4,252
	.byte 3,0
	.byte 128,'G
	.byte 48,15
	.byte 16,'g
	.byte 0,7
	.byte 64,128
	.byte 127,0
	.byte 64,32
	.byte 240,12
	.byte 3,0
	.byte 56,192
	.byte 1,14
	.byte 4,224
	.byte 28,0
	.byte 0,0
	.byte 0,0
	.byte 255,0
	.byte 64,64
	.byte 32,16
	.byte 11,4
	.byte 11,16
	.byte 32,96
	.byte 32,0
	.dbfile F:\±¸·ÝÎÄ¼þ\m16\m16\KS0108±ê×¼12864N/font.h
	.dbsym e font _font A[384:384]kc
	.area text(rom, con, rel)
	.dbfile F:\±¸·ÝÎÄ¼þ\m16\m16\KS0108±ê×¼12864N/font.h
	.dbfile F:\±¸·ÝÎÄ¼þ\m16\m16\KS0108±ê×¼12864N/12864.h
	.dbfunc e OutI _OutI fV
;             aa -> R10
;            Com -> R20
;       CtroCode -> R22
	.even
_OutI::
	xcall push_gset3
	mov R20,R18
	mov R22,R16
	.dbline -1
	.dbline 42
; //ICC-AVR application builder : 2006-11-4 10:04:08
; // Target : M16
; // Crystal: 7.3728Mhz
; 
; #include <iom16v.h>
; #include <macros.h>
; #include <stdlib.h>
; 
; #include "12864.h"
; int i,j;
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
; void main(void)
; {
;  int k;
;  init_devices();
;  
	.dbline 43
; 
	clr R10
	inc R10
	.dbline 44
;   OutI(0,0x3e);
	clr R23
	cpi R22,0
	cpc R22,R23
	breq L5
X0:
	cpi R22,1
	ldi R30,0
	cpc R23,R30
	breq L6
	cpi R22,2
	ldi R30,0
	cpc R23,R30
	breq L7
	xjmp L2
X1:
	.dbline 45
L5:
	.dbline 45
;   OutI(0,0xb8);
	cbi 0x12,2
	.dbline 46
;   OutI(0,0x40);
	cbi 0x12,3
	.dbline 48
;   
;   OutI(0,0xC0);
	xjmp L3
L6:
	.dbline 49
;   OutI(0,0x3f); //Æô¶¯LCD
	cbi 0x12,2
	.dbline 50
;   ClearDisplay();
	sbi 0x12,3
	.dbline 52
;   ClearDisplay();
;  DisplayLine(0,0x04,0,1);
	xjmp L3
L7:
	.dbline 53
;  DisplayLine(32,0x04,1,1);
	sbi 0x12,2
	.dbline 54
;  DisplayLine(64,0x04,2,1);
	cbi 0x12,3
	.dbline 56
;  DisplayLine(96,0x04,3,1);
;  DisplayLine(0,0x04,4,1);
L2:
L3:
	.dbline 59
;  DisplayLine(32,0x04,5,1);
;  DisplayLine(64,0x04,6,1);
;  DisplayLine(96,0x04,7,1);
	clr R2
	out 0x1a,R2
	.dbline 60
; 
	cbi 0x12,6
	.dbline 73
;  
; 
; 
;   
;  //insert your functional code here...
; }
; 
; 
; 
; 
; 
; 
; 
	xcall _LCD_NOP
	.dbline 74
; 
	xcall _LCD_NOP
	.dbline 75
; 
	xcall _LCD_NOP
	.dbline 76
; 
	xcall _LCD_NOP
	.dbline 77
; 
	ldi R24,255
	out 0x1a,R24
	.dbline 78
; 
	cbi 0x12,5
	.dbline 80
; 
; 
	sbi 0x12,7
	.dbline 81
; 
	xcall _LCD_NOP
	.dbline 82
; 
	out 0x1b,R20
	.dbline 83
; 
	xcall _LCD_NOP
	.dbline 84
; 
	cbi 0x12,7
	.dbline 86
; 
; 
	sbi 0x12,2
	.dbline 87
; 
	sbi 0x12,3
	.dbline -2
L1:
	xcall pop_gset3
	.dbline 0 ; func end
	ret
	.dbsym r aa 10 c
	.dbsym r Com 20 c
	.dbsym r CtroCode 22 c
	.dbend
	.dbfunc e OutD _OutD fV
;             aa -> R10
;            Dat -> R20
;       CtroCode -> R22
	.even
_OutD::
	xcall push_gset3
	mov R20,R18
	mov R22,R16
	.dbline -1
	.dbline 92
; 
; 
; 
; 
; 
	.dbline 93
; 
	clr R10
	inc R10
	.dbline 94
; 
	clr R23
	cpi R22,0
	cpc R22,R23
	breq L12
X2:
	cpi R22,1
	ldi R30,0
	cpc R23,R30
	breq L13
	cpi R22,2
	ldi R30,0
	cpc R23,R30
	breq L14
	xjmp L9
X3:
	.dbline 95
L12:
	.dbline 95
; 
	cbi 0x12,2
	.dbline 96
; 
	cbi 0x12,3
	.dbline 98
; 
; 
	xjmp L10
L13:
	.dbline 99
; 
	cbi 0x12,2
	.dbline 100
; 
	sbi 0x12,3
	.dbline 102
; 
; 
	xjmp L10
L14:
	.dbline 103
; 
	sbi 0x12,2
	.dbline 104
; 
	cbi 0x12,3
	.dbline 106
; 
; 
L9:
L10:
	.dbline 109
; 
; 
; 
	clr R2
	out 0x1a,R2
	.dbline 119
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
	xcall _LCD_NOP
	.dbline 120
; 
	xcall _LCD_NOP
	.dbline 121
; 
	xcall _LCD_NOP
	.dbline 122
; 
	xcall _LCD_NOP
	.dbline 123
; 
	xcall _LCD_NOP
	.dbline 124
; 
	xcall _LCD_NOP
	.dbline 126
; 
; 
	cbi 0x12,5
	.dbline 127
; 
	sbi 0x12,6
	.dbline 128
; 
	ldi R24,255
	out 0x1a,R24
	.dbline 129
; 
	sbi 0x12,7
	.dbline 130
; 
	xcall _LCD_NOP
	.dbline 131
; 
	out 0x1b,R20
	.dbline 134
; 
; 
; 
	xcall _LCD_NOP
	.dbline 135
; 
	cbi 0x12,7
	.dbline 136
; 
	sbi 0x12,2
	.dbline 137
; 
	sbi 0x12,3
	.dbline -2
L8:
	xcall pop_gset3
	.dbline 0 ; func end
	ret
	.dbsym r aa 10 c
	.dbsym r Dat 20 c
	.dbsym r CtroCode 22 c
	.dbend
	.dbfunc e LCD_NOP _LCD_NOP fV
;              i -> R16,R17
	.even
_LCD_NOP::
	.dbline -1
	.dbline 142
; 
; 
; 
; 
; 
	.dbline 144
	clr R16
	clr R17
	xjmp L19
L16:
	.dbline 144
L17:
	.dbline 144
	subi R16,255  ; offset = 1
	sbci R17,255
L19:
	.dbline 144
; 
; 
	cpi R16,50
	ldi R30,0
	cpc R17,R30
	brlo L16
	.dbline -2
L15:
	.dbline 0 ; func end
	ret
	.dbsym r i 16 i
	.dbend
	.dbfunc e ClearDisplay _ClearDisplay fV
;              i -> R20
;              j -> R22
	.even
_ClearDisplay::
	xcall push_gset2
	.dbline -1
	.dbline 148
; 
; 
; 
; 
	.dbline 150
; 
; 
	clr R20
	xjmp L24
L21:
	.dbline 151
; 
	.dbline 151
	mov R18,R20
	subi R18,72    ; addi 184
	clr R16
	xcall _OutI
	.dbline 152
; 
	ldi R18,64
	clr R16
	xcall _OutI
	.dbline 153
; 
	clr R22
	xjmp L28
L25:
	.dbline 154
	clr R18
	clr R16
	xcall _OutD
L26:
	.dbline 153
	inc R22
L28:
	.dbline 153
	cpi R22,64
	brlo L25
	.dbline 155
L22:
	.dbline 150
	inc R20
L24:
	.dbline 150
	cpi R20,8
	brlo L21
	.dbline -2
L20:
	xcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r i 20 c
	.dbsym r j 22 c
	.dbend
	.dbfunc e DisplayWord _DisplayWord fV
;              m -> R20
;            dat -> R14
;              i -> R22
;           flag -> R10
;            num -> R12
;         SelscP -> y+16
;           yAdd -> y+14
;           xAdd -> y+12
;            Add -> y+10
	.even
_DisplayWord::
	xcall push_arg4
	xcall push_gset5
	ldd R12,y+18
	ldd R10,y+20
	.dbline -1
	.dbline 161
; 
; 
; 
; 
; 
; 
; 
; 
	.dbline 161
	clr R20
	.dbline 163
; 
; 
	ldd R2,y+12
	mov R24,R2
	subi R24,255    ; addi 1
	std y+12,R24
	mov R18,R2
	ldd R16,y+16
	xcall _OutI
	.dbline 164
; 
	ldd R18,y+14
	ldd R16,y+16
	xcall _OutI
	xjmp L31
L30:
	.dbline 166
; 
; 
	.dbline 166
	clr R22
	xjmp L36
L33:
	.dbline 167
; 
	.dbline 167
	tst R10
	brne L37
	.dbline 167
	clr R14
	xjmp L38
L37:
	.dbline 168
; 
	mov R2,R22
	clr R3
	ldd R30,y+10
	ldd R31,y+11
	add R30,R2
	adc R31,R3
	mov R2,R20
	clr R3
	add R30,R2
	adc R31,R3
	ldi R24,<_font
	ldi R25,>_font
	add R30,R24
	adc R31,R25
	lpm R14,Z
L38:
	.dbline 169
	mov R18,R14
	ldd R16,y+16
	xcall _OutD
	.dbline 170
L34:
	.dbline 166
	inc R22
L36:
	.dbline 166
	cp R22,R12
	brlo L33
	.dbline 171
	ldd R2,y+12
	mov R24,R2
	subi R24,255    ; addi 1
	std y+12,R24
	mov R18,R2
	ldd R16,y+16
	xcall _OutI
	.dbline 172
	ldd R18,y+14
	ldd R16,y+16
	xcall _OutI
	.dbline 173
	add R20,R12
	.dbline 174
L31:
	.dbline 165
	mov R24,R12
	subi R24,254    ; addi 2
	cp R20,R24
	brlo L30
	.dbline -2
L29:
	xcall pop_gset5
	adiw R28,4
	.dbline 0 ; func end
	ret
	.dbsym r m 20 c
	.dbsym r dat 14 c
	.dbsym r i 22 c
	.dbsym r flag 10 c
	.dbsym r num 12 c
	.dbsym l SelscP 16 c
	.dbsym l yAdd 14 c
	.dbsym l xAdd 12 c
	.dbsym l Add 10 i
	.dbend
	.dbfunc e DisplayLine _DisplayLine fV
;              p -> <dead>
;              r -> R20
;              l -> R22
;              i -> R10
;           flag -> R12
;           line -> R14
;            com -> R22
;            Add -> y+17
	.even
_DisplayLine::
	xcall push_arg4
	xcall push_gset5
	mov R22,R18
	sbiw R28,7
	ldd R14,y+21
	ldd R12,y+23
	.dbline -1
	.dbline 178
; à­Ô
; à­Ô
; à­Ô
; à­Ô
; à­Ô
; à­Ô
; à­Ô
; à­Ô
; à­Ô
; à­Ô
	.dbline 180
; à­Ô
; à­Ô
	mov R20,R22
	andi R20,15
	.dbline 181
; à­Ô
	mov R24,R22
	swap R24
	andi R24,#0x0F
	mov R22,R24
	.dbline 182
; à­Ô
	clr R10
	xjmp L43
L40:
	.dbline 183
	std y+6,R12
	ldi R24,16
	std y+4,R24
	mov R24,R14
	lsr R24
	lsr R24
	subi R24,255    ; addi 1
	std y+2,R24
	mov R2,R10
	add R2,R22
	ldi R24,16
	mul R24,R2
	mov R24,R0
	subi R24,192    ; addi 64
	std y+0,R24
	ldi R17,4
	mov R16,R14
	xcall mod8u
	ldi R24,2
	mul R24,R16
	mov R18,R0
	subi R18,72    ; addi 184
	ldi R24,32
	mul R24,R10
	ldd R16,y+17
	ldd R17,y+18
	add R16,R0
	adc R17,R1
	xcall _DisplayWord
L41:
	.dbline 182
	inc R10
L43:
	.dbline 182
	cp R10,R20
	brlo L40
	.dbline -2
L39:
	adiw R28,7
	xcall pop_gset5
	adiw R28,4
	.dbline 0 ; func end
	ret
	.dbsym l p 8 c
	.dbsym r r 20 c
	.dbsym r l 22 c
	.dbsym r i 10 c
	.dbsym r flag 12 c
	.dbsym r line 14 c
	.dbsym r com 22 c
	.dbsym l Add 17 i
	.dbend
	.dbfile F:\±¸·ÝÎÄ¼þ\m16\m16\KS0108±ê×¼12864N\huomen.c
	.dbfunc e port_init _port_init fV
	.even
_port_init::
	.dbline -1
	.dbline 12
	.dbline 13
	ldi R24,255
	out 0x1b,R24
	.dbline 14
	out 0x1a,R24
	.dbline 15
	out 0x18,R24
	.dbline 16
	out 0x17,R24
	.dbline 17
	out 0x15,R24
	.dbline 18
	out 0x14,R24
	.dbline 19
	out 0x12,R24
	.dbline 20
	out 0x11,R24
	.dbline -2
L44:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e init_devices _init_devices fV
	.even
_init_devices::
	.dbline -1
	.dbline 25
	.dbline 27
	cli
	.dbline 28
	xcall _port_init
	.dbline 30
	clr R2
	out 0x35,R2
	.dbline 31
	out 0x3b,R2
	.dbline 32
	out 0x39,R2
	.dbline 33
	sei
	.dbline -2
L45:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e main _main fV
;              k -> <dead>
	.even
_main::
	sbiw R28,3
	.dbline -1
	.dbline 39
	.dbline 41
	xcall _init_devices
	.dbline 44
	ldi R18,62
	clr R16
	xcall _OutI
	.dbline 45
	ldi R18,184
	clr R16
	xcall _OutI
	.dbline 46
	ldi R18,64
	clr R16
	xcall _OutI
	.dbline 48
	ldi R18,192
	clr R16
	xcall _OutI
	.dbline 49
	ldi R18,63
	clr R16
	xcall _OutI
	.dbline 50
	xcall _ClearDisplay
	.dbline 51
	xcall _ClearDisplay
	.dbline 52
	ldi R24,1
	std y+2,R24
	clr R2
	std y+0,R2
	ldi R18,4
	clr R16
	clr R17
	xcall _DisplayLine
	.dbline 53
	ldi R24,1
	std y+2,R24
	std y+0,R24
	ldi R18,4
	ldi R16,32
	ldi R17,0
	xcall _DisplayLine
	.dbline 54
	ldi R24,1
	std y+2,R24
	ldi R24,2
	std y+0,R24
	ldi R18,4
	ldi R16,64
	ldi R17,0
	xcall _DisplayLine
	.dbline 55
	ldi R24,1
	std y+2,R24
	ldi R24,3
	std y+0,R24
	ldi R18,4
	ldi R16,96
	ldi R17,0
	xcall _DisplayLine
	.dbline 56
	ldi R24,1
	std y+2,R24
	ldi R24,4
	std y+0,R24
	ldi R18,4
	clr R16
	clr R17
	xcall _DisplayLine
	.dbline 57
	ldi R24,1
	std y+2,R24
	ldi R24,5
	std y+0,R24
	ldi R18,4
	ldi R16,32
	ldi R17,0
	xcall _DisplayLine
	.dbline 58
	ldi R24,1
	std y+2,R24
	ldi R24,6
	std y+0,R24
	ldi R18,4
	ldi R16,64
	ldi R17,0
	xcall _DisplayLine
	.dbline 59
	ldi R24,1
	std y+2,R24
	ldi R24,7
	std y+0,R24
	ldi R18,4
	ldi R16,96
	ldi R17,0
	xcall _DisplayLine
	.dbline -2
L46:
	adiw R28,3
	.dbline 0 ; func end
	ret
	.dbsym l k 4 I
	.dbend
	.area bss(ram, con, rel)
	.dbfile F:\±¸·ÝÎÄ¼þ\m16\m16\KS0108±ê×¼12864N\huomen.c
_j::
	.blkb 2
	.dbsym e j _j I
_i::
	.blkb 2
	.dbsym e i _i I
