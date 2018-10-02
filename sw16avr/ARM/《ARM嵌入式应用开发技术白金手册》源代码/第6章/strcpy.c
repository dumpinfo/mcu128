#include <stdio.h>
void my_strcpy(const char*src�� char*dst)
{
  	int ch;
	_asm
	{
	loop:
		#ifndef_thumb                        	//ARM ָ��汾
			LDRB ch��[src]��#1
			STRB ch��[dst]��#1
		#else
							//Thumb ָ��汾
			LDRB ch��[src]
			ADD src��#1
			STRB ch��[dst]
			ADD dst��#1
		#endif
			CMP ch��#0
			BNE loop
	}
}
int main(void)
{
	const char*a=��Hello world����
	char b[20]
	_asm
	{
		MOV R0��a                            	  //������ڲ���
		MOV R1��b
		BL my_strcpy��{R0��R1}               	  //����my_strcpy()����
	}
	printf(��Original string:��%s��\n����a);          //��ʾmy_strcpy()�����ַ������ƽ��
	printf(��Copied string:��%s��\n����b);
	return(0);
}
