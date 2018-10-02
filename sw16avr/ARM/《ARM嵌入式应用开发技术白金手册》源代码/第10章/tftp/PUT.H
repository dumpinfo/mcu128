static void put_char(unsigned char data)
{
		while (IO_SYSFLG1 & UTXFF1);
		IO_UARTDR1 = data;
}
//Êä³öÁ½¸ö×Ö·û
/*
static void put_word(int data)
{
	put_char((data>>8)&0xff);
	put_char(data&0xff);
}


static void put_num32(int i)
{
 		put_num8( (unsigned char) (i & 0xff));
		put_num8((unsigned char)(( i>>8) & 0xff));
		put_num8( (unsigned char) (i>>16 & 0xff));
		put_num8((unsigned char)(( i>>24) & 0xff));
}

static void put_num8(unsigned char i)
{
		put_char(((((i>>4) & 0x0f)  + '0')> '9' )? ((i>>4) & 0x0f) +'0'+7 : ((i>>4) & 0x0f) +'0' );
		put_char((((i & 0x0f)  + '0')> '9' )? (i & 0x0f) +'0'+7 : (i & 0x0f) +'0' );
}

static void put_num16(int i)
{
	put_num8((unsigned char)(( i>>8) & 0xff));
	put_num8( (unsigned char) (i & 0xff));
}*/