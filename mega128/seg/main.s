	.module main.c
	.area data(ram, con, rel)
_seg7::
	.blkb 2
	.area idata
	.byte 192,249
	.area data(ram, con, rel)
	.blkb 2
	.area idata
	.byte 164,176
	.area data(ram, con, rel)
	.blkb 2
	.area idata
	.byte 153,146
	.area data(ram, con, rel)
	.blkb 2
	.area idata
	.byte 130,248
	.area data(ram, con, rel)
	.blkb 2
	.area idata
	.byte 128,144
	.area data(ram, con, rel)
	.dbfile F:\mega128包\mega128例程\数码管\main.c
	.dbsym e seg7 _seg7 A[10:10]c
_addr::
	.blkb 1
	.area idata
	.byte 1
	.area data(ram, con, rel)
	.dbfile F:\mega128包\mega128例程\数码管\main.c
	.dbsym e addr _addr c
_ldata::
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile F:\mega128包\mega128例程\数码管\main.c
	.dbsym e ldata _ldata c
_jdata::
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile F:\mega128包\mega128例程\数码管\main.c
	.dbsym e jdata _jdata c
_i::
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile F:\mega128包\mega128例程\数码管\main.c
	.dbsym e i _i c
_kdata::
	.blkb 2
	.area idata
	.byte 5,6
	.area data(ram, con, rel)
	.dbfile F:\mega128包\mega128例程\数码管\main.c
	.blkb 2
	.area idata
	.byte 7,8
	.area data(ram, con, rel)
	.dbfile F:\mega128包\mega128例程\数码管\main.c
	.dbsym e kdata _kdata A[4:4]c
	.area text(rom, con, rel)
	.dbfile F:\mega128包\mega128例程\数码管\main.c
	.dbfunc e port_init _port_init fV
	.even
_port_init::
	.dbline -1
	.dbline 20
