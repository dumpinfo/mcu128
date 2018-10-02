NOTE: AVR Code addresses are word addresses
All other addresses (including ones in FLASH) are byte addresses

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                             lit   0026   000A =     10. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       0026  _seg_table
       0026  __lit_start
       0030  __lit_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                           idata   0030   003D =     61. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       0030  __idata_start
       006D  __idata_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            text   006E   0240 =    576. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       0037  __text_start
       0037  __start
       0056  _exit
       0057  _lcd_init
       007C  _delay_1ms
       0086  _delay_nms
       0093  _lcd_write_command
       00A2  _display_a_char
       00B4  _display_a_string
       00CA  _lcd_write_data
       00D6  _wait_enable
       00E0  _port_init
       00EA  _timer1_init
       00FF  _timer1_ovf_isr
       010A  _init_devices
       0115  _main
       0120  _delay_ms
       0134  pop_gset2
       0136  pop_gset3
       0138  push_gset5
       013A  push_gset4
       013C  push_gset3
       013E  push_gset2
       0140  push_gset1
       0143  pop_gset1
       0144  pop
       0157  __text_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            data   0060   003D =     61. bytes (rel,con,ram)

       Addr  Global Symbol
      -----  --------------------------------
       0060  __data_start
       0060  _led_buff
       0079  _str1
       0093  _hour
       0095  _minute
       0097  _second
       0099  _ms
       009B  _c_next
       009C  _choose
       009D  __data_end

Area                               Start  End    Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                          vector   0000   0012 =     18. bytes (abs,ovr,rom)

Files Linked      [ module(s) ]

D:\icc\lib\crtAVR.o	[ crtavr.s ]
second.o	[ second.c ]
<library>	[ gpop2.s, gpop3.s, gpush.s ]

User Global Definitions

ram_end = 0x45f
hwstk_size = 0x10

User Base Address Definitions

func_lit = 0x26
data = 0x60
eeprom:1.512

