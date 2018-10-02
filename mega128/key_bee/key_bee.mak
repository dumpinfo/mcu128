CC = iccavr
CFLAGS =  -Ic:\icc\include\ -Ic:\icc\include -e -DATMEGA  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -Lc:\icc\lib -g -ucrtatmega.o -bfunc_lit:0x8c.0x20000 -dram_end:0x10ff -bdata:0x100.0x10ff -dhwstk_size:16 -beeprom:1.4096 -fihx_coff -S2
FILES = key_bee.o 

key_bee:	$(FILES)
	$(CC) -o key_bee $(LFLAGS) @key_bee.lk   -lcatmega
key_bee.o: c:/icc/include/iom128v.h c:/icc/include/macros.h
key_bee.o:	F:\工程文件\avr\例程\mega128\key_bee\key_bee.c
	$(CC) -c $(CFLAGS) F:\工程文件\avr\例程\mega128\key_bee\key_bee.c
