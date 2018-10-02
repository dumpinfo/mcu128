// Cirrus Logic CS8900A Ethernet

//#define CS8900_BASE    0x20000000 // normal mode
#define CS8900_BASE    0x50000000 // bootstrap mode

/* although the registers are 16 bit, they are 32-bit aligned on the
   EDB7111. so we have to read them as 32-bit registers and ignore the
   upper 16-bits. i'm not sure if this holds for the EDB7211. */

#define CS8900_(offset)	(*(volatile unsigned int*)(CS8900_BASE + (offset)))

#define CS8900_RTDATA *(volatile unsigned int *)(CS8900_BASE+0x00)
#define CS8900_TxCMD  *(volatile unsigned int *)(CS8900_BASE+0x04)
#define CS8900_TxLEN  *(volatile unsigned int *)(CS8900_BASE+0x06)
#define CS8900_ISQ    *(volatile unsigned int *)(CS8900_BASE+0x08)
#define CS8900_PPTR   *(volatile unsigned int *)(CS8900_BASE+0x0A)
#define CS8900_PDATA  *(volatile unsigned int *)(CS8900_BASE+0x0C)

#define ISQ_RxEvent     0x04
#define ISQ_TxEvent     0x08
#define ISQ_BufEvent    0x0C
#define ISQ_RxMissEvent 0x10
#define ISQ_TxColEvent  0x12
#define ISQ_EventMask   0x3F

/* packet page register offsets */

/* bus interface registers */
#define PP_ChipID    0x0000  // Chip identifier - must be 0x630E
#define PP_ChipRev   0x0002  // Chip revision, model codes

#define CS8900_PP_ChipID	CS8900_(PP_ChipID)


#define PP_IntReg    0x0022  // Interrupt configuration
#define PP_IntReg_IRQ0         0x0000  // Use INTR0 pin
#define PP_IntReg_IRQ1         0x0001  // Use INTR1 pin
#define PP_IntReg_IRQ2         0x0002  // Use INTR2 pin
#define PP_IntReg_IRQ3         0x0003  // Use INTR3 pin

/* status and control registers */

#define PP_RxCFG     0x0102  // Receiver configuration
#define PP_RxCFG_Skip1         0x0040  // Skip (i.e. discard) current frame
#define PP_RxCFG_Stream        0x0080  // Enable streaming mode
#define PP_RxCFG_RxOK          0x0100  // RxOK interrupt enable
#define PP_RxCFG_RxDMAonly     0x0200  // Use RxDMA for all frames
#define PP_RxCFG_AutoRxDMA     0x0400  // Select RxDMA automatically
#define PP_RxCFG_BufferCRC     0x0800  // Include CRC characters in frame
#define PP_RxCFG_CRC           0x1000  // Enable interrupt on CRC error
#define PP_RxCFG_RUNT          0x2000  // Enable interrupt on RUNT frames
#define PP_RxCFG_EXTRA         0x4000  // Enable interrupt on frames with extra data

#define CS8900_PP_RxCFG	CS8900_(PP_RxCFG)

#define PP_RxCTL     0x0104  // Receiver control
#define PP_RxCTL_IAHash        0x0040  // Accept frames that match hash
#define PP_RxCTL_Promiscuous   0x0080  // Accept any frame
#define PP_RxCTL_RxOK          0x0100  // Accept well formed frames
#define PP_RxCTL_Multicast     0x0200  // Accept multicast frames
#define PP_RxCTL_IA            0x0400  // Accept frame that matches IA
#define PP_RxCTL_Broadcast     0x0800  // Accept broadcast frames
#define PP_RxCTL_CRC           0x1000  // Accept frames with bad CRC
#define PP_RxCTL_RUNT          0x2000  // Accept runt frames
#define PP_RxCTL_EXTRA         0x4000  // Accept frames that are too long

#define CS8900_PP_RxCTL	CS8900_(PP_RxCTL)

