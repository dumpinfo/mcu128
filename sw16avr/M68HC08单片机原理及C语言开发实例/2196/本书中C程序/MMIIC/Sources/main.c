#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */
#define I2CR 1 /*表示读模式*/
#define I2CW 0 /*表示写模式*/
#define WP PTB_PTB2 /*该IO口用于确定24C02是否处于写保护状态*/
byte temp,i;
byte date[8];
void delay(word i)
{
	while(i--!=0);
}
/*MMIIC模块的初始化*/
void I2CInit()
{
	/*设置 MMCR1寄存器*/
	MMCR1=0xa0;
	/*设置MMCR2寄存器*/
	MMCR2=0x00;
	/*设置 MMSR寄存器*/
	MMSR=0x00;
	/*预读MMDRR，清除MMRXBF位*/
	temp=MMDRR;
	/*设置从地址MMADR寄存器*/
	MMADR=0xA0;
	/*设置MMIIC通讯的波特率*/
	MMFDR=0x04;
}
/产生一个主模式开始条件*/
void I2CStart(byte addr) 
{
	/*发送模式*/
	MMCR2_MMRW=I2CW;
	/*从设备的地址*/
	MMDTR=addr;
	/*启动主模式*/
	MMCR2_MMAST=1;//开始主模式
}

/*发送一个字节*/
void I2CWriteByte(byte data)
{
	while(MMSR_MMTXIF==0);
	MMSR_MMTXIF=0;
	MMDTR=data;
}

/*接收一个字节*/
byte I2CReadByte(void)
{
	while(MMSR_MMRXIF==0);
	MMSR_MMRXIF=0;
	return MMDRR;
}
/*产生一个结束条件*/
void I2CStop(void)
{
	while(MMSR_MMTXIF==0);
	MMSR_MMTXIF=0;
	MMDTR=0xff;
	MMCR2_MMAST=0;
}
/*主程序*/
void main(void)
{
	/*系统和变量初始化*/
	CONFIG1=0x09;
	CONFIG2=0xfd;
	temp=0x00;
	/*去除24C02的写保护功能*/
	
	DDRB=0xff;
	WP=0;
	PTD=0x00;
	DDRD=0xff;
	for(i=0;i<8;i++)
	date[i]=i;
	
	/*发送数据*/
	I2CInit();
  MMSR_MMTXIF=0;
	I2CStart(0x00);
	for(i=0;i<8;i++)
		I2CWriteByte(date[i]);
	I2CStop();
	delay(1000);
	/*数据写入24C02之后，将数组清零，以便读取数据*/
	for(i=0;i<8;i++)
		date[i]=0;

	/*读取数据*/	
	I2CInit();
	MMSR_MMTXIF=0;
	I2CStart(0x00);
	/*从地址发送完毕。*/
	while(MMSR_MMTXIF==0); 
	MMSR_MMTXIF=0;
	MMADR=0xa0;
/*改成读状态*/
	MMCR2_MMRW=1; 
	MMCR1_MMTXAK=0;//自动发送ACK
	MMCR1_REPSEN=1;//重复开始位置1	
	MMDTR=0xaa; 

	while(MMSR_MMTXIF==0); 
	MMSR_MMTXIF=0;
	MMDTR=0xaa;
	/*开始接收数据*/
	for(i=0;i<8;i++)
	{
		while(MMSR_MMRXIF==0);
		if(i!=6)
		{
			date[i]=MMDRR;
			MMSR_MMRXIF=0;
		}
		/*倒数第二个数据，读取数据并设置停止信号*/
		else
		{
			date[6]=MMDRR;
			MMSR_MMRXIF=0;
			MMCR1_MMTXAK=1;
			MMCR2_MMAST=0;
		}
	}
	while(1);
}




