int max(int a,int b);                     /*函数说明*/
main()                                /*主函数*/
{
  int x,y,z;                          /*整型变量说明*/
  printf("input two numbers:\n");  
  scanf("%d%d",&x,&y);               /*输入x,y值*/
  z=max(x,y);                        /*调用max函数*/
  printf("maxmum=%d",z);             /*输出结果*/
}
int max(int a,int b)                       /*定义max函数*/
{
  if(a>b)
    return a;
  else 
    return b;              //把结果返回主调函数
}
