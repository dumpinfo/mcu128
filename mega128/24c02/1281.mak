CC = iccavr
CFLAGS =  -ID:\PROGRA~1\icc\include\ -e -DATMEGA  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\PROGRA~1\icc\lib\ -g -ucrtatmega.o -bfunc_lit:0x8c.0x20000 -dram_end:0x10ff -bdata:0x100.0x10ff -dhwstk_size:16 -beeprom:1.4096 -fihx_coff -S2
FILES = main.o 

1281:	$(FILES)
	$(CC) -o 1281 $(LFLAGS) @1281.lk   -lcatmega
main.o: D:/PROGRA~1/icc/include/iom128v.h D:/PROGRA~1/icc/include/macros.h C:\DOCUME~1\solo\MYDOCU~1\1281/TWI.H
main.o:	C:\DOCUME~1\solo\MYDOCU~1\1281\main.c
	$(CC) -c $(CFLAGS) C:\DOCUME~1\solo\MYDOCU~1\1281\main.c
