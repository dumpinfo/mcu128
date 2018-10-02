CC = iccavr
CFLAGS =  -ID:\Program -IFiles\icc\include\ -ID:\PROGRA~1\icc\include -e -DATMEGA  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\PROGRA~1\icc\lib -g -ucrtatmega.o -bfunc_lit:0x54.0x4000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = main.o 

bee:	$(FILES)
	$(CC) -o bee $(LFLAGS) @bee.lk   -lcatmega
main.o: D:/PROGRA~1/icc/include/iom16v.h D:/PROGRA~1/icc/include/macros.h
main.o:	D:\mega16学习板资料\例程\m16\蜂鸣器基本实验\main.c
	$(CC) -c $(CFLAGS) D:\mega16学习板资料\例程\m16\蜂鸣器基本实验\main.c
