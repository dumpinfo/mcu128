NOTE: AVR Code addresses are word addresses
All other addresses (including ones in FLASH) are byte addresses

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                             lit   008C   0130 =    304. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       008C  _font
       008C  __lit_start
       01BC  __lit_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            text   01BC   0286 =    646. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       00DE  __text_start
       00DE  __start
       00FE  _exit
       00FF  _delay
       0115  _write_com
       0125  _write_data
       0135  _read_data
       0148  _init_lcd
       016A  _ClearDisplay
       0180  _Test
       0195  _Testlcd2
       01A3  _port_init
       01B7  _init_devices
       01C8  _main
       01FF  pop_gset2
       0202  push_gset5
       0204  push_gset4
       0206  push_gset3
       0208  push_gset2
       020A  push_gset1
       020D  pop_gset1
       020E  pop
       0221  __text_end

Area                               Start  End    Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                          vector   0000   0004 =      4. bytes (abs,ovr,rom)

Files Linked      [ module(s) ]

D:\PROGRA~1\icc\lib\crtatmega.o	[ crtatmega.s ]
main.o	[ main.c ]
<library>	[ gpop2.s, gpush.s ]

User Global Definitions

ram_end = 0x10ff
hwstk_size = 0x10

User Base Address Definitions

func_lit = 0x8c
data = 0x100
eeprom:1.4096

