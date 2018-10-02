     AREA    globats，CODE，READONLY
     EXPORT  asmsubroutime
     IMPORt   glovbvar                          ;声明外部变量glovbvar
asmsubroutime
     LDR  R1，=glovbvar                         ;装载变量地址
     LDR  R0，[R1]                              ;读出数据
     ADD  R0，R0，#1                            ;加1 操作
     STR  R0，[R1]                              ;保存变量值
     MOV  PC LR
     END
