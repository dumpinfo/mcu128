#include <iom16v.h>
#define   LM_KEY_IN  PINA    //数据输入
#define   LM_KEY_DIR DDRA   //方向
#define   LM_KEY_OUT PORTA   
//键盘 低电平为有效值
//该程序含有软件抗干扰设计
//函数输入void
//函数输出unsigned char 
//键盘按下P0~P7分别对应输出1~8
//需要宏定义键盘使用的IO口 如：
//#define PINA  LM_KEY_IN      //数据输入
//#define DDRA  LM_KEY_DIR     //方向
unsigned char LM_KeyPress_Low(void)
{ unsigned char LM_KeyState,LM_aa;
  
  LM_KEY_DIR=0; //键盘接口设置为输入
  
  LM_aa=LM_KEY_IN; //读取键盘值
  LM_KeyState=~LM_aa;
  if(LM_KeyState==0) return 0;//键盘没有键值
  LM_delay_ms(100);
  LM_aa=LM_KEY_IN;
  LM_KeyState=~LM_aa;
  switch(LM_KeyState)
  { case 1: LM_aa=1;
	        break;
	case 2: LM_aa=2;
            break;
	case 4: LM_aa=3;
	        break;	
	case 8: LM_aa=4;
	        break;
	case 16: LM_aa=5;
            break;
	case 32: LM_aa=6;
	        break;	
	case 64: LM_aa=7;
            break;
	case 128: LM_aa=8;
	        break;			
	default: LM_aa=0;
	         break;		
  }
  
  return LM_aa;
}
//阵列键盘函数
//该函数使用一个8位IO口，其中低4位输入，高4位输出,可完成4*4=16个键盘的定位
//函数输出unsigned char 
//键盘按下K11\K12\K13\K14~K41\K42\K43\K44分别对应函数输出1~16，没有键按下输出0
//需要宏定义键盘使用的IO口 如：
//#define PINA  LM_KEY_IN      //数据输入
//#define DDRA  LM_KEY_DIR     //方向
//#define PORTA LM_KEY_OUT     //数据输出
unsigned char LM_KeyPress_Low_Matrix(void)
{ unsigned char LM_KeyState,j,LM_Data1=0x01,LM_KEY_GET1,LM_KEY_GET2;
  
  LM_KEY_DIR=0xFF;//键盘接口设置为输出
  for(j=0;j<4;j++)
  {LM_KEY_OUT=LM_Data1;
   LM_Data1=LM_Data1<<1;
   LM_KEY_DIR=0;
   LM_KeyState = LM_KEY_IN&0X0F;//取低位
   if(LM_KeyState != 0)
   {LM_KEY_GET1=j*4+LM_KeyState;
    break;
   }
  } 
   LM_delay_ms(10);//10ms延时后再测一次，结果相同则输出
   LM_KEY_DIR=0xFF;//键盘接口设置为输出
   LM_Data1=0x01;
  for(j=0;j<4;j++)
  {LM_KEY_OUT=LM_Data1;
   LM_Data1=LM_Data1<<1;
   LM_KEY_DIR=0;
   LM_KeyState = LM_KEY_IN&0X0F;//取低位
   if(LM_KeyState != 0)
   {LM_KEY_GET2=j*4+LM_KeyState;
    break;
   }
  }
  if(LM_KEY_GET1 == LM_KEY_GET2)
   return LM_KEY_GET1;
  else
   return 0;
  
}

//延时
void LM_delay_ms(unsigned int LM_time)
{ unsigned int i,j;
  
  for(j=0;j<LM_time;j++)
  { for(i=0;i<1000;i++)
     LM_time=LM_time;
  }
}