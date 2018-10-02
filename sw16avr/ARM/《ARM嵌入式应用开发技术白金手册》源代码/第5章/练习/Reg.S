                                                ；16进制输出r1的子程序
HexOut  MOV r2, #8                              ; r2= 8

LOOP    MOV r0, r1, LSR #28                     ; 逻辑左移
        CMP r0, #9                              ; 比较，0-9 或者 A-F?
        ADDGT r0, r0, #"A"-10                   ; 按ASCII 字母顺序
        ADDLE r0, r0, #"0"                      ; ASCII数字顺序
        SWI SWI_WriteC                          ; 中断
        MOV r1, r1, LSL #4                      ; 左移半位
        SUBS r2, r2, #1                         ; 减1
        BNE LOOP                                ; 如果不等，循环

        MOV pc, r14                             ; 否则，返回