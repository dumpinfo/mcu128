#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */

#define N  4
void delay(int num)
{
	int i;
	for(i=0;i<num;i++);
}

void main(void) {
 // EnableInterrupts; /* enable interrupts */
  /* include your code here */
  uchar  adc_result[N];
  
  CONFIG1=0x09; //5伏操作模式,关闭看门狗
  CONFIG2=0x10; // 选择外部晶振作为时钟源
  
  ADICLK=0x10; // 选择内部总线时钟作为ADC的时钟。
  ADASCR=0x07; // 自动扫描模式 ， ATD0~ATD3;
  
  DDRD=0xff;   // PTD为输出   
  PTD=0;       // 初始化PTD为0
  
  //变量初始化

  adc_result[3]=0;
  adc_result[2]=0;
  adc_result[1]=0;
  adc_result[0]=0;
  
  ADSCR=0x00;   //启动ADC
  
  while(1)       /* loop forever */
  {
      if(ADSCR_COCO==1)   //是否转换完成
      {

          adc_result[0]=ADR0L;  //保存采样值
          adc_result[1]=ADR1L;  //保存采样值
          adc_result[2]=ADR2L;
          adc_result[3]=ADR3L;
          //利用PPTD4~7上的4个灯显示采样植
	      PTD= adc_result[0] ;  
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
	      PTD=(adc_result[0]<<4);
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
	       PTD= adc_result[1] ;  
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
	      PTD=(adc_result[1]<<4);
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
	       PTD= adc_result[2] ;  
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
	      PTD=(adc_result[2]<<4);
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
	       PTD= adc_result[3];   
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
	      PTD=(adc_result[3]<<4);
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
	      ADSCR=0x00;   //启动ADC

	   }
     
  }
}
