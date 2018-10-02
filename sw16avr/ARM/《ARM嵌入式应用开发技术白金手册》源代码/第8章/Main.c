#define  IOPMOD	   (*(volatile unsigned *)0x03FF5000)   //IO port mode register
#define  IOPDATA  (*(volatile unsigned *)0x03FF5008)      //IO port data register

void Delay(unsigned int);

int Main()
{
	unsigned long  LED;
	IOPMOD=0xFFFFFFFF;   	                        //��IO����Ϊ���ģʽ
	IOPDATA=0x01;
	for(;;)
	{
		LED=IOPDATA;
		LED=(LED<<1);                                 // ѭ������LED
		IOPDATA=LED;      
		Delay(10);
		if(!(IOPDATA&0x0F)) 
			IOPDATA=0x01;                            // I/O���ݼĴ������س�ֵ
	}
	return(0);	
}

void Delay(unsigned int x)
{
	unsigned int i,j,k;

	for(i=0;i<=x;i++)                                    // ����ѭ��ʵ����ʱ
			for(j=0;j<0xff;j++)
				for(k=0;k<0xff;k++);
}
