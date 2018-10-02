CC = iccavr
CFLAGS =  -ID:\PROGRA~1\icc\include\ -e -DATMEGA -DATMega128  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\PROGRA~1\icc\lib\ -g -ucrtatmega.o -bfunc_lit:0x8c.0x20000 -dram_end:0x10ff -bdata:0x100.0x10ff -dhwstk_size:16 -beeprom:1.4096 -fihx_coff -S2
FILES = Chap_9.o D12ci.o Epphal.o Isr.o main.o Protodma.o 

USB:	$(FILES)
	$(CC) -o USB $(LFLAGS) @USB.lk   -lcatmega
Chap_9.o: D:/PROGRA~1/icc/include/stdio.h D:/PROGRA~1/icc/include/stdarg.h D:/PROGRA~1/icc/include/_const.h D:/PROGRA~1/icc/include/string.h D:/PROGRA~1/icc/include/_const.h D:/PROGRA~1/icc/include/iom16v.h E:\avr资料\例程\m16\USB\固件/epphal.h\
 E:\avr资料\例程\m16\USB\固件/d12ci.h E:\avr资料\例程\m16\USB\固件/mainloop.h E:\avr资料\例程\m16\USB\固件/usb100.h E:\avr资料\例程\m16\USB\固件/chap_9.h
Chap_9.o:	E:\avr资料\例程\m16\USB\固件\Chap_9.c
	$(CC) -c $(CFLAGS) E:\avr资料\例程\m16\USB\固件\Chap_9.c
D12ci.o: D:/PROGRA~1/icc/include/iom16v.h E:\avr资料\例程\m16\USB\固件/mainloop.h E:\avr资料\例程\m16\USB\固件/d12ci.h E:\avr资料\例程\m16\USB\固件/epphal.h
D12ci.o:	E:\avr资料\例程\m16\USB\固件\D12ci.c
	$(CC) -c $(CFLAGS) E:\avr资料\例程\m16\USB\固件\D12ci.c
Epphal.o: D:/PROGRA~1/icc/include/iom16v.h E:\avr资料\例程\m16\USB\固件/epphal.h E:\avr资料\例程\m16\USB\固件/d12ci.h E:\avr资料\例程\m16\USB\固件/mainloop.h
Epphal.o:	E:\avr资料\例程\m16\USB\固件\Epphal.c
	$(CC) -c $(CFLAGS) E:\avr资料\例程\m16\USB\固件\Epphal.c
Isr.o: D:/PROGRA~1/icc/include/stdio.h D:/PROGRA~1/icc/include/stdarg.h D:/PROGRA~1/icc/include/_const.h D:/PROGRA~1/icc/include/string.h D:/PROGRA~1/icc/include/_const.h D:/PROGRA~1/icc/include/iom16v.h E:\avr资料\例程\m16\USB\固件/epphal.h\
 E:\avr资料\例程\m16\USB\固件/d12ci.h E:\avr资料\例程\m16\USB\固件/mainloop.h E:\avr资料\例程\m16\USB\固件/usb100.h
Isr.o:	E:\avr资料\例程\m16\USB\固件\Isr.c
	$(CC) -c $(CFLAGS) E:\avr资料\例程\m16\USB\固件\Isr.c
main.o: D:/PROGRA~1/icc/include/stdio.h D:/PROGRA~1/icc/include/stdarg.h D:/PROGRA~1/icc/include/_const.h D:/PROGRA~1/icc/include/string.h D:/PROGRA~1/icc/include/_const.h D:/PROGRA~1/icc/include/iom16v.h E:\avr资料\例程\m16\USB\固件/epphal.h\
 E:\avr资料\例程\m16\USB\固件/d12ci.h E:\avr资料\例程\m16\USB\固件/mainloop.h E:\avr资料\例程\m16\USB\固件/usb100.h E:\avr资料\例程\m16\USB\固件/chap_9.h E:\avr资料\例程\m16\USB\固件/protodma.h E:\avr资料\例程\m16\USB\固件/51usb.h\
 D:/PROGRA~1/icc/include/iom16v.h
main.o:	E:\avr资料\例程\m16\USB\固件\main.c
	$(CC) -c $(CFLAGS) E:\avr资料\例程\m16\USB\固件\main.c
Protodma.o: D:/PROGRA~1/icc/include/string.h D:/PROGRA~1/icc/include/_const.h D:/PROGRA~1/icc/include/iom16v.h E:\avr资料\例程\m16\USB\固件/epphal.h E:\avr资料\例程\m16\USB\固件/d12ci.h E:\avr资料\例程\m16\USB\固件/mainloop.h\
 E:\avr资料\例程\m16\USB\固件/usb100.h E:\avr资料\例程\m16\USB\固件/chap_9.h
Protodma.o:	E:\avr资料\例程\m16\USB\固件\Protodma.c
	$(CC) -c $(CFLAGS) E:\avr资料\例程\m16\USB\固件\Protodma.c
