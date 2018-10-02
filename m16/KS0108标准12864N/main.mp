NOTE: AVR Code addresses are word addresses
All other addresses (including ones in FLASH) are byte addresses

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                             lit   0054   0180 =    384. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       0054  _font
       0054  __lit_start
       01D4  __lit_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            text   01D4   038A =    906. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       00EA  __start
       00EA  __text_start
       010A  _exit
       010B  _OutI
       013A  _OutD
       016B  _LCD_NOP
       0175  _ClearDisplay
       018E  _DisplayWord
       01CE  _DisplayLine
       0204  _port_init
       020E  _init_devices
       0216  _main
       026A  push_arg4
       026C  push_arg2
       026F  mod8u
       0271  div8u
       0272  xdiv8u
       0287  pop_gset2
       028A  pop_gset3
       028D  pop_gset5
       0290  push_gset5
       0292  push_gset4
       0294  push_gset3
       0296  push_gset2
       0298  push_gset1
       029B  pop_gset1
       029C  pop
       02AF  __text_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                             bss   0060   0004 =      4. bytes (rel,con,ram)

       Addr  Global Symbol
      -----  --------------------------------
       0060  __bss_start
       0060  _j
       0062  _i
       0064  __bss_end

Area                               Start  End    Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                          vector   0000   0004 =      4. bytes (abs,ovr,rom)

Files Linked      [ module(s) ]

D:\PROGRA~1\icc\lib\crtatmega.o	[ crtatmega.s ]
huomen.o	[ huomen.c ]
<library>	[ asave.s, div8u.s, gpop2.s, gpop3.s, gpop5.s, gpush.s ]

User Global Definitions

ram_end = 0x45f
hwstk_size = 0x10

User Base Address Definitions

func_lit = 0x54
data = 0x60
eeprom:1.512

