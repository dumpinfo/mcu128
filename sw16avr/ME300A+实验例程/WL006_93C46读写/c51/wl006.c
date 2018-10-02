/*******************************************************************************
*  ����:  ME300ϵ�е�Ƭ������ϵͳ��ʾ���� -  AT93C46��д��ʾ����               *
*  Ӳ���� ME300A+,ME300B                                                       *
*  �ļ�:  wl006.C                                                              *
*  ����:  2004-1-5                                                             *
*  �汾:  1.0                                                                  *
*  ����:  ΰ�ɵ��� - Freeman                                                   *
*  ����:  freeman@willar.com                                                   *
*  ��վ�� http://www.willar.com                                                *
********************************************************************************
*  ����:                                                                       *
*         AT93C46��д��ʾ����                                                  *
*         �ӵ�ַ0x00��ʼд�����ݡ�www.willar.com���� Ȼ���ٶ���                  *
*                                                                              *
*         ע�⣺�ڲ�����д������֮ǰ��������д��EWENָ�93C46�ұߵ�JP7����   *
*               ����8λ��16λģʽѡ��Ĭ��Ϊ8λģʽ                           *
********************************************************************************
*  �������ã�                                                                  *
*     ME300A+    JP1 ȫ���̽ӣ�JP2�̽�3-4��                                    *
*     ME300B     JP1 �̽ӣ�JP2�̽�3-4�ˣ�JP3�̽�93��                           *
*                                                                              *
********************************************************************************
* ����Ȩ�� Copyright(C)ΰ�ɵ��� www.willar.com  All Rights Reserved            *
* �������� �˳��������ѧϰ��ο���������ע����Ȩ��������Ϣ��                  *
*******************************************************************************/


#include <reg51.h>
#include <intrins.h>

//define OP code
#define OP_EWEN_H		0x00	// 00					write enable
#define OP_EWEN_L		0x60	// 11X XXXX				write enable
#define OP_EWDS_H		0x00	// 00					disable
#define OP_EWDS_L		0x00	// 00X XXXX				disable

#define OP_WRITE_H		0x40	// 01 A6-A0				write data
#define OP_READ_H		0x80	// 10 A6-A0				read data

#define OP_ERASE_H		0xc0	// 11 A6-A0				erase a word

#define OP_ERAL_H		0x00	// 00					erase all
#define OP_ERAL_L		0x40	// 10X XXXX				erase all
#define OP_WRAL_H		0x00	// 00  					write all	
#define OP_WRAL_L		0x20	// 01X XXXX		 		write all	


//define pin
sbit CS = P3^4;
sbit SK = P3^3;
sbit DI	= P3^5;
sbit DO = P3^6;

unsigned char code dis_code[] = {0x7e,0xbd,0xdb,0xe7,0xdb,0xbd,0x7e,0xff};

void start();
void ewen();
void ewds();
void erase();
void write(unsigned char addr, unsigned char indata);
unsigned char read(unsigned char addr);
void inop(unsigned char op_h, unsigned char op_l);
void shin(unsigned char indata);
unsigned char shout();
void delayms(unsigned char ms);

main()
{
	unsigned char i;
	CS = 0;				//��ʼ���˿�
	SK = 0;
	DI = 1;
	DO = 1;

	ewen();				// ʹ��д�����
	erase();			// ����ȫ������
		
	for(i = 0 ; i < 8; i++)		//д����ʾ���뵽AT93C46
	{
		write(i, dis_code[i]);
	}
	
	ewds();				// ��ֹд�����	
	
	i = 0;
	while(1)
	{
		P0 = read(i);	// ѭ����ȡAT93C46���ݣ��������P0��
		i++;
		i &= 0x07;		// ѭ����ȡ��ַΪ0x00��0x07
		delayms(250);		
	}
}


void write(unsigned char addr, unsigned char indata)
// д������indata��addr
{
	inop(OP_WRITE_H, addr);	// д��ָ��͵�ַ
		shin(indata);
		CS = 0;
	delayms(10);			// Twp
}

unsigned char read(unsigned char addr)
// ��ȡaddr��������
{
	unsigned char out_data;
	inop(OP_READ_H, addr);	// д��ָ��͵�ַ
	out_data = shout();
	CS = 0;	
	return out_data;
}

void ewen()
{
	inop(OP_EWEN_H, OP_EWEN_L);
	CS= 0;
}

void ewds()
{
	inop(OP_EWDS_H, OP_EWDS_L);
	CS= 0;	
}

void erase()
{
	inop(OP_ERAL_H, OP_ERAL_L);
	delayms(30);
	CS = 0;
}


void inop(unsigned char op_h, unsigned char op_l)
//����op_h�ĸ���λ��op_l�ĵ�7λ
//op_hΪָ����ĸ���λ
//op_lΪָ����ĵ�7λ��7λ��ַ
{	

	unsigned char i;
	
	SK = 0;		// ��ʼλ
	DI = 1;
	CS = 1;
	_nop_();
	_nop_(); 
	SK = 1;
	_nop_();
	_nop_();
	SK = 0;		// ��ʼλ����

	DI = (bit)(op_h & 0x80);	// ������ָ�����λ
	SK = 1;
	op_h <<= 1;
	SK = 0;		

	DI = (bit)(op_h & 0x80);	// ����ָ����θ�λ
	SK = 1;
	_nop_();
	_nop_();	
	SK = 0;
	
	// �������µ�ָ������ַ����
	op_l <<= 1;	
	for(i = 0; i < 7; i++)		
	{
		DI = (bit)(op_l & 0x80);	// �������λ
		SK = 1;
		op_l <<= 1;
		SK = 0;		
	}
	DI = 1;		
}


void shin(unsigned char indata)		
//��������
{
	unsigned char i;
	for(i = 0; i < 8; i++)
	{
		DI = (bit)(indata & 0x80);	// �������λ
		SK = 1;
		indata <<= 1;
		SK = 0;		
	}
	DI = 1;
}

unsigned char shout(void)			
// �Ƴ�����
{
	unsigned char i, out_data;
	for(i = 0; i < 8; i++)
	{
		SK = 1;
		out_data <<= 1;
		SK = 0;
		out_data |= (unsigned char)DO;
	}
	return(out_data);
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
