#define SYS_(offset)	(*(volatile unsigned long*)(offset))	  //32λ����ָ��
#define SYSC_(offset)	(*(volatile unsigned char*)(offset))	  //8λ����ָ��
#define SDRAM_BASE	0xC0000000				              //SDRAM��ַ
#define SDRAM_(offset)	(*(volatile unsigned long*)(SDRAM_BASE + offset))
                                                         //SDRAMָ��
unsigned long address;				                     //32λ��ַ
unsigned long data;					                    //32λ����
unsigned long length;			 	                   //32λ����

void init_uart(void)					              //����1��ʼ�� @ 115200bps
{
	IO_UBRLCR1 = (IO_UBRLCR1 & ~BRDIV) | BR_115200;
	IO_UBRLCR1 = IO_UBRLCR1 | FIFOEN;
	IO_UBRLCR1 = (IO_UBRLCR1 & ~WRDLEN) | (3<<WRDLEN_SHIFT);
	IO_SYSCON1 |=  UART1EN;
}
unsigned char get_char(void)			                   //����1����
{
	while (IO_SYSFLG1 & URXFE1);
	return IO_UARTDR1 & 0xff;
}
void put_char(unsigned char data)			               //����1����
{
	while (IO_SYSFLG1 & UTXFF1);
	IO_UARTDR1 = data;
}
void put_string(char *sp)				                  //����1�ַ�������
{
unsigned int i=0;
	 while(sp[i]!=0)
		put_char(sp[i++]);
	 	
}
unsigned int wait(unsigned char i)		                	//��ʱ����
{
	 unsigned int sum=0;
for(;i>0;i--)
		sum+=i;
	return(sum);
}
void flash_erase()				                          //FLASH����
{
	 SYSC_(0x70005555)=0xaa;			                  //д���������
	   wait(1);						                     //��ʱ
	 SYSC_(0x70002aaa)=0x55;			                 //д���������
	   wait(1);						                     //��ʱ
     SYSC_(0x70005555)=0x80;			                 //д���������
	   wait(1);						                     //��ʱ
	 SYSC_(0x70005555)=0xaa;			                 //д���������
	   wait(1);						                    //��ʱ
     SYSC_(0x70002aaa)=0x55;			                //д���������
	   wait(1);						                    //��ʱ
     SYSC_(0x70005555)=0x10;			                //д���������
	   wait(1);						                    //��ʱ
	while((SYSC_(0x70000000)& 0x80)==0);	            //ȷ���Ѳ���
}
void flash_prog(unsigned long address,unsigned char data)	       //FLASH�ֽڱ��
{
	 SYSC_(0x70005555)=0xaa;			                  //д��������
	   wait(1);					       	                  //��ʱ
     SYSC_(0x70002aaa)=0x55;			                  //д��������
	   wait(1);						                     //��ʱ
	 SYSC_(0x70005555)=0xa0;			                  //д��������
	   wait(1);						                      //��ʱ
     SYSC_(address)=data;				                  //д��������
	while(SYSC_(address)!=data);			              //ȷ���ֽ���д��
}
void writein()					                          //�����ݻ�ȡ
{
	  unsigned long i,data;
       put_string("Len:\n");				         //����"�����볤������"����ʾ
       length=get_char();
       length=(length<<8)+get_char();
       length=(length<<8)+get_char();
       length=(length<<8)+get_char();			    //��ȡ32λ��������
	  for(i=0;i<length;i+=4)
	 {
		data=get_char();
		data+=get_char()<<8;
		data+=get_char()<<16;
		data+=get_char()<<24;			           //��ȡ32λ����
		SDRAM_(i)=data;			                   //SDRAM��ֵ
}
	put_string("Ok!\n");				          //���Ϳ����ݶ�ȡ��ϱ�־
}
void flashload()					             //������FLASH���
{
  unsigned long i;
  writein();					                 //��������ȶ���SDRAM
	 flash_erase();					             //FLASH����
     for(i=0;i<length;i+=4)
	 {
		data=SDRAM_(i);
		flash_prog((0x70000000+i),data & 0xff);	        //FLASH�ֽڱ��
		flash_prog((0x70000001+i),(data>>8) & 0xff);	//FLASH�ֽڱ��
		flash_prog((0x70000002+i),(data>>16) & 0xff);	//FLASH�ֽڱ��
		flash_prog((0x70000003+i),(data>>24) & 0xff);	//FLASH�ֽڱ��			
	  }
	put_string("Done!\n");				              //����FLASH��̳ɹ���־
}
void mymain(void)					                  //���ڵ��Ժ���
{
	unsigned char scomm,sdata;
	unsigned char *addrp;
	unsigned char *datap;

	addrp=(unsigned char*)&address;
	datap=(unsigned char*)&data;
	put_string("ok!\n");				        //���ʹ��ڵ���������־
	
	while (1)					                 //��ѭ��
    	{
		scomm=get_char();			             //������
		if(scomm==0xff)			                 //�Ƿ�Ϊ����ǰ���ֽ�"0xFF"��
	  		{
		  	scomm=get_char();		            //�����������ֽ�
		  	if(scomm!=0xff)
	  			switch(scomm)		                     //���ݵ�������ɢת
	  			{
					case 0xfa:flashload();break;              //ִ��FLASH��̲���
		  			default:put_string("Not Support!\n");        //��֧�ֵ�����
		  		}
		   else sdata=0xff;				              //����"0xFF"��ֵ
		   }
         else sdata=scomm;				              //��"0xFF"����ֱ�Ӹ�ֵ
        }
}
void  C_vMain(void)			              	      //������
{
     unsigned char i;
	 unsigned short j;	
     init_uart();					              //����1��ʼ��
     while(1)
	 {
		i=get_char();				               //������
		if(i==0x79)			              	       //�Ƿ��ȡ�����Կ�ʼ���
			mymain();			                   //���봮�ڵ���
		else 
            put_char(i);				          //���Դ���
     }
}
