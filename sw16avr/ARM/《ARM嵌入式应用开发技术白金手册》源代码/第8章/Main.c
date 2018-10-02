#define  IOPMOD	   (*(volatile unsigned *)0x03FF5000)   //IO port mode register
#define  IOPDATA  (*(volatile unsigned *)0x03FF5008)      //IO port data register

void Delay(unsigned int);

int Main()
{
	unsigned long  LED;
	IOPMOD=0xFFFFFFFF;   	                        //将IO口置为输出模式
	IOPDATA=0x01;
	for(;;)
	{
		LED=IOPDATA;
		LED=(LED<<1);                                 // 循环点亮LED
		IOPDATA=LED;      
		Delay(10);
		if(!(IOPDATA&0x0F)) 
			IOPDATA=0x01;                            // I/O数据寄存器返回初值
	}
	return(0);	
}

void Delay(unsigned int x)
{
	unsigned int i,j,k;

	for(i=0;i<=x;i++)                                    // 三个循环实现延时
			for(j=0;j<0xff;j++)
				for(k=0;k<0xff;k++);
}
