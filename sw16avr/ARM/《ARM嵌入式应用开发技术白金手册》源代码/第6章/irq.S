IRQHandler
    	stmfd sp!,{r0-r12,lr}		              ;断点保护，保存寄存器
	bl t1_irq_asm			              ;跳转到T1中断处理
	ldr r12,=0x80000000
	mov r2,#0xffffffff
	str r2,[r12,#0x06c0]		              ;清除T1中断标志
	ldmfd sp!,{r0-r12,lr}		              ;恢复寄存器
	subs pc,lr,#4			              ;IRQ中断返回

t1_irq_asm				              ;T1中断处理，交替改变PD0状态
	ldr r12,=0x80000000
	     ldrb r2,[r12,#0x3]
	eor r2,r2,#0x01			              ;改变PD0状态
	strb r2,[r12,#0x3]
	     mov pc,lr			              ;T1中断处理返回

;-----------------------------------------------------------------------
						      ;Pre-defined constants
USERMODE      	EQU 0x10
IRQMODE       	EQU 0x12
SVCMODE       	EQU 0x13
MODEMASK      	EQU 0x1f
NOINT         	EQU 0xc0

        mrs r0,cpsr
        bic r0,r0,#MODEMASK
        orr r1,r0,#IRQMODE|NOINT
        msr cpsr,r1			               ;IRQ模式
        ldr sp,=IRQStack

        bic r0,r0,#MODEMASK|NOINT
        orr r1,r0,#SVCMODE
        msr cpsr,r1			               ;SVC模式
        ldr sp,=SVCStack

;-----------------------------------------------------------------------
	ldr r12,=0x80000000
	ldr r1,=0x10
	str r1,[r12,#0x100]		                ;设置T1定时器运行模式
	ldr r1,=0xd0
	str r1,[r12,#0x300]		                ;设置T1定时器定时常数
	ldr r0,=0x100
	str r0,[r12,#0x280]		                ;使能T1定时器中断

;-----------------------------------------------------------------------

        mrs r0,cpsr
        bic r0,r0,#MODEMASK
        orr r1,r0,#USERMODE
        msr cpsr,r1			                ;User模式
        ldr sp,=UserStack

        IMPORT C_vMain
        bl C_vMain                  		        ;调用C程序