#define PP_TxCFG     0x0106  // Transmit configuration
#define PP_TxCFG_CRS           0x0040  // Enable interrupt on loss of carrier
#define PP_TxCFG_SQE           0x0080  // Enable interrupt on Signal Quality Error
#define PP_TxCFG_TxOK          0x0100  // Enable interrupt on successful xmits
#define PP_TxCFG_Late          0x0200  // Enable interrupt on "out of window" 
#define PP_TxCFG_Jabber        0x0400  // Enable interrupt on jabber detect
#define PP_TxCFG_Collision     0x0800  // Enable interrupt if collision
#define PP_TxCFG_16Collisions  0x8000  // Enable interrupt if > 16 collisions

#define CS8900_PP_TxCFG	CS8900_(PP_TxCFG)

#define PP_TxCmd     0x0108  // Transmit command status
#define PP_TxCmd_TxStart_5     0x0000  // Start after 5 bytes in buffer
#define PP_TxCmd_TxStart_381   0x0040  // Start after 381 bytes in buffer
#define PP_TxCmd_TxStart_1021  0x0080  // Start after 1021 bytes in buffer
#define PP_TxCmd_TxStart_Full  0x00C0  // Start after all bytes loaded
#define PP_TxCmd_Force         0x0100  // Discard any pending packets
#define PP_TxCmd_OneCollision  0x0200  // Abort after a single collision
#define PP_TxCmd_NoCRC         0x1000  // Do not add CRC
#define PP_TxCmd_NoPad         0x2000  // Do not pad short packets

#define CS8900_PP_TxCmd	CS8900_(PP_TxCmd)

#define PP_BufCFG    0x010A  // Buffer configuration
#define PP_BufCFG_SWI          0x0040  // Force interrupt via software
#define PP_BufCFG_RxDMA        0x0080  // Enable interrupt on Rx DMA
#define PP_BufCFG_TxRDY        0x0100  // Enable interrupt when ready for Tx
#define PP_BufCFG_TxUE         0x0200  // Enable interrupt in Tx underrun
#define PP_BufCFG_RxMiss       0x0400  // Enable interrupt on missed Rx packets
#define PP_BufCFG_Rx128        0x0800  // Enable Rx interrupt after 128 bytes
#define PP_BufCFG_TxCol        0x1000  // Enable int on Tx collision ctr overflow
#define PP_BufCFG_Miss         0x2000  // Enable int on Rx miss ctr overflow
#define PP_BufCFG_RxDest       0x8000  // Enable int on Rx dest addr match

#define CS8900_PP_BusCFG	CS8900_(PP_BusCFG)

#define PP_LineCTL   0x0112  // Line control
#define PP_LineCTL_Rx          0x0040  // Enable receiver
#define PP_LineCTL_Tx          0x0080  // Enable transmitter
#define PP_LineCTL_AUIonly     0x0100  // AUI interface only
#define PP_LineCTL_AutoAUI10BT 0x0200  // Autodetect AUI or 10BaseT interface
#define PP_LineCTL_ModBackoffE 0x0800  // Enable modified backoff algorithm
#define PP_LineCTL_PolarityDis 0x1000  // Disable Rx polarity autodetect
#define PP_LineCTL_2partDefDis 0x2000  // Disable two-part defferal
#define PP_LineCTL_LoRxSquelch 0x4000  // Reduce receiver squelch threshold

#define CS8900_PP_LineCTL	CS8900_(PP_LineCTL)

#define PP_SelfCTL   0x0114  // Chip self control
#define PP_SelfCTL_Reset       0x0040  // Self-clearing reset
#define PP_SelfCTL_SWSuspend   0x0100  // Initiate suspend mode
#define PP_SelfCTL_HWSleepE    0x0200  // Enable SLEEP input
#define PP_SelfCTL_HWStandbyE  0x0400  // Enable standby mode
#define PP_SelfCTL_HC0E        0x1000  // use HCB0 for LINK LED
#define PP_SelfCTL_HC1E        0x2000  // use HCB1 for BSTATUS LED
#define PP_SelfCTL_HCB0        0x4000  // control LINK LED if HC0E set
#define PP_SelfCTL_HCB1        0x8000  // control BSTATUS LED if HC1E set

