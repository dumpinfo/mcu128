CC = iccavr
CFLAGS =  -ID:\PROGRA~1\icc\include\ -ID:\icc\include -e -DATMEGA -DATMega16  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\icc\lib -g -ucrtatmega.o -bfunc_lit:0x54.0x4000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = main.o 

sss:	$(FILES)
	$(CC) -o sss $(LFLAGS) @sss.lk   -lcatmega
main.o: D:/icc/include/iom16v.h D:/icc/include/macros.h
main.o:	E:\avr资料\例程\m16\步进驱动\main.c
	$(CC) -c $(CFLAGS) E:\avr资料\例程\m16\步进驱动\main.c
