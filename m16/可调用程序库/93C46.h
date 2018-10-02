//采用模拟时序

#define Port PORTA

#define CS 1<<0
#define SK 1<<1
#define DI 1<<2
#define DO 1<<3

#define CLEAR_CS() (Port &= ~CS)
#define CLEAR_SK() (Port &= ~SK)
#define CLEAR_DI() (Port &= ~DI)
#define CLEAR_DO() (Port &= ~DO)

#define SET_CS() (Port |= CS)
#define SET_SK() (Port |= SK)
#define SET_DI() (Port |= DI)
#define SET_DO() (Port |= DO)        //定义几个口位的操作

#define uchar  unsigned char
#define de 100

 //延时程序
void _delay(int LM_us)
 {while(LM_us)
   {
     LM_us--;
	 NOP();
   }
 }
 
            /****************************************
            start bit: 1, op: 10, addr : A6--A0;*****
            addrx=1 10 a6a5a4a3a2a1a0 : 10 number ***
            ******* read_9346()   8bit  
            ****************************************/

            unsigned  char  read_9346(uchar addrx)
            {
            uchar i;
            unsigned char j=0x00;
            SET_CS(); _delay(de);
            CLEAR_SK(); _delay(de);
            SET_DI(); //1 1 0
            SET_SK(); _delay(de);
            CLEAR_SK(); _delay(de);
            SET_DI();
            SET_SK();_delay(de);
            CLEAR_SK();_delay(de);
            CLEAR_DI();
            SET_SK();_delay(de);
            CLEAR_SK();_delay(de);
            // a6---a0 valid 7 bit data;so follow
            for(i=0;i<7;i++)
            { addrx<<=1;
             di=(addrx&0x80);
              SET_SK();_delay(de);
              CLEAR_SK();_delay(de);
            }
            dod=1;
              // return char 8 bit data;
              for(i=0;i<8;i++)
              {//j=(j<<1)|dod;
              SET_SK();_delay(de);
              j=(j<<1)|dod;
              CLEAR_SK();_delay(de);
            }
            CLEAR_CS();
            return j;
            }


/****************************************
            ********** en_ dis write_ erase()  8bit
            *****************************************/
            void en_dis(uchar a)
            {
            uchar i,en_dis;
            SET_CS(); _delay(de);
            CLEAR_SK(); _delay(de);
            SET_DI(); //1 0 0
            SET_SK(); _delay(de);
            CLEAR_SK(); _delay(de);
            CLEAR_DI();
            SET_SK();_delay(de);
            CLEAR_SK();_delay(de);
            CLEAR_DI();
            SET_SK();_delay(de);
            CLEAR_SK();_delay(de);
            if(a>=1)en_dis=0xc0;else en_dis=0x00;  //11x_xxxxb
            for(i=0;i<7;i++)
            { 
            di=en_dis&0x80;
            SET_SK();_delay(de);
            CLEAR_SK();_delay(de);
            en_dis<<=1;
            }
            CLEAR_CS();
            }
            /*********************************************
            ******* void erase_all93c46(void)***********
            a>0 write a=0; erase 
            *********************************************/
            void erase(void)
            { 
            uchar i,erase;
            SET_CS(); _delay(de);
            CLEAR_SK(); _delay(de);
            SET_DI(); //1 0 0
            SET_SK(); _delay(de);
            CLEAR_SK(); _delay(de);
            CLEAR_DI();
            SET_SK();_delay(de);
            CLEAR_SK();_delay(de);
            CLEAR_DI();
            SET_SK();_delay(de);
            CLEAR_SK();_delay(de);
            //if(a>0)erase=0x40;else erase=0x20;
            erase=0x80;
            for(i=0;i<7;i++)
            {
            di=erase&0x80;
            SET_SK();_delay(de);
            CLEAR_SK();_delay(de);
            erase<<=1;
            }
            CLEAR_CS();
            }

            /*****************************************
            ********void  write_all_93c46(uchar a)
            *****************************************/

            void   write_all(unsigned char  ax)
            {
            uchar i,erase;
            CLEAR_CS(); _delay(de);
            CLEAR_SK(); _delay(de);
            SET_CS(); _delay(de);

            SET_DI(); //1 0 0
            SET_SK(); _delay(de);
            CLEAR_SK(); _delay(de);
            CLEAR_DI();
            SET_SK();_delay(de);
            CLEAR_SK();_delay(de);
            CLEAR_DI();
            SET_SK();_delay(de);
            CLEAR_SK();_delay(de);
            erase=0x40; //01x_xxxxb
            //if(a>0)erase=0x40;else erase=0x20;
            for(i=0;i<7;i++)
            {

            di=erase&0x80;//if((erase&0x80)>0)SET_DI();else CLEAR_DI();
            SET_SK();_delay(de);
            CLEAR_SK();_delay(de);
            erase<<=1;
            }
            //dod=1;
            for(i=0;i<8;i++)
            {
            di=ax&0x80;

            SET_SK();_delay(de);
            CLEAR_SK();_delay(de);
            ax<<=1;

            }
            //ax<<=1;
            //di=ax&0x80;
            CLEAR_CS();_delay(30);dod=1;;SET_CS();
            SET_SK();_delay(de);
            CLEAR_SK();_delay(de);
            //_delay(de);SET_CS();
            /*_delay(de); dod=1;
            SET_CS(); SET_SK();_delay(de);
            while(dod==0) {
            CLEAR_SK();_delay(de);
            SET_SK();_delay(de);
            }
            CLEAR_SK();*/ CLEAR_CS();
            }

            /**********************************
            **********************************/
            