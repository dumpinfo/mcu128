CC = iccavr
CFLAGS =  -ID:\PROGRA~1\icc\include\ -e -DATMEGA -DATMega128  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\PROGRA~1\icc\lib\ -g -ucrtatmega.o -bfunc_lit:0x8c.0x20000 -dram_end:0x10ff -bdata:0x100.0x10ff -dhwstk_size:16 -beeprom:1.4096 -fihx_coff -S2
FILES = 192128.o 

192128:	$(FILES)
	$(CC) -o 192128 $(LFLAGS) @192128.lk   -lcatmega
192128.o: D:/PROGRA~1/icc/include/iom128v.h D:/PROGRA~1/icc/include/macros.h
192128.o:	E:\avr资料\例程\m16\new192128\192128.c
	$(CC) -c $(CFLAGS) E:\avr资料\例程\m16\new192128\192128.c
