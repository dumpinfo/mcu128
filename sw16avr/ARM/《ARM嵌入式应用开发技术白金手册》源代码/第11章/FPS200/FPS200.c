/*

测试FPS200

*/
#include "GloblDef.h"
#include "ioregs.h" 
#include "flash.h"
#include "put.h"
#include "fps200.h"

int s_addr;
void DelayRowCapture()
{
	// (28 + DTR_TIME) * 1/12M
	WORD i;
	for(i = 0;i<100;i++)
		i = i;
}

void DelayADConvert()
{
	// 6 * 1/12M
	WORD i;
	for(i = 0;i<15;i++)
		i = i;
}
void Delay30us()
{
	WORD i;
	for(i = 0;i<600;i++)
		i = i;
}
WORD FPSReadID()
{
	BYTE IDH,IDL;

	FPS_INDEX = FPS_CIDL;
	IDL = FPS_DATA;
	
	FPS_INDEX = FPS_CIDH;
	IDH = FPS_DATA;

	return (((WORD)IDH)<<8 | (WORD)IDL);
}
void FPSInitial()
{
	///////////
	// important initial

	// control register B
	FPS_INDEX = FPS_CTRLB;
	FPS_DATA = FPS_CTRLB_AUTOINCEN | FPS_CTRLB_ENABLE;	// row auto inc. inner 12MHz vibrator. no low-power state

	// wait for 30us
	Delay30us();
	
	// discharge time register
	FPS_INDEX = FPS_DTR;
	FPS_DATA = FPS_DTR_TIME;

	// discharge current register
	FPS_INDEX = FPS_DCR;
	FPS_DATA = FPS_DCR_CURRENT;
	
	// programmable gain control register
	FPS_INDEX = FPS_PGC;
	FPS_DATA = FPS_PGC_VALUE;	// default value

	/////////////
	// other initial

	FPS_INDEX = FPS_RAH;
	FPS_DATA = 0;

	FPS_INDEX = FPS_RAL;
	FPS_DATA = 0;

	FPS_INDEX = FPS_CAL;
	FPS_DATA = 0;

	FPS_INDEX = FPS_REH;
	FPS_DATA = 0;

	FPS_INDEX = FPS_REL;
	FPS_DATA = 0;

	FPS_INDEX = FPS_CEL;
	FPS_DATA = 0;

	FPS_INDEX = FPS_CTRLC;
	FPS_DATA = 0;
	
	FPS_INDEX = FPS_CTRLA;	// clear FPS_CTRLA_AINSEL
	FPS_DATA = 0;

	// interrupt control regsiter
	FPS_INDEX = FPS_ICR;
	FPS_DATA = FPS_ICR_IT0_LEVEL | FPS_ICR_IE0;	//faling edage, level triger, no mask, enable
   
	// Threshold Register
	FPS_INDEX = FPS_THR;
	FPS_DATA = FPS_THR_THV | FPS_THR_THC;
	
}

