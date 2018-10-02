CC = iccavr
CFLAGS =  -ID:\Program -IFiles\icc\include\ -ID:\PROGRA~1\icc\include -e -DATMEGA -DATMega128  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\PROGRA~1\icc\lib -g -ucrtatmega.o -bfunc_lit:0x8c.0x20000 -dram_end:0x10ff -bdata:0x100.0x10ff -dhwstk_size:16 -beeprom:1.4096 -fihx_coff -S2
FILES = main.o 

smg:	$(FILES)
	$(CC) -o smg $(LFLAGS) @smg.lk   -lcatmega
main.o: D:/PROGRA~1/icc/include/iom128v.h D:/PROGRA~1/icc/include/macros.h
main.o:	F:\mega128包\mega128例程\数码管\main.c
	$(CC) -c $(CFLAGS) F:\mega128包\mega128例程\数码管\main.c
