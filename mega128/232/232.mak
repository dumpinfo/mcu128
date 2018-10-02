CC = iccavr
CFLAGS =  -ID:\Program -IFiles\icc\include\ -ID:\PROGRA~1\icc\include -e -DATMEGA  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\PROGRA~1\icc\lib -g -ucrtatmega.o -bfunc_lit:0x8c.0x20000 -dram_end:0x10ff -bdata:0x100.0x10ff -dhwstk_size:16 -beeprom:1.4096 -fihx_coff -S2
FILES = test.o 

232:	$(FILES)
	$(CC) -o 232 $(LFLAGS) @232.lk   -lcatmega
test.o: D:/PROGRA~1/icc/include/iom128v.h D:/PROGRA~1/icc/include/macros.h
test.o:	F:\工程文件\avr\例程\mega128\232\test.c
	$(CC) -c $(CFLAGS) F:\工程文件\avr\例程\mega128\232\test.c
