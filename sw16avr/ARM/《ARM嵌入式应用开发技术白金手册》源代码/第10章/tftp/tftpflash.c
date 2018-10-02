#include "ioregs.h" 
#include "cs8900.h"
#include "net.h"
#include "flash.h"
#include "put.h"

static int sdrampoint=0;			//SDRAM的地址指针
static int i,j,pktlength=0,pktcount=0;
static int tftpNo,tftpSPort=0;	//保存接收tftp数据的序号和源端口
static int packetRAM[280];		//定义帧的存储数组 按照字从低到高排列

/******************************

	把ram中的数据写到flash中

********************************/

void ramtoflash(int length)
{

int point=0,t=0,k;

for(t=0;t<length*2;t=t+0x20000)			//每次写一个block
	{	
	FLASH_BYTE(t)=0x50;
	FLASH_BYTE(t)=0x20;
	FLASH_BYTE(t)=0xD0;
	while(FLASH_WORD(t)!=0x00800080);
	for(j=0;j<0x20000;j+=32)
		{
			FLASH_BYTE(t)=0x50;
			FLASH_BYTE(t)=0xE8;
			while(FLASH_WORD(t)!=0x00800080);
			FLASH_BYTE(t)=0x0F0F;
			for(k=0;k<8;k++)
				{
				FLASH_WORD(point)=RAM_WORD(point);
				point=point+4;
				}
			FLASH_BYTE(t+j)=0xD0;
			while(FLASH_WORD(t+j)!=0x00800080);
		if(point>2*length) return;
		
		}
	}	

}


/******************************

	交换高低字节

********************************/

int low2high(int i)
{
return ((i>>8)&0x00ff)+((i<<8)&0xff00);
}

/******************************

	将数据报读取到packetRAM[]中

********************************/
/*
static void readpacket(int i)
{
		packetRAM[i]=low2high(CS8900_RTDATA);
}
*/
/******************************

	计算校验和

	从packetRAM[start]开始
	计算len长度的和，然后把
	进位	位也加到地位，最后
	取补码。

********************************/

int inet_chksum(int start,int len)
{
long acc=0;
for(i=0;i<len;i++)
	acc=acc+packetRAM[start+i];

// 对于本程序校验和不会超过4个字节所以就不需要使用循环

// while(acc >> 16) {   
	acc = (acc & 0xffff) + (acc >> 16);
// }    
  return ~(acc & 0xffff);
}
/******************************

	交换 IP 地址

********************************/

void IpResp()
{
	packetRAM[ip_dst+0]=packetRAM[ip_src+0];
	packetRAM[ip_dst+1]=packetRAM[ip_src+1];

	packetRAM[ip_src]=IP12;
	packetRAM[ip_src+1]=IP34;
	
	packetRAM[ip_cksum]=0x0000;
	packetRAM[ip_cksum]=inet_chksum(ip_VerLen,10);
}

/******************************

	交换以太头地址

********************************/

void EthResp()
{
	packetRAM[pktDest12]=packetRAM[pktSrc12];
	packetRAM[pktDest34]=packetRAM[pktSrc34];
	packetRAM[pktDest56]=packetRAM[pktSrc56];

	packetRAM[pktSrc12]=MAC12;
	packetRAM[pktSrc34]=MAC34;
	packetRAM[pktSrc56]=MAC56;

}
/******************************

	发送数据报文的函数

********************************/

void sendpacket()
{
	//写发送命令字

	//CS8900_PP_TxCommand=0x00C0;
	CS8900_TxCMD=0x00C0;
	//写入发送数据报文的长度

	//CS8900_PP_TxLength=packetRAM[pktLen];
	CS8900_TxLEN=packetRAM[pktLen];
	//等待线路空闲的时候发送

	while(!(get_reg(PP_BusSTAT)&PP_BusSTAT_TxRDY));

	//写入需要发送的数据

	for(i=1;i<=packetRAM[pktLen]/2;i++)
		//CS8900_(PP_TxBASE+2*i-2)=low2high(packetRAM[i]);
		CS8900_RTDATA=low2high(packetRAM[i]);
}
/******************************

	发送tftp的ack信号

********************************/

 void tftpack()
{	
	//ack 用0004

	packetRAM[tftp_op]=tftp_opack;	

	//ack Number

	packetRAM[tftp_blk]=tftpNo;		
	
	//交换udp 端口
	
	packetRAM[u_src]=tftpARMport;
	packetRAM[u_dst]=tftpSPort;

	 //忽略校验和
	
	packetRAM[u_cksum]=0x0000;
	
	//ack帧 是定长度的 46 个字节 
	
	packetRAM[pktLen]=46;	
	packetRAM[ip_Len]=32;
	packetRAM[u_len]=12;
	EthResp();
	IpResp();
	sendpacket();
}


