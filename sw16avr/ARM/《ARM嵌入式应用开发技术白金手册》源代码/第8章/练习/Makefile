PAT	= C:\Program Files\arm\adsv1_2\bin                                #宏定义
CC	= $(PAT)/armcc                                                #指定ARM C编译器
LD      = $(PAT)/armlink                                           #指定ARM 连接器
OBJTOOL	= $(PAT)/fromelf

RM	= $(PAT)/rm –f                                               
AS	= $(PAT)/armasm -keep -g                                      #指定ARM汇编器
ASFILE	= C:/arm_xyexp/Init.s
CFLAGS	= -g -O1  -Wa -DNO_UNDERSCORES=1  
MODEL	= main
SRC     = $(MODEL).c                                           #maic.c源，main.o目标
OBJS	= $(MODEL).o
all:	$(MODEL).axf  $(MODEL).bin  clean
	%.axf:$(OBJS) Init.o 
	@echo "### Linking ..."                               #输出显示     ### Linking ...
	$(LD)  $(OBJS) Init.o -ro-base 0x8000  -entry Main -first Init.o  -o $@ -libpath C:/arm/adsv1_2/lib
	%.bin: %.axf	
	$(OBJTOOL) -c -bin -output $@ $<
	$(OBJTOOL) -c -s -o $(<:.axf=.lst) $<
	
%.o:%.c 
	@echo "### Compiling $<"	                          #输出显示     ### Compiling
	$(CC) $(CFLAGS)  -c $< -o $@

clean:                                                 # make clean
	$(RM) Init.o $(OBJS) 
