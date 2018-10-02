            AREA   HelloW, CODE, READONLY           
SWI-WriteC  EQU    &0                                 ; 输出r0的字符
SWI-Exit    EQU    &11                                ; 程序结束
            ENTRY                                     ; 程序入口
START       ADR    r1, TEXT                           ; r1-> "Hello World"
LOOP       
            LDRB   r0, [r1], #1                       ; 获得下一个bytes
            CMP    r0, #0                             
            SWINE SWI_WriteC                        
            BNE LOOP                                  ; 重复循环
            SWI SWI_Exit                              ; 运行完
TEXT        = "Hello World"                           ；&0a, &0d, 0
            END                                     