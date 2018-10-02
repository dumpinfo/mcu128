//****************************************************************************** 
//Դ�ļ� 
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
          Start();//I2C���� 
          Wait(); 
          if(TestAck()!=START) return 1;//ACK 
		  
          Write8Bit(wr_device_add);//дI2C��������ַ��д��ʽ 
          Wait(); 
          if(TestAck()!=MT_SLA_ACK) return 1;//ACK 
		  
          Write8Bit(RomAddress);//д24C02��ROM��ַ 
          Wait(); 
          if(TestAck()!=MT_DATA_ACK) return 1;//ACK 
		  
          Write8Bit(Wdata);//д���ݵ�24C02��ROM 
          Wait(); 
          if(TestAck()!=MT_DATA_ACK) return 1;//ACK
		           
          Stop();//I2Cֹͣ 
            for(i=0;i<250;i++); 
          return 0; 
} 
/****************************************** 
               I2C���߶�һ���ֽ� 
                           �����ʧ��Ҳ����0 
*******************************************/ 
unsigned char i2c_Read(unsigned char RomAddress)  
      { 
           unsigned char temp; 
           Start();//I2C���� 
           Wait(); 
           if (TestAck()!=START) return 0;//ACK  
		            
           Write8Bit(wr_device_add);//дI2C��������ַ��д��ʽ 
           Wait();  
           if (TestAck()!=MT_SLA_ACK) return 0;//ACK //
		   // 
           Write8Bit(RomAddress);//д24C02��ROM��ַ 
           Wait(); 
           if (TestAck()!=MT_DATA_ACK) return 0; //?
		  //data1=TestAck();
           Start();//I2C�������� 
           Wait(); 
           if (TestAck()!=RE_START)  return 0; 
		   
           Write8Bit(rd_device_add);//дI2C��������ַ�Ͷ���ʽ 
           Wait(); 
           if(TestAck()!=MR_SLA_ACK)  return 0;//ACK 
		    
           Twi();//������I2C����ʽ 
           Wait(); 
           if(TestAck()!=MR_DATA_NOACK) return 0;//ACK         
           temp=TWDR;//��ȡI2C�������� 
       Stop();//I2Cֹͣ 
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
