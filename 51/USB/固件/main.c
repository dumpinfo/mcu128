#include <stdio.h>
#include <string.h>
#include <reg51.h>                /* special function register declarations   */

#include "epphal.h"
#include "d12ci.h"
#include "mainloop.h"
#include "usb100.h"
#include "chap_9.h"
#include "protodma.h"
#include"51usb.h"


/*
//*************************************************************************
// USB protocol function pointer arrays
//*************************************************************************
*/

#define uchar unsigned char 

//USB��׼����
code void (*StandardDeviceRequest[])(void) =
{
	get_status,
	clear_feature,
	reserved,
	set_feature,
	reserved,
	set_address,
	get_descriptor,
	reserved,
	get_configuration,
	set_configuration,
	get_interface,
	set_interface,
	reserved,
	reserved,
	reserved,
	reserved
};

//�û���������
code void (*VendorDeviceRequest[])(void) =
{
	reserved,
	reserved,
	reserved,
	reserved,
	reserved,
	reserved,
	reserved,
	reserved,
	reserved,
	reserved,
	reserved,
	reserved,
	reserved,
	reserved,
	reserved,
	reserved
};

/*
//*************************************************************************
//  Public static data
//*************************************************************************
*/

extern EPPFLAGS bEPPflags;
extern unsigned long ClockTicks;
extern unsigned char idata GenEpBuf[];
extern IO_REQUEST idata ioRequest;

extern unsigned char ioSize, ioCount;
extern unsigned char idata EpBuf[];
extern unsigned char idata mainbuflen;

CONTROL_XFER ControlData;
BOOL bNoRAM;

/////////////////���������/////////////////////
unsigned char code 	SEG[8]={0x00,0x02,0x04,0x06,0x08,0x0A,0x0C,0x0E};
unsigned char code  Tab[]	=	{0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,
                          		 0x80,0x90,0x88,0x83,0xC6,0xA1,0x86,0x8E};
unsigned char ShuMa[7]={1,2,3,4,5,6,0xFF};
unsigned char index=0;
///////////////////////////////////////////////

void init_timer0(void)
{
 	TMOD=0x01;//Timer0ģʽ1
	TH0 =0xFA;//Timer0 1.5ms�ж�һ��
 	TL0 =0x24;
	TF0 = 0;
	ET0 = 1;       
	TR0 = 1;         
}

//�ⲿ�ж�����
void init_special_interrupts(void)
{
	IT0 = 0;
	EX0 = 1;
	PX0 = 1;
}

//I/O�ڳ�ʼ������
void init_port()
{
	P0 = 0xFF;
	P1 = 0xFF;
	P2 = 0xFF;
	P3 = 0xFF;
}
//////////////////////////////////
void Display();
/////////////////////////////////
void main(void)
{

	init_port();//��ʼ��I/O��
	init_timer0();//��ʼ����ʱ��0
	init_special_interrupts();//�����ж�
	EA = 1;
	bEPPflags.value = 0;
	reconnect_USB();//��������USB
	/* Main program loop */

	while( TRUE )
	{
		if (bEPPflags.bits.timer)
		{
			Display();
			DISABLE;//��ʱ�����,��ⰴ��״̬
			bEPPflags.bits.timer = 0;
			if(bEPPflags.bits.configuration)//�豸δ���÷���
				check_key_LED();		//������
			ENABLE;

		}


		if (bEPPflags.bits.bus_reset) 
		{//�豸��λ����
			DISABLE;
			bEPPflags.bits.bus_reset = 0;
			ENABLE;
		
		} // if bus reset

		if(bEPPflags.bits.ep1_rxdone)  //�˵�1���
		{  
		 DISABLE;
		 bEPPflags.bits.ep1_rxdone=0;
		 ENABLE;
		}
	

		if (bEPPflags.bits.setup_packet)
		{//Setup������
			DISABLE;
			bEPPflags.bits.setup_packet = 0;
			ENABLE;
			TR0=0;
			control_handler();//�����������ӳ���
			TR0=1;
		} // if setup_packet

		if(bEPPflags.bits.main_rxdone)			//�˵�2���
		{
			DISABLE;
			bEPPflags.bits.main_rxdone=0;
			ENABLE;
		} //if main_rxdone
	} // Main Loop
}

