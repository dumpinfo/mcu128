#include <signal.h>
#include <unistd.h>
#define IOPMOD   (*(volatile unsigned *)0x3ff5000)
#define IOPDATA  (*(volatile unsigned *)0x3ff5008)
int i=0;
static void sig_alarm(int signumber)                     //��SIGALRM�źŲ���,ִ��
{
    if(i==3) i=0;
    IOPDATA=i++;                                //�޸�I/O�����ݼĴ���
    alarm(2);                                      //�趨һ��2��Ķ�ʱ
}
int main(void)
{
    IOPMOD=0xff;
    if(signal(SIGALRM,sig_alarm)==SIG_ERR)
    {
	printf("some error occurs\n");                    //����
        return  1;
    }
    alarm(2);                                       //�趨һ��2��Ķ�ʱ
    while(1);
    return 0;
}
