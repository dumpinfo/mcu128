void  C_vMain(void)				                      //������
{
	 unsigned char i;
	 unsigned short j;	
	 init_uart();					              //����1��ʼ��
	 while(1)
	 {   
		i=get_char();				              //������
		if(i==0x79)				              //�Ƿ��ȡ�����Կ�ʼ���
			mymain();			              //���봮�ڵ���
		else 
			put_char(i);				      //���Դ���
	 }
}
