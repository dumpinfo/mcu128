#line 1 "E:\avr资料\例程\m16\USB\固件\Chap_9.c"
#line 1 "D:/PROGRA~1/icc/include/stdio.h"


#line 1 "D:/PROGRA~1/icc/include/stdarg.h"


typedef char *va_list;




#line 9 "D:/PROGRA~1/icc/include/stdarg.h"

char *_va_start(void *, int);

#line 13 "D:/PROGRA~1/icc/include/stdarg.h"




#line 4 "D:/PROGRA~1/icc/include/stdio.h"
#line 1 "D:/PROGRA~1/icc/include/_const.h"




#line 10 "D:/PROGRA~1/icc/include/_const.h"







#line 5 "D:/PROGRA~1/icc/include/stdio.h"

int getchar(void);
int putchar(char);
int puts( char *);
int printf( char *, ...);
int vprintf( char *, va_list va);
int sprintf(char *, char *, ...);
int vsprintf(char *, char *, va_list va);

int scanf( char *, ...);
int vscanf( char *, va_list va);
int sscanf(char *, char *, ...);
int vsscanf(char *, char *, va_list va);






int cprintf(const char *, ...);
int csprintf(char *, const char *, ...);



#line 2 "E:\avr资料\例程\m16\USB\固件\Chap_9.c"
#line 1 "D:/PROGRA~1/icc/include/string.h"


#line 1 "D:/PROGRA~1/icc/include/_const.h"




#line 10 "D:/PROGRA~1/icc/include/_const.h"







#line 4 "D:/PROGRA~1/icc/include/string.h"


















typedef unsigned int size_t;


void *memcpy(void *, void *, size_t);
void *memset(void *, int, size_t);
void *memchr(void *, int, size_t);
int memcmp(void *, void *, size_t);
void *memmove(void *, void *, size_t);

char *strchr( char *, int);
int strcoll( char *, char *);
size_t strcspn( char *, char *);
char *strncat(char *, char *, size_t);
int strncmp( char *, char *, size_t);
char *strncpy(char *, char *, size_t);
char *strpbrk( char *, char *);
char *strrchr( char *, int);
size_t strspn( char *, char *);
char *strstr( char *, char *);


char *strtok(char *, char *);


size_t strlen( char *);
char *strcpy(char *, char *);
int strcmp( char *, char *);
char *strcat(char *, char *);


size_t cstrlen(const char *cs);
char *cstrcpy(char *, const char *cs);
char *cstrncpy(char *, const char *cs, size_t);
int cstrcmp(const char *cs, char *);
char *cstrcat(char *, const char *);



int cstrncmp(const char *cs, char *i, int);

char *cstrstr(char *ramstr, const char *romstr);
char *cstrstrx(char *ramstr, const char *romstr);
void *cmemcpy(void *, const void *, size_t);
void *cmemchr(const void *, int, size_t);
int cmemcmp(const void *, void *, size_t);



#line 72 "D:/PROGRA~1/icc/include/string.h"

#line 3 "E:\avr资料\例程\m16\USB\固件\Chap_9.c"

#line 1 "D:/PROGRA~1/icc/include/iom16v.h"




#line 7 "D:/PROGRA~1/icc/include/iom16v.h"


#line 10 "D:/PROGRA~1/icc/include/iom16v.h"


#line 13 "D:/PROGRA~1/icc/include/iom16v.h"


#line 16 "D:/PROGRA~1/icc/include/iom16v.h"
























































































































































































































































































































































































































































































































#line 5 "E:\avr资料\例程\m16\USB\固件\Chap_9.c"

#line 1 "E:\avr资料\例程\m16\USB\固件/epphal.h"

#line 20 "E:\avr资料\例程\m16\USB\固件/epphal.h"














	sbit MCU_SWM0     = P1^0;
	sbit MCU_SWM1     = P1^1;
	sbit MCU_SWM2     = P1^2;
	sbit MCU_SWM3     = P1^3;
	sbit MCU_LED0	  = P1^4;
	sbit MCU_LED1	  = P3^3;




#line 7 "E:\avr资料\例程\m16\USB\固件\Chap_9.c"
#line 1 "E:\avr资料\例程\m16\USB\固件/d12ci.h"

