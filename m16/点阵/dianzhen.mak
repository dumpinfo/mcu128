CC = iccavr
CFLAGS =  -ID:\PROGRA~1\icc\include\ -e -DATMEGA -DATMega16  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\PROGRA~1\icc\lib\ -g -ucrtatmega.o -bfunc_lit:0x54.0x4000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = dianzhen.o 

dianzhen:	$(FILES)
	$(CC) -o dianzhen $(LFLAGS) @dianzhen.lk   -lcatmega
dianzhen.o: D:/PROGRA~1/icc/include/iom16v.h D:/PROGRA~1/icc/include/macros.h
dianzhen.o:	E:\avr资料\例程\m16\点阵\dianzhen.c
	$(CC) -c $(CFLAGS) E:\avr资料\例程\m16\点阵\dianzhen.c
