NOTE: AVR Code addresses are word addresses
All other addresses (including ones in FLASH) are byte addresses

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                             lit   0054   0130 =    304. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       0054  _font
       0054  __lit_start
       0184  __lit_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            text   0184   0254 =    596. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       00C2  __start
       00C2  __text_start
       00E2  _exit
       00E3  _delay
       00F9  _write_com
       0109  _write_data
       0119  _read_data
       012C  _init_lcd
       014D  _ClearDisplay
       0163  _Test
       0178  _Testlcd2
       0186  _port_init
       0190  _init_devices
       0198  _main
       01CE  pop_gset2
       01D1  push_gset1
       01D4  pop_gset1
       01D5  pop
       01E8  push_gset2
       01EC  __text_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                          vector   0000   0004 =      4. bytes (abs,ovr,rom)

Files Linked      [ module(s) ]

D:\PROGRA~1\icc\lib\crtatmega.o	[ crtatmega.s ]
main.o	[ main.c ]
<library>	[ gpop2.s, gpush.s, gpush2.s ]

User Global Definitions

ram_end = 0x45f
hwstk_size = 0x10

User Base Address Definitions

func_lit = 0x54
data = 0x60
eeprom:1.512

