void main (void) 
{
/*------------------------------------------------
���ô���4800�����ʣ�12MHzʱ��
------------------------------------------------*/
    SCON  = 0x50;		   /* SCON: mode 1, 8-bit UART, enable rcvr      */
    TMOD |= 0x20;                  /* TMOD: timer 1, mode 2, 8-bit reload        */
    TH1   = 0xFA;                  /* TH1:  reload value for 4800 baud @ 12MHz */
    TR1   = 1;                     /* TR1:  timer 1 run                      */
    TI    = 1;                     /* TI:   set TI to send first char of UART    */
/*------------------------------------------------
ѭ����ִ��
------------------------------------------------*/
    while (1) 
    {
        P1 ^= 0x01;     	   /* Toggle P1.0 each time we print */
 	printf ("Hello World\n");  /* Print "Hello World" */
    }
}
