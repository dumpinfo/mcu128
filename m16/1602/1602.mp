NOTE: AVR Code addresses are word addresses
All other addresses (including ones in FLASH) are byte addresses

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                             lit   0054   000A =     10. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       0054  _seg_table
       0054  __lit_start
       005E  __lit_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                           idata   005E   0018 =     24. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       005E  __idata_start
       0076  __idata_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            text   0076   0260 =    608. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       003B  __text_start
       003B  __start
       005B  _exit
       005C  _lcd_init
       0081  _delay_1ms
       008B  _delay_nms
       009A  _lcd_write_command
       00AB  _display_a_char
       00BF  _display_a_string
       00D8  _lcd_write_data
       00E6  _wait_enable
       00F0  _port_init
       00FA  _timer1_init
       010F  _timer1_ovf_isr
       011A  _init_devices
       0125  _main
       0130  _delay_ms
       0146  pop_gset2
       0149  pop_gset3
       014C  push_gset5
       014E  push_gset4
       0150  push_gset3
       0152  push_gset2
       0154  push_gset1
       0157  pop_gset1
       0158  pop
       016B  __text_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            data   0060   0018 =     24. bytes (rel,con,ram)

       Addr  Global Symbol
      -----  --------------------------------
       0060  __data_start
       0060  _led_buff
       0069  _str1
       006E  _hour
       0070  _minute
       0072  _second
       0074  _ms
       0076  _c_next
       0077  _choose
       0078  __data_end

Area                               Start  End    Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                          vector   0000   0024 =     36. bytes (abs,ovr,rom)

Files Linked      [ module(s) ]

D:\PROGRA~1\icc\lib\crtatmega.o	[ crtatmega.s ]
second.o	[ second.c ]
<library>	[ gpop2.s, gpop3.s, gpush.s ]

User Global Definitions

ram_end = 0x45f
hwstk_size = 0x10

User Base Address Definitions

func_lit = 0x54
data = 0x60
eeprom:1.512

