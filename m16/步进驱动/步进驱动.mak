CC = iccavr
CFLAGS =  -ID:\PROGRA~1\icc\include\ -e -DATMEGA -DATMega16  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\PROGRA~1\icc\lib\ -g -ucrtatmega.o -bfunc_lit:0x54.0x4000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = main.o 

步进驱动:	$(FILES)
	$(CC) -o 步进驱动 $(LFLAGS) @步进驱动.lk   -lcatmega
main.o: D:/PROGRA~1/icc/include/iom16v.h D:/PROGRA~1/icc/include/macros.h
main.o:	E:\新建文件夹\例程\m16\步进驱动\main.c
	$(CC) -c $(CFLAGS) E:\新建文件夹\例程\m16\步进驱动\main.c
