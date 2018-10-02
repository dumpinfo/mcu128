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
usb_isr() interrupt 0	 //�ⲿ�ж�0
{
	DISABLE;
	fn_usb_isr();	//USB������
	ENABLE;
}


timer_isr() interrupt 1	  //��ʱ0������
{
	//DISABLE;
	TF0 = 0;
	TH0 =0xFA;//Timer0 1.5ms�ж�һ��
 	TL0 =0x24;
	if(++index==7)index=0;	  //index��1��ɨ����
	ClockTicks++;
	bEPPflags.bits.timer = 1;
	//ENABLE;
}

//USB�жϴ���

//USB�жϷ����ӳ���
void fn_usb_isr()
{
	unsigned int i_st;

	bEPPflags.bits.in_isr = 1;

	i_st = D12_ReadInterruptRegister();//��ȡ�жϼĴ���

	if(i_st != 0) {
		if(i_st & D12_INT_BUSRESET) {
			bus_reset();//USB���߷���
			bEPPflags.bits.bus_reset = 1;
		}

		if(i_st & D12_INT_EOT)
			dma_eot();//DMA�������

		if(i_st & D12_INT_SUSPENDCHANGE)
			bEPPflags.bits.suspend = 1;//����ı�

		if(i_st & D12_INT_ENDP0IN)
			ep0_txdone();//�˵�0IN�ж�
		if(i_st & D12_INT_ENDP0OUT)
			ep0_rxdone();//�˵�0OUT�ж�
		if(i_st & D12_INT_ENDP1IN)
			ep1_txdone();//�˵�1IN�ж�
		if(i_st & D12_INT_ENDP1OUT)
			ep1_rxdone();//�˵�1OUT�ж�
		if(i_st & D12_INT_ENDP2IN)
			main_txdone();//�˵�2IN�ж�
		if(i_st & D12_INT_ENDP2OUT)
			main_rxdone();//�˵�2OUT�ж�
	}

	bEPPflags.bits.in_isr = 0;
}

//���߸�λ�����ӳ���
void bus_reset(void)
{
}

//�˵�0 OUT�ж�
void ep0_rxdone(void)
{
	unsigned char ep_last, i;

	ep_last = D12_ReadLastTransactionStatus(0); //���жϱ�־

	if (ep_last & D12_SETUPPACKET) 
	{
		//���յ�SETUP����������λ��
		ControlData.wLength = 0;
		ControlData.wCount = 0;

		if( D12_ReadEndpoint(0, sizeof(ControlData.DeviceRequest),
			(unsigned char *)(&(ControlData.DeviceRequest))) != sizeof(DEVICE_REQUEST) )
		{
			//SETUP������,����
			D12_SetEndpointStatus(0, 1);
			D12_SetEndpointStatus(1, 1);
			bEPPflags.bits.control_state = USB_IDLE;
			return;
		}

		ControlData.DeviceRequest.wValue = SWAP(ControlData.DeviceRequest.wValue);
		ControlData.DeviceRequest.wIndex = SWAP(ControlData.DeviceRequest.wIndex);
		ControlData.DeviceRequest.wLength = SWAP(ControlData.DeviceRequest.wLength);

		//�Կ��ƶ˵������/�������Ӧ��
		D12_AcknowledgeEndpoint(0);
		D12_AcknowledgeEndpoint(1);

		ControlData.wLength = ControlData.DeviceRequest.wLength;
		ControlData.wCount = 0;

		if (ControlData.DeviceRequest.bmRequestType & (unsigned char)USB_ENDPOINT_DIRECTION_MASK)
		{
			//��������������
			bEPPflags.bits.setup_packet = 1;
			bEPPflags.bits.control_state = USB_TRANSMIT;		/* get command */
		}
		else
		{  //��������������
			if (ControlData.DeviceRequest.wLength == 0) //������ճ�����0
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
					bEPPflags.bits.control_state = USB_RECEIVE;	//���ý���״̬
				}
			} // set command with data
		} // else set command
	} // if setup packet

	else if (bEPPflags.bits.control_state == USB_RECEIVE) 
	{
		//�������� ��������λ��
		i =	D12_ReadEndpoint(0, EP0_PACKET_SIZE,
			ControlData.dataBuffer + ControlData.wCount);
		ControlData.wCount += i;
		if( i != EP0_PACKET_SIZE || ControlData.wCount >= ControlData.wLength) 
		{
			//���ݽ������
			bEPPflags.bits.setup_packet = 1;
			bEPPflags.bits.control_state = USB_IDLE;
		}
	}
	else 
	{
		bEPPflags.bits.control_state = USB_IDLE;//����ȴ�״̬
	}
}

//�˵�0IN����
void ep0_txdone(void)
{
	short i = ControlData.wLength - ControlData.wCount;
	D12_ReadLastTransactionStatus(1); //���жϱ�־λ
	if (bEPPflags.bits.control_state != USB_TRANSMIT) 
		return;//�Ƿ���״̬,����

	if( i >= EP0_PACKET_SIZE) 
	{
		//ʣ�����ݴ���16�ֽ�,����16�ֽ�
		D12_WriteEndpoint(1, EP0_PACKET_SIZE, ControlData.pData + ControlData.wCount);
		ControlData.wCount += EP0_PACKET_SIZE;
		bEPPflags.bits.control_state = USB_TRANSMIT;
	}
	else if( i != 0) 
	{
		//����ʣ������
		D12_WriteEndpoint(1, i, ControlData.pData + ControlData.wCount);
		ControlData.wCount += i;
		bEPPflags.bits.control_state = USB_IDLE;
	}
	else if (i == 0){
		D12_WriteEndpoint(1, 0, 0); //�������,����0�ֽ�
		bEPPflags.bits.control_state = USB_IDLE;
	}
}

//DMA��������
void dma_eot(void)
{
}

//�˵�1IN����
void ep1_txdone(void)
{
	D12_ReadLastTransactionStatus(3); //���жϱ�־λ
}

//�˵�1OUT����
/*extern unsigned char ShuMa[7];*/
void ep1_rxdone(void)
{  //����LED/�����/
	unsigned char len;

	D12_ReadLastTransactionStatus(2); //���жϱ�־λ
	len = D12_ReadEndpoint(2, sizeof(GenEpBuf), GenEpBuf);//��ȡ����
	ShuMa[0]=GenEpBuf[0];
	ShuMa[1]=GenEpBuf[1];
	ShuMa[2]=GenEpBuf[2];
	ShuMa[3]=GenEpBuf[3];
	ShuMa[4]=GenEpBuf[4];
	ShuMa[5]=GenEpBuf[5];
	ShuMa[6]=GenEpBuf[6];
	if(len != 0)
		bEPPflags.bits.ep1_rxdone = 1;//��־���յ�����
}

//���˵�IN����
void main_txdone(void)
{
	D12_ReadLastTransactionStatus(5); //���жϱ�־λ

}

//���˵�OUT����
void main_rxdone(void)
{
	unsigned char len,epstatus;
	D12_ReadLastTransactionStatus(4); //���жϱ�־λ
	//��������
	len = D12_ReadEndpoint(4, 64, EpBuf);
	epstatus=D12_ReadEndpointStatus(4);
	epstatus &= 0x60;
	if (epstatus == 0x60)
		len = D12_ReadEndpoint(4, 64, EpBuf);//��ȡ˫����������
	if(len != 0)
	{
		bEPPflags.bits.main_rxdone = 1;//��־���յ�����
	mainbuflen=len;
	}
}























