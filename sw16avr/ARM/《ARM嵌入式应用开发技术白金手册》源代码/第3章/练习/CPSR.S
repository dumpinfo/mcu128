                                                 ;设定有用的常量
mmask EQU 0x1f                                   ; mask清除模式位
userm EQU 0x10                                   ; 用户模式
                                                 ;管理模式开始
MRS r0, cpsr                                     ;复制CPSR内容
BIC r0,r0,#mmask                                 ;清除模式位
ORR r0,r0,#userm                                 ; 选择新模式
MSR cpsr, r0                                     ; 修改后写回CPSR
                                                 ;以用户模式结束
                                                 ; 退出，累加和于r1