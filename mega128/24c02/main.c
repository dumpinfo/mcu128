//****************************************************************************** 
//源文件 
//****************************************************************************** 
#include <iom128v.h> 
#include <macros.h> 
#include"TWI.H" 
#define rd_device_add 0xA1 
#define wr_device_add 0xA0  
  
unsigned char  data1,data2,data3,data4;


unsigned char i2c_Write(unsigned char Wdata,unsigned char RomAddress)  
{ 
     unsigned char i; 
          Start();//I2C启动 
          Wait(); 
          if(TestAck()!=START) return 1;//ACK 
		  
          Write8Bit(wr_device_add);//写I2C从器件地址和写方式 
          Wait(); 
          if(TestAck()!=MT_SLA_ACK) return 1;//ACK 
		  
          Write8Bit(RomAddress);//写24C02的ROM地址 
          Wait(); 
          if(TestAck()!=MT_DATA_ACK) return 1;//ACK 
		  
          Write8Bit(Wdata);//写数据到24C02的ROM 
          Wait(); 
          if(TestAck()!=MT_DATA_ACK) return 1;//ACK
		           
          Stop();//I2C停止 
            for(i=0;i<250;i++); 
          return 0; 
} 
/****************************************** 
               I2C总线读一个字节 
                           如果读失败也返回0 
*******************************************/ 
unsigned char i2c_Read(unsigned char RomAddress)  
      { 
           unsigned char temp; 
           Start();//I2C启动 
           Wait(); 
           if (TestAck()!=START) return 0;//ACK  
		            
           Write8Bit(wr_device_add);//写I2C从器件地址和写方式 
           Wait();  
           if (TestAck()!=MT_SLA_ACK) return 0;//ACK //
		   // 
           Write8Bit(RomAddress);//写24C02的ROM地址 
           Wait(); 
           if (TestAck()!=MT_DATA_ACK) return 0; //?
		  //data1=TestAck();
           Start();//I2C重新启动 
           Wait(); 
           if (TestAck()!=RE_START)  return 0; 
		   
           Write8Bit(rd_device_add);//写I2C从器件地址和读方式 
           Wait(); 
           if(TestAck()!=MR_SLA_ACK)  return 0;//ACK 
		    
           Twi();//启动主I2C读方式 
           Wait(); 
           if(TestAck()!=MR_DATA_NOACK) return 0;//ACK         
           temp=TWDR;//读取I2C接收数据 
       Stop();//I2C停止 
           return temp; 
      } 


     void i2cini(void) 
         { 
         TWBR=163; 
      TWSR=00; 
         } 


          
void main(void) 
{     
     unsigned char i=0Xff,b = 0x0,c = 0x22,j,k; 
         
         DDRC=0xff; 
		 DDRE=0xff;
         DDRD=0xff; 
         PORTD=0; 
     i2cini(); 
        // while(1)
		// {         
        c = i2c_Write(i,0x03); 
		for(j=0;j<100;j++)
		for(k=0;k<100;k++);
		 
		b = i2c_Read(0x03); 
		PORTE = data1;
		PORTC = b;
       //  }   
} 
