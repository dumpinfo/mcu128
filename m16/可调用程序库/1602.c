#include <iom16v.h>
#include <1602.h>
//液晶初始化
void lcd_init(void)
{
 delay_nms(15);
 lcd_write_command(0x38,0);//显示模式设置三次(此时不管lcd空闲与否)
 delay_nms(5);
 lcd_write_command(0x38,0);
 delay_nms(5);
 lcd_write_command(0x38,0);
 delay_nms(5);
 
 lcd_write_command(0x38,1);//显示模式设置(从此之后均需lcd空闲)
 lcd_write_command(0x08,1);//显示关闭
 lcd_write_command(0x01,1);//显示清屏
 lcd_write_command(0x06,1);//显示光标移动设置
 lcd_write_command(0x0c,1);//显示开及光标设置
}

/*---------------------------------------延时函数-------------------------------------*/
//1ms延时函数
void delay_1ms(void)
{
 unsigned int i;
 for(i=0;i<600;i++);
}

//n ms延时函数
void delay_nms(unsigned int n)
{
 unsigned int i;
 for(i=0;i<n;i++)delay_1ms();
}

//写指令函数: E=高脉冲 RS=0 RW=0
void lcd_write_command(unsigned char command,unsigned char wait_en)//command为指令，wait_en指定是否要检测LCD忙信号
{
 if(wait_en)wait_enable();//若wait_en为1，则要检测LCD忙信号，等待其空闲
 lcd_control_port&=~lcd_RS;//RS=0
 lcd_control_port&=~lcd_RW;//RW=0
 lcd_control_port&=~lcd_EN;//E=0,下面给LCD一个高脉冲
 NOP();
 lcd_control_port|=lcd_EN;//E=1
 lcd_data_port=command;
 lcd_control_port&=~lcd_EN;//重设E=0
}

//指定位置显示一个字符:第一行位置0~15,第二行16~31
//显示一个字符函数
void display_a_char(unsigned char position,unsigned char char_data)//参数position指定位置0~31,char_data为要显示的字符
{
 unsigned char position_tem;
 if(position>=0x10)
 position_tem=position+0xb0;
 else
 position_tem=position+0x80;
 lcd_write_command(position_tem,1);
 lcd_write_data(char_data);
}

//指定一行显示连续字符串:0显示在第一行,1显示在第二行,注字符串不能长于16个字符
//显示一行连续字符串函数
void display_a_string(unsigned char posi,unsigned char col,unsigned char *ptr)//参数col指定行,*ptr指字符串数组的首指针
{ unsigned char col_tem,i;
 col_tem=col<<4;//若col为1(即在LCD第二行显示字符串),先把col左移4位,使显示字符的首位置改到第二行首位,即位置16
 for(i=0;i<16;i++)
 display_a_char(posi+col_tem++,*(ptr+i));
}

//写数据函数: E =高脉冲 RS=1 RW=0
void lcd_write_data(unsigned char char_data)
{
 wait_enable();//等待LCD空闲
 lcd_control_port|=lcd_RS;//RS=1
 lcd_control_port&=~lcd_RW;//RW=0
 lcd_control_port&=~lcd_EN;//E=0,下面给LCD一个高脉冲
 NOP();
 lcd_control_port|=lcd_EN;//E=1
 lcd_data_port=char_data;
 lcd_control_port&=~lcd_EN;//重设E=0
}

//正常读写操作之前必须检测LCD控制器状态:E=1 RS=0 RW=1;DB7: 0 LCD控制器空闲，1 LCD控制器忙。
//检测忙信号,等待LCD空闲函数
void wait_enable(void)
{
 lcd_busy_ddr&=~busy;//设置busy口为输入
 lcd_control_port&=~lcd_RS;//RS=0
 lcd_control_port|=lcd_RW;//RW=1
 NOP();
 lcd_control_port|=lcd_EN;//E=1
 while(lcd_busy_pin&busy);//等待LCD_DB7为0
 lcd_control_port&=~lcd_EN;//重设E=0
 lcd_busy_ddr|=busy;//设置busy口为输出
}

