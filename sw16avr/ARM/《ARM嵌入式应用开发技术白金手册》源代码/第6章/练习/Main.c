void Main(void)
{
	int i;
	*((volatile unsigned long *) 0x3ff5000) = 0x0000000f;              //ʹ��volatile�ؼ�������
									   //��ֹ������gcc�Ż�
	while(1)
	{
		*((volatile unsigned long *) 0x3ff5008) = 0x00000001;
		for(i=0; i<0x7fFFF; i++);
		*((volatile unsigned long *) 0x3ff5008) = 0x00000002;
		for(i=0; i<0x7FFFF; i++);
	}
}
