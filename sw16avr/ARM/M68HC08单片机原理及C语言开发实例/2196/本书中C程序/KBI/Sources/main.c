#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */

void main(void) {
 
  CONFIG1 = 0x39;
  DDRD =  0xF0;     //PTD����λ��Ϊ���������λ��Ϊ����
  PTD &= 0x0F;      //PTD����λ�����ʼֵΪ0
  KBSCR_MODEK = 1;  //ѡ�񴥷���ʽΪ�½��غ͵͵�ƽ
   /*Initialize KeyBoard(to prevent a false interrupt)*/
  KBSCR_IMASKK = 1;
  KBIER = 0x0F;     
  KBSCR_ACKK = 1;
  KBSCR_IMASKK = 0;  
  EnableInterrupts; /* enable interrupts */
  for(;;);
}

interrupt  void  KBI_ISR(void)
{
    KBSCR_IMASKK = 1;  //���μ����ж�
    if(PTD_PTD0==0)    //���жϷ�������в�ѯ������һ����������ж� 
    {
      PTD=0;
      PTD_PTD4 = 1;    //����ָʾ�����ָʾ��������֤
    }
    if(PTD_PTD1==0) 
    {
      PTD=0;
      PTD_PTD5 = 1;
    }
	KBSCR_ACKK = 1;   //����ж�ȷ�ϣ��������ж�
	KBSCR_IMASKK = 0; //�����μ����ж�
}
