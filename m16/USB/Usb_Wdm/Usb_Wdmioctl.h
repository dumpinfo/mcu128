// Usb_Wdmioctl.h
//
// Define control codes for Usb_Wdm driver
//

#ifndef __Usb_Wdmioctl__h_
#define __Usb_Wdmioctl__h_

#define USB_WDM_IOCTL_Test CTL_CODE(FILE_DEVICE_UNKNOWN, 0x800, METHOD_BUFFERED, FILE_ANY_ACCESS)
#endif
