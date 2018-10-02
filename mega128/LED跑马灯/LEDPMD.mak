CC = iccavr
CFLAGS =  -IC:\icc\include\ -IC:\icc\include -e -DATMEGA  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LC:\icc\lib -g -ucrtatmega.o -bfunc_lit:0x8c.0x20000 -dram_end:0x10ff -bdata:0x100.0x10ff -dhwstk_size:16 -beeprom:1.4096 -fihx_coff -S2
FILES = C_LEDPMD.o 

LEDPMD:	$(FILES)
	$(CC) -o LEDPMD $(LFLAGS) @LEDPMD.lk   -lcatmega
C_LEDPMD.o: C:/icc/include/iom128v.h C:/icc/include/macros.h
C_LEDPMD.o:	F:\�����ļ�\avr\����\mega128\LED�����\C_LEDPMD.C
	$(CC) -c $(CFLAGS) F:\�����ļ�\avr\����\mega128\LED�����\C_LEDPMD.C
