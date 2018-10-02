#include <stdio.h>
extern void strcopy(char*d，const char*s)              	     //声明外部函数，即要调用的汇编子程序
int mian(void)
{
	const char *srcstr=“First string-source”；         //定义字符串常量
	char dstsrt[] =“Second string-destination”；       //定义字符串变量
	printf(“Before copying：\n”);
	printf(“’%s’\n ‘%s\n，”srcstr，dststr);         //显示源字符串和目标字符串的内容
	strcopy(dststr，srcstr);                             //调用汇编子程序，R0=dststr，R1=srcstr
	printf(“After copying：\n”)
	printf(“’%s’\n ‘%s\n，”srcstr，dststr);         //显示strcopy 复制字符串结果
	return(0);
}
