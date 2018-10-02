NOTE: AVR Code addresses are word addresses
All other addresses (including ones in FLASH) are byte addresses

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                             lit   008C   000A =     10. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       008C  _seg_table
       008C  __lit_start
       0096  __lit_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                           idata   0096   002C =     44. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       0096  __idata_start
       00C2  __idata_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            text   00C2   0244 =    580. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       0061  __text_start
       0061  __start
       0081  _exit
       0082  _lcd_init
       00A7  _delay_1ms
       00B1  _delay_nms
       00C0  _lcd_write_command
       00D1  _display_a_char
       00E5  _display_a_string
       00FE  _lcd_write_data
       010C  _wait_enable
       0116  _port_init
       012C  _init_devices
       013D  _main
       0148  _delay_ms
       015E  pop_gset2
       0161  pop_gset3
       0164  push_gset5
       0166  push_gset4
       0168  push_gset3
       016A  push_gset2
       016C  push_gset1
       016F  pop_gset1
       0170  pop
       0183  __text_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            data   0100   002C =     44. bytes (rel,con,ram)

       Addr  Global Symbol
      -----  --------------------------------
       0100  __data_start
       0100  _led_buff
       0111  _str1
       0122  _hour
       0124  _minute
       0126  _second
       0128  _ms
       012A  _c_next
       012B  _choose
       012C  __data_end

Area                               Start  End    Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                          vector   0000   0004 =      4. bytes (abs,ovr,rom)

Files Linked      [ module(s) ]

D:\icc\lib\crtatmega.o	[ crtatmega.s ]
second.o	[ second.c ]
<library>	[ gpop2.s, gpop3.s, gpush.s ]

User Global Definitions

ram_end = 0x10ff
hwstk_size = 0x10

User Base Address Definitions

func_lit = 0x8c
data = 0x100
eeprom:1.4096

