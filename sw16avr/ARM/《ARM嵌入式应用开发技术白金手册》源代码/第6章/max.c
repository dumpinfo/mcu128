int max(int a,int b);                     /*����˵��*/
main()                                /*������*/
{
  int x,y,z;                          /*���ͱ���˵��*/
  printf("input two numbers:\n");  
  scanf("%d%d",&x,&y);               /*����x,yֵ*/
  z=max(x,y);                        /*����max����*/
  printf("maxmum=%d",z);             /*������*/
}
int max(int a,int b)                       /*����max����*/
{
  if(a>b)
    return a;
  else 
    return b;              //�ѽ��������������
}
