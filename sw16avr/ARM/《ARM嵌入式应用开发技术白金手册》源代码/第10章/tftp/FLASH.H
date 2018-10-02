/*
定义flash的基地址

RAM的基地址
*/
#define FLASH_START	0x70000000
#define RAM_START	0xC0000000


#define FLASH(offset)	(FLASH_START + (offset))

#define FLASH_BYTE(offset)	(*(volatile unsigned char *)(FLASH_START + (offset)))
#define FLASH_WORD(offset)	(*(volatile unsigned long *)(FLASH_START + (offset)))

#define RAM(offset)	(RAM_START + (offset))
#define RAM_BYTE(offset)	(*(volatile unsigned char *)(RAM_START + (offset)))
#define RAM_WORD(offset)	(*(volatile unsigned long *)(RAM_START + (offset)))

#define block1_base	0x20000		//已经被试验所证明 ^-^
