/****************************************************************
 *      ʹ�ñ����ļ������Է���Ŀ���1602��ʾ
 *      �û���ʹ�ñ����ʱ�򣬿ɶ���1602�Ŀ��ƿں����ݿ�
 *      
 *      ��Ȩ��Ƕ��ʽ�������У���ַ��www.ourembed.com
 *      ת�ػ��޸���ע��      designed by solo 
 *      2007.2.6
****************************************************************/

#include <iom16v.h>
#include <macros.h>
#define lcd_data_port PORTB     //�������ݿ�������û����޸�
#define lcd_data_ddr DDRB       //�������ݿڷ����û����޸�
#define lcd_busy_pin PINB       //�������ݿ����룬�û����޸�
#define lcd_busy_ddr DDRB       //����busy��־�ڣ��û����޸�
#define lcd_control_port PORTC  //������ƿ�������û����޸�
#define lcd_control_ddr DDRC    //������ƿڷ����û����޸�

#define lcd_RS 0x08             //RS_PORTC^3���û����޸�
#define lcd_RW 0x04             //RW_PORTC^2���û����޸�
#define lcd_EN 0x02             //EN_PORTC^1���û����޸�
#define busy 0x80 //LCD_DB7


/*----------------------------------��������------------------------------------------*/
void lcd_init(void);
void lcd_write_command(unsigned char command,unsigned char wait_en);
void lcd_write_data(unsigned char char_data);
void wait_enable(void);
void display_a_char(unsigned char position,unsigned char char_data);
void display_a_string(unsigned char posi,unsigned char col,unsigned char *ptr);
void delay_1ms(void);
void delay_nms(unsigned int n);
