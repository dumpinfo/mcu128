#include <stdio.h>
#include <string.h>

#include <iom16v.h>               /* special function register declarations   */

#include "epphal.h"
#include "d12ci.h"
#include "mainloop.h"
#include "usb100.h"

extern void bus_reset(void);
extern void ep0_txdone(void);
extern void ep0_rxdone(void);
extern void ep1_txdone(void);
extern void ep1_rxdone(void);
extern void main_txdone(void);
extern void main_rxdone(void);
extern void dma_eot(void);

/*
//*************************************************************************
//  Public static data
//*************************************************************************
*/
#define uchar unsigned char 
EPPFLAGS bEPPflags;

/* Control endpoint TX/RX buffers */
extern CONTROL_XFER ControlData;

/* ISR static vars */
unsigned char idata GenEpBuf[EP1_PACKET_SIZE];
unsigned char idata EpBuf[EP2_PACKET_SIZE];
unsigned char idata mainbuflen;
IO_REQUEST idata ioRequest;
unsigned char ioSize, ioCount;
unsigned long ClockTicks = 0;

extern BOOL bNoRAM;
/*//////////////////////////////*/
extern unsigned char ShuMa[7];
extern unsigned char index;
/*//////////////////////////////*/
usb_isr() interrupt 0	 //外部中断0
{
	DISABLE;
	fn_usb_isr();	//USB处理函数
	ENABLE;
}


timer_isr() interrupt 1	  //定时0处理函数
{
	//DISABLE;
	TF0 = 0;
	TH0 =0xFA;//Timer0 1.5ms中断一次
 	TL0 =0x24;
	if(++index==7)index=0;	  //index加1，扫描用
	ClockTicks++;
	bEPPflags.bits.timer = 1;
	//ENABLE;
}

//USB中断处理

//USB中断服务子程序
void fn_usb_isr()
{
	unsigned int i_st;

	bEPPflags.bits.in_isr = 1;

	i_st = D12_ReadInterruptRegister();//读取中断寄存器

	if(i_st != 0) {
		if(i_st & D12_INT_BUSRESET) {
			bus_reset();//USB总线服务
			bEPPflags.bits.bus_reset = 1;
		}

		if(i_st & D12_INT_EOT)
			dma_eot();//DMA传输结束

		if(i_st & D12_INT_SUSPENDCHANGE)
			bEPPflags.bits.suspend = 1;//挂起改变

		if(i_st & D12_INT_ENDP0IN)
			ep0_txdone();//端点0IN中断
		if(i_st & D12_INT_ENDP0OUT)
			ep0_rxdone();//端点0OUT中断
		if(i_st & D12_INT_ENDP1IN)
			ep1_txdone();//端点1IN中断
		if(i_st & D12_INT_ENDP1OUT)
			ep1_rxdone();//端点1OUT中断
		if(i_st & D12_INT_ENDP2IN)
			main_txdone();//端点2IN中断
		if(i_st & D12_INT_ENDP2OUT)
			main_rxdone();//端点2OUT中断
	}

	bEPPflags.bits.in_isr = 0;
}

//总线复位处理子程序
void bus_reset(void)
{
}

