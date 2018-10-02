void  C_vMain(void)				                      //主程序
{
	 unsigned char i;
	 unsigned short j;	
	 init_uart();					              //串口1初始化
	 while(1)
	 {   
		i=get_char();				              //读串口
		if(i==0x79)				              //是否读取到调试开始命令？
			mymain();			              //进入串口调试
		else 
			put_char(i);				      //测试串口
	 }
}
