#include <iom128v.h>
#include <macros.h>

#define F_CPU 2000000
const unsigned char buffer[]="http://www.avrvi.com";

void USART0_Init( unsigned int baud )
{
unsigned int tmp;
/* ���ò�����*/
tmp= F_CPU/baud/16-1;
UBRR0H = (unsigned char)(tmp>>8);
UBRR0L = (unsigned char)tmp;
/* �������뷢����ʹ��*/
UCSR0B = (1<<RXEN0)|(1<<TXEN0);
/* ����֡��ʽ: 8 ������λ, 1��ֹͣλ*/
UCSR0C = (1<<UCSZ00)|(1<<UCSZ01);
}

// ���ݷ��͡�����5 ��8 λ����λ��֡��
void USART0_Transmit( unsigned char data )
{
/* �ȴ����ͻ�����Ϊ�� */
while ( !( UCSR0A & (1<<UDRE0)) )
;
/* �����ݷ��뻺�������������� */
UDR0 = data;
} 


// ���ݽ��ա���5 ��8 ������λ�ķ�ʽ������ ��֡��
unsigned char USART0_Receive( void )
{
/* �ȴ���������*/
while ( !(UCSR0A & (1<<RXC0)) )
;
/* �ӻ������л�ȡ����������*/
return UDR0;
} 




void main(void)
{
unsigned char n=0,tmp=0;

USART0_Init(9600); //������9600 ��ʼ������
// uart0_init();

while(1)
{
if(UCSR0A&(1<<RXC0)) //������ջ�����������
{
tmp=USART0_Receive(); //��������
USART0_Transmit(tmp); //��������

}
}
}