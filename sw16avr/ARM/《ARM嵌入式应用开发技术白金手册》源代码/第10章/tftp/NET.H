//定义IP包的信息位置


//硬件地址
#define	MAC12	0x0123
#define	MAC34	0x4567
#define	MAC56	0x89AB

#define	MAC12_	0x2301
#define	MAC34_	0x6745
#define	MAC56_	0xAB89
//IP地址
#define	IP1	0xCA	//202
#define	IP2	0x71	//113
#define	IP3	0x18	//24
#define	IP4	0x24	//36

#define IP12	0xCA71
#define	IP34	0x1824

//以太网帧信息
//按照字长计算

#define	pktLen		0	//帧长
#define	pktDest12	1	//目的地址
#define	pktDest34	2
#define	pktDest56	3
#define	pktSrc12	4	//源地址
#define	pktSrc34	5
#define	pktSrc56	6
#define	pktType 	7	//帧类型	 0800 IP	0806 ARP

//ARP

#define	arp_hwtype	8	//硬件类型00 01 表示10M以太网
#define arp_prtype	9	//协议类型08 00 表示Arp
#define arp_hwlen	10	//硬件地址的长度 6 协议地址的长度	4
#define arp_op		11	//arp 操作码 00 01 表示Request 00 02 表示Reply
#define arp_sha		12	//Sender's Hardware Address 发送者的硬件地址 6
#define arp_spa		15	//Sender's Protocal Address 发送者的协议地址 4
#define arp_tha		17	//Target's Hardware Address 目标硬件地址 6
#define arp_tpa		20	//Target's Protocal Address 目标协议地址 4

// with IP

#define	ip_VerLen	8	//Ver = 4 ,HeadLength=14H 
#define	ip_TOS		0x11H	//Type Of Service服务类型 
#define	ip_Len		9	//Total Length 总长度
#define	ip_ID		10	//Identification 
#define	ip_Fragoff	11	//Fragment Offset段偏移量
#define	ip_ttl		12	//Time to Live 生存时间   前一个字节
#define	ip_proto	12	//协议类型 01 TCP 06 ICMP 后一个字节
#define	ip_cksum	13	//校验和
#define	ip_src		14	//源IP
#define	ip_dst		16	//目的IP
#define	ip_data		18	//数据

//  ICMP	-- Internet 控制消息协议 

#define	ic_type		18		//Packet Type 00 ＝ Echo Reply 08 ＝ Echo Response
#define	ic_code		18	//Echo Code 
#define	ic_cksum	19	//Checksum 校验和
#define	ic_id		20	//Identification
#define	ic_seq		21		//Sequence Number 顺序号
 
//  UDP -- 用户数据报协议 

#define	u_src		18		//Source Port 源端口
#define	u_dst		19		//Destination Port 目的端口
#define	u_len		20		//Total Length 总长度
#define	u_cksum		21		//Checksum 校验和
#define	u_data		22	//Data 数据

//  TFTP -- 简单文件传输协议
//  Trivial File Transfer Protocol
#define	tftp_op		22		//Tftp操作码 00 03 DATA；00 04 ACK
/*	tftp_opCode:
            1     Read request (RRQ)
            2     Write request (WRQ)
            3     Data (DATA)
            4     Acknowledgment (ACK)
            5     Error (ERROR)
*/
#define	tftp_blk	23	//Block
#define	tftp_data	24	//DATA 实际数据

//tftp参数
#define	tftp_opRrq	0x0001
#define	tftp_opWrq	0x0002
#define tftp_opdata	0x0003
#define	tftp_opack	0x0004
#define	tftp_operr	0x0005
#define tftpPort	0x0045		//就是69
#define tftpARMport	0x9966		//任意制定的数据端口
//  IP 类型转换表

#define	IPT_ICMP	0x01H
#define	IPT_TCP		0x06H
#define	IPT_EGP		0x08H	//Exterior Gateway 外部网关
#define	IPT_UDP		0x11H
