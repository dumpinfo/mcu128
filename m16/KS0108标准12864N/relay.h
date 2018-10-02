#define Heigh() PORTB |= 0x01
#define Low() PORTB &= 0xFE
#define Test() PIND &= 0x80 
#define  RK_DDR DDRA
#define KEY_DATA_IN PINA

#define RELAY PORTB
#define  ON_RELAY1() RELAY |= 0x01; 
#define  ON_RELAY2() RELAY |= 0x02; 
#define  ON_RELAY3() RELAY |= 0x04; 
#define  ON_RELAY4() RELAY |= 0x08; 
#define  ON_RELAY5() RELAY |= 0x10; 
#define  ON_RELAY6() RELAY |= 0x20; 
#define  ON_RELAY7() RELAY |= 0x40; 
#define  ON_RELAY8() RELAY |= 0x80;
 
#define  OFF_RELAY1() RELAY &= 0xFE; 
#define  OFF_RELAY2() RELAY &= 0xFD; 
#define  OFF_RELAY3() RELAY &= 0xFB; 
#define  OFF_RELAY4() RELAY &= 0xF7; 
#define  OFF_RELAY5() RELAY &= 0xEF; 
#define  OFF_RELAY6() RELAY &= 0xDF; 
#define  OFF_RELAY7() RELAY &= 0xBF; 
#define  OFF_RELAY8() RELAY &= 0x7F; 