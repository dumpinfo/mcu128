CC = iccavr
CFLAGS =  -ID:\icc\include\ -e -DATMEGA -DATMega128  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\icc\lib\ -g -ucrtatmega.o -bfunc_lit:0x8c.0x20000 -dram_end:0x10ff -bdata:0x100.0x10ff -dhwstk_size:16 -beeprom:1.4096 -fihx_coff -S2
FILES = second.o 

main:	$(FILES)
	$(CC) -o main $(LFLAGS) @main.lk   -lcatmega
second.o: D:/icc/include/iom128v.h D:/icc/include/macros.h E:\avr资料\例程\mega128\1602/1602.h D:/icc/include/iom128v.h D:/icc/include/macros.h
second.o:	E:\avr资料\例程\mega128\1602\second.c
	$(CC) -c $(CFLAGS) E:\avr资料\例程\mega128\1602\second.c
