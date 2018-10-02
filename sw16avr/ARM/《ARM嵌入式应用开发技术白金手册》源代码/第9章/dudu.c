#include <stdio.h>
static void display(int i, int *ptr);
int main(void) 
{
        int x = 5;
	int *xptr = &x;                                         //指针赋值
	printf("In main():\n");
    	printf("   x is %d and is stored at %p.\n", x, &x);
   	printf("   xptr holds %p and points to %d.\n", xptr, *xptr);
   	display(x, xptr);                                       //调用display函数
   	return 0;
}
void display(int z, int *zptr)                                      
 {
	printf("In display():\n");
   	printf("   z is %d and is stored at %p.\n", z, &z);
   	printf("   zptr holds %p and points to %d.\n", zptr, *zptr);
}
