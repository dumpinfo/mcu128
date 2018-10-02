NOTE: AVR Code addresses are word addresses
All other addresses (including ones in FLASH) are byte addresses

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                             lit   008C   0015 =     21. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       008C  __lit_start
       008C  _buffer
       00A1  __lit_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            text   00A2   01F8 =    504. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       0051  __text_start
       0051  __start
       0071  _exit
       0072  _USART0_Init
       00A6  _USART0_Transmit
       00AA  _USART0_Receive
       00AE  _main
       00BA  div32u
       00BC  mod32u
       00C0  div32s
       00C2  mod32s
       00ED  long_div_prolog
       0100  long_div_epilog
       010F  tst_R16_R19
       0114  tst_R24_R27
       0119  neg_R16_R19
       0122  neg_R24_R27
       012B  pop_gset3
       012E  push_gset1
       0131  pop_gset1
       0132  pop
       0145  push_gset2
       0149  push_gset3
       014D  __text_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                          vector   0000   0004 =      4. bytes (abs,ovr,rom)

Files Linked      [ module(s) ]

D:\PROGRA~1\icc\lib\crtatmega.o	[ crtatmega.s ]
test.o	[ test.c ]
<library>	[ div32.s, gpop3.s, gpush.s, gpush2.s, gpush3.s ]

User Global Definitions

ram_end = 0x10ff
hwstk_size = 0x10

User Base Address Definitions

func_lit = 0x8c
data = 0x100
eeprom:1.4096

