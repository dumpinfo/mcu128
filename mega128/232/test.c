#include <iom128v.h>
#include <macros.h>

#define F_CPU 2000000
const unsigned char buffer[]="http://www.avrvi.com";

void USART0_Init( unsigned int baud )
{
unsigned int tmp;
/* 设置波特率*/
tmp= F_CPU/baud/16-1;
UBRR0H = (unsigned char)(tmp>>8);
UBRR0L = (unsigned char)tmp;
/* 接收器与发送器使能*/
UCSR0B = (1<<RXEN0)|(1<<TXEN0);
/* 设置帧格式: 8 个数据位, 1个停止位*/
UCSR0C = (1<<UCSZ00)|(1<<UCSZ01);
}

// 数据发送【发送5 到8 位数据位的帧】
void USART0_Transmit( unsigned char data )
{
/* 等待发送缓冲器为空 */
while ( !( UCSR0A & (1<<UDRE0)) )
;
/* 将数据放入缓冲器，发送数据 */
UDR0 = data;
} 


// 数据接收【以5 到8 个数据位的方式接收数 据帧】
unsigned char USART0_Receive( void )
{
/* 等待接收数据*/
while ( !(UCSR0A & (1<<RXC0)) )
;
/* 从缓冲器中获取并返回数据*/
return UDR0;
} 




void main(void)
{
unsigned char n=0,tmp=0;

USART0_Init(9600); //波特率9600 初始化串口
// uart0_init();

while(1)
{
if(UCSR0A&(1<<RXC0)) //如果接收缓存区有数据
{
tmp=USART0_Receive(); //接收数据
USART0_Transmit(tmp); //发送数据

}
}
}