#include <stdio.h> 
static void my_print (char *); 
static void my_print2 (char *); 
main () 
{ 
	char my_string[] = "hello world!";                       //显示一个简单的问候
	my_print (my_string); 
	my_print2 (my_string); 
} 
void my_print (char *string) 
{ 
	printf ("The string is %s ", string); 
} 
void my_print2 (char *string)                                   //反序列出
{ 
	char *string2; 
	int size, i; 
	size = strlen (string);                                 //长度
	string2 = (char *) malloc (size + 1);                   //分配内存
	for (i = 0; i < size; i++)   
	string2[size - i] = string[i];                          //依次反序
        //string2[size -1 - i] = string[i];                     //修改之处
	string2[size+1] = ''; 
	printf ("The string printed backward is %s ", string2); 
} 
