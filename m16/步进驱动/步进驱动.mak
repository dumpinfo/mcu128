CC = iccavr
CFLAGS =  -ID:\PROGRA~1\icc\include\ -e -DATMEGA -DATMega16  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\PROGRA~1\icc\lib\ -g -ucrtatmega.o -bfunc_lit:0x54.0x4000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = main.o 

��������:	$(FILES)
	$(CC) -o �������� $(LFLAGS) @��������.lk   -lcatmega
main.o: D:/PROGRA~1/icc/include/iom16v.h D:/PROGRA~1/icc/include/macros.h
main.o:	E:\�½��ļ���\����\m16\��������\main.c
	$(CC) -c $(CFLAGS) E:\�½��ļ���\����\m16\��������\main.c
