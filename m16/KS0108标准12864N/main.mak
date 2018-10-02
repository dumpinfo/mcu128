CC = iccavr
CFLAGS =  -ID:\PROGRA~1\icc\include -e -DATMEGA -DATMega16  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\PROGRA~1\icc\lib -g -ucrtatmega.o -bfunc_lit:0x54.0x4000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = huomen.o 

main:	$(FILES)
	$(CC) -o main $(LFLAGS) @main.lk   -lcatmega
huomen.o: D:/PROGRA~1/icc/include/iom16v.h D:/PROGRA~1/icc/include/macros.h D:/PROGRA~1/icc/include/stdlib.h D:/PROGRA~1/icc/include/_const.h D:/PROGRA~1/icc/include/limits.h F:\备份文件\m16\m16\KS0108标准12864N/12864.h\
 D:/PROGRA~1/icc/include/iom16v.h D:/PROGRA~1/icc/include/macros.h D:/PROGRA~1/icc/include/stdlib.h F:\备份文件\m16\m16\KS0108标准12864N/font.h D:/PROGRA~1/icc/include/string.h D:/PROGRA~1/icc/include/_const.h
huomen.o:	F:\备份文件\m16\m16\KS0108标准12864N\huomen.c
	$(CC) -c $(CFLAGS) F:\备份文件\m16\m16\KS0108标准12864N\huomen.c
