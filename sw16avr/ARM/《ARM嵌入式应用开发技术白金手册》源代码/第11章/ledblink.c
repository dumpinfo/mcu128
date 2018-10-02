/*ledblink.c*/
#define MODULE
#include <Linux/module.h>
#include <asm/system.h>                                           /* »ã±àÍ·ÎÄ¼þ */ 
#include <asm/io.h>
#include <asm/irq.h>
#include <asm/uaccess.h>
#include <asm/bitops.h>
#include <asm/hardware.h>
#include <asm/hardware/clps7111.h>
int init_module( void )
{
/* Turn on the Led on insmod */
	clps_writel(0x01, PDDR);
	return 0;
}
void cleanup_module( void )
{
/* Turn off the led on rmmod*/
	clps_writel(~0x01,PDDR);
}
