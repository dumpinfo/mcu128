CC = iccavr
CFLAGS =  -ID:\PROGRA~1\icc\include\ -e -DATMEGA -DATMega16  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\PROGRA~1\icc\lib\ -g -ucrtatmega.o -bfunc_lit:0x54.0x4000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = second.o 

1602:	$(FILES)
	$(CC) -o 1602 $(LFLAGS) @1602.lk   -lcatmega
second.o: D:/PROGRA~1/icc/include/iom16v.h D:/PROGRA~1/icc/include/macros.h E:\avr资料\例程\m16\1602/1602.h D:/PROGRA~1/icc/include/iom16v.h D:/PROGRA~1/icc/include/macros.h
second.o:	E:\avr资料\例程\m16\1602\second.c
	$(CC) -c $(CFLAGS) E:\avr资料\例程\m16\1602\second.c
