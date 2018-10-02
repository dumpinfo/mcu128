	EXPORT   CALLSUM5
	AREA     Example， CODE，READONLY
	IMPORT   sum5                ;声明外部标号sum5，即C 函数sum5()
CALLSUMS
	STMFD   SP!{LR}              ;LR 寄存器放栈
	ADD  R1，R0，R0              ;设置sum5 函数入口参数，R0 为参数a
	ADD  R2，R1，R0              ;R1 为参数b，R2 为参数c
	ADD  R3，R1，R2，
	STR   R3，[SP，#-4]!         ;参数e 要通过堆栈传递
	ADD  R3，R1，R1              ;R3 为参数d
	BL    sum5                   ;调用sum5()，结果保存在R0
	ADD  SP，SP#4                ;修正SP 指针
	LDMFD  SP，{PC }             ;子程序返回
	END
