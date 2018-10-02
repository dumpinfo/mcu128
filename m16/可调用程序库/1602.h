/****************************************************************
 *      使用本库文件，可以方便的控制1602显示
 *      用户在使用本库的时候，可定义1602的控制口和数据口
 *      
 *      版权归嵌入式联盟所有，网址：www.ourembed.com
 *      转载或修改请注明      designed by solo 
 *      2007.2.6
****************************************************************/

#include <iom16v.h>
#include <macros.h>
#define lcd_data_port PORTB     //定义数据口输出，用户可修改
#define lcd_data_ddr DDRB       //定义数据口方向，用户可修改
#define lcd_busy_pin PINB       //定义数据口输入，用户可修改
#define lcd_busy_ddr DDRB       //定义busy标志口，用户可修改
#define lcd_control_port PORTC  //定义控制口输出，用户可修改
#define lcd_control_ddr DDRC    //定义控制口方向，用户可修改

#define lcd_RS 0x08             //RS_PORTC^3，用户可修改
#define lcd_RW 0x04             //RW_PORTC^2，用户可修改
#define lcd_EN 0x02             //EN_PORTC^1，用户可修改
#define busy 0x80 //LCD_DB7


/*----------------------------------函数声明------------------------------------------*/
void lcd_init(void);
void lcd_write_command(unsigned char command,unsigned char wait_en);
void lcd_write_data(unsigned char char_data);
void wait_enable(void);
void display_a_char(unsigned char position,unsigned char char_data);
void display_a_string(unsigned char posi,unsigned char col,unsigned char *ptr);
void delay_1ms(void);
void delay_nms(unsigned int n);
