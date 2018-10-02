CC = iccavr
CFLAGS =  -e -DATMEGA  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -m -g -ucrtatmega.o -bfunc_lit:0x48.0x4000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = main.o 

BEE:	$(FILES)
	$(CC) -o BEE $(LFLAGS) @BEE.lk   -lcatmega
main.o:  
main.o:	F:\�����ļ�\avr\����\mega128\����������ʵ��\main.c
	$(CC) -c $(CFLAGS) F:\�����ļ�\avr\����\mega128\����������ʵ��\main.c