//端点0 OUT中断
void ep0_rxdone(void)
{
	unsigned char ep_last, i;

	ep_last = D12_ReadLastTransactionStatus(0); //清中断标志

	if (ep_last & D12_SETUPPACKET) 
	{
		//接收到SETUP包（命令相位）
		ControlData.wLength = 0;
		ControlData.wCount = 0;

		if( D12_ReadEndpoint(0, sizeof(ControlData.DeviceRequest),
			(unsigned char *)(&(ControlData.DeviceRequest))) != sizeof(DEVICE_REQUEST) )
		{
			//SETUP包出错,返回
			D12_SetEndpointStatus(0, 1);
			D12_SetEndpointStatus(1, 1);
			bEPPflags.bits.control_state = USB_IDLE;
			return;
		}

		ControlData.DeviceRequest.wValue = SWAP(ControlData.DeviceRequest.wValue);
		ControlData.DeviceRequest.wIndex = SWAP(ControlData.DeviceRequest.wIndex);
		ControlData.DeviceRequest.wLength = SWAP(ControlData.DeviceRequest.wLength);

		//对控制端点的输入/输出进行应答
		D12_AcknowledgeEndpoint(0);
		D12_AcknowledgeEndpoint(1);

		ControlData.wLength = ControlData.DeviceRequest.wLength;
		ControlData.wCount = 0;

		if (ControlData.DeviceRequest.bmRequestType & (unsigned char)USB_ENDPOINT_DIRECTION_MASK)
		{
			//向主机传输数据
			bEPPflags.bits.setup_packet = 1;
			bEPPflags.bits.control_state = USB_TRANSMIT;		/* get command */
		}
		else
		{  //从主机接收数据
			if (ControlData.DeviceRequest.wLength == 0) //如果接收长度是0
			{
				bEPPflags.bits.setup_packet = 1;
				bEPPflags.bits.control_state = USB_IDLE;		/* set command */
			}
			else 
			{
				if(ControlData.DeviceRequest.wLength > MAX_CONTROLDATA_SIZE) 
				{
				
					bEPPflags.bits.control_state = USB_IDLE;
					D12_SetEndpointStatus(0, 1);
					D12_SetEndpointStatus(1, 1);
				}
				else 
				{
					bEPPflags.bits.control_state = USB_RECEIVE;	//设置接收状态
				}
			} // set command with data
		} // else set command
	} // if setup packet

	else if (bEPPflags.bits.control_state == USB_RECEIVE) 
	{
		//接收数据 （数据相位）
		i =	D12_ReadEndpoint(0, EP0_PACKET_SIZE,
			ControlData.dataBuffer + ControlData.wCount);
		ControlData.wCount += i;
		if( i != EP0_PACKET_SIZE || ControlData.wCount >= ControlData.wLength) 
		{
			//数据接收完毕
			bEPPflags.bits.setup_packet = 1;
			bEPPflags.bits.control_state = USB_IDLE;
		}
	}
	else 
	{
		bEPPflags.bits.control_state = USB_IDLE;//进入等待状态
	}
}

//端点0IN处理
void ep0_txdone(void)
{
	short i = ControlData.wLength - ControlData.wCount;
	D12_ReadLastTransactionStatus(1); //清中断标志位
	if (bEPPflags.bits.control_state != USB_TRANSMIT) 
		return;//非发送状态,返回

	if( i >= EP0_PACKET_SIZE) 
	{
		//剩下数据大于16字节,发送16字节
		D12_WriteEndpoint(1, EP0_PACKET_SIZE, ControlData.pData + ControlData.wCount);
		ControlData.wCount += EP0_PACKET_SIZE;
		bEPPflags.bits.control_state = USB_TRANSMIT;
	}
	else if( i != 0) 
	{
		//发送剩下数据
		D12_WriteEndpoint(1, i, ControlData.pData + ControlData.wCount);
		ControlData.wCount += i;
		bEPPflags.bits.control_state = USB_IDLE;
	}
	else if (i == 0){
		D12_WriteEndpoint(1, 0, 0); //发送完毕,发送0字节
		bEPPflags.bits.control_state = USB_IDLE;
	}
}

//DMA结束处理
void dma_eot(void)
{
}

//端点1IN处理
void ep1_txdone(void)
{
	D12_ReadLastTransactionStatus(3); //清中断标志位
}

//端点1OUT处理
/*extern unsigned char ShuMa[7];*/
void ep1_rxdone(void)
{  //控制LED/数码管/
	unsigned char len;

	D12_ReadLastTransactionStatus(2); //清中断标志位
	len = D12_ReadEndpoint(2, sizeof(GenEpBuf), GenEpBuf);//读取数据
	ShuMa[0]=GenEpBuf[0];
	ShuMa[1]=GenEpBuf[1];
	ShuMa[2]=GenEpBuf[2];
	ShuMa[3]=GenEpBuf[3];
	ShuMa[4]=GenEpBuf[4];
	ShuMa[5]=GenEpBuf[5];
	ShuMa[6]=GenEpBuf[6];
	if(len != 0)
		bEPPflags.bits.ep1_rxdone = 1;//标志接收到数据
}

//主端点IN控制
void main_txdone(void)
{
	D12_ReadLastTransactionStatus(5); //清中断标志位

}

//主端点OUT控制
void main_rxdone(void)
{
	unsigned char len,epstatus;
	D12_ReadLastTransactionStatus(4); //清中断标志位
	//接收数据
	len = D12_ReadEndpoint(4, 64, EpBuf);
	epstatus=D12_ReadEndpointStatus(4);
	epstatus &= 0x60;
	if (epstatus == 0x60)
		len = D12_ReadEndpoint(4, 64, EpBuf);//读取双缓冲区数据
	if(len != 0)
	{
		bEPPflags.bits.main_rxdone = 1;//标志接收到数据
	mainbuflen=len;
	}
}























