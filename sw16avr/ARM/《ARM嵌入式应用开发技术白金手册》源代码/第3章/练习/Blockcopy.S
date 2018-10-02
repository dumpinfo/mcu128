                                          ; r12指向源数据的开始
                                          ; r14指向源数据的结束
                                          ; r13指向目标数据的开始
loop    LDMIA r12!, {r0-r11}              ; 装载48 bytes
        STMIA r13!, {r0-r11}              ; 存储
        CMP r12, r14                      ; 检查是否结束
        BNE loop                          ; 循环直到结束
                                          ;在31个周期内循环48bytes
