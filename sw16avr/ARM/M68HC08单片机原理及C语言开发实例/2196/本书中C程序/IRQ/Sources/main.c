#include <hidef.h> /* for EnableInterrupts macro */
#include <MC68HC908SR12.h> /* include peripheral declarations */

void main(void) {
	CONFIG1 = 0x39;
    DDRD = 0xFF;	   //PortD����Ϊ���
	PTD = 0x00;        //PortD�����Ϊ�͵�ƽ ���ж��޹ؽ�Ϊָʾ����			
	INTSCR1_IMASK1 = 0;//����IRQ1�ж�
	INTSCR1_MODE1 = 1; //������ʽѡ��Ϊ�½��غ͵͵�ƽ
    EnableInterrupts;  //enable interrupts 
    for(;;);		   //��ѭ��
}
/*IRQ1�жϷ������*/
interrupt  void IRQ1_ISR(void)
{
	INTSCR1_IMASK1 = 1;//Ϊ��ֹ���жϣ������ж�
	PTD_PTD4 = 1;
	PTD_PTD5 = 1;      //ͨ�������ڿ�����������ܣ�ָʾ�Ƿ�������ж�
	INTSCR1_ACK1 = 1;  //ȷ���жϣ�����ж�����
	INTSCR1_IMASK1 = 0;//�˳�ǰ�����ж�	
}