void FPSRow(WORD RowI)
{
	// First load the RAH and RAL registers with the address of the row to be fetched. Then write the CTRLA
	// register to initiate a GETROW operation. Finally, read the CTRLA register 256 times to retrieve the row
	// data.

	WORD i;
	// Write RAH
	FPS_INDEX = FPS_RAH;
	FPS_DATA = (BYTE)(RowI>>8);

	// Write RAL
	FPS_INDEX = FPS_RAL;
	FPS_DATA = (BYTE)RowI;

	// row capture
	FPS_INDEX = FPS_CTRLA;
	FPS_DATA = FPS_CTRLA_GETROW ;

	// Wait row capture time
	DelayRowCapture();

	for(i = 0;i<COL_NUM;i++)
	{
		//put_num8(FPS_DATA);
		//put_char(' ');
		//RAM_BYTE(s_addr++)=FPS_DATA;
		RAM_BYTE(s_addr)=FPS_DATA;
		DelayADConvert();
	}
	
}
/*
void FPSImg()
{
	// No row or column registers need to be loaded prior to starting a GETIMG operation. The sensor will
	// automatically begin A/D conversion at row zero, column zero.

	WORD row,col;

	// Write CTRLA with 0x02.
	FPS_INDEX = FPS_CTRLA;
	FPS_DATA = FPS_CTRLA_GETIMG ;

	for(row = 0; row < ROW_NUM; row++)
	{
		// Wait Row Capture Time.
		DelayRowCapture();
		for(col = 0; col < COL_NUM; col++)
		{
			// Read CTRLA.
			put_num8(FPS_DATA);

			// Wait A/D Conversion Time.
			DelayADConvert();
		}
	}
	
}

void FPSSub(WORD RowStart,WORD RowEnd,BYTE ColStart,BYTE ColEnd)
{
	WORD row,col;

	// Write RAH.
	FPS_INDEX = FPS_RAH;
	FPS_DATA = (BYTE)(RowStart>>8);

	// Write RAL.
	FPS_INDEX = FPS_RAL;
	FPS_DATA = (BYTE)RowStart;
	
	// Write CAL.
	FPS_INDEX = FPS_CAL;
	FPS_DATA = ColStart;

	// Write REH.	
	FPS_INDEX = FPS_REH;
	FPS_DATA = (BYTE)(RowEnd>>8);
	
	// Write REL.
	FPS_INDEX = FPS_REL;
	FPS_DATA = (BYTE)RowEnd;

	// Write CEL.
	FPS_INDEX = FPS_CEL;
	FPS_DATA = ColEnd;

	// Write CTRLA with 0x04.
	FPS_INDEX = FPS_CTRLA;
	FPS_DATA = FPS_CTRLA_GETSUB ;

	for(row = RowStart; row <= RowEnd; row++)
	{
		// Wait Row Capture Time.
		DelayRowCapture();

		for(col = ColStart; col <= ColEnd; col++)
		{
			// Read CTRLA.
			put_num8(FPS_DATA);

			// Wait A/D Conversion Time.
			DelayADConvert();
		}
	}
}

*/

void FPSAin()
{
	// ROW
	FPS_INDEX = FPS_CTRLA;
	FPS_DATA = FPS_CTRLA_GETROW | FPS_CTRLA_AINSEL;
	
	DelayADConvert();
	put_num8(FPS_DATA);
	
	// IMG
	FPS_INDEX = FPS_CTRLA;
	FPS_DATA = FPS_CTRLA_GETIMG | FPS_CTRLA_AINSEL;
	
	DelayADConvert();
	put_num8(FPS_DATA);
	
	// Write CTRLA with 0x04.
	FPS_INDEX = FPS_CTRLA;
	FPS_DATA = FPS_CTRLA_GETSUB | FPS_CTRLA_AINSEL;
	
	DelayADConvert();
	put_num8(FPS_DATA);
}

