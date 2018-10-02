CC = iccavr
CFLAGS =  -IC:\icc\include\ -e -DATMEGA  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LC:\icc\lib\ -g -ucrtatmega.o -bfunc_lit:0x54.0x4000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = demo.o 

demo:	$(FILES)
	$(CC) -o demo $(LFLAGS) @demo.lk   -lcatmega
demo.o: C:/icc/include/iom16v.h
demo.o:	D:\AVR\demo\demo.c
	$(CC) -c $(CFLAGS) D:\AVR\demo\demo.c
