CC = iccavr
CFLAGS =  -ID:\PROGRA~1\icc\include\ -IF:\最新\数码管 -e -DATMEGA -DATMega16  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\PROGRA~1\icc\lib\ -g -ucrtatmega.o -bfunc_lit:0x54.0x4000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = main.o 

smg:	$(FILES)
	$(CC) -o smg $(LFLAGS) @smg.lk   -lcatmega
main.o: F:\最新\数码管/seg7.h D:/PROGRA~1/icc/include/iom16v.h D:/PROGRA~1/icc/include/macros.h D:/PROGRA~1/icc/include/iom16v.h D:/PROGRA~1/icc/include/macros.h
main.o:	F:\最新\数码管\main.c
	$(CC) -c $(CFLAGS) F:\最新\数码管\main.c
