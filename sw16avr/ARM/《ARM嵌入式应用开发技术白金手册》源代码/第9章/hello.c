#include <stdio.h> 
static void my_print (char *); 
static void my_print2 (char *); 
main () 
{ 
	char my_string[] = "hello world!";                       //��ʾһ���򵥵��ʺ�
	my_print (my_string); 
	my_print2 (my_string); 
} 
void my_print (char *string) 
{ 
	printf ("The string is %s ", string); 
} 
void my_print2 (char *string)                                   //�����г�
{ 
	char *string2; 
	int size, i; 
	size = strlen (string);                                 //����
	string2 = (char *) malloc (size + 1);                   //�����ڴ�
	for (i = 0; i < size; i++)   
	string2[size - i] = string[i];                          //���η���
        //string2[size -1 - i] = string[i];                     //�޸�֮��
	string2[size+1] = ''; 
	printf ("The string printed backward is %s ", string2); 
} 