; //ICC-AVR application builder : 2007-6-11 20:45:01
; // Target : M16
; // Crystal: 4.0000Mhz
; //使用了PD口和PC口，其中Pd口作为数据口，PC口作为地址口。
; //该程序使用了定时器T0，采用循环扫描方式显示8位数据
; 
; 
; //ICC-AVR application builder : 2007-6-26 15:48:39
; // Target : M128
; // Crystal: 6.0000Mhz
; 
; #include <iom128v.h>
; #include <macros.h>
; //#include "seg7.h"
; unsigned char seg7[]={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90};
; unsigned char addr=1,ldata = 0,jdata = 0,i=0;//定义几个变量
; 
; unsigned char kdata[] = {5,6,7,8};//需要显示的数据
; void port_init(void)
; {
	.dbline 21
;  PORTA = 0xFF;
	ldi R24,255
	out 0x1b,R24
	.dbline 22
;  DDRA  = 0xFF;
	out 0x1a,R24
	.dbline 23
;  PORTB = 0xFF;
	out 0x18,R24
	.dbline 24
;  DDRB  = 0xFF;
	out 0x17,R24
	.dbline 25
;  PORTC = 0xFF; //m103 output only
	out 0x15,R24
	.dbline 26
;  DDRC  = 0xFF;
	out 0x14,R24
	.dbline 27
;  PORTD = 0xFF;
	out 0x12,R24
	.dbline 28
;  DDRD  = 0xFF;
	out 0x11,R24
	.dbline 29
;  PORTE = 0x0; 
	clr R2
	out 0x3,R2
	.dbline 30
;  DDRE  = 0xFF;
	out 0x2,R24
	.dbline 31
;  PORTF = 0xFF;
	sts 98,R24
	.dbline 32
;  DDRF  = 0xFF;
	sts 97,R24
	.dbline 33
;  PORTG = 0x0;
	sts 101,R2
	.dbline 34
;  DDRG  = 0xFF;
	sts 100,R24
	.dbline -2
L1:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e timer0_init _timer0_init fV
	.even
_timer0_init::
	.dbline -1
	.dbline 42
; }
; 
; //TIMER0 initialisation - prescale:8
; // WGM: Normal
; // desired value: 10KHz
; // actual value: 10.000KHz (0.0%)
; void timer0_init(void)
; {
	.dbline 43
;  TCCR0 = 0x00; //stop
	clr R2
	out 0x33,R2
	.dbline 44
;  ASSR  = 0x00; //set async mode
	out 0x30,R2
	.dbline 45
;  TCNT0 = 0xB5; //set count
	ldi R24,181
	out 0x32,R24
	.dbline 46
;  OCR0  = 0x4B;
	ldi R24,75
	out 0x31,R24
	.dbline 47
;  TCCR0 = 0x02; //start timer
	ldi R24,2
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
	.dbfile F:\mega128包\mega128例程\数码管\main.c
	.dbfunc e timer0_ovf_isr _timer0_ovf_isr fV
	.even
_timer0_ovf_isr::
	st -y,R2
	st -y,R24
	st -y,R25
	st -y,R30
	st -y,R31
	in R2,0x3f
	st -y,R2
	.dbline -1
	.dbline 52
	.dbline 53
	ldi R24,181
	out 0x32,R24
	.dbline 55
	lds R2,_addr
	out 0x15,R2
	.dbline 56
	ldi R24,<_kdata
	ldi R25,>_kdata
	lds R30,_i
	clr R31
	add R30,R24
	adc R31,R25
	ldd R2,z+0
	sts _jdata,R2
	.dbline 60
	ldi R24,<_seg7
	ldi R25,>_seg7
	mov R30,R2
	clr R31
	add R30,R24
	adc R31,R25
	ldd R2,z+0
	out 0x12,R2
	.dbline 62
	lds R24,_i
	subi R24,255    ; addi 1
	sts _i,R24
	.dbline 63
	lds R2,_addr
	lsl R2
	sts _addr,R2
	.dbline 64
	cpi R24,4
	brne L4
	.dbline 65
	.dbline 65
	ldi R24,1
	sts _addr,R24
	.dbline 66
	clr R2
	sts _i,R2
	.dbline 67
L4:
	.dbline -2
L3:
	ld R2,y+
	out 0x3f,R2
	ld R31,y+
	ld R30,y+
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
	.dbline 74
; }
; 
; #pragma interrupt_handler timer0_ovf_isr:17
; void timer0_ovf_isr(void)
; {
;  TCNT0 = 0xB5; //reload counter value
;  
;  PORTC = addr; //地址送如PC口
;  jdata = kdata[i];//取出需要显示的数据
;  
;  
;  //数据译码成7段SEG数据
;  PORTD = seg7[jdata];//数据送如PD口
;  
;  i++;         //取数地址加1
;  addr = addr<<1;//显示地址左移
;  if(i == 4)//如果显示完8位后，返回到第一位
;   {addr = 1;
;    i = 0;
;   }
;   
;  
; }
; 
; //call this routine to initialise all peripherals
; void init_devices(void)
; {
	.dbline 76
;  //stop errant interrupts until set up
;  CLI(); //disable all interrupts
	cli
	.dbline 77
;  XDIV  = 0x00; //xtal divider
	clr R2
	out 0x3c,R2
	.dbline 78
;  XMCRA = 0x00; //external memory
	sts 109,R2
	.dbline 79
;  port_init();
	xcall _port_init
	.dbline 80
;  timer0_init();
	xcall _timer0_init
	.dbline 82
; 
;  MCUCR = 0x00;
	clr R2
	out 0x35,R2
	.dbline 83
;  EICRA = 0x00; //extended ext ints
	sts 106,R2
	.dbline 84
;  EICRB = 0x00; //extended ext ints
	out 0x3a,R2
	.dbline 85
;  EIMSK = 0x00;
	out 0x39,R2
	.dbline 86
;  TIMSK = 0x01; //timer interrupt sources
	ldi R24,1
	out 0x37,R24
	.dbline 87
;  ETIMSK = 0x00; //extended timer interrupt sources
	sts 125,R2
	.dbline 88
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
	.dbline 94
;  //all peripherals are now initialised
; }
; 
; //
; void main(void)
; {
	.dbline 95
;  init_devices();
	xcall _init_devices
	.dbline -2
L7:
	.dbline 0 ; func end
	ret
	.dbend
