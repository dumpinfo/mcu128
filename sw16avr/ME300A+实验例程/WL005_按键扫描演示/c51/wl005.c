/*******************************************************************************
*  ����:  ME300ϵ�е�Ƭ������ϵͳ��ʾ���� - ����ɨ�����                       *
*  Ӳ���� ME300A+,ME300B                                                       *
*  �ļ�:  wl005.C                                                              *
*  ����:  2004-1-5                                                             *
*  �汾:  1.0                                                                  *
*  ����:  ΰ�ɵ��� - Freeman                                                   *
*  ����:  freeman@willar.com                                                   *
*  ��վ�� http://www.willar.com                                                *
********************************************************************************
*  ����:                                                                       *
*         ����ɨ�����                                                         *
*         �ϵ�ʱ, ����P00��LED                                                 *
*         ����K1ʱ, LED������һλ                                              *
*         ����K2ʱ, LED������һλ                                              *
********************************************************************************
*  �������ã�                                                                  *
*     ME300A+    JP1 ȫ���̽ӣ�JP2�̽�2-3��                                    *
*     ME300B     JP1 �̽ӣ�    JP2�̽�2-3��                                    *
*                                                                              *
********************************************************************************
* ����Ȩ�� Copyright(C)ΰ�ɵ��� www.willar.com  All Rights Reserved            *
* �������� �˳��������ѧϰ��ο���������ע����Ȩ��������Ϣ��                  *
*******************************************************************************/

#include <reg51.h>
#include <intrins.h>

unsigned char scan_key();
void proc_key(unsigned char key_v);
void delayms(unsigned char ms);

sbit	K1 = P1^4;
sbit	K2 = P1^5;

main()
{
	
	unsigned char key_s,key_v;
	key_v = 0x03;
	P0 = 0xfe;
	while(1)
	{
		key_s = scan_key();
		if(key_s != key_v)
		{
			delayms(10);
			key_s = scan_key();
			if(key_s != key_v)
			{	
				key_v = key_s;
				proc_key(key_v);					
			}
		}
	}	
}

unsigned char scan_key()
{
	unsigned char key_s;
	key_s = 0x00;
	key_s |= K2;
	key_s <<= 1;
	key_s |= K1;
	return key_s;		
}

void proc_key(unsigned char key_v)
{
	if((key_v & 0x01) == 0)
	{
		P0 = _cror_(P0,1);
	}
	else if((key_v & 0x02) == 0)
	{
		P0 = _crol_(P0, 1);
	}
}

void delayms(unsigned char ms)	
// ��ʱ�ӳ���
{						
	unsigned char i;
	while(ms--)
	{
		for(i = 0; i < 120; i++);
	}
}
