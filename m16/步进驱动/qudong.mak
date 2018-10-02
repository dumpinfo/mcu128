CC = iccavr
CFLAGS =  -ID:\Program -IFiles\icc\include\ -e -DATMEGA -DATMega16  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\PROGRA~1\icc\lib\ -g -ucrtatmega.o -bfunc_lit:0x54.0x4000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = main.o 

qudong:	$(FILES)
	$(CC) -o qudong $(LFLAGS) @qudong.lk   -lcatmega
main.o: Files/icc/include/iom16v.h Files/icc/include/macros.h
main.o:	E:\新建文件夹\avr资料\例程\m16\步进驱动\main.c
	$(CC) -c $(CFLAGS) E:\新建文件夹\avr资料\例程\m16\步进驱动\main.c
