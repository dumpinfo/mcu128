#include <stdio.h>
extern void strcopy(char*d��const char*s)              	     //�����ⲿ��������Ҫ���õĻ���ӳ���
int mian(void)
{
	const char *srcstr=��First string-source����         //�����ַ�������
	char dstsrt[] =��Second string-destination����       //�����ַ�������
	printf(��Before copying��\n��);
	printf(����%s��\n ��%s\n����srcstr��dststr);         //��ʾԴ�ַ�����Ŀ���ַ���������
	strcopy(dststr��srcstr);                             //���û���ӳ���R0=dststr��R1=srcstr
	printf(��After copying��\n��)
	printf(����%s��\n ��%s\n����srcstr��dststr);         //��ʾstrcopy �����ַ������
	return(0);
}
