// 单片机演唱歌 刀郎《2002年的第一场雪》
// 作者：chenming
// 出处：伟纳电子论坛  www.willar.com



#include <reg51.h>
sbit SPK=P3^7;
void delayms(unsigned char ms);
unsigned int data j;
unsigned char code song[636]={ 0xFF,0xFF,4,0xFd,0x08,2,0xFd,0x08,2,0xFd,0x08,2,0xFd,0x08,2,0xFd,0x08,2,0xfd,0x08,2,				//21
							  0xFD,0x5B,4,0xFD,0x08,2,0xFC,0xAB,2,0xFC,0x0B,2,0xFC,0x0B,2,0xff,0xff,2,0xFc,0x0B,2,				//21
							  0xFC,0xAB,2,0xFC,0xAB,2,0xFC,0xAB,2,0xFC,0xAB,2,0xFC,0xAB,4,0xFC,0xAB,2,0xFC,0xAB,2,				//21	
							  0xFB,0x8F,2,0xFC,0x0B,2,0xFC,0x0B,4,0xff,0xff,8,									 				//12
							  0xff,0xff,2,0xFD,0x08,2,0xFD,0x08,2,0xFD,0x08,2,0xFD,0x08,4,0xFD,0x08,2,0xFD,0x08,2,				//21
							  0xFD,0x5B,4,0xFD,0x08,2,0xFC,0xAB,4,0xFD,0x08,6,                                  				//12
							  0xff,0xff,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x03,2,0xFA,0x14,2,  //24
							  0xFC,0xAB,4,0xFC,0xAB,2,0xFC,0xAB,2,0xFC,0xAB,2,0xFC,0x0B,2,0xFC,0x0B,4,							//18
							  0xFF,0xFF,4,0xFD,0x08,2,0xFD,0x08,2,0xFD,0x08,2,0xFD,0x08,2,0xFD,0x08,2,0xFD,0x08,2,				//21	
							  0xFD,0x5B,4,0xFD,0x08,2,0xFC,0xAB,4,0xFD,0x08,6,											    	//12,183
						      0xFF,0xFF,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x03,2,0xFA,0x14,2,  //24
							  0xFC,0xAB,4,0xFC,0xAB,2,0xFC,0xAB,2,0xFC,0xAB,2,0xFC,0x0B,2,0xFC,0x0B,4,						    //18
						      0xFF,0xFF,4,0xFd,0x08,2,0xFd,0x08,2,0xFd,0x08,2,0xFd,0x08,2,0xFd,0x08,2,0xfd,0x08,2,				//21
                              0xFD,0x5B,4,0xFD,0x08,2,0xFD,0x5B,2,0xFC,0xAB,2,0xFC,0x0B,2,0xFC,0x0B,4,							//18
							  0xFF,0xFF,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x03,2,0xFB,0x8F,4,0xFB,0x8F,2,0xFB,0x03,2,				//21
							  0xFC,0x0B,4,0xFB,0x8F,2,0xFC,0x0B,2,0xFB,0x03,2,0xfa,0x14,2,0xfa,0x14,4,                          //18
						      0xFF,0xFF,2,0xFD,0x08,2,0xFD,0x08,2,0xFD,0x08,2,0xFD,0x08,2,0xFD,0x08,2,0xFD,0x08,2,0xFD,0x08,2,  //24
							  0xFD,0x5B,4,0xFD,0x08,2,0xFD,0x5B,2,0xFC,0xAB,2,0xFC,0x0B,2,0xFC,0x0B,4,							//18
							  0xff,0xff,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x03,2,0xFA,0x14,2,  //24
							  0xfc,0xab,4,0xfc,0xab,2,0xfc,0xab,2,0xfb,0x8f,2,0xfc,0x0b,2,0xFC,0x0B,4,						    //18,204
							  0xFF,0xFF,2,0xFd,0x08,2,0xFd,0x08,2,0xFd,0x08,2,0xFd,0x08,2,0xFd,0x08,4,0xFd,0x08,2,	            //21
							  0xfd,0x5b,4,0xfd,0x08,2,0xfc,0xab,4,0xfc,0x0b,6,													//12
							  0xFF,0xFF,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x03,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x03,2,	//24	
						      0xFC,0x0B,4,0xFB,0x8F,2,0xFC,0x0B,2,0xFB,0x03,2,0xfa,0x14,2,0xfa,0x14,4,							//18	
						      0xff,0xff,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x03,2,0xFA,0x14,2,  //24
							  0xfb,0x03,2,0xfb,0x03,2,0xfb,0x03,2,0xfa,0x14,2,0xfa,0x14,1,0xf9,0x5b,1,0xf8,0x2a,2,0xf8,0x2a,4,  //24
							  0xff,0xff,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x03,2,0xFA,0x14,2,  //24
							  0xfb,0x8f,2,0xfc,0x08,2,0xfc,0x08,2,0xfc,0x08,10,													//12
							  0xff,0xff,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x03,2,0xFA,0x14,2,  //24
							  0xfb,0x03,2,0xfb,0x03,2,0xfb,0x03,2,0xfa,0x14,2,0xfa,0x14,1,0xf9,0x5b,1,0xf8,0x2a,2,0xf8,0x2a,4,  //24,207				
							  0xff,0xff,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x8F,2,0xFB,0x03,2,0xFA,0x14,2,  //24
							  0xfc,0xab,2,0xfd,0x08,2,0xfd,0x08,2,0xfd,0x08,2,0xff,0xff,4,0xff,0xff,4};							//18,42,636	

void main()
{	TMOD = 0x01;
	IE = 0x82;
		while(1)
		{	j=0;
   		 	while (j<636)
			 	{	TR0=1;
			  		if ((song[j]==0xff)&&(song[j+1]==0xff)) TR0=0;//休止符用0xff,0xff表示,出现休止符时CT0禁止,不发声.
			  		delayms(song[j+2]);							  //每一音符唱多长.
		 	  		j=j+3;
			 	}
		}
}

void timer0() interrupt 1 using 1								  //每一音符唱多高
{	TH0=song[j];
	TL0=song[j+1];
	SPK = !SPK;	
}
void delayms(unsigned char ms)									  //基本延时子程序(16分之1拍的时间)
{	unsigned int i;	
	while(ms--)
	{
		for(i = 0; i < 20300; i++);
	}
	TR0=0;
	
}
