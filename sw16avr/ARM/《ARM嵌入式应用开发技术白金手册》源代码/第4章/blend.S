ABC  EQU  0x12                                    ;声明一个代码段Example
     AREA  Example，CODE，READONLY
     ENTRY
     CODE32
     ADR  R0，Thumb_START+1                     ;装载地址，并设置d0 位为1
     BX   R0                                       ;切换到Thumb 状态
     CODE16                                        ;声明16 位代码(Thumb)
Thumb_START
     MOV  R1，#ABC
     ADD  R1，R1，#0x10
     B     Thumb_START
     END