#line 21 "E:\avr资料\例程\m16\USB\固件/d12ci.h"














































void D12_SetAddressEnable(unsigned char bAddress, unsigned char bEnable);
void D12_SetEndpointEnable(unsigned char bEnable);
void D12_SetMode(unsigned char bConfig, unsigned char bClkDiv);
void D12_SetDMA(unsigned char bMode);
unsigned char D12_GetDMA(void);
unsigned short D12_ReadInterruptRegister(void);
unsigned char D12_SelectEndpoint(unsigned char bEndp);
unsigned char D12_ReadLastTransactionStatus(unsigned char bEndp);
unsigned char D12_ReadEndpointStatus(unsigned char bEndp);
void D12_SetEndpointStatus(unsigned char bEndp, unsigned char bStalled);


unsigned short D12_ReadChipID(void);

unsigned char D12_ReadEndpoint(unsigned char endp, unsigned char len, unsigned char * buf);
unsigned char D12_WriteEndpoint(unsigned char endp, unsigned char len, unsigned char * buf);
void D12_AcknowledgeEndpoint(unsigned char endp);

unsigned char D12_ReadMainEndpoint(unsigned char * buf);

unsigned char inportb(unsigned int addr);
void outportb(unsigned int addr, unsigned char Data);


#line 8 "E:\avr资料\例程\m16\USB\固件\Chap_9.c"
#line 1 "E:\avr资料\例程\m16\USB\固件/mainloop.h"

#line 21 "E:\avr资料\例程\m16\USB\固件/mainloop.h"







#line 32 "E:\avr资料\例程\m16\USB\固件/mainloop.h"
























#line 60 "E:\avr资料\例程\m16\USB\固件/mainloop.h"
















#line 80 "E:\avr资料\例程\m16\USB\固件/mainloop.h"









#line 93 "E:\avr资料\例程\m16\USB\固件/mainloop.h"
typedef unsigned char   UCHAR;
typedef unsigned short  USHORT;
typedef unsigned long   ULONG;
typedef unsigned char   BOOL;


#line 103 "E:\avr资料\例程\m16\USB\固件/mainloop.h"
typedef union _epp_flags
{
	struct _flags
	{
		unsigned char timer               	: 1;
		unsigned char bus_reset           	: 1;
		unsigned char suspend             	: 1;
		unsigned char setup_packet  	  	: 1;
		unsigned char remote_wakeup		   	: 1;
		unsigned char in_isr		      	: 1;
		unsigned char control_state			: 2;

		unsigned char configuration			: 1;
		unsigned char verbose				: 1;
		unsigned char ep1_rxdone			: 1;
		unsigned char main_rxdone			: 1;
		unsigned char dma_state      		: 2;
		unsigned char power_down			: 1;
	} bits;
	unsigned short value;
} EPPFLAGS;

typedef struct _device_request
{
	unsigned char bmRequestType;
	unsigned char bRequest;
	unsigned short wValue;
	unsigned short wIndex;
	unsigned short wLength;
} DEVICE_REQUEST;

typedef struct _IO_REQUEST {
	unsigned short	uAddressL;
	unsigned char	bAddressH;
	unsigned short	uSize;
	unsigned char	bCommand;
} IO_REQUEST, *PIO_REQUEST;



typedef struct _control_xfer
{
	DEVICE_REQUEST DeviceRequest;
	unsigned short wLength;
	unsigned short wCount;
	unsigned char * pData;
	unsigned char dataBuffer[8];
} CONTROL_XFER;


#line 157 "E:\avr资料\例程\m16\USB\固件/mainloop.h"

void fn_usb_isr();

extern void suspend_change(void);
extern void stall_ep0(void);
extern void disconnect_USB(void);
extern void connect_USB(void);
extern void reconnect_USB(void);
extern void init_unconfig(void);
extern void init_config(void);
extern void single_transmit(unsigned char * pData, unsigned char len);
extern void code_transmit(unsigned char code * pRomData, unsigned short len);

extern void control_handler();
extern void check_key_LED(void);


















typedef struct _TWAIN_FILEINFO {
	unsigned char	bPage;
	unsigned char	uSizeH;
	unsigned char	uSizeL;
} TWAIN_FILEINFO, *PTWAIN_FILEINFO;




