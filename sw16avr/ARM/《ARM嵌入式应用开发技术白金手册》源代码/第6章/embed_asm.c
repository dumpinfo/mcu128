__inline void enable_IRQ(void)
{
	int tmp
	_asm                                           //嵌入汇编代码
	{
		MRS tmp，CPSR                          //读取CPSR 的值
		BIC tmp，tmp，#0x80                     //将IRQ 中断禁止位I 清零，即允许IRQ 中断
		MSR
		CPSR_c，tmp                            //设置CPSR 的值
	}
}
__inline void disable_IRQ(void)
{
	int tmp;
	_asm
	{
		MRS tmp，CPSR
		ORR tmp，tmp，#0x80
		MSR CPSR_c，tmp
	}
}
