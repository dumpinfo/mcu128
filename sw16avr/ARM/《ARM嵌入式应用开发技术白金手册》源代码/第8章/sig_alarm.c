#include <signal.h>
#include <unistd.h>
#define IOPMOD   (*(volatile unsigned *)0x3ff5000)
#define IOPDATA  (*(volatile unsigned *)0x3ff5008)
int i=0;
static void sig_alarm(int signumber)                     //有SIGALRM信号产生,执行
{
    if(i==3) i=0;
    IOPDATA=i++;                                //修改I/O口数据寄存器
    alarm(2);                                      //设定一个2秒的定时
}
int main(void)
{
    IOPMOD=0xff;
    if(signal(SIGALRM,sig_alarm)==SIG_ERR)
    {
	printf("some error occurs\n");                    //报错
        return  1;
    }
    alarm(2);                                       //设定一个2秒的定时
    while(1);
    return 0;
}
