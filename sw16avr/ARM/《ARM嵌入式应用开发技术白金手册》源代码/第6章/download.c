#define SYS_(offset)	(*(volatile unsigned long*)(offset))	  //32位总线指针
#define SYSC_(offset)	(*(volatile unsigned char*)(offset))	  //8位总线指针
#define SDRAM_BASE	0xC0000000				              //SDRAM基址
#define SDRAM_(offset)	(*(volatile unsigned long*)(SDRAM_BASE + offset))
                                                         //SDRAM指针
unsigned long address;				                     //32位地址
unsigned long data;					                    //32位数据
unsigned long length;			 	                   //32位长度

void init_uart(void)					              //串口1初始化 @ 115200bps
{
	IO_UBRLCR1 = (IO_UBRLCR1 & ~BRDIV) | BR_115200;
	IO_UBRLCR1 = IO_UBRLCR1 | FIFOEN;
	IO_UBRLCR1 = (IO_UBRLCR1 & ~WRDLEN) | (3<<WRDLEN_SHIFT);
	IO_SYSCON1 |=  UART1EN;
}
unsigned char get_char(void)			                   //串口1接收
{
	while (IO_SYSFLG1 & URXFE1);
	return IO_UARTDR1 & 0xff;
}
void put_char(unsigned char data)			               //串口1发送
{
	while (IO_SYSFLG1 & UTXFF1);
	IO_UARTDR1 = data;
}
void put_string(char *sp)				                  //串口1字符串发送
{
unsigned int i=0;
	 while(sp[i]!=0)
		put_char(sp[i++]);
	 	
}
unsigned int wait(unsigned char i)		                	//延时函数
{
	 unsigned int sum=0;
for(;i>0;i--)
		sum+=i;
	return(sum);
}
void flash_erase()				                          //FLASH擦除
{
	 SYSC_(0x70005555)=0xaa;			                  //写入擦除命令
	   wait(1);						                     //延时
	 SYSC_(0x70002aaa)=0x55;			                 //写入擦除命令
	   wait(1);						                     //延时
     SYSC_(0x70005555)=0x80;			                 //写入擦除命令
	   wait(1);						                     //延时
	 SYSC_(0x70005555)=0xaa;			                 //写入擦除命令
	   wait(1);						                    //延时
     SYSC_(0x70002aaa)=0x55;			                //写入擦除命令
	   wait(1);						                    //延时
     SYSC_(0x70005555)=0x10;			                //写入擦除命令
	   wait(1);						                    //延时
	while((SYSC_(0x70000000)& 0x80)==0);	            //确认已擦除
}
void flash_prog(unsigned long address,unsigned char data)	       //FLASH字节编程
{
	 SYSC_(0x70005555)=0xaa;			                  //写入编程命令
	   wait(1);					       	                  //延时
     SYSC_(0x70002aaa)=0x55;			                  //写入编程命令
	   wait(1);						                     //延时
	 SYSC_(0x70005555)=0xa0;			                  //写入编程命令
	   wait(1);						                      //延时
     SYSC_(address)=data;				                  //写入编程数据
	while(SYSC_(address)!=data);			              //确认字节已写入
}
void writein()					                          //块数据获取
{
	  unsigned long i,data;
       put_string("Len:\n");				         //发送"请输入长度数据"的提示
       length=get_char();
       length=(length<<8)+get_char();
       length=(length<<8)+get_char();
       length=(length<<8)+get_char();			    //获取32位长度数据
	  for(i=0;i<length;i+=4)
	 {
		data=get_char();
		data+=get_char()<<8;
		data+=get_char()<<16;
		data+=get_char()<<24;			           //获取32位数据
		SDRAM_(i)=data;			                   //SDRAM赋值
}
	put_string("Ok!\n");				          //发送块数据读取完毕标志
}
void flashload()					             //块数据FLASH编程
{
  unsigned long i;
  writein();					                 //编程数据先读入SDRAM
	 flash_erase();					             //FLASH擦除
     for(i=0;i<length;i+=4)
	 {
		data=SDRAM_(i);
		flash_prog((0x70000000+i),data & 0xff);	        //FLASH字节编程
		flash_prog((0x70000001+i),(data>>8) & 0xff);	//FLASH字节编程
		flash_prog((0x70000002+i),(data>>16) & 0xff);	//FLASH字节编程
		flash_prog((0x70000003+i),(data>>24) & 0xff);	//FLASH字节编程			
	  }
	put_string("Done!\n");				              //发送FLASH编程成功标志
}
void mymain(void)					                  //串口调试函数
{
	unsigned char scomm,sdata;
	unsigned char *addrp;
	unsigned char *datap;

	addrp=(unsigned char*)&address;
	datap=(unsigned char*)&data;
	put_string("ok!\n");				        //发送串口调试启动标志
	
	while (1)					                 //主循环
    	{
		scomm=get_char();			             //读串口
		if(scomm==0xff)			                 //是否为命令前导字节"0xFF"？
	  		{
		  	scomm=get_char();		            //读调试命令字节
		  	if(scomm!=0xff)
	  			switch(scomm)		                     //根据调试命令散转
	  			{
					case 0xfa:flashload();break;              //执行FLASH编程操作
		  			default:put_string("Not Support!\n");        //不支持的命令
		  		}
		   else sdata=0xff;				              //数据"0xFF"赋值
		   }
         else sdata=scomm;				              //非"0xFF"数据直接赋值
        }
}
void  C_vMain(void)			              	      //主程序
{
     unsigned char i;
	 unsigned short j;	
     init_uart();					              //串口1初始化
     while(1)
	 {
		i=get_char();				               //读串口
		if(i==0x79)			              	       //是否读取到调试开始命令？
			mymain();			                   //进入串口调试
		else 
            put_char(i);				          //测试串口
     }
}
