CC = iccavr
CFLAGS =  -ID:\icc\include -e -DATMEGA -DATMega16  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\icc\lib -g -ucrtatmega.o -bfunc_lit:0x54.0x4000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = huomen.o 

123:	$(FILES)
	$(CC) -o 123 $(LFLAGS) @123.lk   -lcatmega
huomen.o: D:/icc/include/iom16v.h D:/icc/include/macros.h D:/icc/include/stdlib.h D:/icc/include/_const.h D:/icc/include/limits.h E:\新建文件夹\avr资料\例程\m16\KS0108标准12864N/12864.h D:/icc/include/iom16v.h D:/icc/include/macros.h\
 D:/icc/include/stdlib.h E:\新建文件夹\avr资料\例程\m16\KS0108标准12864N/font.h D:/icc/include/string.h D:/icc/include/_const.h
huomen.o:	E:\新建文件夹\avr资料\例程\m16\KS0108标准12864N\huomen.c
	$(CC) -c $(CFLAGS) E:\新建文件夹\avr资料\例程\m16\KS0108标准12864N\huomen.c