void  C_vMain(void)
{

/*******************************
	
	初始化CS8900A

*********************************/
	put_reg(PP_SelfCTL,PP_SelfCTL_Reset);	
	while(get_reg(PP_SelfSTAT)&PP_SelfSTAT_InitD!=PP_SelfSTAT_InitD);
	put_reg(PP_RxCTL,PP_RxCTL_RxOK |PP_RxCTL_Broadcast|PP_RxCTL_IA);
	put_reg(PP_RxCFG,PP_RxCFG_RxOK| PP_RxCFG_BufferCRC);
	put_reg(PP_LineCTL,PP_LineCTL_Rx|PP_LineCTL_Tx);
	put_reg(PP_TxCFG,PP_TxCFG_TxOK);
	put_reg(PP_IA_65,MAC56_);
	put_reg(PP_IA_43,MAC34_);
	put_reg(PP_IA_21,MAC12_);

/******************************

		开始接受数据

******************************/
for(;;){
	while( get_reg(PP_RER)&PP_RER_RxOK ){
		packetRAM[0]=get_reg(PP_RxLENGTH);
		//收取前面的74个字节，如果是ICMP正好包括了最后一个字符 14+20+8+32

		for (i=pktDest12;i<=23; i++)
		{
				packetRAM[i]=low2high(CS8900_RTDATA);		
		}
		
		//检查帧的类型 如果是 0806 表示arp

		if (packetRAM[pktType]==0x0806)
		{
			//*******************************
			
			//发现ARP数据报文就开始发送RARP

			//*********************************
			

			//判断arp是否合法
			/*	
			if (packetRAM[arp_hwtype]!=0x0001)
			return;
			if (packetRAM[arp_prtype]!=0x0800)
			return;
			if (packetRAM[arp_hwlen]!=0x0604)
			return;
			if (packetRAM[arp_op]!=0x0001)
			return;
			if (packetRAM[arp_tpa]!=IP12)
			return;
			if (packetRAM[arp_tpa+1]!=IP34)
			return;
			*/
			//判断结束 如果没有返回说明需要发送RARP			
			//******************************

			//		发送arp request

			//********************************

			//修改arp操作码为rarp

			packetRAM[arp_op]=0x0002;		
			
			//交换以太Mac
			
			EthResp();						
			
			//源mac 写到目的mac

			packetRAM[arp_tha]=packetRAM[arp_sha];
			packetRAM[arp_tha+1]=packetRAM[arp_sha+1];
			packetRAM[arp_tha+2]=packetRAM[arp_sha+2];
			
			//源ip 写到目的ip

			packetRAM[arp_tpa]=packetRAM[arp_spa];
			packetRAM[arp_tpa+1]=packetRAM[arp_spa+1];
			
			//重写源mac

			packetRAM[arp_sha]=MAC12;
			packetRAM[arp_sha+1]=MAC34;
			packetRAM[arp_sha+2]=MAC56;
			
			//重写源IP

			packetRAM[arp_spa]=IP12;
			packetRAM[arp_spa+1]=IP34;
			
			//发送rarp报文

			sendpacket();
		
		}

		//如果帧的类型是 0800 表示 IP 帧

		if(packetRAM[pktType]==0x0800)
		{
			//检查IP帧的类型 01 表示 ICMP , 11 表示UDP

			if((packetRAM[ip_proto]&0x00ff)==0x0001){
				
				//当帧的类型是 0800 表示ICMP请求

					if(packetRAM[ic_type]==0x0800){
					
						EthResp();
						IpResp();

						//改变ICMP 为 0000 表示应答

						packetRAM[ic_type]=0x0000;
						packetRAM[ic_cksum]=0x0000;
						packetRAM[ic_cksum]=inet_chksum(ip_data,20);
						sendpacket();
					}
			
				}

			if((packetRAM[ip_proto]&0x00ff)==0x0011){
				
				//判断UDP的目的地址是否是本机地址，如果不是就不处理

				//if(packetRAM[ip_dst+1]!=IP34||packetRAM[ip_dst]!=IP12)
				//	return;
				
				//检查目的端口是否是69 和tftpARMport
				
				if(packetRAM[u_dst]!=0x0045 && packetRAM[u_dst]!=tftpARMport)
					return;
				
				//然后检查 tftp_op 操作码 0002 表示写请求 
				
				if(packetRAM[tftp_op]==0x0002)
					{
					tftpNo=0;
					tftpSPort=packetRAM[u_src];
					sdrampoint=0;pktcount=0;
					tftpack();
					}
				// tftp_op 操作码 0003 表示数据
				if(packetRAM[tftp_op]==0x0003)
				{
					
					tftpNo=packetRAM[tftp_blk];

					//得到这一帧的长度 
					pktlength=(packetRAM[ip_Len]-32)/2;
					

					for(i=tftp_data;i<tftp_data+pktlength;i++)
					{	
						packetRAM[i]=CS8900_RTDATA&0xffff;
					//	put_char((packetRAM[i])&0x00ff);
					//	put_char((packetRAM[i]>>8)&0x00ff);
					}
					if (packetRAM[ip_Len]&0x0001==1)
					{
					packetRAM[i]=CS8900_RTDATA&0xffff;

					}

					//for(j=0;j<i-tftp_data;j+=2)	
					//{	
					//}
					//处理数据
						//将数据写到ram中
						for(j=0;j<i-tftp_data;j+=2)	
						{
						RAM_WORD(sdrampoint)=((packetRAM[tftp_data+j+1]<<16)|packetRAM[tftp_data+j]);
						sdrampoint=sdrampoint+4;
						}
					tftpack();
					//计算文件的长度 以字为单位
					pktcount=pktcount+pktlength;

					//如果帧的数据的长度 在 0-511个字节 pktlength是字长所以和256比较 表示已经是最后一个报文就开始向flash中写如数据
					
					if(pktlength<256)
					{
						ramtoflash(pktcount);
						put_char('!');
					}

					}
				if(packetRAM[tftp_op]==0x0005)	//清空所有的标记
					{
					sdrampoint=0;pktcount=0;
					return;
					}
			}

		}
		
		//不满足条件就跳过这一帧
		put_reg(PP_RxCFG,PP_RxCFG_Skip1);
	}

	}
}

