CC = iccavr
CFLAGS =  -ID:\Program -IFiles\icc\include\ -ID:\PROGRA~1\icc\include -e -DATMEGA  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\PROGRA~1\icc\lib -g -ucrtatmega.o -bfunc_lit:0x54.0x4000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = main.o 

12864:	$(FILES)
	$(CC) -o 12864 $(LFLAGS) @12864.lk   -lcatmega
main.o: D:/PROGRA~1/icc/include/iom16v.h D:/PROGRA~1/icc/include/macros.h D:\mega16学习板资料\例程\m16\12864/12864.H D:\mega16学习板资料\例程\m16\12864/font.h
main.o:	D:\mega16学习板资料\例程\m16\12864\main.c
	$(CC) -c $(CFLAGS) D:\mega16学习板资料\例程\m16\12864\main.c
