	IMPORT Main						;通知编译器该标号为一个外部标号
	AREA    Init,CODE,READONLY				;定义一个代码段
	ENTRY							;定义程序的入口点
	LDR	R0,=0x3FF0000				     	;初始化系统配置寄存器
	LDR	R1,=0xE7FFFF80                   		; 配置SYSCFG,片内4K Cache,4K SRAM
	STR	R1,[R0]
	LDR	SP,=0x3FE1000				     	;初始化用户堆栈
								;  SP指向4K SRAM的尾地址，堆栈向下生成
	BL	Main						;跳转到Main（）函数处的C/C++代码执行
	END							;标识汇编程序的结束
