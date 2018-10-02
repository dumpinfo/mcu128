#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */

#define N  4
void delay(int num)
{
	int i;
	for(i=0;i<num;i++);
}

void main(void)
{
    CONFIG1 = 0x09;				/* COP dis,  5v	ģʽ	*/
	
	PCTL_PLLON=0;// �ر����໷��·  
	
	PWMDR2 = 0x40;                        
	PWMDR1 = 0x40;				//ռ�ձ�25��  0x40/0xFF'
	PWMDR0 = 0x40;
	
	PWMCCR = 0x02;              //ѡ��CGMOUT��ΪPWM������ʱ�ӣ�Ԥ��Ƶϵ��Ϊ4
	
	//PWMPCR=0x1A;                 //��λ�Ĵ�����
	//PWMPCR_PHEN=1;               //ʹ����λ�Ĵ���
	 
	PWMCR= 0x07;                 //����PWM�����
	PWMCR |= 0xE0;               //ʹ��1
	
  while(1);      /* loop forever */

}
