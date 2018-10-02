#include <REG52.h>
#include "font.h"
#include "string.h"
/*************19264显示接口引脚定义*****************/


sbit	LCD_RW   =P2^0;    	// PA0----DI
sbit	LCD_DI   =P2^1;					// PA1----RW
sbit	LCD_E    =P2^2;			    	// PA2----E
sbit	LCD_CS1  =P2^3;	           	// PA3----CS1
sbit	LCD_CS2  =P2^4;				// PA4----CS2


#define	LCD_DATA	P0				//LCD数据输出口


void OutI(unsigned char CtroCode,unsigned char Com);
void OutD(unsigned char CtroCode,unsigned char Dat);
void LCD_NOP(void);
void ClearDisplay(void);
void DisplayWord(unsigned int Add,unsigned char xAdd,unsigned char yAdd,
unsigned char SelscP,unsigned char num,unsigned char flag);
void DisplayLine(unsigned int Add,unsigned char com,unsigned char line,unsigned char flag);



void OutI(unsigned char CtroCode,unsigned char Com)
{ //Com为指令
  unsigned char aa=1;    
  switch(CtroCode)
  { case 0: LCD_CS1 = 0;
			LCD_CS2 = 0;		
  		 	break;
  	case 1: LCD_CS1= 0;
			LCD_CS2 = 1;
			
		 	break;
	case 2: LCD_CS1 = 1;
    		LCD_CS2 = 0;
			
		 	break;	
   
  }
  
  LCD_DI = 0;       //DI=0
  /*
  while(aa)
  { LCD_SET_RW(); //R/W=1
	LCD_CLEAR_DI(); //D/I=0
    LCD_SET_E(); //E=1
    NOP();
    LCD_CLEAR_E(); //E=0
    aa=LCD_DATA_IN;
	
    aa&=0x80;
	//if(aa==0) break;
  }*/
   LCD_NOP();
   LCD_NOP();
   LCD_NOP();
   LCD_NOP();
  
  LCD_RW=0; //R/W=0
  
  LCD_E = 1; //E=1
  LCD_NOP();
  LCD_DATA=Com;
  LCD_NOP();
  LCD_E = 0; //E=0
  //
  LCD_CS1 = 1; //CS1=1,CS2=1,CS3=1
  LCD_CS2 = 1; 
  
}

void OutD(unsigned char CtroCode,unsigned char Dat)
{ //Dat为数据
  unsigned char aa=1;  
    switch(CtroCode)
  { case 0: LCD_CS1 = 0;
			LCD_CS2 = 0;		
  		 	break;
  	case 1: LCD_CS1= 0;
			LCD_CS2 = 1;
			
		 	break;
	case 2: LCD_CS1 = 1;
    		LCD_CS2 = 0;
			
		 	break;	
   
  }
 /* while(aa)
  { LCD_SET_RW(); //RW=1
    LCD_CLEAR_DI(); //D/I=0
    LCD_SET_E(); //E=1
	NOP();
    LCD_CLEAR_E(); //E=0
    aa=LCD_DATA_IN;
    aa&=0x80;
  }*/
  LCD_NOP();
  LCD_NOP();
  LCD_NOP();
  LCD_NOP();
  LCD_NOP();
  LCD_NOP();
  
  LCD_RW = 0; //RW=0
  LCD_DI = 1; //D/I=1
  
  LCD_E = 1; //E=1
  LCD_NOP();
  LCD_DATA=Dat;
  
  
  LCD_NOP();
  LCD_E = 0; //E=0
  LCD_CS1 = 1; //CS1=1,CS2=1,CS3=1
  LCD_CS2 = 1; 
  
}

void LCD_NOP(void)
{ unsigned int i;

  for(i=0;i<2;i++); 
}

void ClearDisplay(void)
{ unsigned char i,j;

  for(i=0;i<8;i++)
  { OutI(0,0xb8+i); //X首地址
  	OutI(0,0x40); //y首地址
  	for(j=0;j<64;j++)
      OutD(0,0x00);
  }
}


void DisplayWord(unsigned int Add,unsigned char xAdd,unsigned char yAdd,
unsigned char SelscP,unsigned char num,unsigned char flag)//Add:显示数据的起始地址
{ unsigned char i,m=0,dat;                                //xAdd,yAdd:显示位置
                                                          //SelscP:选择屏1，2，3
  OutI(SelscP,xAdd++); //x首地址                          //mun显示宽度，一般为16
  OutI(SelscP,yAdd); //y首地址							  //flag:是否清字位1不清
  while(m<num+2)
  { for(i=0;i<num;i++)
    { if(flag==0) dat=0;
	  else dat=font[Add+i+m];
	  OutD(SelscP,dat);
	}
	OutI(SelscP,xAdd++); 
	OutI(SelscP,yAdd);
	m+=num;
   } 
}

void DisplayLine(unsigned int Add,unsigned char com,unsigned char line,unsigned char flag)
{ unsigned char i,l,r;  	  			   			     //Add:数据起始位置
  		   												 //com:空位置个数，4字为满
  r=com&0x0f;											 //line: 显示行位置
  l=com>>4;												 //flag:是否清字符1不清
  for(i=0;i<r;i++)
    DisplayWord(Add+i*32,0xb8+(line%4)*2,0x40+(i+l)*16,(line/4)+1,16,flag);
}



