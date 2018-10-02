	.module dianzhen.c
	.area data(ram, con, rel)
_data1::
	.blkb 2
	.area idata
	.byte 255,253
	.area data(ram, con, rel)
	.blkb 2
	.area idata
	.byte 189,189
	.area data(ram, con, rel)
	.blkb 2
	.area idata
	.byte 129,189
	.area data(ram, con, rel)
	.blkb 2
	.area idata
	.byte 189,253
	.area data(ram, con, rel)
	.dbfile E:\avr资料\例程\m16\点阵\dianzhen.c
	.dbsym e data1 _data1 A[8:8]c
_data2::
	.blkb 2
	.area idata
	.byte 255,253
	.area data(ram, con, rel)
	.dbfile E:\avr资料\例程\m16\点阵\dianzhen.c
	.blkb 2
	.area idata
	.byte 235,231
	.area data(ram, con, rel)
	.dbfile E:\avr资料\例程\m16\点阵\dianzhen.c
	.blkb 2
	.area idata
	.byte 143,231
	.area data(ram, con, rel)
	.dbfile E:\avr资料\例程\m16\点阵\dianzhen.c
	.blkb 2
	.area idata
	.byte 235,253
	.area data(ram, con, rel)
	.dbfile E:\avr资料\例程\m16\点阵\dianzhen.c
	.dbsym e data2 _data2 A[8:8]c
_addr::
	.blkb 1
	.area idata
	.byte 1
	.area data(ram, con, rel)
	.dbfile E:\avr资料\例程\m16\点阵\dianzhen.c
	.dbsym e addr _addr c
_i::
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile E:\avr资料\例程\m16\点阵\dianzhen.c
	.dbsym e i _i c
_j::
	.blkb 4
	.area idata
	.word 0,0
	.area data(ram, con, rel)
	.dbfile E:\avr资料\例程\m16\点阵\dianzhen.c
	.dbsym e j _j L
	.area text(rom, con, rel)
	.dbfile E:\avr资料\例程\m16\点阵\dianzhen.c
	.dbfunc e port_init _port_init fV
	.even
_port_init::
	.dbline -1
	.dbline 14