/*
// delay more
void FPSAin2()
{
	WORD i;
	// ROW
	FPS_INDEX = FPS_CTRLA;
	FPS_DATA = FPS_CTRLA_GETROW | FPS_CTRLA_AINSEL;
	
		for(i=0;i<100;i++)
	DelayADConvert();
	put_num8(FPS_DATA);
	
	// IMG
	FPS_INDEX = FPS_CTRLA;
	FPS_DATA = FPS_CTRLA_GETIMG | FPS_CTRLA_AINSEL;
	
	for(i=0;i<100;i++)
		DelayADConvert();
	put_num8(FPS_DATA);
	
	// Write CTRLA with 0x04.
	FPS_INDEX = FPS_CTRLA;
	FPS_DATA = FPS_CTRLA_GETSUB | FPS_CTRLA_AINSEL;
	
	for(i=0;i<100;i++)
		DelayADConvert();
	put_num8(FPS_DATA);
}

void FPSToggle()
{
	FPS_INDEX = FPS_CTRLC;
	//FPS_DATA = 0;	//p0 is 0
	FPS_DATA = 0x04;	// p0 is toggle
}
*/
/*
// 测试SRA中标志位是否清除，当读完最后一个byte.如果清除，说明内部寄存器在计数
// 说明内部已经启动了图像的转化。
BYTE FPSImgIncTest()
{
	WORD row,col;
	BYTE temp;
	
	//FPS_INDEX = FPS_CTRLB;
	//FPS_DATA =  FPS_CTRLB_ENABLE;	// row auto inc. inner 12MHz vibrator. no low-power state

	// GET IMG TEST
	FPS_INDEX = FPS_CTRLA;
	FPS_DATA = FPS_CTRLA_GETIMG ;

	for(row = 0; row < ROW_NUM; row++)
	{
		// Wait Row Capture Time.
		DelayRowCapture();
		for(col = 0; col < COL_NUM; col++)
		{
			// test SRA
			FPS_INDEX = FPS_SRA;
			if(FPS_DATA != FPS_CTRLA_GETIMG)
				return 0;
				
			// Read CTRLA.
			FPS_INDEX = FPS_CTRLA;
			temp = FPS_DATA;
			
			// Wait A/D Conversion Time.
			DelayADConvert();
		}
	}
	put_char('a');
	FPS_INDEX = FPS_SRA;
	if(FPS_DATA != 0)
		return 0;
	put_char('b');
	
	// GET ROW TEST
	// Write RAH
	FPS_INDEX = FPS_RAH;
	FPS_DATA = 0;

	// Write RAL
	FPS_INDEX = FPS_RAL;
	FPS_DATA = 0;

	// row capture
	FPS_INDEX = FPS_CTRLA;
	FPS_DATA = FPS_CTRLA_GETROW ;

	// Wait row capture time
	DelayRowCapture();

	for(col = 0;col<COL_NUM;col++)
	{
		// test SRA
		FPS_INDEX = FPS_SRA;
		if(FPS_DATA != FPS_CTRLA_GETROW)
			return 0;
		// AD busy?
		FPS_INDEX = FPS_CTRLB;
		if((FPS_DATA & 0x20) == 0)
			put_char('!');
			
		// Read CTRLA.
		FPS_INDEX = FPS_CTRLA;
		temp = FPS_DATA;
		DelayADConvert();
	}
	put_char('c');
	
	FPS_INDEX = FPS_CTRLB;
	put_num8(FPS_DATA);
	
	FPS_INDEX = FPS_SRA;
	if(FPS_DATA != 0)
	{
		put_num8(FPS_DATA);
		return 0;
	}
	put_char('d');
	
	// GET SUB test
	// Write RAH.
	FPS_INDEX = FPS_RAH;
	FPS_DATA = 0;

	// Write RAL.
	FPS_INDEX = FPS_RAL;
	FPS_DATA = 0;
	
	// Write CAL.
	FPS_INDEX = FPS_CAL;
	FPS_DATA = 0;

	// Write REH.	
	FPS_INDEX = FPS_REH;
	FPS_DATA = 0;
	
	// Write REL.
	FPS_INDEX = FPS_REL;
	FPS_DATA = 10;

	// Write CEL.
	FPS_INDEX = FPS_CEL;
	FPS_DATA = 0;

	// Write CTRLA with 0x04.
	FPS_INDEX = FPS_CTRLA;
	FPS_DATA = FPS_CTRLA_GETSUB ;

	for(row = 0; row <= 0; row++)
	{
		// Wait Row Capture Time.
		DelayRowCapture();

		for(col = 0; col <= 10; col++)
		{
			// test SRA
			FPS_INDEX = FPS_SRA;
			if(FPS_DATA != FPS_CTRLA_GETSUB)
				return 0;
				
			// Read CTRLA.
			FPS_INDEX = FPS_CTRLA;
			temp = FPS_DATA;
			
			// Wait A/D Conversion Time.
			DelayADConvert();
		}
	}
	put_char('e');
	FPS_INDEX = FPS_CTRLB;
	put_num8(FPS_DATA);
	FPS_INDEX = FPS_SRA;
	if(FPS_DATA != 0)
	{
		return 0;
	}
	put_char('f');
	
	return 1;
}
*/	
	

	
BYTE FPSMode()
{
	BYTE value;
	FPS_INDEX = FPS_CTRLB;
	value = FPS_DATA;

	return (value>>6);
}

