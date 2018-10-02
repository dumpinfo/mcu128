NOTE: AVR Code addresses are word addresses
All other addresses (including ones in FLASH) are byte addresses

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                           idata   0054   0016 =     22. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       0054  __idata_start
       006A  __idata_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            text   006A   01D8 =    472. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       0035  __text_start
       0035  __start
       0055  _exit
       0056  _port_init
       0061  _timer0_init
       006A  _timer0_ovf_isr
       00F3  _init_devices
       00FD  _main
       00FF  pop_gset2
       0102  push_gset5
       0104  push_gset4
       0106  push_gset3
       0108  push_gset2
       010A  push_gset1
       010D  pop_gset1
       010E  pop
       0121  __text_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            data   0060   0016 =     22. bytes (rel,con,ram)

       Addr  Global Symbol
      -----  --------------------------------
       0060  _data1
       0060  __data_start
       0068  _data2
       0070  _addr
       0071  _i
       0072  _j
       0076  __data_end

Area                               Start  End    Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                          vector   0000   0028 =     40. bytes (abs,ovr,rom)

Files Linked      [ module(s) ]

D:\PROGRA~1\icc\lib\crtatmega.o	[ crtatmega.s ]
dianzhen.o	[ dianzhen.c ]
<library>	[ gpop2.s, gpush.s ]

User Global Definitions

ram_end = 0x45f
hwstk_size = 0x10

User Base Address Definitions

func_lit = 0x54
data = 0x60
eeprom:1.512

