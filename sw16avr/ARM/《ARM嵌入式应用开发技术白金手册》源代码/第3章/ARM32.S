     ADD r0, r0, r1, LSL#2                    ; 设置r0为元素x的地址
     ADD r2, r0, r2, LSL#2                    ; 设置r2为元素n+1
     MOV r1, #0                               ; 初始化计数counter
loop
     LDR r3, [r0], #4                         ; 存储，移向下一个
     ADD r1, r1, r3
     CMP r0, r2                               ; 到达元素x+n?
     BLT loop                                 ; 如果没有，重复下一个元素
                                              ; 退出，累加和于r1