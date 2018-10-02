// interface.h - device interface classes for Usb_Wdm

// This GUID identifies the device interface class used by the Usb_WdmDevice device

// TODO:	If your driver supports a standard interface, use the GUID that identifies
//			the interface class, rather than using the one defined below

#define Usb_WdmDevice_CLASS_GUID \
 { 0xed92d57a, 0x7f44, 0x4df3, { 0xa1, 0x82, 0x8, 0xff, 0x28, 0x1, 0xc0, 0x79 } }