#define CS8900_PP_SelfCTL	CS8900_(PP_SelfCTL)

#define PP_BusCTL    0x0116  // Bus control
#define PP_BusCTL_ResetRxDMA   0x0040  // Reset RxDMA pointer
#define PP_BusCTL_DMAextend    0x0100  // Extend DMA cycle
#define PP_BusCTL_UseSA        0x0200  // Assert MEMCS16 on address decode
#define PP_BusCTL_MemoryE      0x0400  // Enable memory mode
#define PP_BusCTL_DMAburst     0x0800  // Limit DMA access burst
#define PP_BusCTL_IOCHRDYE     0x1000  // Set IOCHRDY high impedence
#define PP_BusCTL_RxDMAsize    0x2000  // Set DMA buffer size 64KB
#define PP_BusCTL_EnableIRQ    0x8000  // Generate interrupt on interrupt event 

#define CS8900_PP_BusCTL	CS8900_(PP_BusCTL)

#define PP_TestCTL   0x0118  // Test control
#define PP_TestCTL_DisableLT   0x0080  // Disable link status 
#define PP_TestCTL_ENDECloop   0x0200  // Internal loopback
#define PP_TestCTL_AUIloop     0x0400  // AUI loopback
#define PP_TestCTL_DisBackoff  0x0800  // Disable backoff algorithm
#define PP_TestCTL_FDX         0x4000  // Enable full duplex mode

#define PP_ISQ       0x0120  // Interrupt Status Queue

#define PP_RER       0x0124  // Receive event
#define PP_RER_IAHash          0x0040  // Frame hash match
#define PP_RER_Dribble         0x0080  // Frame had 1-7 extra bits after last byte
#define PP_RER_RxOK            0x0100  // Frame received with no errors
#define PP_RER_Hashed          0x0200  // Frame address hashed OK
#define PP_RER_IA              0x0400  // Frame address matched IA
#define PP_RER_Broadcast       0x0800  // Broadcast frame
#define PP_RER_CRC             0x1000  // Frame had CRC error
#define PP_RER_RUNT            0x2000  // Runt frame
#define PP_RER_EXTRA           0x4000  // Frame was too long

#define CS8900_PP_RER	CS8900_(PP_RER)

#define PP_TER       0x0128 // Transmit event
#define PP_TER_CRS             0x0040  // Carrier lost
#define PP_TER_SQE             0x0080  // Signal Quality Error
#define PP_TER_TxOK            0x0100  // Packet sent without error
#define PP_TER_Late            0x0200  // Out of window
#define PP_TER_Jabber          0x0400  // Stuck transmit?
#define PP_TER_NumCollisions   0x7800  // Number of collisions
#define PP_TER_16Collisions    0x8000  // > 16 collisions

#define PP_BER       0x012C // Buffer event
#define PP_BER_SWint           0x0040 // Software interrupt
#define PP_BER_RxDMAFrame      0x0080 // Received framed DMAed
#define PP_BER_Rdy4Tx          0x0100 // Ready for transmission
#define PP_BER_TxUnderrun      0x0200 // Transmit underrun
#define PP_BER_RxMiss          0x0400 // Received frame missed
#define PP_BER_Rx128           0x0800 // 128 bytes received
#define PP_BER_RxDest          0x8000 // Received framed passed address filter

#define PP_RxMiss    0x0130  //  Receiver miss counter 

#define PP_TxCol     0x0132  //  Transmit collision counter

