#include<stdio.h>                    /*scanf和printf标准输入输出函数、main主函数，需要stdio.h */
                                    /*include称为文件包含命令, 扩展名为.h的文件也称为头文件或首部文件*/
#include<math.h>                           /*正弦函数sin，需要math.h */
main()          
{
     double x,s;                          /* 定义两个实数变量，以被后面程序使用，sin双精度浮点型*/
                                         /* sin函数需要使用双精度浮点型，使用类型double*/
     printf("input number:\n");         /* 显示提示信息*/
     scanf("%lf",&x);                  /*从键盘获得一个实数x */
     s=sin(x);                        /*求x的正弦，并把它赋给变量s */
    printf("sine of %lf is %lf\n",x,s);   /*显示程序运算结果*/
                                     /* %lf为格式字符，表示按双精度浮点数处理，对应了x和s两个变量*/
                                    /*"%d"表示按十进制整型输出，"%ld"表示按十进制长整型输出，*/
                                   /*"%c"表示按字符型输出。*/
}	                              /* main函数结束*/ 
