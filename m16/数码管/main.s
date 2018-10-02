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
	.dbfile F:\最新\数码管/seg7.h
	.dbsym e seg7 _seg7 A[10:10]c
_addr::
	.blkb 1
	.area idata
	.byte 1
	.area data(ram, con, rel)
	.dbfile F:\最新\数码管/seg7.h
	.dbfile F:\最新\数码管\main.c
	.dbsym e addr _addr c
_ldata::
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile F:\最新\数码管\main.c
	.dbsym e ldata _ldata c
_jdata::
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile F:\最新\数码管\main.c
	.dbsym e jdata _jdata c
_i::
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile F:\最新\数码管\main.c
	.dbsym e i _i c
_kdata::
	.blkb 2
	.area idata
	.byte 1,2
	.area data(ram, con, rel)
	.dbfile F:\最新\数码管\main.c
	.blkb 2
	.area idata
	.byte 3,4
	.area data(ram, con, rel)
	.dbfile F:\最新\数码管\main.c
	.blkb 2
	.area idata
	.byte 5,6
	.area data(ram, con, rel)
	.dbfile F:\最新\数码管\main.c
	.blkb 2
	.area idata
	.byte 7,8
	.area data(ram, con, rel)
	.dbfile F:\最新\数码管\main.c
	.dbsym e kdata _kdata A[8:8]c
	.area text(rom, con, rel)
	.dbfile F:\最新\数码管\main.c
	.dbfunc e port_init _port_init fV
	.even
_port_init::
	.dbline -1
	.dbline 14
; //ICC-AVR application builder : 2007-6-11 20:45:01
; // Target : M16
; // Crystal: 4.0000Mhz
; //使用了PA口和PB口，其中PA口作为数据口，PB口作为地址口。
; //该程序使用了定时器T0，采用循环扫描方式显示8位数据
; #include "seg7.h"
; #include <iom16v.h>
; #include <macros.h>
; 
; unsigned char addr=1,ldata = 0,jdata = 0,i=0;
; 
; unsigned char kdata[] = {1,2,3,4,5,6,7,8};
; void port_init(void)
; {
	.dbline 15
;  PORTA = 0xFF;
	ldi R24,255
	out 0x1b,R24
	.dbline 16
;  DDRA  = 0xFF;
	out 0x1a,R24
	.dbline 17
;  PORTB = 0xFF;
	out 0x18,R24
	.dbline 18
;  DDRB  = 0xFF;
	out 0x17,R24
	.dbline 19
;  PORTC = 0x00; //m103 output only
	clr R2
	out 0x15,R2
	.dbline 20
;  DDRC  = 0x00;
	out 0x14,R2
	.dbline 21
;  PORTD = 0x00;
	out 0x12,R2
	.dbline 22
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
	.dbline 30
; }
; 
; //TIMER0 initialize - prescale:64
; // WGM: Normal
; // desired value: 1KHz
; // actual value:  1.008KHz (0.8%)
; void timer0_init(void)
; {
	.dbline 31
;  TCCR0 = 0x00; //stop
	clr R2
	out 0x33,R2
	.dbline 32
;  TCNT0 = 0xC2; //set count
	ldi R24,194
	out 0x32,R24
	.dbline 33
;  OCR0  = 0x3E;  //set compare
	ldi R24,62
	out 0x3c,R24
	.dbline 34
;  TCCR0 = 0x03; //start timer
	ldi R24,3
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
	.dbfile F:\最新\数码管\main.c
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
	.dbline 39
	.dbline 40
	ldi R24,194
	out 0x32,R24
	.dbline 41
	lds R2,_addr
	out 0x18,R2
	.dbline 42
	ldi R24,<_kdata
	ldi R25,>_kdata
	lds R30,_i
	clr R31
	add R30,R24
	adc R31,R25
	ldd R2,z+0
	sts _jdata,R2
	.dbline 43
	ldi R24,<_seg7
	ldi R25,>_seg7
	mov R30,R2
	clr R31
	add R30,R24
	adc R31,R25
	ldd R2,z+0
	sts _ldata,R2
	.dbline 44
	out 0x1b,R2
	.dbline 46
	lds R24,_i
	subi R24,255    ; addi 1
	sts _i,R24
	.dbline 47
	lds R2,_addr
	lsl R2
	sts _addr,R2
	.dbline 48
	tst R2
	brne L4
	.dbline 49
	.dbline 49
	ldi R24,1
	sts _addr,R24
	.dbline 50
	clr R2
	sts _i,R2
	.dbline 51
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
	.dbline 58
; }
; 
; #pragma interrupt_handler timer0_ovf_isr:10
; void timer0_ovf_isr(void)
; {
;  TCNT0 = 0xC2; //reload counter value
;  PORTB = addr; 
;  jdata = kdata[i];
;  ldata = seg7[jdata];
;  PORTA = ldata;
;  
;  i++;
;  addr = addr<<1;
;  if(addr == 0)
;   {addr = 1;
;    i = 0;
;   }
;  
;  
; }
; 
; //call this routine to initialize all peripherals
; void init_devices(void)
; {
	.dbline 60
;  //stop errant interrupts until set up
;  CLI(); //disable all interrupts
	cli
	.dbline 61
;  port_init();
	xcall _port_init
	.dbline 62
;  timer0_init();
	xcall _timer0_init
	.dbline 64
; 
;  MCUCR = 0x00;
	clr R2
	out 0x35,R2
	.dbline 65
;  GICR  = 0x00;
	out 0x3b,R2
	.dbline 66
;  TIMSK = 0x01; //timer interrupt sources
	ldi R24,1
	out 0x39,R24
	.dbline 67
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
	.dbline 73
;  //all peripherals are now initialized
; }
; 
; //
; void main(void)
; {
	.dbline 74
;  init_devices();
	xcall _init_devices
	.dbline -2
L7:
	.dbline 0 ; func end
	ret
	.dbend