; //ICC-AVR application builder : 2007-6-12 20:23:24
; // Target : M16
; // Crystal: 4.0000Mhz
; //该程序采用了循环扫描方式现在汉字，其中用B口作为地址口，用A口作为数据口
; //循环扫描地址，显示相应的数据，达到显示整个汉字的目的
; 
; #include <iom16v.h>
; #include <macros.h>
; unsigned char data1[]={0xff,0xfd,0xbd,0xbd,0x81,0xbd,0xbd,0xfd};//需要显示的汉字1
; unsigned char data2[]={0xff,0xfd,0xeb,0xe7,0x8f,0xe7,0xeb,0xfd};//需要显示的汉字2
; unsigned char addr = 1,i = 0;//addr是用来循环扫描的地址位，即某一位如果为高的话，该列就显示发来的数据
; long int j = 0;   //j用来做为选择是否显示汉字1或者汉字2
; void port_init(void)
; {
	.dbline 15
;  PORTA = 0x00;   //PA
	clr R2
	out 0x1b,R2
	.dbline 16
;  DDRA  = 0xFF;   //PA口输出
	ldi R24,255
	out 0x1a,R24
	.dbline 17
;  PORTB = 0x00;
	out 0x18,R2
	.dbline 18
;  DDRB  = 0xFF;   //PB口输出
	out 0x17,R24
	.dbline 19
;  PORTC = 0x00; //m103 output only
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
	.dbfile E:\avr资料\例程\m16\点阵\dianzhen.c
	.dbfunc e timer0_ovf_isr _timer0_ovf_isr fV
	.even
_timer0_ovf_isr::
	st -y,R2
	st -y,R3
	st -y,R4
	st -y,R5
	st -y,R8
	st -y,R9
	st -y,R24
	st -y,R25
	st -y,R26
	st -y,R27
	st -y,R30
	st -y,R31
	in R2,0x3f
	st -y,R2
	xcall push_gset2
	.dbline -1
	.dbline 39
; }
; 
; #pragma interrupt_handler timer0_ovf_isr:10
; void timer0_ovf_isr(void)
; {
	.dbline 40
;  TCNT0 = 0xC2; //reload counter value
	ldi R24,194
	out 0x32,R24
	.dbline 43
;                //在定时器中完成显示
;  
;  PORTB = addr;  //地址送入PB口  
	lds R2,_addr
	out 0x18,R2
	.dbline 45
;  
;  j++;          //选择汉字变量+1
	ldi R20,1
	ldi R21,0
	ldi R22,0
	ldi R23,0
	lds R4,_j+2
	lds R5,_j+2+1
	lds R2,_j
	lds R3,_j+1
	add R2,R20
	adc R3,R21
	adc R4,R22
	adc R5,R23
	sts _j+1,R3
	sts _j,R2
	sts _j+2+1,R5
	sts _j+2,R4
	.dbline 46
;  if(j<5000)    //如果小于5000，显示A
	ldi R20,136
	ldi R21,19
	ldi R22,0
	ldi R23,0
	cp R2,R20
	cpc R3,R21
	cpc R4,R22
	cpc R5,R23
	brge L4
	.dbline 47
;  PORTA = data1[i];
	ldi R24,<_data1
	ldi R25,>_data1
	lds R30,_i
	clr R31
	add R30,R24
	adc R31,R25
	ldd R2,z+0
	out 0x1b,R2
	xjmp L5
L4:
	.dbline 49
;  else
;  PORTA = data2[i]; //如果大于5000，显示B
	ldi R24,<_data2
	ldi R25,>_data2
	lds R30,_i
	clr R31
	add R30,R24
	adc R31,R25
	ldd R2,z+0
	out 0x1b,R2
L5:
	.dbline 51
;  
;  if(j>10000)     //大于10000，清零
	ldi R20,16
	ldi R21,39
	ldi R22,0
	ldi R23,0
	lds R4,_j+2
	lds R5,_j+2+1
	lds R2,_j
	lds R3,_j+1
	cp R20,R2
	cpc R21,R3
	cpc R22,R4
	cpc R23,R5
	brge L6
	.dbline 52
;  j=0;
	ldi R20,0
	ldi R21,0
	ldi R22,0
	ldi R23,0
	sts _j+1,R21
	sts _j,R20
	sts _j+2+1,R23
	sts _j+2,R22
L6:
	.dbline 54
	lds R24,_i
	subi R24,255    ; addi 1
	sts _i,R24
	.dbline 56
	lds R2,_addr
	lsl R2
	sts _addr,R2
	.dbline 58
	tst R2
	brne L8
	.dbline 59
	.dbline 60
	ldi R24,1
	sts _addr,R24
	.dbline 61
	clr R2
	sts _i,R2
	.dbline 62
L8:
	.dbline -2
L3:
	xcall pop_gset2
	ld R2,y+
	out 0x3f,R2
	ld R31,y+
	ld R30,y+
	ld R27,y+
	ld R26,y+
	ld R25,y+
	ld R24,y+
	ld R9,y+
	ld R8,y+
	ld R5,y+
	ld R4,y+
	ld R3,y+
	ld R2,y+
	.dbline 0 ; func end
	reti
	.dbend
	.dbfunc e init_devices _init_devices fV
	.even
_init_devices::
	.dbline -1
	.dbline 67
;  
;  i++;            //数据数组地址+1
;  
;  addr= addr<<1;  //显示口地址左移
;  
;  if(addr == 0)   //判断是否显示完8个位，如果显示完，回到初始值
;   {
;    addr =1;
;    i=0;
;   }
; }
; 
; //call this routine to initialize all peripherals
; void init_devices(void)
; {
	.dbline 69
;  //stop errant interrupts until set up
;  CLI(); //disable all interrupts
	cli
	.dbline 70
;  port_init();
	xcall _port_init
	.dbline 71
;  timer0_init();
	xcall _timer0_init
	.dbline 73
; 
;  MCUCR = 0x00;
	clr R2
	out 0x35,R2
	.dbline 74
;  GICR  = 0x00;
	out 0x3b,R2
	.dbline 75
;  TIMSK = 0x01; //timer interrupt sources
	ldi R24,1
	out 0x39,R24
	.dbline 76
;  SEI(); //re-enable interrupts
	sei
	.dbline -2
L10:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e main _main fV
	.even
_main::
	.dbline -1
	.dbline 82
;  //all peripherals are now initialized
; }
; 
; //
; void main(void)
; {
	.dbline 83
;  init_devices();
	xcall _init_devices
	.dbline -2
L11:
	.dbline 0 ; func end
	ret
	.dbend
