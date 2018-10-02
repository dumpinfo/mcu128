//#include <stdio.h>
#include <string.h>

#include <reg51.h>                /* special function register declarations   */
#include "epphal.h"

#include "d12ci.h"
#include "mainloop.h"
#include "usb100.h"
#include "chap_9.h"

extern CONTROL_XFER ControlData;
extern IO_REQUEST idata ioRequest;
extern EPPFLAGS bEPPflags;
extern BOOL bNoRAM;
extern unsigned char idata EpBuf[EP2_PACKET_SIZE];
















