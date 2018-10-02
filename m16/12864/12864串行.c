#include   <reg52.h>   
  #include   <intrins.h>   
  sbit   E_CLK   =P3^0;//clock   input                                         同步时钟输入端   
  sbit   RW_SID=P3^1;//data   input/output                         串行数据输入、输出端   
  //sbit   RS_CS   =P3^5;//chip   select                                  片选端 直接接高电平  
  //sbit   PSB       =P3^6;//serial   mode   select                       串口模式 直接接地  
  //sbit   RST       =P1^2;                                         不常复位时，悬空
  void   delay(unsigned   int   n)     
  {   
      unsigned   int   i;   
      for(i=0;   i<n;   i++)   {;}   
  }   
    //串行发送一字节数据   
  void   SendByte(unsigned   char   dat)   
  {   
            unsigned   char   i;   
            for(i=0;i<8;i++)   
                        {   
       
pyp731:                              E_CLK=0;   
                                    if(dat&0x80)RW_SID=1;else   RW_SID=0;   
                                    E_CLK=1;   
                                    dat=dat<<1;   
                          }   
  }   
  //串行接收一字节数据   
  unsigned   char   ReceieveByte(void)   
  {   
            unsigned   char   i,d1,d2;   
            for(i=0;i<8;i++)   
                        {   
                                    E_CLK=0;delay(100);   //这个延迟很重要
                                    E_CLK=1;   
                                    if(RW_SID)d1++;   
                                    d1=d1<<1;   
                          }   
            for(i=0;i<8;i++)   
                        {   
                                    E_CLK=0;delay(100);   
         
pyp731:                            E_CLK=1;   
                                    if(RW_SID)d2++;   
                                    d2=d2<<1;   
                          }   
            return   (d1&0xF0+d2&0x0F);   
  }   
 /* //读取标志位BF   
  bit   ReadBF(bit   bf)   
  {   
            unsigned   char   dat;   
            SendByte(0xFA);//11111,01,0   RW=1,RS=0   
            dat=ReceieveByte();   
            if(dat>0x7F)bf=1;else   bf=0;   
            return   bf;   
            }         */      
  //写控制命令   
  void   SendCMD(unsigned   char   dat)   
  {   
  //             while(ReadBF){;}   
  //             RS_CS=1;   
            SendByte(0xF8);//11111,00,0   RW=0,RS=0   同步标志   
            SendByte(dat&0xF0);//高四位   
            SendByte((dat&0x0F)<<4);//低四位   
  //            
pyp731:  RS_CS=0;   
  }   
  //写显示数据或单字节字符   
  void   SendDat(unsigned   char   dat)   
  {   
  //             while(ReadBF){;}   
  //             RS_CS=1;   
            SendByte(0xFA);//11111,01,0   RW=0,RS=1   
            SendByte(dat&0xF0);//高四位   
            SendByte((dat&0x0F)<<4);//低四位   
  //             RS_CS=0;   
  }               
  /*             写汉字到LCD   指定的位置   
            x_add显示RAM的地址   
            dat1/dat2显示汉字编码   
  */   
  void   display(unsigned   char   x_add,unsigned   char   dat1,unsigned   char   dat2)   
  {   
            SendCMD(x_add);//1xxx,xxxx   设定DDRAM   7位地址xxx,xxxx到地址计数器AC   
            SendDat(dat1);   
            SendDat(dat2);   
  }   
  //初始化   LCM   
  void   initlcm(void)   
  {   
     //       RST=0;   
  //    
pyp731:          RS_CS=0;   
  //             PSB=0;//serial   mode   
            delay(100);   
        //    RST=1;   
            SendCMD(0x30);//功能设置，一次送8位数据，基本指令集   
          SendCMD(0x0C);//0000,1100     整体显示，游标off，游标位置off   
            SendCMD(0x01);//0000,0001   清DDRAM   
            SendCMD(0x02);//0000,0010   DDRAM地址归位   
            SendCMD(0x80);//1000,0000   设定DDRAM   7位地址000，0000到地址计数器AC   
  //             SendCMD(0x04);//点设定，显示字符/光标从左到右移位，DDRAM地址加   一   
  //             SendCMD(0x0F);//显示设定，开显示，显示光标，当前显示位反白闪动   
  }   
    
  void   main(void)   
  {   
            initlcm();   
            SendCMD(0x81);//1000,0001   设定DDRAM   7位地址000，0001到地址计数器AC   
            SendDat(0x33);   
            Send
pyp731: Dat(0x42);   
            SendDat(0x43);   
            SendDat(0x44);   
            SendCMD(0x00);   
            for(;;)   
            {   
                        delay(100);   
                        display(0x80,0xb0,0xb2);//安   
                        display(0x81,0xbb,0xD5);//徽   
                        display(0x82,0xb5,0xe7);//电   
                        display(0x83,0xc1,0xA6);//力   
                        display(0x84,0xc5,0xe0);//培   
                        display(0x85,0xD1,0xb5);//训   
                        display(0x86,0xd6,0xD0);//中   
                        display(0x87,0xd0,0xc4);//心   
                        delay(65000);   
                        SendCMD(0x00);   
                        delay(100);   
                        display(0x90,0xb0,0xb2);//安   
           
pyp731:              display(0x91,0xbb,0xD5);//徽   
                        display(0x92,0xb5,0xe7);//电   
                        display(0x93,0xc1,0xA6);//力   
                        display(0x94,0xc5,0xe0);//培   
                        display(0x95,0xD1,0xb5);//训   
                        display(0x96,0xd6,0xD0);//中   
                        display(0x97,0xd0,0xc4);//心   
                        delay(65000);   
                        SendCMD(0x00);                           
                        delay(100);   
                        display(0x88,0xb0,0xb2);//安   
                        display(0x89,0xbb,0xD5);//徽   
                        display(0x8A,0xb5,0xe7);//电   
                        display(0x8B,0xc1,0xA6);//力   
                        display(0x8C,0xc5,0xe0);//培   
             
pyp731:            display(0x8D,0xD1,0xb5);//训   
                        display(0x8E,0xd6,0xD0);//中   
                        display(0x8F,0xd0,0xc4);//心   
                        delay(65000);   
                        SendCMD(0x00);   
                        delay(100);   
                        display(0x98,0xb0,0xb2);//安   
                        display(0x99,0xbb,0xD5);//徽   
                        display(0x9A,0xb5,0xe7);//电   
                        display(0x9B,0xc1,0xA6);//力   
                        display(0x9C,0xc5,0xe0);//培   
                        display(0x9D,0xD1,0xb5);//训   
                        display(0x9E,0xd6,0xD0);//中   
                        display(0x9F,0xd0,0xc4);//心   
                        delay(65000);   
                        SendCMD(0x00);                
pyp731:            
            }   
  }   
