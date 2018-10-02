#include "GloblDef.h"
#include "fps200.h"

extern void FPSCapture(BYTE xdata * buf);
extern void FPSInitial();
extern WORD FPSReadID();
extern void FPSTest();
extern BYTE FPSRegTest(BYTE radom);
extern void FPSToggle();


BYTE xdata FpsBuf[READ_SIZE];

void SerialInitial()
{
	/* set TI to 1, set TR1 to 1,if use scanf set RI=1 */
	SCON = 0x52;/* SM0 SM1 =1 SM2 REN TB8 RB8 TI RI */
	TMOD = 0x20;/* GATE=0 C/T-=0 M1 M0=2 GATE C/T- M1 M0 */
	TH1 = 0xE6;	/* 4800 when at 24MHz */
	PCON = 0x80;
	TCON = 0x40;/* 01101001 TF1 TR1 TF0 TR0 IE1 IT1 IE0 IT */
}
main()
{
	WORD i;

	SerialInitial();

	if(FPSRegTest(2) == TRUE)
		printf("\n reg ok!");
	else
		printf("\n reg fail!");
	
	FPSInitial();
	//FPSToggle();
	//while(1);
	
	
	FPSCapture(FpsBuf);
	
	for(i = 0; i < READ_SIZE; i++)
		printf("%c",FpsBuf[i]);
	
	while(1);
}
