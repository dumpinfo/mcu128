__inline void enable_IRQ(void)
{
	int tmp
	_asm                                           //Ƕ�������
	{
		MRS tmp��CPSR                          //��ȡCPSR ��ֵ
		BIC tmp��tmp��#0x80                     //��IRQ �жϽ�ֹλI ���㣬������IRQ �ж�
		MSR
		CPSR_c��tmp                            //����CPSR ��ֵ
	}
}
__inline void disable_IRQ(void)
{
	int tmp;
	_asm
	{
		MRS tmp��CPSR
		ORR tmp��tmp��#0x80
		MSR CPSR_c��tmp
	}
}
