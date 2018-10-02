#include "ioregs.h" 
#include "cs8900.h"
#include "net.h"
#include "flash.h"
#include "put.h"

static int sdrampoint=0;			//SDRAM�ĵ�ַָ��
static int i,j,pktlength=0,pktcount=0;
static int tftpNo,tftpSPort=0;	//�������tftp���ݵ���ź�Դ�˿�
static int packetRAM[280];		//����֡�Ĵ洢���� �����ִӵ͵�������

/******************************

	��ram�е�����д��flash��

********************************/

void ramtoflash(int length)
{

int point=0,t=0,k;

for(t=0;t<length*2;t=t+0x20000)			//ÿ��дһ��block
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

	�����ߵ��ֽ�

********************************/

int low2high(int i)
{
return ((i>>8)&0x00ff)+((i<<8)&0xff00);
}

/******************************

	�����ݱ���ȡ��packetRAM[]��

********************************/
/*
static void readpacket(int i)
{
		packetRAM[i]=low2high(CS8900_RTDATA);
}
*/
/******************************

	����У���

	��packetRAM[start]��ʼ
	����len���ȵĺͣ�Ȼ���
	��λ	λҲ�ӵ���λ�����
	ȡ���롣

********************************/

int inet_chksum(int start,int len)
{
long acc=0;
for(i=0;i<len;i++)
	acc=acc+packetRAM[start+i];

// ���ڱ�����У��Ͳ��ᳬ��4���ֽ����ԾͲ���Ҫʹ��ѭ��

// while(acc >> 16) {   
	acc = (acc & 0xffff) + (acc >> 16);
// }    
  return ~(acc & 0xffff);
}
/******************************

	���� IP ��ַ

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

	������̫ͷ��ַ

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

	�������ݱ��ĵĺ���

********************************/

void sendpacket()
{
	//д����������

	//CS8900_PP_TxCommand=0x00C0;
	CS8900_TxCMD=0x00C0;
	//д�뷢�����ݱ��ĵĳ���

	//CS8900_PP_TxLength=packetRAM[pktLen];
	CS8900_TxLEN=packetRAM[pktLen];
	//�ȴ���·���е�ʱ����

	while(!(get_reg(PP_BusSTAT)&PP_BusSTAT_TxRDY));

	//д����Ҫ���͵�����

	for(i=1;i<=packetRAM[pktLen]/2;i++)
		//CS8900_(PP_TxBASE+2*i-2)=low2high(packetRAM[i]);
		CS8900_RTDATA=low2high(packetRAM[i]);
}
/******************************

	����tftp��ack�ź�

********************************/

 void tftpack()
{	
	//ack ��0004

	packetRAM[tftp_op]=tftp_opack;	

	//ack Number

	packetRAM[tftp_blk]=tftpNo;		
	
	//����udp �˿�
	
	packetRAM[u_src]=tftpARMport;
	packetRAM[u_dst]=tftpSPort;

	 //����У���
	
	packetRAM[u_cksum]=0x0000;
	
	//ack֡ �Ƕ����ȵ� 46 ���ֽ� 
	
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
	
	��ʼ��CS8900A

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

		��ʼ��������

******************************/
for(;;){
	while( get_reg(PP_RER)&PP_RER_RxOK ){
		packetRAM[0]=get_reg(PP_RxLENGTH);
		//��ȡǰ���74���ֽڣ������ICMP���ð��������һ���ַ� 14+20+8+32

		for (i=pktDest12;i<=23; i++)
		{
				packetRAM[i]=low2high(CS8900_RTDATA);		
		}
		
		//���֡������ ����� 0806 ��ʾarp

		if (packetRAM[pktType]==0x0806)
		{
			//*******************************
			
			//����ARP���ݱ��ľͿ�ʼ����RARP

			//*********************************
			

			//�ж�arp�Ƿ�Ϸ�
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
			//�жϽ��� ���û�з���˵����Ҫ����RARP			
			//******************************

			//		����arp request

			//********************************

			//�޸�arp������Ϊrarp

			packetRAM[arp_op]=0x0002;		
			
			//������̫Mac
			
			EthResp();						
			
			//Դmac д��Ŀ��mac

			packetRAM[arp_tha]=packetRAM[arp_sha];
			packetRAM[arp_tha+1]=packetRAM[arp_sha+1];
			packetRAM[arp_tha+2]=packetRAM[arp_sha+2];
			
			//Դip д��Ŀ��ip

			packetRAM[arp_tpa]=packetRAM[arp_spa];
			packetRAM[arp_tpa+1]=packetRAM[arp_spa+1];
			
			//��дԴmac

			packetRAM[arp_sha]=MAC12;
			packetRAM[arp_sha+1]=MAC34;
			packetRAM[arp_sha+2]=MAC56;
			
			//��дԴIP

			packetRAM[arp_spa]=IP12;
			packetRAM[arp_spa+1]=IP34;
			
			//����rarp����

			sendpacket();
		
		}

		//���֡�������� 0800 ��ʾ IP ֡

		if(packetRAM[pktType]==0x0800)
		{
			//���IP֡������ 01 ��ʾ ICMP , 11 ��ʾUDP

			if((packetRAM[ip_proto]&0x00ff)==0x0001){
				
				//��֡�������� 0800 ��ʾICMP����

					if(packetRAM[ic_type]==0x0800){
					
						EthResp();
						IpResp();

						//�ı�ICMP Ϊ 0000 ��ʾӦ��

						packetRAM[ic_type]=0x0000;
						packetRAM[ic_cksum]=0x0000;
						packetRAM[ic_cksum]=inet_chksum(ip_data,20);
						sendpacket();
					}
			
				}

			if((packetRAM[ip_proto]&0x00ff)==0x0011){
				
				//�ж�UDP��Ŀ�ĵ�ַ�Ƿ��Ǳ�����ַ��������ǾͲ�����

				//if(packetRAM[ip_dst+1]!=IP34||packetRAM[ip_dst]!=IP12)
				//	return;
				
				//���Ŀ�Ķ˿��Ƿ���69 ��tftpARMport
				
				if(packetRAM[u_dst]!=0x0045 && packetRAM[u_dst]!=tftpARMport)
					return;
				
				//Ȼ���� tftp_op ������ 0002 ��ʾд���� 
				
				if(packetRAM[tftp_op]==0x0002)
					{
					tftpNo=0;
					tftpSPort=packetRAM[u_src];
					sdrampoint=0;pktcount=0;
					tftpack();
					}
				// tftp_op ������ 0003 ��ʾ����
				if(packetRAM[tftp_op]==0x0003)
				{
					
					tftpNo=packetRAM[tftp_blk];

					//�õ���һ֡�ĳ��� 
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
					//��������
						//������д��ram��
						for(j=0;j<i-tftp_data;j+=2)	
						{
						RAM_WORD(sdrampoint)=((packetRAM[tftp_data+j+1]<<16)|packetRAM[tftp_data+j]);
						sdrampoint=sdrampoint+4;
						}
					tftpack();
					//�����ļ��ĳ��� ����Ϊ��λ
					pktcount=pktcount+pktlength;

					//���֡�����ݵĳ��� �� 0-511���ֽ� pktlength���ֳ����Ժ�256�Ƚ� ��ʾ�Ѿ������һ�����ľͿ�ʼ��flash��д������
					
					if(pktlength<256)
					{
						ramtoflash(pktcount);
						put_char('!');
					}

					}
				if(packetRAM[tftp_op]==0x0005)	//������еı��
					{
					sdrampoint=0;pktcount=0;
					return;
					}
			}

		}
		
		//������������������һ֡
		put_reg(PP_RxCFG,PP_RxCFG_Skip1);
	}

	}
}

