CC = iccavr
CFLAGS =  -ID:\PROGRA~1\icc\include\ -ID:\icc\include -e -DATMega8  -l -g -Mavr_enhanced_small -Wa-W 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\icc\lib -g -Wl-W -bfunc_lit:0x26.0x2000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = second.o 

2402:	$(FILES)
	$(CC) -o 2402 $(LFLAGS) @2402.lk  
second.o: D:/icc/include/iom16v.h D:/icc/include/macros.h E:\新建文件夹\avr资料\例程\m16\2402v32/1602.h D:/icc/include/iom16v.h D:/icc/include/macros.h
second.o:	E:\新建文件夹\avr资料\例程\m16\2402v32\second.c
	$(CC) -c $(CFLAGS) E:\新建文件夹\avr资料\例程\m16\2402v32\second.c
