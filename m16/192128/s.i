#line 1 "E:\avr资料\例程\m16\192128\s.c"




#line 1 "D:/PROGRA~1/icc/include/iom128v.h"




#line 7 "D:/PROGRA~1/icc/include/iom128v.h"


#line 11 "D:/PROGRA~1/icc/include/iom128v.h"


#line 14 "D:/PROGRA~1/icc/include/iom128v.h"


#line 17 "D:/PROGRA~1/icc/include/iom128v.h"


#line 20 "D:/PROGRA~1/icc/include/iom128v.h"






























































































































































































































































































































































































































































































































































































































































































































































































#line 6 "E:\avr资料\例程\m16\192128\s.c"
#line 1 "D:/PROGRA~1/icc/include/macros.h"






























#line 35 "D:/PROGRA~1/icc/include/macros.h"














void _StackCheck(void);
void _StackOverflowed(char);




#line 7 "E:\avr资料\例程\m16\192128\s.c"













































unsigned char data = 0;

void port_init(void)
{
(*(volatile unsigned char *)0x3B) = 0x00;
(*(volatile unsigned char *)0x3A)  = 0xFF;
(*(volatile unsigned char *)0x38) = 0x00;
(*(volatile unsigned char *)0x37)  = 0x00;
(*(volatile unsigned char *)0x35) = 0x00;
(*(volatile unsigned char *)0x34)  = 0x00;
(*(volatile unsigned char *)0x32) = 0x00;
(*(volatile unsigned char *)0x31)  = 0x00;
}





void timer0_init(void)
{
(*(volatile unsigned char *)0x53) = 0x00;
(*(volatile unsigned char *)0x52) = 0xC4;
(*(volatile unsigned char *)0x51)  = 0x3C;
(*(volatile unsigned char *)0x53) = 0x04;
}

#pragma interrupt_handler timer0_ovf_isr:10
void timer0_ovf_isr(void)
{
(*(volatile unsigned char *)0x52) = 0xC4;
 data++;
 if(data == 2)
 {
((*(volatile unsigned char *)0x3B) |=(1<<2));
 data = 0;
 }
 else
((*(volatile unsigned char *)0x3B) &= ~(1<<2));

((*(volatile unsigned char *)0x3B) |=(1<<4));
((*(volatile unsigned char *)0x3B) &= ~(1<<4));

(*(volatile unsigned char *)0x3B) = 0X0;
((*(volatile unsigned char *)0x3B) &= ~(1<<5));
((*(volatile unsigned char *)0x3B) |=(1<<5));


}





void timer1_init(void)
{
(*(volatile unsigned char *)0x4E) = 0x00;
(*(volatile unsigned char *)0x4D) = 0xE8;
(*(volatile unsigned char *)0x4C) = 0x90;
(*(volatile unsigned char *)0x4B) = 0x17;
(*(volatile unsigned char *)0x4A) = 0x70;
(*(volatile unsigned char *)0x49) = 0x17;
(*(volatile unsigned char *)0x48) = 0x70;
(*(volatile unsigned char *)0x47)  = 0x17;
(*(volatile unsigned char *)0x46)  = 0x70;
(*(volatile unsigned char *)0x4F) = 0x00;
(*(volatile unsigned char *)0x4E) = 0x01;
}

#pragma interrupt_handler timer1_ovf_isr:9
void timer1_ovf_isr(void)
{

(*(volatile unsigned char *)0x4D) = 0xE8;
(*(volatile unsigned char *)0x4C) = 0x90;
}


void init_devices(void)
{

 asm("cli");
 port_init();
 timer0_init();
 timer1_init();

(*(volatile unsigned char *)0x55) = 0x00;
 GICR  = 0x00;
(*(volatile unsigned char *)0x57) = 0x05;
 asm("sei");

}


void main(void)
{
 init_devices();
((*(volatile unsigned char *)0x3B) |=(1<<5));

}