BYTE RegTest(BYTE reg,BYTE value)
{
	FPS_INDEX = reg;
	FPS_DATA = value;
	if(FPS_DATA != value)
		return FALSE;
	else
		return TRUE;
}
/*
BYTE FPSRegTest()
{
	WORD i;
	BYTE temp;

	//////////
	// test write read 0--255 to some regs

	for(i = 0, temp = 0; i < 256; i++, temp++)
	{
		// RAH REH
		if(i < 0x2)
		{
			if(RegTest(FPS_RAH,temp) == FALSE)
				return FALSE;
			if(RegTest(FPS_REH,temp) == FALSE)
				return FALSE;
		}

		// FPS_RAL FPS_CAL FPS_REL FPS_CEL FPS_ICR
		if(i < 256)
		{
			if(RegTest(FPS_RAL,temp) == FALSE)
				return FALSE;
			if(RegTest(FPS_CAL,temp) == FALSE)
				return FALSE;
			if(RegTest(FPS_REL,temp) == FALSE)
				return FALSE;
			if(RegTest(FPS_CEL,temp) == FALSE)
				return FALSE;
			if(RegTest(FPS_ICR,temp) == FALSE)
				return FALSE;
			if(RegTest(FPS_CTRLC,temp) == FALSE)
				return FALSE;
		}

		// FPS_DTR
		if(i < 0x80)
		{
			if(RegTest(FPS_DTR,temp) == FALSE)
				return FALSE;
		}

		// FPS_DCR
		if(i < 0x20)
		{
			if(RegTest(FPS_DCR,temp) == FALSE)
				return FALSE;
		}

		
		if(i < 0x10)
		{
			// FPS_PGC
			if(RegTest(FPS_PGC,temp) == FALSE)
				return FALSE;

			// FPS_CTRLB
			FPS_INDEX = FPS_CTRLB;
			FPS_DATA = temp&0x0f;
			if((FPS_DATA &0x0f) != temp)
				return FALSE;

		}

		// FPS_THR
		if(i < 0x40)
		{
			if(RegTest(FPS_THR,temp) == FALSE)
				return FALSE;
		}

		// test FPS_SRA reflect FPS_CTRLA
		if(i == FPS_CTRLA_GETSUB || i == FPS_CTRLA_GETIMG || i == FPS_CTRLA_GETROW ||
			i == (FPS_CTRLA_GETSUB | FPS_CTRLA_AINSEL) || i == (FPS_CTRLA_GETIMG | FPS_CTRLA_AINSEL) || 
			i == (FPS_CTRLA_GETROW || FPS_CTRLA_AINSEL))
		{
			FPS_INDEX = FPS_CTRLA;
			FPS_DATA = temp;
			FPS_INDEX = FPS_SRA;
			if(FPS_DATA	!= temp)
				return FALSE;
		}
	}

	// FPS_TST
	if(RegTest(FPS_THR,0) == FALSE)
		return FALSE;

	// FPS_CIDH == 0x20, and can't change
	FPS_INDEX = FPS_CIDH;
	temp = FPS_DATA;
	FPS_DATA = temp + 1;
	if(FPS_DATA	!= temp)
		return FALSE;

	// FPS_CIDL can't change
	FPS_INDEX = FPS_CIDL;
	temp = FPS_DATA;
	FPS_DATA = temp + 1;
	if(FPS_DATA	!= temp)
		return FALSE;
	return 1;
}
*/
/*void FPSChangePara(BYTE t,BYTE i,BYTE g)
{
	// discharge time register
	FPS_INDEX = FPS_DTR;
	FPS_DATA = t;

	// discharge current register
	FPS_INDEX = FPS_DCR;
	FPS_DATA = i;
	
	// programmable gain control register
	FPS_INDEX = FPS_PGC;
	FPS_DATA = g;	// default value
}
void GetPara()
{
	static BYTE t=1,i=1,g=0;
	
	switch(get_char())
	{
		case 't':
			t += 0x3a;
			if(t>0x7f)
				t = 1;
			break;
		case 'i':
			i += 0x0a;
			if(i>0x1f)
				i = 1;
			break;
		case 'g':
			g += 0x07;
			if(g > 0x0f)
				g = 0;
			break;
		default:
			put_char('e');
	}
	put_num8(t);
	put_num8(i);
	put_num8(g);
	FPSChangePara(t,i,g);
}
*/	
void  C_vMain(void)
{
	DWORD i,j,k;
	
	get_char();
		
	put_num16(FPSReadID());
	
	put_num8(FPSMode());
	
	//////////////////
	// test regs
	
/*	if(FPSRegTest() == 1)
		put_char('o');
	else
		put_char('f');
*/		
	FPSInitial();
	////////////////////
	// anolog input
	/*
	put_char('\n');
	put_char('A');
	put_char('\n');
	FPSAin();
	*/
	///////////////
	//  get image
	/*
	put_char('I');
	put_char('\n');
	FPSImg();*/
	
	/////////////////
	//get image by row
	s_addr=0;
		while(1);{
		for(j=0;j<300;j++)
		FPSRow(j);}
	put_char('O');
	
	s_addr=0;
	k=0;
	for(j=0;j<256*300;j++){
			
		put_num8(RAM_BYTE(s_addr++));
		put_char(' ');
		k++;
		if(k==8000)
			{get_char();
			k=0;}
		
	}	
	while(1);
	////////////////////
	// get sub
	/*
	put_char('\n');
	put_char('S');
	put_char('\n');
	FPSSub();
	*/
}