#line 9 "E:\avr资料\例程\m16\USB\固件\Chap_9.c"
#line 1 "E:\avr资料\例程\m16\USB\固件/usb100.h"










































































































typedef struct _USB_DEVICE_DESCRIPTOR {
    UCHAR bLength;
    UCHAR bDescriptorType;
    USHORT bcdUSB;
    UCHAR bDeviceClass;
    UCHAR bDeviceSubClass;
    UCHAR bDeviceProtocol;
    UCHAR bMaxPacketSize0;
    USHORT idVendor;
    USHORT idProduct;
    USHORT bcdDevice;
    UCHAR iManufacturer;
    UCHAR iProduct;
    UCHAR iSerialNumber;
    UCHAR bNumConfigurations;
} USB_DEVICE_DESCRIPTOR, *PUSB_DEVICE_DESCRIPTOR;

typedef struct _USB_ENDPOINT_DESCRIPTOR {
    UCHAR bLength;
    UCHAR bDescriptorType;
    UCHAR bEndpointAddress;
    UCHAR bmAttributes;
    USHORT wMaxPacketSize;
    UCHAR bInterval;
} USB_ENDPOINT_DESCRIPTOR, *PUSB_ENDPOINT_DESCRIPTOR;










typedef struct _USB_CONFIGURATION_DESCRIPTOR {
    UCHAR bLength;
    UCHAR bDescriptorType;
    USHORT wTotalLength;
    UCHAR bNumInterfaces;
    UCHAR bConfigurationValue;
    UCHAR iConfiguration;
    UCHAR bmAttributes;
    UCHAR MaxPower;
} USB_CONFIGURATION_DESCRIPTOR, *PUSB_CONFIGURATION_DESCRIPTOR;

typedef struct _USB_INTERFACE_DESCRIPTOR {
    UCHAR bLength;
    UCHAR bDescriptorType;
    UCHAR bInterfaceNumber;
    UCHAR bAlternateSetting;
    UCHAR bNumEndpoints;
    UCHAR bInterfaceClass;
    UCHAR bInterfaceSubClass;
    UCHAR bInterfaceProtocol;
    UCHAR iInterface;
} USB_INTERFACE_DESCRIPTOR, *PUSB_INTERFACE_DESCRIPTOR;

typedef struct _USB_STRING_DESCRIPTOR {
    UCHAR bLength;
    UCHAR bDescriptorType;
    UCHAR bString[1];
} USB_STRING_DESCRIPTOR, *PUSB_STRING_DESCRIPTOR;














typedef struct _USB_POWER_DESCRIPTOR {
    UCHAR bLength;
    UCHAR bDescriptorType;
    UCHAR bCapabilitiesFlags;
    USHORT EventNotification;
    USHORT D1LatencyTime;
    USHORT D2LatencyTime;
    USHORT D3LatencyTime;
    UCHAR PowerUnit;
    USHORT D0PowerConsumption;
    USHORT D1PowerConsumption;
    USHORT D2PowerConsumption;
} USB_POWER_DESCRIPTOR, *PUSB_POWER_DESCRIPTOR;


typedef struct _USB_COMMON_DESCRIPTOR {
    UCHAR bLength;
    UCHAR bDescriptorType;
} USB_COMMON_DESCRIPTOR, *PUSB_COMMON_DESCRIPTOR;








typedef struct _USB_HUB_DESCRIPTOR {
    UCHAR        bDescriptorLength;
    UCHAR        bDescriptorType;
    UCHAR        bNumberOfPorts;
    USHORT       wHubCharacteristics;
    UCHAR        bPowerOnToPowerGood;
    UCHAR        bHubControlCurrent;


    UCHAR        bRemoveAndPowerMask[64];
} USB_HUB_DESCRIPTOR, *PUSB_HUB_DESCRIPTOR;



#line 10 "E:\avr资料\例程\m16\USB\固件\Chap_9.c"
#line 1 "E:\avr资料\例程\m16\USB\固件/chap_9.h"

#line 19 "E:\avr资料\例程\m16\USB\固件/chap_9.h"






#line 29 "E:\avr资料\例程\m16\USB\固件/chap_9.h"


