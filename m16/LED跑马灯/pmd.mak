CC = iccavr
CFLAGS =  -ID:\Program -IFiles\icc\include\ -ID:\PROGRA~1\icc\include -e -DATMEGA -DATMega16  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\PROGRA~1\icc\lib -g -ucrtatmega.o -bfunc_lit:0x54.0x4000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = C_LEDPMD.o 

pmd:	$(FILES)
	$(CC) -o pmd $(LFLAGS) @pmd.lk   -lcatmega
C_LEDPMD.o: D:/PROGRA~1/icc/include/iom16v.h D:/PROGRA~1/icc/include/macros.h
C_LEDPMD.o:	E:\avr资料\例程\m16\LED跑马灯\C_LEDPMD.C
	$(CC) -c $(CFLAGS) E:\avr资料\例程\m16\LED跑马灯\C_LEDPMD.C
