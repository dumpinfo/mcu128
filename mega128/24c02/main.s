	.module main.c
	.area text(rom, con, rel)
	.dbfile C:\DOCUME~1\solo\MYDOCU~1\1281\main.c
	.dbfunc e i2c_Write _i2c_Write fc
;              i -> R20
;     RomAddress -> R18
;          Wdata -> R16
	.even
_i2c_Write::
	xcall push_gset1
	.dbline -1
	.dbline 14
; //****************************************************************************** 
; //源文件 
; //****************************************************************************** 
; #include <iom128v.h> 
; #include <macros.h> 
; #include"TWI.H" 
; #define rd_device_add 0xA1 
; #define wr_device_add 0xA0  
;   
; unsigned char  data1,data2,data3,data4;
; 
; 
; unsigned char i2c_Write(unsigned char Wdata,unsigned char RomAddress)  
; { 
	.dbline 16
;      unsigned char i; 
;           Start();//I2C启动 
	ldi R24,164
	sts 116,R24
	.dbline 17
L2:
	.dbline 17
L3:
	.dbline 17
;           Wait(); 
	lds R2,116
	sbrs R2,7
	rjmp L2
	.dbline 17
	.dbline 17
	.dbline 18
;           if(TestAck()!=START) return 1;//ACK 
	lds R24,113
	andi R24,248
	cpi R24,8
	breq L5
	.dbline 18
	ldi R16,1
	xjmp L1
L5:
	.dbline 20
; 		  
;           Write8Bit(wr_device_add);//写I2C从器件地址和写方式 
	.dbline 20
	ldi R24,160
	sts 115,R24
	.dbline 20
	ldi R24,132
	sts 116,R24
	.dbline 20
	.dbline 20
	.dbline 21
L7:
	.dbline 21
L8:
	.dbline 21
;           Wait(); 
	lds R2,116
	sbrs R2,7
	rjmp L7
	.dbline 21
	.dbline 21
	.dbline 22
;           if(TestAck()!=MT_SLA_ACK) return 1;//ACK 
	lds R24,113
	andi R24,248
	cpi R24,24
	breq L10
	.dbline 22
	ldi R16,1
	xjmp L1
L10:
	.dbline 24
; 		  
;           Write8Bit(RomAddress);//写24C02的ROM地址 
	.dbline 24
	sts 115,R18
	.dbline 24
	ldi R24,132
	sts 116,R24
	.dbline 24
	.dbline 24
	.dbline 25
L12:
	.dbline 25
L13:
	.dbline 25
;           Wait(); 
	lds R2,116
	sbrs R2,7
	rjmp L12
	.dbline 25
	.dbline 25
	.dbline 26
;           if(TestAck()!=MT_DATA_ACK) return 1;//ACK 
	lds R24,113
	andi R24,248
	cpi R24,40
	breq L15
	.dbline 26
	ldi R16,1
	xjmp L1
L15:
	.dbline 28
; 		  
;           Write8Bit(Wdata);//写数据到24C02的ROM 
	.dbline 28
	sts 115,R16
	.dbline 28
	ldi R24,132
	sts 116,R24
	.dbline 28
	.dbline 28
	.dbline 29
L17:
	.dbline 29
L18:
	.dbline 29
;           Wait(); 
	lds R2,116
	sbrs R2,7
	rjmp L17
	.dbline 29
	.dbline 29
	.dbline 30
;           if(TestAck()!=MT_DATA_ACK) return 1;//ACK
	lds R24,113
	andi R24,248
	cpi R24,40
	breq L20
	.dbline 30
	ldi R16,1
	xjmp L1
L20:
	.dbline 32
; 		           
;           Stop();//I2C停止 
	ldi R24,148
	sts 116,R24
	.dbline 33
	clr R20
	xjmp L25
L22:
	.dbline 33
L23:
	.dbline 33
	inc R20
L25:
	.dbline 33
;             for(i=0;i<250;i++); 
	cpi R20,250
	brlo L22
	.dbline 34
;           return 0; 
	clr R16
	.dbline -2
L1:
	xcall pop_gset1
	.dbline 0 ; func end
	ret
	.dbsym r i 20 c
	.dbsym r RomAddress 18 c
	.dbsym r Wdata 16 c
	.dbend
	.dbfunc e i2c_Read _i2c_Read fc
;           temp -> R20
;     RomAddress -> R16
	.even
_i2c_Read::
	xcall push_gset1
	.dbline -1
	.dbline 41
; } 
; /****************************************** 
;                I2C总线读一个字节 
;                            如果读失败也返回0 
; *******************************************/ 
; unsigned char i2c_Read(unsigned char RomAddress)  
;       { 
	.dbline 43
;            unsigned char temp; 
;            Start();//I2C启动 
	ldi R24,164
	sts 116,R24
	.dbline 44
L27:
	.dbline 44
L28:
	.dbline 44
;            Wait(); 
	lds R2,116
	sbrs R2,7
	rjmp L27
	.dbline 44
	.dbline 44
	.dbline 45
;            if (TestAck()!=START) return 0;//ACK  
	lds R24,113
	andi R24,248
	cpi R24,8
	breq L30
	.dbline 45
	clr R16
	xjmp L26
L30:
	.dbline 47
; 		            
;            Write8Bit(wr_device_add);//写I2C从器件地址和写方式 
	.dbline 47
	ldi R24,160
	sts 115,R24
	.dbline 47
	ldi R24,132
	sts 116,R24
	.dbline 47
	.dbline 47
	.dbline 48
L32:
	.dbline 48
L33:
	.dbline 48
;            Wait();  
	lds R2,116
	sbrs R2,7
	rjmp L32
	.dbline 48
	.dbline 48
	.dbline 49
;            if (TestAck()!=MT_SLA_ACK) return 0;//ACK //
	lds R24,113
	andi R24,248
	cpi R24,24
	breq L35
	.dbline 49
	clr R16
	xjmp L26
L35:
	.dbline 51
; 		   // 
;            Write8Bit(RomAddress);//写24C02的ROM地址 
	.dbline 51
	sts 115,R16
	.dbline 51
	ldi R24,132
	sts 116,R24
	.dbline 51
	.dbline 51
	.dbline 52
L37:
	.dbline 52
L38:
	.dbline 52
;            Wait(); 
	lds R2,116
	sbrs R2,7
	rjmp L37
	.dbline 52
	.dbline 52
	.dbline 53
;            if (TestAck()!=MT_DATA_ACK) return 0; //?
	lds R24,113
	andi R24,248
	cpi R24,40
	breq L40
	.dbline 53
	clr R16
	xjmp L26
L40:
	.dbline 55
; 		  //data1=TestAck();
;            Start();//I2C重新启动 
	ldi R24,164
	sts 116,R24
	.dbline 56
L42:
	.dbline 56
L43:
	.dbline 56
;            Wait(); 
	lds R2,116
	sbrs R2,7
	rjmp L42
	.dbline 56
	.dbline 56
	.dbline 57
;            if (TestAck()!=RE_START)  return 0; 
	lds R24,113
	andi R24,248
	cpi R24,16
	breq L45
	.dbline 57
	clr R16
	xjmp L26
L45:
	.dbline 59
; 		   
;            Write8Bit(rd_device_add);//写I2C从器件地址和读方式 
	.dbline 59
	ldi R24,161
	sts 115,R24
	.dbline 59
	ldi R24,132
	sts 116,R24
	.dbline 59
	.dbline 59
	.dbline 60
L47:
	.dbline 60
L48:
	.dbline 60
;            Wait(); 
	lds R2,116
	sbrs R2,7
	rjmp L47
	.dbline 60
	.dbline 60
	.dbline 61
;            if(TestAck()!=MR_SLA_ACK)  return 0;//ACK 
	lds R24,113
	andi R24,248
	cpi R24,64
	breq L50
	.dbline 61
	clr R16
	xjmp L26
L50:
	.dbline 63
; 		    
;            Twi();//启动主I2C读方式 
	ldi R24,132
	sts 116,R24
	.dbline 64
L52:
	.dbline 64
L53:
	.dbline 64
;            Wait(); 
	lds R2,116
	sbrs R2,7
	rjmp L52
	.dbline 64
	.dbline 64
	.dbline 65
;            if(TestAck()!=MR_DATA_NOACK) return 0;//ACK         
	lds R24,113
	andi R24,248
	cpi R24,88
	breq L55
	.dbline 65
	clr R16
	xjmp L26
L55:
	.dbline 66
;            temp=TWDR;//读取I2C接收数据 
	lds R20,115
	.dbline 67
;        Stop();//I2C停止 
	ldi R24,148
	sts 116,R24
	.dbline 68
;            return temp; 
	mov R16,R20
	.dbline -2
L26:
	xcall pop_gset1
	.dbline 0 ; func end
	ret
	.dbsym r temp 20 c
	.dbsym r RomAddress 16 c
	.dbend
	.dbfunc e i2cini _i2cini fV
	.even
_i2cini::
	.dbline -1
	.dbline 73
;       } 
; 
; 
;      void i2cini(void) 
;          { 
	.dbline 74
;          TWBR=163; 
	ldi R24,163
	sts 112,R24
	.dbline 75
;       TWSR=00; 
	clr R2
	sts 113,R2
	.dbline -2
	.dbline 76
;          } 
L57:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e main _main fV
;              c -> R22
;              i -> R10
;              b -> R20
;              j -> R22
;              k -> R10
	.even