//����stallӦ��
void stall_ep0(void)
{
	D12_SetEndpointStatus(0, 1);
	D12_SetEndpointStatus(1, 1);
}

//�Ͽ�USB����
void disconnect_USB(void)
{
	// Initialize D12 configuration
	D12_SetMode(D12_NOLAZYCLOCK, D12_SETTOONE | D12_CLOCK_12M);
}

//����USB����
void connect_USB(void)
{
	// reset event flags
	DISABLE;
	bEPPflags.value = 0;//�������״̬
	ENABLE;

	// V2.1 enable normal+sof interrupt
	D12_SetDMA(D12_ENDP4INTENABLE | D12_ENDP5INTENABLE);

	// Initialize D12 configuration
	D12_SetMode(D12_NOLAZYCLOCK|D12_SOFTCONNECT, D12_SETTOONE | D12_CLOCK_12M);
}

//�������ӵ�USB����
void reconnect_USB(void)
{
	unsigned long clk_cnt;
	disconnect_USB();
	clk_cnt = ClockTicks;
	while(ClockTicks < clk_cnt + 20);
	connect_USB();
}

//�ָ���δ����״̬
void init_unconfig(void)
{
	D12_SetEndpointEnable(0);	/* Disable all endpoints but EPP0. */
}

//��������״̬
void init_config(void)
{
	D12_SetEndpointEnable(1);	/* Enable  generic/iso endpoints. */
}

//�Ӷ˵��1��������
void single_transmit(unsigned char * buf, unsigned char len)
{
	if( len <= EP0_PACKET_SIZE) {
		D12_WriteEndpoint(1, len, buf);
	}
}

//���Ͷ˵��1��������
void code_transmit(unsigned char code * pRomData, unsigned short len)
{
	ControlData.wCount = 0;
	if(ControlData.wLength > len)
		ControlData.wLength = len;

	ControlData.pData = pRomData;
	if( ControlData.wLength >= EP0_PACKET_SIZE) {
		D12_WriteEndpoint(1, EP0_PACKET_SIZE, ControlData.pData);//����16�ֽ�����
		ControlData.wCount += EP0_PACKET_SIZE;
		DISABLE;
		bEPPflags.bits.control_state = USB_TRANSMIT;
		ENABLE;
	}
	else {
		D12_WriteEndpoint(1, ControlData.wLength, pRomData);//����16�ֽ�������
		ControlData.wCount += ControlData.wLength;
		DISABLE;
		bEPPflags.bits.control_state = USB_IDLE;
		ENABLE;
	}
}

//LED�Ͱ��������ӳ���

void Display()
{
	P1=1;			//����ʾ
	if(index==6) 	LED=ShuMa[index];//���LED����
	else			LED=Tab[ShuMa[index]];//������������
	P1=SEG[index];	//����ʾ
}
void check_key_LED(void)
{
	unsigned char temp;
	temp=KEY;			//��ȡ��ֵ
	temp^=0xff;			//ȡ����������λ������
	D12_WriteEndpoint(5,1,&temp); //д��˵�5
}

//�������ӳ���	����Setup��
void control_handler()
{
	unsigned char type, req;
	type = ControlData.DeviceRequest.bmRequestType & USB_REQUEST_TYPE_MASK;
	req = ControlData.DeviceRequest.bRequest & USB_REQUEST_MASK;
	if (type == USB_STANDARD_REQUEST)
		(*StandardDeviceRequest[req])();//���ñ�׼����
	else if (type == USB_VENDOR_REQUEST)
		(*VendorDeviceRequest[req])();//���ó�������
	else
		stall_ep0();
}
