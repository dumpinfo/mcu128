NOTE: AVR Code addresses are word addresses
All other addresses (including ones in FLASH) are byte addresses

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                           idata   008C   0009 =      9. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       008C  __idata_start
       0095  __idata_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            text   0096   01F0 =    496. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       004B  __text_start
       004B  __start
       006B  _exit
       006C  _port_init
       0082  _init_devices
       0093  _main
       009F  _delay
       00B4  _key
       00FF  empy16s
       010F  pop_gset2
       0112  pop_gset5
       0115  push_gset1
       0118  pop_gset1
       0119  pop
       012C  push_gset2
       0130  push_gset3
       0134  push_gset4
       0138  push_gset5
       013C  lsl16
       0143  __text_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            data   0100   0009 =      9. bytes (rel,con,ram)

       Addr  Global Symbol
      -----  --------------------------------
       0100  __data_start
       0100  _chabiao
       0109  __data_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                          vector   0000   0004 =      4. bytes (abs,ovr,rom)

Files Linked      [ module(s) ]

c:\icc\lib\crtatmega.o	[ crtatmega.s ]
key_bee.o	[ key_bee.c ]
<library>	[ emul16s.s, gpop2.s, gpop5.s, gpush.s, gpush2.s, gpush3.s, gpush4.s, gpush5.s, lsl16.s ]

User Global Definitions

ram_end = 0x10ff
hwstk_size = 0x10

User Base Address Definitions

func_lit = 0x8c
data = 0x100
eeprom:1.4096