_main::
	.dbline -1
	.dbline 81
; 
; 
;           
; void main(void) 
; {     
	.dbline 82
;      unsigned char i=0Xff,b = 0x0,c = 0x22,j,k; 
	ldi R24,255
	mov R10,R24
	.dbline 82
	clr R20
	.dbline 82
	ldi R22,34
	.dbline 84
;          
;          DDRC=0xff; 
	out 0x14,R10
	.dbline 85
; 		 DDRE=0xff;
	out 0x2,R10
	.dbline 86
;          DDRD=0xff; 
	out 0x11,R10
	.dbline 87
;          PORTD=0; 
	clr R2
	out 0x12,R2
	.dbline 88
;      i2cini(); 
	xcall _i2cini
	.dbline 91
;         // while(1)
; 		// {         
;         c = i2c_Write(i,0x03); 
	ldi R18,3
	mov R16,R10
	xcall _i2c_Write
	.dbline 92
; 		for(j=0;j<100;j++)
	clr R22
	xjmp L62
L59:
	.dbline 93
	clr R10
	xjmp L66
L63:
	.dbline 93
L64:
	.dbline 93
	inc R10
L66:
	.dbline 93
	mov R24,R10
	cpi R24,100
	brlo L63
L60:
	.dbline 92
	inc R22
L62:
	.dbline 92
	cpi R22,100
	brlo L59
	.dbline 95
; 		for(k=0;k<100;k++);
; 		 
; 		b = i2c_Read(0x03); 
	ldi R16,3
	xcall _i2c_Read
	mov R20,R16
	.dbline 96
; 		PORTE = data1;
	lds R2,_data1
	out 0x3,R2
	.dbline 97
; 		PORTC = b;
	out 0x15,R16
	.dbline -2
	.dbline 99
;        //  }   
; } 
L58:
	.dbline 0 ; func end
	ret
	.dbsym r c 22 c
	.dbsym r i 10 c
	.dbsym r b 20 c
	.dbsym r j 22 c
	.dbsym r k 10 c
	.dbend
	.area bss(ram, con, rel)
	.dbfile C:\DOCUME~1\solo\MYDOCU~1\1281\main.c
_data4::
	.blkb 1
	.dbsym e data4 _data4 c
_data3::
	.blkb 1
	.dbsym e data3 _data3 c
_data2::
	.blkb 1
	.dbsym e data2 _data2 c
_data1::
	.blkb 1
	.dbsym e data1 _data1 c
