//ICC-AVR application builder : 2006-5-30 8:29:21
// Target : M8
// Crystal: 4.0000Mhz

#include <iom16v.h>
#include <macros.h>

#define lcd_data_port PORTA       //�������ݿ�ΪPB��
#define lcd_data_ddr DDRA
#define lcd_busy_pin PINA
#define lcd_busy_ddr DDRA
#define lcd_control_port PORTD    //������ƿ�ΪPA��
#define lcd_control_ddr DDRD  

#define lcd_RS (1<<2) //PORTD^2
#define lcd_RW (1<<3) //PORTD^3
#define lcd_EN (1<<4) //PORTD^4
#define busy 0x80 //LCD_DB7


/*----------------------------------��������------------------------------------------*/
void lcd_init(void);
void lcd_write_command(unsigned char command,unsigned char wait_en);
void lcd_write_data(unsigned char char_data);
void wait_enable(void);
void display_a_char(unsigned char position,unsigned char char_data);
void display_a_string(unsigned char col,unsigned char *ptr);
void delay_1ms(void);
void delay_nms(unsigned int n);
const unsigned char seg_table[]={0x30,0x31,0x32,0x33,0x34,0x35,
0x36,0x37,0x38,0x39};



//Һ����ʼ��
void lcd_init(void)
{
 delay_nms(100);
 lcd_write_command(0x38,0);//��ʾģʽ��������(��ʱ����lcd�������)
 delay_nms(20);
 lcd_write_command(0x38,0);
 delay_nms(20);
 lcd_write_command(0x38,0);
 delay_nms(20);
 
 lcd_write_command(0x38,1);//��ʾģʽ����(�Ӵ�֮�����lcd����)
 lcd_write_command(0x08,1);//��ʾ�ر�
 lcd_write_command(0x01,1);//��ʾ����
 lcd_write_command(0x06,1);//��ʾ����ƶ�����
 lcd_write_command(0x0c,1);//��ʾ�����������
}

/*---------------------------------------��ʱ����-------------------------------------*/
//1ms��ʱ����
void delay_1ms(void)
{
 unsigned int i;
 for(i=0;i<1600;i++);
}

//n ms��ʱ����
void delay_nms(unsigned int n)
{
 unsigned int i;
 for(i=0;i<n;i++)delay_1ms();
}

//дָ���: E=������ RS=0 RW=0
void lcd_write_command(unsigned char command,unsigned char wait_en)//commandΪָ�wait_enָ���Ƿ�Ҫ���LCDæ�ź�
{
 if(wait_en)wait_enable();//��wait_enΪ1����Ҫ���LCDæ�źţ��ȴ������
 lcd_control_port&=~lcd_RS;//RS=0
 lcd_control_port&=~lcd_RW;//RW=0
 lcd_control_port&=~lcd_EN;//E=0,�����LCDһ��������
 NOP();
 lcd_control_port|=lcd_EN;//E=1
 lcd_data_port=command;
 lcd_control_port&=~lcd_EN;//����E=0
}

//ָ��λ����ʾһ���ַ�:��һ��λ��0~15,�ڶ���16~31
//��ʾһ���ַ�����
void display_a_char(unsigned char position,unsigned char char_data)//����positionָ��λ��0~31,char_dataΪҪ��ʾ���ַ�
{
 unsigned char position_tem;
 if(position>=0x10)
 position_tem=position+0xb0;
 else
 position_tem=position+0x80;
 lcd_write_command(position_tem,1);
 lcd_write_data(char_data);
}

//ָ��һ����ʾ�����ַ���:0��ʾ�ڵ�һ��,1��ʾ�ڵڶ���,ע�ַ������ܳ���16���ַ�
//��ʾһ�������ַ�������
void display_a_string(unsigned char col,unsigned char *ptr)//����colָ����,*ptrָ�ַ����������ָ��
{
 unsigned char col_tem,i;
 col_tem=col<<4;//��colΪ1(����LCD�ڶ�����ʾ�ַ���),�Ȱ�col����4λ,ʹ��ʾ�ַ�����λ�øĵ��ڶ�����λ,��λ��16
 for(i=0;i<16;i++)
 display_a_char(col_tem++,*(ptr+i));
}

//д���ݺ���: E =������ RS=1 RW=0
void lcd_write_data(unsigned char char_data)
{
 wait_enable();//�ȴ�LCD����
 lcd_control_port|=lcd_RS;//RS=1
 lcd_control_port&=~lcd_RW;//RW=0
 lcd_control_port&=~lcd_EN;//E=0,�����LCDһ��������
 NOP();
 lcd_control_port|=lcd_EN;//E=1
 lcd_data_port=char_data;
 lcd_control_port&=~lcd_EN;//����E=0
}

//������д����֮ǰ������LCD������״̬:E=1 RS=0 RW=1;DB7: 0 LCD���������У�1 LCD������æ��
//���æ�ź�,�ȴ�LCD���к���
void wait_enable(void)
{
 lcd_busy_ddr&=~busy;//����busy��Ϊ����
 lcd_control_port&=~lcd_RS;//RS=0
 lcd_control_port|=lcd_RW;//RW=1
 NOP();
 lcd_control_port|=lcd_EN;//E=1
 while(lcd_busy_pin&busy);//�ȴ�LCD_DB7Ϊ0
 lcd_control_port&=~lcd_EN;//����E=0
 lcd_busy_ddr|=busy;//����busy��Ϊ���
}

