CC = iccavr
CFLAGS =  -ID:\PROGRA~1\icc\include\ -IF:\����\����� -e -DATMEGA -DATMega16  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\PROGRA~1\icc\lib\ -g -ucrtatmega.o -bfunc_lit:0x54.0x4000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = main.o 

smg:	$(FILES)
	$(CC) -o smg $(LFLAGS) @smg.lk   -lcatmega
main.o: F:\����\�����/seg7.h D:/PROGRA~1/icc/include/iom16v.h D:/PROGRA~1/icc/include/macros.h D:/PROGRA~1/icc/include/iom16v.h D:/PROGRA~1/icc/include/macros.h
main.o:	F:\����\�����\main.c
	$(CC) -c $(CFLAGS) F:\����\�����\main.c
