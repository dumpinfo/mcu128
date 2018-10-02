        AREA ThumbSub, CODE, READONLY        ; 命名
        ENTRY                                ; 入口
        CODE32                               ; 声明32位ARM代码 
header
        ADR     r0, start + 1                ; 处理器以ARM状态开始 
        BX      r0                           ; 切换到Thumb状态，调用Thumb主程序

        CODE16                               ; 以下是Thumb指令
start
        MOV     r0, #10                      ; 设定参数
        MOV     r1, #3
        BL      doadd                        ; 调用子程序

stop
        MOV     r0, #0x18                    ; 报告异常
        LDR     r1, =0x20026                 ;停止，退出
        SWI     0xAB                         ; Thumb中断

doadd
        ADD     r0, r0, r1                  
        MOV     pc, lr                       ; 返回
        END                                  ; 文件结束