CC := gcc
CROSS := arm-linux-
CFLAGS ?= -g -Wall
override CFLAGS += $(EXTRAFLAGS)
INSTALL := install
INSTALLPREFIX ?= /usr/local
LDFLAGS := -g

SRCS := tftpflash.c
OBJS := $(SRCS:.c=.o)
DEPS := $(SRCS:.c=.d)
all:tftpflash.bin


tftpflash.elf: init.S tftpflash.c cs8900.h ep7211.h ioregs.h put.h net.h flash.h
	$(CROSS)gcc -Wall -fomit-frame-pointer -O2 -nostdlib \
		-Wl,-Ttext,0x10000000 -N init.S loader.c -o loader.elf

%.bin: %.elf
	$(CROSS)objcopy -O binary $^ $@

# automated dependency checking
include $(DEPS)

%.d: %.c
	$(CC) $(CFLAGS) -M $< > $@