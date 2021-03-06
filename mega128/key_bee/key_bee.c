//ICC-AVR application builder : 2008-1-14 9:09:01
// Target : M128
// Crystal: 2.0000Mhz
//该程序采用了键盘扫描的方法
//PD口作为键盘控制端
//PC0作为LED输出端
//PD口高4位作为列，低4位作为行


#include <iom128v.h>
#include <macros.h>

#define port_key  PORTD
#define ddr_key   DDRD
#define pin_key   PIND
#define port_bee  PORTC
void delay(int ms);
unsigned char key(unsigned char number);
 unsigned char chabiao[]={0,1,2,0,3,0,0,0,4};

void port_init(void)
{
 PORTA = 0xFF;
 DDRA  = 0x00;
 PORTB = 0xFF;
 DDRB  = 0x00;
 PORTC = 0x0; 
 DDRC  = 0xFF;
 PORTD = 0x0;
 DDRD  = 0xFF;
 PORTE = 0xFF;
 DDRE  = 0x00;
 PORTF = 0xFF;
 DDRF  = 0x00;
 PORTG = 0x1F;
 DDRG  = 0x00;
}

//call this routine to initialise all peripherals
void init_devices(void)
{
 //stop errant interrupts until set up
 CLI(); //disable all interrupts
 XDIV  = 0x00; //xtal divider
 XMCRA = 0x00; //external memory
 port_init();

 MCUCR = 0x00;
 EICRA = 0x00; //extended ext ints
 EICRB = 0x00; //extended ext ints
 EIMSK = 0x00;
 TIMSK = 0x00; //timer interrupt sources
 ETIMSK = 0x00; //extended timer interrupt sources
 SEI(); //re-enable interrupts
 //all peripherals are now initialised
}

//
void main(void)
{ 
  unsigned char kk;
 init_devices();
 while(1)
  {if(key(2)!=0)
   kk=key(2);
  PORTC = kk;
  }
   
   
 }
void delay(int ms)
{int i,j;
  for(j=0;j<ms;j++)
  for(i=0;i<100;i++);
}

//number表示键盘列数，比如共有2列,number=2
unsigned char key(unsigned char number)
{ 
  unsigned key_data=0,ky=1,key_out,i = 0,key_in1,key_in2,key_in3,key_in;
  ddr_key = 0Xff;//低4位输入，高4位输出
  
  for(i = 0;i<number; i++)
   {port_key = 1<<(i+4);
    key_in1 = pin_key&0xf;
	delay(1);
	key_in2 = pin_key&0xf;
	delay(1);
	key_in3 = pin_key&0xf;
	key_in = key_in2&key_in3;
	if(key_in != 0)
	 key_data = key_in<<(i*4);
	
   }
   //key_data = pin_key;
    return key_data;
  
}  
  
  
    
