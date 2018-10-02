#include"reg51.h"
#include"absacc.h"


#define 	LED		XBYTE[0xEFFF]

#define 	SEG		XBYTE[0x100]

#define 	KEY 		XBYTE[0xDFFF]
#define  	WCOM  		XBYTE[0xBCFF]
#define  	RCOM  		XBYTE[0xBEFF]
#define  	WDAT  		XBYTE[0xBDFF]



sbit 		SCL	=	P3^3;
sbit		SDA	=	P3^4;