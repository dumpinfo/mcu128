CC = iccavr
CFLAGS =  -e -DATMEGA  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -m -g -ucrtatmega.o -bfunc_lit:0x48.0x4000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = main.o 

BEE:	$(FILES)
	$(CC) -o BEE $(LFLAGS) @BEE.lk   -lcatmega
main.o:  
main.o:	F:\工程文件\avr\例程\mega128\蜂鸣器基本实验\main.c
	$(CC) -c $(CFLAGS) F:\工程文件\avr\例程\mega128\蜂鸣器基本实验\main.c