#line 35 "E:\avr资料\例程\m16\USB\固件/chap_9.h"
void get_status(void);
void clear_feature(void);
void set_feature(void);
void set_address(void);
void get_descriptor(void);
void get_configuration(void);
void set_configuration(void);
void get_interface(void);
void set_interface(void);

void reserved(void);


#line 11 "E:\avr资料\例程\m16\USB\固件\Chap_9.c"




#line 17 "E:\avr资料\例程\m16\USB\固件\Chap_9.c"

extern CONTROL_XFER ControlData;
extern IO_REQUEST idata ioRequest;
extern EPPFLAGS bEPPflags;


code USB_DEVICE_DESCRIPTOR DeviceDescr =
{
	sizeof(USB_DEVICE_DESCRIPTOR),
 0x01,
((((0x0110) & 0xFF) << 8) | (((0x0110) >> 8) & 0xFF)),
 0xdc,
    0, 0,
 16,
((((0x0471) & 0xFF) << 8) | (((0x0471) >> 8) & 0xFF)),
((((0x0677) & 0xFF) << 8) | (((0x0677) >> 8) & 0xFF)),
((((0x0100) & 0xFF) << 8) | (((0x0100) >> 8) & 0xFF)),
    0, 0, 0,
	1
};


code USB_CONFIGURATION_DESCRIPTOR ConfigDescr =
{
    sizeof(USB_CONFIGURATION_DESCRIPTOR),
 0x02,
((((sizeof(USB_CONFIGURATION_DESCRIPTOR) + sizeof(USB_INTERFACE_DESCRIPTOR) + (4 * sizeof(USB_ENDPOINT_DESCRIPTOR))) & 0xFF) << 8) | (((sizeof(USB_CONFIGURATION_DESCRIPTOR) + sizeof(USB_INTERFACE_DESCRIPTOR) + (4 * sizeof(USB_ENDPOINT_DESCRIPTOR))) >> 8) & 0xFF)),
	1,
	1,
    0,
	0xa0,
	0x32
};


code USB_INTERFACE_DESCRIPTOR InterfaceDescr =
{
    sizeof(USB_INTERFACE_DESCRIPTOR),
 0x04,
    0,
    0,
 4,
 0xdc,
 0xA0,
 0xB0,
	0
};


code USB_ENDPOINT_DESCRIPTOR EP1_TXDescr =
{
	sizeof(USB_ENDPOINT_DESCRIPTOR),
 0x05,
	0x81,
 0x03,
((((16) & 0xFF) << 8) | (((16) >> 8) & 0xFF)),
	1
};

code USB_ENDPOINT_DESCRIPTOR EP1_RXDescr =
{
	sizeof(USB_ENDPOINT_DESCRIPTOR),
 0x05,
	0x1,
 0x03,
((((16) & 0xFF) << 8) | (((16) >> 8) & 0xFF)),
	1
};

code USB_ENDPOINT_DESCRIPTOR EP2_TXDescr =
{
	sizeof(USB_ENDPOINT_DESCRIPTOR),
 0x05,
	0x82,
 0x02,
((((64) & 0xFF) << 8) | (((64) >> 8) & 0xFF)),
	10
};

code USB_ENDPOINT_DESCRIPTOR EP2_RXDescr =
{
	sizeof(USB_ENDPOINT_DESCRIPTOR),
 0x05,
	0x2,
 0x02,
((((64) & 0xFF) << 8) | (((64) >> 8) & 0xFF)),
	10
};


#line 111 "E:\avr资料\例程\m16\USB\固件\Chap_9.c"

void reserved(void)
{
	stall_ep0();
}


#line 122 "E:\avr资料\例程\m16\USB\固件\Chap_9.c"


void get_status(void)
{
	unsigned char endp, txdat[2];
	unsigned char bRecipient = ControlData.DeviceRequest.bmRequestType &(unsigned char)0x1F;
	unsigned char c;

	if (bRecipient ==(unsigned char)0x00) {
		if(bEPPflags.bits.remote_wakeup == 1)
			txdat[0] = 3;
		else
			txdat[0] = 1;
		txdat[1]=0;
		single_transmit(txdat, 2);
	} else if (bRecipient ==(unsigned char)0x01) {
		txdat[0]=0;
		txdat[1]=0;
		single_transmit(txdat, 2);
	} else if (bRecipient ==(unsigned char)0x02) {
		endp = (unsigned char)(ControlData.DeviceRequest.wIndex &(unsigned char)0x3);
		if (ControlData.DeviceRequest.wIndex & (unsigned char)0x80)
			c = D12_SelectEndpoint(endp*2 + 1);
		else
			c = D12_SelectEndpoint(endp*2);
		if(c & 0x02)
			txdat[0] = 1;
		else
			txdat[0] = 0;
		txdat[1] = 0;
		single_transmit(txdat, 2);
	} else
		stall_ep0();
}


