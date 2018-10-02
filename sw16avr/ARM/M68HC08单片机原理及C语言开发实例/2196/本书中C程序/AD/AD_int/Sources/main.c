#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */

//#define  unsigned char  uchar
//#define  unsigned int   uint 

#define  N 10
uchar  adc_result[N],i;

void delay(int num)
{
	int i;
	for(i=0;i<num;i++);
}

void main(void) 
{
  uchar j,max,min;
  uint  temp;
  EnableInterrupts; /* enable interrupts */
  
  /* include your code here */
  
  CONFIG1=0x09; //5伏操作模式，关闭看门狗
  CONFIG2=0x10; //选择x-tal
   
  ADICLK=0x10; // 选择内部总线时钟作为ADC的时钟。
  
  DDRD=0xff;   // PTD为输出
  PTD=0;       // 初始化PTD为0

  //初始化变量
  for(j=0;j<N;j++)
  {
      adc_result[j]=0;
  }
  i=0;
  temp=0;
  ADSCR=0x00;     //通道0
  ADSCR_AIEN=1;  //使能中断
  while(1)       /* loop forever */
  {
       // 十次采样植取平均，起滤波作用
     if(i>=N)
     {
        //ADSCR=0x1f;  //关闭ADC
        i=0;
        temp=0;
        for(j=0;j<N;j++)
        {  
            max=adc_result[0];
            min=adc_result[0];
           if(max<adc_result[j])
           {
               max=adc_result[j];
           }
           if(min>adc_result[j])
           {
               min=adc_result[j];
           }
           temp+=adc_result[j];
         }
         temp=(temp-max-min)/(N-2);
         //利用PPTD4~7上的4个灯显示采样植
	     PTD=(uchar)temp;   
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
         //delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);
	     PTD=(uchar)(temp<<4);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);   
	     PTD=0xff;
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);
	     //delay(5000);
      }
        
  }
}

interrupt void _ADC_int(void)
{
       ADSCR_AIEN=0;  //禁止中断
       adc_result[i]=ADR0L;  //保存采样值
       i++;       
       ADSCR=0x00;          //选择通道0
       ADSCR_AIEN=1;         //使能中断
}
