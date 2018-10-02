CC = iccavr
CFLAGS =  -ID:\icc\include\ -IC:\icc\include -e -DATMEGA -DATMega128  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\icc\lib -g -ucrtatmega.o -bfunc_lit:0x8c.0x20000 -dram_end:0x10ff -bdata:0x100.0x10ff -dhwstk_size:16 -beeprom:1.4096 -fihx_coff -S2
FILES = C_LEDPMD.o 

dianji:	$(FILES)
	$(CC) -o dianji $(LFLAGS) @dianji.lk   -lcatmega
C_LEDPMD.o: D:/icc/include/iom16v.h D:/icc/include/macros.h
C_LEDPMD.o:	E:\新建文件夹\avr资料\例程\m16\电机\C_LEDPMD.C
	$(CC) -c $(CFLAGS) E:\新建文件夹\avr资料\例程\m16\电机\C_LEDPMD.C
