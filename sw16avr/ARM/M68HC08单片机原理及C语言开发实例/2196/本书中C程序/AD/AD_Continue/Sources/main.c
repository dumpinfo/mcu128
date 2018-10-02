#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */


void delay(int num)
{
	int i;
	for(i=0;i<num;i++);
}

void main(void) {
 // EnableInterrupts; /* enable interrupts */
  /* include your code here */
  uchar  adc_result[10],i,j;
  uint   temp;
  
  
  CONFIG1=0x09; //5伏操作模式,关闭看门狗 
  ADICLK=0x10; // 选择内部总线时钟作为ADC的时钟。
  
  DDRD=0xff;   // PTD为输出
  PTD=0;       // 初始化PTD为0
  //ADSCR=0x00;   //单次转换
  ADSCR=0x20;     //连续转换
  temp=0;
  for(i=0;i<10;i++)
  {
     adc_result[i]=0;
  }
  i=0;
  while(1)       /* loop forever */
  {
      if(ADSCR_COCO==1)   //是否转换完成
      {
          adc_result[i]=ADR0L;  //保存采样值
          
          i++;
          // 十次采样植取平均，起滤波作用
          if(i==10)
          {
              i=0; 
              temp=0;
              for(j=0;j<10;j++)
              {
                   temp=temp+adc_result[j];
              }
              temp=temp/10;
              //利用PPTD4~7上的4个灯显示采样植
		      PTD=(uchar)temp;   
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      PTD=(uchar)(temp<<4);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      PTD=0xff;
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
		      delay(5000);
                
          }
         
      }
      
      
  }
}
