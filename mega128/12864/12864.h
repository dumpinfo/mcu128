#include "font.h"

#define	LCD_DI (1 <<5)			    	// PD5----DI
#define	LCD_RW (1 <<6)					// PD6----RW
#define	LCD_E (1 <<7)			    	// PD7----E

#define	LCD_PSB (1 << 7)	           	// PA7----CS1
#define	LCD_RST (1 << 5)				// PA5----RST

#define LCD_PORT  PORTD                 //PA�����ӵ���5�����ƽţ����嶨������
#define LCD_PORT1  PORTA

#define	LCD_SET_PSB()    (LCD_PORT1 |= LCD_PSB)	// λ��λ�����1
#define	LCD_SET_RST()    (LCD_PORT1 |= LCD_RST)
#define	LCD_SET_DI()     (LCD_PORT |= LCD_DI)
#define	LCD_SET_RW()     (LCD_PORT |= LCD_RW)
#define	LCD_SET_E()      (LCD_PORT |= LCD_E)

#define	LCD_CLEAR_PSB()  (LCD_PORT1 &= ~LCD_PSB)			// λ���㣬���0
#define	LCD_CLEAR_RST()  (LCD_PORT1 &= ~LCD_RST)
#define	LCD_CLEAR_DI()   (LCD_PORT &= ~LCD_DI)
#define	LCD_CLEAR_RW()   (LCD_PORT &= ~LCD_RW)
#define	LCD_CLEAR_E()    (LCD_PORT &= ~LCD_E)

#define	LCD_DATA_OUT	 PORTC				//LCD���������
#define	LCD_DATA_IN 	 PINC				//LCD���������
#define	LCD_DDR 	     DDRC				//LCD���ݿڷ���
/* Define the register command code */
#define Disp_On  0x3f
#define Disp_Off 0x30
#define Col_Add  0x40
#define Page_Add 0xb8
#define Start_Line 0xc0


void delay(unsigned int t);
void write_com(unsigned char cmdcode);
void write_data(unsigned char Dispdata);
void init_lcd(void);
unsigned char read_data(void);
void DisplayWord(unsigned int Add,unsigned char xAdd,unsigned char yAdd,
unsigned char SelscP,unsigned char num,unsigned char flag);
void DisplayLine(unsigned int Add,unsigned char com,unsigned char line,unsigned char flag);
void ClearDisplay(void);
void Test(unsigned int lcd_data);
void Testlcd2(unsigned char lcd_datah,unsigned char lcd_datal);
/*------------------��ʱ�ӳ���-----------------------------*/
void delay(unsigned int t)
{
unsigned int i,j;
for(i=0;i<t;i++)
for(j=0;j<10;j++)
;
}

/*------------------д���LCD------------------------------*/
void write_com(unsigned char cmdcode)
{

LCD_CLEAR_DI();
LCD_CLEAR_RW();
LCD_DDR=0xff;

LCD_DATA_OUT=cmdcode;
LCD_SET_E();
delay(100);
LCD_CLEAR_E();
}

/*-------------------д���ݵ�LCD----------------------------*/

void write_data(unsigned char Dispdata)
{

LCD_SET_DI();
LCD_CLEAR_RW();
LCD_DDR=0xff;

LCD_DATA_OUT=Dispdata;
LCD_SET_E();
delay(100);
LCD_CLEAR_E();
}

/*-------------------��LCD����----------------------------*/

unsigned char read_data(void)
{
unsigned char tmpin;
LCD_DDR=0x0;
LCD_SET_DI();
LCD_SET_RW();
delay(0);
LCD_SET_E();
delay(0);
LCD_CLEAR_E();

tmpin=LCD_DATA_IN;

return tmpin;
}
/*------------------��ʼ��LCD��--------------------------*/
void init_lcd(void)
{
LCD_SET_PSB();
delay(100);
LCD_SET_RST();
delay(100);

write_com(0X30);
delay(100);
write_com(0X30);
delay(100);
write_com(0x0C);
delay(100);
write_com(0X01);
delay(100);
write_com(0X06);
delay(100);
}

/*void DisplayWord(unsigned int Add,unsigned char xAdd,unsigned char yAdd,
unsigned char SelscP,unsigned char num,unsigned char flag)//Add:��ʾ���ݵ���ʼ��ַ
{ unsigned char i,m=0,dat;                                //xAdd,yAdd:��ʾλ��
  switch (SelscP)
   {case 0:LCD_SET_CS1();
   		   LCD_SET_CS2();
		   break;
	case 1:LCD_SET_CS1();
   		   LCD_CLEAR_CS2();
		   break;
	case 2:LCD_CLEAR_CS1();
   		   LCD_SET_CS2();
		   break;	   	   
   }                                                       //SelscP:ѡ����1��2��3
  write_com(xAdd++); //x�׵�ַ                          //mun��ʾ��ȣ�һ��Ϊ16
  write_com(yAdd); //y�׵�ַ							  //flag:�Ƿ�����λ1����
  while(m<num+2)
  { for(i=0;i<num;i++)
    { if(flag==0) dat=0;
	  else dat=font[Add+i+m];
	  write_data(dat);
	}
	write_com(xAdd++); 
	write_com(yAdd);
	m+=num;
   } 
}

void DisplayLine(unsigned int Add,unsigned char com,unsigned char line,unsigned char flag)
{ unsigned char i,p,l,r;  	  			   			     //Add:������ʼλ��
  		   												 //com:��λ�ø�����4��Ϊ��
  r=com&0x0f;											 //line: ��ʾ��λ��
  l=4-com;												 //flag:�Ƿ����ַ�1����
  for(i=0;i<r;i++)
    DisplayWord(Add+i*32,0xb8+(line%4)*2,0x40+(i+l)*16,(line/4)+1,16,flag);
}*/
void ClearDisplay(void)
{ unsigned char i,j;

  for(i=0;i<8;i++)
  { write_com(0xb8+i); //X�׵�ַ
  	write_com(0x40); //y�׵�ַ
  	for(j=0;j<64;j++)
      write_data(0x00);
  }
}

void Test(unsigned int lcd_data)
 {unsigned int K;
  write_com(0x01);
  write_com(0x40);
  for(K=0;K<148;K++)
  {write_data(lcd_data);
  }

 }
void Testlcd2(unsigned char lcd_datah,unsigned char lcd_datal)
{write_data(lcd_datal);
 delay(100);
 write_data(lcd_datah);
}