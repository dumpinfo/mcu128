EXEC =                                                      #ºê¶¨Òå
OBJS =.o
all: $(EXEC)
$(EXEC): $(OBJS)
        $(CC) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS)
romfs:
        $(ROMFSINST) /bin/$(EXEC)
clean:
        rm -f $(EXEC) *.elf *.gdb *.o                       #make cleanÉ¾³ý