#define PP_LineSTAT  0x0134  // Line status
#define PP_LineSTAT_LinkOK     0x0080  // Line is connected and working
#define PP_LineSTAT_AUI        0x0100  // Connected via AUI
#define PP_LineSTAT_10BT       0x0200  // Connected via twisted pair
#define PP_LineSTAT_Polarity   0x1000  // Line polarity OK (10BT only)
#define PP_LineSTAT_CRS        0x4000  // Frame being received

#define CS8900_PP_LineSTAT	CS8900_(PP_LineSTAT)

#define PP_SelfSTAT  0x0136  // Chip self status
#define PP_SelfSTAT_33VActive  0x0040  // supply voltage is 3.3V
#define PP_SelfSTAT_InitD      0x0080  // Chip initialization complete
#define PP_SelfSTAT_SIBSY      0x0100  // EEPROM is busy
#define PP_SelfSTAT_EEPROM     0x0200  // EEPROM present
#define PP_SelfSTAT_EEPROM_OK  0x0400  // EEPROM checks out
#define PP_SelfSTAT_ELPresent  0x0800  // External address latch logic available
#define PP_SelfSTAT_EEsize     0x1000  // Size of EEPROM

#define CS8900_PP_SelfSTAT	CS8900_(PP_SelfSTAT)

#define PP_BusSTAT   0x0138  // Bus status
#define PP_BusSTAT_TxBid       0x0080  // Tx error
#define PP_BusSTAT_TxRDY       0x0100  // Ready for Tx data

#define CS8900_PP_BusSTAT	CS8900_(PP_BusSTAT)


#define PP_TDR       0x013C  // AUI Time Domain Reflectometer

/* initiate transmit registers */

#define PP_TxCommand 0x0144  // Tx Command 
#define PP_TxLength  0x0146  // Tx Length 


/* address filter registers */

#define PP_LAF       0x0150  // Logical address filter (6 bytes)
#define PP_IA        0x0158  // Individual address (MAC)
#define PP_IA_21     0x0158  // Individual address (MAC)
#define PP_IA_43     0x015A  // Individual address (MAC)
#define PP_IA_65     0x015C  // Individual address (MAC)
#define PP_IA_TT     0x015E  // Individual address (MAC)

#define CS8900_PP_IA	CS8900_(PP_IA)
#define CS8900_PP_IA_21	CS8900_(PP_IA_21)
#define CS8900_PP_IA_43	CS8900_(PP_IA_43)
#define CS8900_PP_IA_65	CS8900_(PP_IA_65)
#define CS8900_PP_IA_TT	CS8900_(PP_IA_TT)


#define PP_RxSTAT	0x0400	//receive status
#define PP_RxLENGTH	0x0402	//receive length
#define	PP_RxBASE	0x0404	//receive Frame base address
#define	PP_TxBASE	0x0A00	//transmit Frame base address

#define CS8900_PP_RxSTAT	CS8900_(PP_RxSTAT)
#define CS8900_PP_RxLENGTH	CS8900_(PP_RxLENGTH)
#define CS8900_PP_RxBASE	CS8900_(PP_RxBASE)
#define CS8900_PP_TxBASE	CS8900_(PP_TxBASE)

#define CS8900_PP_TxCommand	CS8900_(PP_TxCommand)
#define CS8900_PP_TxLength	CS8900_(PP_TxLength)


/* packet page register access functions */

/*
static __inline__ unsigned short
get_reg(int regno)
{
    CS8900_PPTR = regno;
    return (unsigned short) CS8900_PDATA;
}

static __inline__ void
put_reg(int regno, unsigned short val)
{
    CS8900_PPTR = regno;
    CS8900_PDATA = val;
}
*/
static  unsigned short get_reg(int regno)
{
    CS8900_PPTR = regno;
    return (unsigned short) CS8900_PDATA;
}

static  void put_reg(int regno, unsigned short val)
{
    CS8900_PPTR = regno;
    CS8900_PDATA = val;
}