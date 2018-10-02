//********************************************************************************* 
//TWI文件 
//********************************************************************************* 
//TWI状态定义 
//MT 主方式传输  MR 主方式接收 
#define START 0x08 
#define RE_START 0x10 
#define MT_SLA_ACK 0x18 
#define MT_SLA_NOACK 0x20 
#define MT_DATA_ACK  0x28 
#define MT_DATA_NOACK 0x30 
#define MR_SLA_ACK  0x40 
#define MR_SLA_NOACK 0x48 
#define MR_DATA_ACK 0x50 
#define MR_DATA_NOACK 0x58 
//常用TWI操作(主模式写和主模式读) 
#define Start()              (TWCR=(1<<TWINT)|(1<<TWSTA)|(1<<TWEN)) 
#define Stop()               (TWCR=(1<<TWINT)|(1<<TWSTO)|(1<<TWEN)) 
#define Wait()                     {while(!(TWCR&(1<<TWINT)));} 
#define TestAck()           (TWSR&0xf8) 
#define SetAck()          (TWCR|=(1<<TWEA)) 
#define SetNoAck()    (TWCR&=~(1<<TWEA)) 
#define Twi()                    (TWCR=(1<<TWINT)|(1<<TWEN)) 
#define Write8Bit(x)  {TWDR=(x);TWCR=(1<<TWINT)|(1<<TWEN);}  