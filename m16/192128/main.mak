CC = iccavr
CFLAGS =  -ID:\PROGRA~1\icc\include\ -e -DATMEGA -DATMega16  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\PROGRA~1\icc\lib\ -g -ucrtatmega.o -bfunc_lit:0x54.0x4000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = s.o 

main:	$(FILES)
	$(CC) -o main $(LFLAGS) @main.lk   -lcatmega
s.o: D:/PROGRA~1/icc/include/iom16v.h D:/PROGRA~1/icc/include/macros.h
s.o:	E:\新建文件夹\例程\m16\192128\s.c
	$(CC) -c $(CFLAGS) E:\新建文件夹\例程\m16\192128\s.c
