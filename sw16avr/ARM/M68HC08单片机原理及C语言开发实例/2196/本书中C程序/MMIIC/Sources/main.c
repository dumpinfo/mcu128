#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */
#define I2CR 1 /*��ʾ��ģʽ*/
#define I2CW 0 /*��ʾдģʽ*/
#define WP PTB_PTB2 /*��IO������ȷ��24C02�Ƿ���д����״̬*/
byte temp,i;
byte date[8];
void delay(word i)
{
	while(i--!=0);
}
/*MMIICģ��ĳ�ʼ��*/
void I2CInit()
{
	/*���� MMCR1�Ĵ���*/
	MMCR1=0xa0;
	/*����MMCR2�Ĵ���*/
	MMCR2=0x00;
	/*���� MMSR�Ĵ���*/
	MMSR=0x00;
	/*Ԥ��MMDRR�����MMRXBFλ*/
	temp=MMDRR;
	/*���ôӵ�ַMMADR�Ĵ���*/
	MMADR=0xA0;
	/*����MMIICͨѶ�Ĳ�����*/
	MMFDR=0x04;
}
/����һ����ģʽ��ʼ����*/
void I2CStart(byte addr) 
{
	/*����ģʽ*/
	MMCR2_MMRW=I2CW;
	/*���豸�ĵ�ַ*/
	MMDTR=addr;
	/*������ģʽ*/
	MMCR2_MMAST=1;//��ʼ��ģʽ
}

/*����һ���ֽ�*/
void I2CWriteByte(byte data)
{
	while(MMSR_MMTXIF==0);
	MMSR_MMTXIF=0;
	MMDTR=data;
}

/*����һ���ֽ�*/
byte I2CReadByte(void)
{
	while(MMSR_MMRXIF==0);
	MMSR_MMRXIF=0;
	return MMDRR;
}
/*����һ����������*/
void I2CStop(void)
{
	while(MMSR_MMTXIF==0);
	MMSR_MMTXIF=0;
	MMDTR=0xff;
	MMCR2_MMAST=0;
}
/*������*/
void main(void)
{
	/*ϵͳ�ͱ�����ʼ��*/
	CONFIG1=0x09;
	CONFIG2=0xfd;
	temp=0x00;
	/*ȥ��24C02��д��������*/
	
	DDRB=0xff;
	WP=0;
	PTD=0x00;
	DDRD=0xff;
	for(i=0;i<8;i++)
	date[i]=i;
	
	/*��������*/
	I2CInit();
  MMSR_MMTXIF=0;
	I2CStart(0x00);
	for(i=0;i<8;i++)
		I2CWriteByte(date[i]);
	I2CStop();
	delay(1000);
	/*����д��24C02֮�󣬽��������㣬�Ա��ȡ����*/
	for(i=0;i<8;i++)
		date[i]=0;

	/*��ȡ����*/	
	I2CInit();
	MMSR_MMTXIF=0;
	I2CStart(0x00);
	/*�ӵ�ַ������ϡ�*/
	while(MMSR_MMTXIF==0); 
	MMSR_MMTXIF=0;
	MMADR=0xa0;
/*�ĳɶ�״̬*/
	MMCR2_MMRW=1; 
	MMCR1_MMTXAK=0;//�Զ�����ACK
	MMCR1_REPSEN=1;//�ظ���ʼλ��1	
	MMDTR=0xaa; 

	while(MMSR_MMTXIF==0); 
	MMSR_MMTXIF=0;
	MMDTR=0xaa;
	/*��ʼ��������*/
	for(i=0;i<8;i++)
	{
		while(MMSR_MMRXIF==0);
		if(i!=6)
		{
			date[i]=MMDRR;
			MMSR_MMRXIF=0;
		}
		/*�����ڶ������ݣ���ȡ���ݲ�����ֹͣ�ź�*/
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




