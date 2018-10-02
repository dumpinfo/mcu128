//***************WINAVR V1.41编译*****************//

#include"avr/io.h"                   //头文件
#define uchar unsigned char  //数据类型说明
#define uint  unsigned int      //数据类型说明


uchar dis_code[11]={0xc0,0xf9,0xa4,0xb0,0x99, // 0, 1, 2, 3，4,
                    0x92,0x82,0xf8,0x80,0x90, 0xff} ;// 5, 6, 7, 8, 9, off

uchar dis_buf[8] ;
uchar dis_index ;
uchar dis_digit ;

//

void DelayMs(uint i)           //Ms级延时函数,参数i：延时时间
{ uint j ;
  for( ;i!=0 ;i--)
  {for(j=8000 ;j!=0 ;j--)  ;}
}

//

// dis_index --- 显示索引, 用于标识当前显示的数码管和缓冲区的偏移量。
// dis_digit --- 位选通值, 传送到PB口用于选通当前数码管的数值。
// dis_buf   --- 显于缓冲区基地址。

//

void main()
{
    DDRA=0xFF ;       //置PA口为输出
    PORTA=0xFF ;
    DDRC=0xFF ;
    PORTC=0xFF ;     //置PC口为输出

    dis_buf[0] = dis_code[0x1] ;
    dis_buf[1] = dis_code[0x2] ;
    dis_buf[2] = dis_code[0x3] ;
    dis_buf[3] = dis_code[0x4] ;
    dis_buf[4] = dis_code[0x5] ;
    dis_buf[5] = dis_code[0x6] ;
    dis_buf[6] = dis_code[0x7] ;
    dis_buf[7] = dis_code[0x8] ;
 
     dis_digit = 0xfe ;   //预置位扫描初值。
     dis_index = 0 ;
 
 while(1)

  {
      PORTC=0xFF ;                         // 先关闭所有数码管
      PORTA=dis_buf[dis_index] ;   // 显示代码传送到PA口
      PORTC=dis_digit ;                  // 位选通值传送到PC口
      DelayMs(10) ;
 
      dis_digit=(dis_digit< ;< ;1)|0x01 ;   // 位选通值左移, 下次选通下一位数码管
      dis_index++ ;                
     
    if(dis_index == 0x08)  // 8个数码管是否全部扫描完一遍？
    {dis_digit = 0xfe ;      // 重装初值
     dis_index = 0 ;
    }
  }
}