void clear_feature(void)
{
	unsigned char endp;
	unsigned char bRecipient = ControlData.DeviceRequest.bmRequestType &(unsigned char)0x1F;

	if (bRecipient ==(unsigned char)0x00
		&& ControlData.DeviceRequest.wValue == 0x0001) {
 EA=0;
		bEPPflags.bits.remote_wakeup = 0;
 EA=1;
		single_transmit(0, 0);
	}
	else if (bRecipient ==(unsigned char)0x02
		&& ControlData.DeviceRequest.wValue == 0x0000) {
		endp = (unsigned char)(ControlData.DeviceRequest.wIndex &(unsigned char)0x3);
		if (ControlData.DeviceRequest.wIndex & (unsigned char)0x80)

			D12_SetEndpointStatus(endp*2 + 1, 0);
		else

			D12_SetEndpointStatus(endp*2, 0);
		single_transmit(0, 0);
	} else
		stall_ep0();
}


void set_feature(void)
{
	unsigned char endp;
	unsigned char bRecipient = ControlData.DeviceRequest.bmRequestType &(unsigned char)0x1F;

	if (bRecipient ==(unsigned char)0x00
		&& ControlData.DeviceRequest.wValue == 0x0001) {
 EA=0;
		bEPPflags.bits.remote_wakeup = 1;
 EA=1;
		single_transmit(0, 0);
	}
	else if (bRecipient ==(unsigned char)0x02
		&& ControlData.DeviceRequest.wValue == 0x0000) {
		endp = (unsigned char)(ControlData.DeviceRequest.wIndex &(unsigned char)0x3);
		if (ControlData.DeviceRequest.wIndex & (unsigned char)0x80)

			D12_SetEndpointStatus(endp*2 + 1, 1);
		else

			D12_SetEndpointStatus(endp*2, 1);
		single_transmit(0, 0);
	} else
		stall_ep0();
}


void set_address(void)
{
	D12_SetAddressEnable((unsigned char)(ControlData.DeviceRequest.wValue &
 0x7F), 1);
	single_transmit(0, 0);
}


void get_descriptor(void)
{
	unsigned char bDescriptor =(((ControlData.DeviceRequest.wValue) >> 8) & 0xFF);

	if (bDescriptor == 0x01) {
		code_transmit((unsigned char code *)&DeviceDescr, sizeof(USB_DEVICE_DESCRIPTOR));
	} else if (bDescriptor == 0x02) {
		code_transmit((unsigned char code *)&ConfigDescr,sizeof(USB_CONFIGURATION_DESCRIPTOR) + sizeof(USB_INTERFACE_DESCRIPTOR) + (4 * sizeof(USB_ENDPOINT_DESCRIPTOR)));
	} else
		stall_ep0();
}


void get_configuration(void)
{
	unsigned char c = bEPPflags.bits.configuration;
	single_transmit(&c, 1);
}


void set_configuration(void)
{
	if (ControlData.DeviceRequest.wValue == 0) {

		single_transmit(0, 0);
 EA=0;
		bEPPflags.bits.configuration = 0;
 EA=1;
		init_unconfig();
	} else if (ControlData.DeviceRequest.wValue == 1) {

		single_transmit(0, 0);

		init_unconfig();
		init_config();
 EA=0;
		bEPPflags.bits.configuration = 1;
 EA=1;
	} else
		stall_ep0();
}


void get_interface(void)
{
	unsigned char txdat = 0;
	single_transmit(&txdat, 1);
}


void set_interface(void)
{
	if (ControlData.DeviceRequest.wValue == 0 && ControlData.DeviceRequest.wIndex == 0)
		single_transmit(0, 0);
	else
		stall_ep0();
}

