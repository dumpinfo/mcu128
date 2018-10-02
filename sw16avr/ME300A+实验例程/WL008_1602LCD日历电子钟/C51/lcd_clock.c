//==============================================
//ME300ϵ�е�Ƭ������ϵͳ��ʾ��������ʱ��
//==============================================
//
//���ߣ�chenming
//������ΰ�ɵ�����̳ www.willar.com
//����ʱ��
//��K1,��������״̬
//��k2,ֹͣ��������
//��k3,���ν������ӹ����Ƿ����ã�����ʱ,����,��,��,�ռ�ʱ��ʱ,��,�������,ֱ���˳�����״̬
//��k4,�����Ƿ��������Ӻ͵�������ʱ,��,��,��,��,��,ʱ���ʱ,��,�������
//LCD�ڶ����м���ʾС���ȣ���ʾ�������ӹ��ܣ������ֹ���ӹ��ܣ����ڵ���״̬�������ã�
//����״̬,LCD������ǰ����ʾ�Զ����ַ�,LCD������ǰ������"willar"
//����״̬,LCD������ǰ����ʾ"P",������ǰ������������ʱ��ʱ��ʾ"alarm:",����״̬��ʾ"time"
//����仯2000--2099,�����Զ�ת��
//���������Զ����ַ�д��


#include <reg51.h>
#include <intrins.h>
unsigned char code dis_week[]={"SUN,MON,TUE,WED,THU,FRI,SAT"};
unsigned char code para_month[13]={0,0,3,3,6,1,4,6,2,5,0,3,5};	//�����²α���
unsigned char data dis_buf1[16];		//lcd������ʾ������
unsigned char data dis_buf2[16];		//lcd������ʾ������		
unsigned char data year,month,date,week;//�ꡢ�¡��ա�����
unsigned char data armhour,armmin,armsec;//����ʱ���֡���
unsigned char data hour,min,sec,sec100;	//ʱ���֡��롢�ٷ�֮һ��
unsigned char data flag,vkey,skey;//����״̬������־��������ǰֵ��������ǰֵ	
bit	alarm;	//��ʶ�Ƿ��������ӣ�1--���ã�0--�ر�
sbit	 rs = P2^0;				//LCD����/����ѡ���(H/L)
sbit	 rw = P2^1;				//LCD��/дѡ���(H/L)
sbit	 ep = P2^2;				//LCDʹ�ܿ���
sbit	PRE = P1^6;				//������(k3)
sbit	SET = P1^7;				//������(k4)
sbit	SPK = P3^7;				
void delayms(unsigned char ms);	//��ʱ����
bit  lcd_busy();				//����LCDæµ״̬����
void lcd_wcmd(char cmd);		//д��ָ�LCD����
void lcd_wdat(char dat);		//д�����ݵ�LCD����
void lcd_pos(char pos);			//LCD����ָ��λ�ó���
void lcd_init();				//LCD��ʼ���趨����
void pro_timedate();			//ʱ�����ڴ������
void pro_display();				//��ʾ�������
void pro_key();					//�����������
void time_alarm();				//��ʱ��������(����)
unsigned char scan_key();		//����ɨ�����
unsigned char week_proc();		//�����Զ���������ʾ����
bit leap_year();				//�ж��Ƿ�Ϊ����
void lcd_sef_chr();				//LCD�Զ����ַ�����
void update_disbuf(unsigned char t1,unsigned char t2[],unsigned char dis_h,unsigned char dis_m,unsigned char dis_s);			
								//������ʾ����������
 

// ��ʱ����
void delay(unsigned char ms)
{	while(ms--)
	{	unsigned char i;
		for(i = 0; i< 250; i++)     
		{
			_nop_();			   //ִ��һ��_nop_()ָ��Ϊһ����������
			_nop_();
			_nop_();
			_nop_();
		}
	}
}		
	

//����LCDæµ״̬
bit lcd_busy()
{	
	bit result;
	rs = 0;
	rw = 1;
	ep = 1;
	_nop_();
	_nop_();
	_nop_();
	_nop_();
	result =(bit)(P0&0x80);	//LCD��D0--D7��,D7=1Ϊæµ,D7=0Ϊ����
	ep = 0;
	return result;	
}

//д��ָ�LCD
void lcd_wcmd(char cmd)
{							
	while(lcd_busy());	//��lcd_busyΪ1ʱ,�ٴμ��LCDæµ״̬,lcd-busyΪ0ʱ,��ʼдָ��
	rs = 0;
	rw = 0;
	ep = 0;
	_nop_();
	_nop_();	
	P0 = cmd;
	_nop_();
	_nop_();
	_nop_();
	_nop_();
	ep = 1;
	_nop_();
	_nop_();
	_nop_();
	_nop_();
	ep = 0;		
}

//д�����ݵ�LCD
void lcd_wdat(char dat)	
{							
	while(lcd_busy());	//��lcd_busyΪ1ʱ,�ٴμ��LCDæµ״̬,lcd-busyΪ0ʱ,��ʼд����
	rs = 1;
	rw = 0;
	ep = 0;
	P0 = dat;
	_nop_();
	_nop_();
	_nop_();
	_nop_();
	ep = 1;
	_nop_();
	_nop_();
	_nop_();
	_nop_();
	ep = 0;	
}

//LCD����ָ��λ�ó���
void lcd_pos(char pos)
{						
	lcd_wcmd(pos|0x80);	//����ָ��=80+��ַ��(00H~27H,40H~67H)
}


//�趨�����Զ����ַ�,(ע�⣺LCD1602���Զ����ַ��ĵ�ַΪ0x00--0x07,���ɶ���8���ַ�)
//���������趨��һ���Զ����ַ�����0x00λ�ã�000��,��һ������0x01λ�ӣ�001��
void lcd_sef_chr()
{	//��һ���Զ����ַ�
	lcd_wcmd(0x40);	//"01 000 000"  ��1�е�ַ (D7D6Ϊ��ַ�趨������ʽ�DD5D4D3Ϊ�ַ����λ��(0--7)��D2D1D0Ϊ�ַ��е�ַ(0--7)��
  	lcd_wdat(0x1f);	//"XXX 11111"	��1�����ݣ�D7D6D5ΪXXX����ʾΪ������(һ����000����D4D3D2D1D0Ϊ�ַ�������(1-������0-Ϩ��
	lcd_wcmd(0x41);	//"01 000 001" 	��2�е�ַ
  	lcd_wdat(0x11);	//"XXX 10001"	��2������
	lcd_wcmd(0x42);	//"01 000 010" 	��3�е�ַ
  	lcd_wdat(0x15);	//"XXX 10101"	��3������
	lcd_wcmd(0x43);	//"01 000 011" 	��4�е�ַ
  	lcd_wdat(0x11);	//"XXX 10001"	��4������
	lcd_wcmd(0x44);	//"01 000 100" 	��5�е�ַ
  	lcd_wdat(0x1f);	//"XXX 11111"	��5������
	lcd_wcmd(0x45);	//"01 000 101" 	��6�е�ַ
  	lcd_wdat(0x0a);	//"XXX 01010"	��6������
	lcd_wcmd(0x46);	//"01 000 110" 	��7�е�ַ
  	lcd_wdat(0x1f);	//"XXX 11111"	��7������
	lcd_wcmd(0x47);	//"01 000 111" 	��8�е�ַ
  	lcd_wdat(0x00);	//"XXX 00000"	��8������ 
	//�ڶ����Զ����ַ�
	lcd_wcmd(0x48);	//"01 001 000"  ��1�е�ַ  
  	lcd_wdat(0x01);	//"XXX 00001"	��1������ 
	lcd_wcmd(0x49);	//"01 001 001" 	��2�е�ַ
  	lcd_wdat(0x1b);	//"XXX 11011"	��2������
	lcd_wcmd(0x4a);	//"01 001 010" 	��3�е�ַ
  	lcd_wdat(0x1d);	//"XXX 11101"	��3������
	lcd_wcmd(0x4b);	//"01 001 011" 	��4�е�ַ
  	lcd_wdat(0x19);	//"XXX 11001"	��4������
	lcd_wcmd(0x4c);	//"01 001 100" 	��5�е�ַ
  	lcd_wdat(0x1d);	//"XXX 11101"	��5������
	lcd_wcmd(0x4d);	//"01 001 101" 	��6�е�ַ
  	lcd_wdat(0x1b);	//"XXX 11011"	��6������
	lcd_wcmd(0x4e);	//"01 001 110" 	��7�е�ַ
  	lcd_wdat(0x01);	//"XXX 00001"	��7������
	lcd_wcmd(0x4f);	//"01 001 111" 	��8�е�ַ
  	lcd_wdat(0x00);	//"XXX 00000"	��8������ 



 
}

//LCD��ʼ���趨
void lcd_init()
{						
	lcd_wcmd(0x38);		//����LCDΪ16X2��ʾ,5X7����,��λ���ݽ��
	delay(1);
	lcd_wcmd(0x0c);		//LCD����ʾ���������(��겻��˸,����ʾ"-")
	delay(1);
	lcd_wcmd(0x06);		//LCD��ʾ����ƶ�����(����ַָ���1,������ʾ���ƶ�)
	delay(1);
	lcd_wcmd(0x01);		//���LCD����ʾ����
	delay(1);
}

//����ļ���
bit leap_year()
{
	bit leap;
	if((year%4==0&&year%100!=0)||year%400==0)//���������
		leap=1;
	else
		leap=0;
	return leap;
}

//���ڵ��Զ�����ʹ���
unsigned char week_proc()
{	unsigned char num_leap;	
	unsigned char c;
	num_leap=year/4-year/100+year/400;//��00����year��������������
	if( leap_year()&& month<=2 )	  //������������1�º�2��	
		c=5;
	else 
		c=6;
	week=(year+para_month[month]+date+num_leap+c)%7;//�����Ӧ������
	return week;
}	

//������ʾ������
void update_disbuf(unsigned char t1,unsigned char t2[],unsigned char dis_h,unsigned char dis_m,unsigned char dis_s)	
{	dis_buf1[0]=t1; 			//
	dis_buf1[1]=0x20; 			//�ո�
	dis_buf1[2]=50; 			//'2' 
	dis_buf1[3]=48;             //'0'
	dis_buf1[4]=year/10+48; 
	dis_buf1[5]=year%10+48; 
	dis_buf1[6]=0x2d;
	dis_buf1[7]=month/10+48;
	dis_buf1[8]=month%10+48; 
	dis_buf1[9]=0x2d; 			//'-'
	dis_buf1[10]=date/10+48;
	dis_buf1[11]=date%10+48;
	dis_buf1[12]=0x20;
	dis_buf1[13]=dis_week[4*week];
	dis_buf1[14]=dis_week[4*week+1];
	dis_buf1[15]=dis_week[4*week+2];

	dis_buf2[0]=t2[0]; 
	dis_buf2[1]=t2[1]; 
	dis_buf2[2]=t2[2]; 
	dis_buf2[3]=t2[3];
	dis_buf2[4]=t2[4]; 
	dis_buf2[5]=t2[5];
	dis_buf2[6]=0x20;			//�ո�
 	if (alarm)
		dis_buf2[7]=0x01;		//alarm=1����ʾ�������ñ��£��ڶ����Զ����ַ���
	else
		dis_buf2[7]=0x20;		//alarm=0������ʾ�������ñ���
	dis_buf2[8]=dis_h/10+48; 
	dis_buf2[9]=dis_h%10+48; 
	dis_buf2[10]=0x3a;			//':'
	dis_buf2[11]=dis_m/10+48;
	dis_buf2[12]=dis_m%10+48;
	dis_buf2[13]=0x3a;
	dis_buf2[14]=dis_s/10+48;
	dis_buf2[15]=dis_s%10+48;

}

//ʱ������ڴ������
void pro_timedate()
{	
	sec++;
	if(sec > 59)
		{sec = 0;
		 min++;
		 if(min>59)
			{min=0;
			 hour++;
			 if(hour>23)
				{hour=0;
				 date++;
				 if (month==1||month==3||month==5||month==7||month==8||month==10||month==12)
					 if (date>31) {date=1;month++;}					//����31��
				 if (month==4||month==6||month==9||month==11)		
				 	 if (date>30) {date=1;month++;}					//С��30��
				 if (month==2)			
					 {if( leap_year())								//���������
						{if (date>29) {date=1;month++;}}			//����2��Ϊ29��
					 else
						{if (date>28) {date=1;month++;}}			//ƽ��2��Ϊ28��	
					 }				
				 if (month>12) {month=1;year++;}
				 if (year>99) year=0;
				}
			}
		}
	week_proc();
	if (sec==armsec && min==armmin && hour==armhour)				
		{if (alarm)
			TR1=1;					//��������ʱ������ʱ�䵽,����Timer1
		}

}

//��ʾ�������
void pro_display()
{	unsigned char i;
	lcd_pos(0x00);
	for (i=0;i<=15;i++)
		{lcd_wdat(dis_buf1[i]);}

	lcd_pos(0x40);
	for (i=0;i<=15;i++)
		{lcd_wdat(dis_buf2[i]);}
}

//Timer0�жϴ������,��Ĳ���
void timer0() interrupt 1 
{
	TH0=0xdc;			//Timer0��10ms��ʱ��ֵdc00H(2^16=65536D,dc00H=56320D)
	TL0=0x00;			//��ʱʱ��=(65536-56320)*(1/11.0592)*12=10ms (f0=11.0592Mhz)
	sec100++;
	if(sec100 >= 100)	//1��ʱ�� (100*10ms=1000ms=1s)
		{sec100 = 0;
		 pro_timedate();//����ʱ������ڴ������
		}
	if (sec&0x01)										//"willar"��һ�룬ͣһ��
		update_disbuf(0x00,"      ",hour,min,sec);	   //0x00��ʾ��ʾ00λ�õ��Զ����ַ�		
	else 
		update_disbuf(0x00,"willar",hour,min,sec);	
	pro_display();		//������ʾ������


}	
	
//����ɨ�����
unsigned char  scan_key()
{	
	skey=0x00;									//������vkey�ó�ֵ
	skey|=PRE;									//��ȡPRE����״̬
	skey=skey<<1;								//��PRE����״̬����skey��B1λ
	skey|=SET;									//��ȡSET����״̬,������skey��B0λ
	return skey;								//����skey�ļ�ֵ(��PRE,SET��״̬)

}

//�ⲿ�ж�INT0�жϴ������
void int0() interrupt 0 
{		
		TR0=0;									//��ֹTimer0
		IE=0;									//��ֹ�ж�
		lcd_wcmd(0x0e);							//��ʾ���"_",������겻��˸
		alarm=1;
		update_disbuf(0x50,"alarm:",armhour,armmin,armsec);	//������ʾ���ݣ�0x50��ʾҪ��ʾ"P"	
		pro_display();							//������ʾ�������
		lcd_pos(0x47);			    			//ʹ���λ�ڵ�һ����������						
		flag=0;									
		vkey=0x03;
		while(flag^0x0a)
			{skey = scan_key();					//ɨ�谴��״̬
			if (skey^vkey)						//��skey��vkey��ͬ,����ѭ��,����ִ��ѭ����
				{	delay(10);					//ȥ��������	
					skey = scan_key();			//ת��ɨ�谴��״̬			
					if (skey^vkey)				//��skey��vkey��ͬ,����ѭ��,����ִ��ѭ����		
			 			{	vkey=skey;			//��skey��ֵ����vkey	
							if (skey==0x01)		//PRE������
								{	 flag++;	//������־λ��1 
										switch (flag)	//�����������Ӧ����λ��
										{	
										  		
											case 1: lcd_pos(0x49);break;		//�����Сʱ��������λ��						 
											case 2:	lcd_pos(0x4c);break;		//����÷��ӱ�������λ��	   	
											case 3:	lcd_pos(0x4f);break;		//�������ʱ��������λ��
											
											case 4:	update_disbuf(0x50,"time: ",hour,min,sec);
													pro_display();
													lcd_pos(0x05);break;		//����������λ��										  	
											case 5:	lcd_pos(0x08);break;		//������µ���λ��
											case 6:	lcd_pos(0x0b);break;		//������յ���λ��
											
											case 7: lcd_pos(0x49);break;		//�����ʱ����λ��
											case 8:	lcd_pos(0x4c);break;		//����÷ֵ���λ��
											case 9:	lcd_pos(0x4f);break;		//����������λ��
												
											default:break;
										}
								}
							if (skey==0x02)		    //SET������
								{	pro_key();		//ת���ð����������
								}
						}
				}								 
			}								 
		lcd_wcmd(0x0c);							//����LCD����ʾ����겻��˸,����ʾ"-"
		lcd_wcmd(0x01);						    //���LCD����ʾ����
		IE=0x8f;      							//CPU���ж�,INT0,INT1,���ж�
		TR0=1;									//Timer0����
}


//������,��ʼ������ֵ�趨
void main()
{	
	lcd_init();		                   	//��ʼ��LCD
	lcd_sef_chr();						//д���Զ����ַ���
	hour=0;min=0;sec=0;				    //����ʱ��ʱ,��,����ʾ
	armhour=0;armmin=0;armsec=0;		//����ʱ��ʱ,��,�뱨����ֵ
	year= 5; month=1;date=1;     		//����ʱ����,��,��,������ʾ
	week_proc();
	alarm=1;							//��ʼ��������������
	IE = 0x8f;							//CPU���ж�,INT0,INT1,Timer0,Timer1���ж�
	IP = 0x04;							//����INT0Ϊ�ж�������ȼ�
	IT0=0;IT1=0;						//�ⲿINT0,INT1����Ϊ��ƽ������ʽ��ע�⣬������Ҫѡ���ط�ʽ�����󶯣�
	TMOD = 0x11;						//Timer0,Timer1������ģʽ1, 16λ��ʱ��ʽ
	TH0 = 0xdc;TL0 = 0x00;				//Timer0��10ms��ʱ��ֵ 	
	TH1 = 0xff;TL1 = 0x00;				//Timer1�ó�ֵ 	
	TR0 = 1;							//Timer0����
	TR1 = 0;
	while(1);
}

//���ð����������
void pro_key()
{
	switch (flag)
		{ 
		case 0:alarm=!alarm;			//���û�ر����ӣ�alarm=1:����,alarm=0:�ر�)
				update_disbuf(0x50,"alarm:",armhour,armmin,armsec); //������ʾ����
				pro_display();										//������ʾ����
				lcd_pos(0x47);break;								//���ص�ԭ����λ�� 
		case 1:armhour++;
				if (armhour>23) armhour=0;
				update_disbuf(0x50,"alarm:",armhour,armmin,armsec); //������ʾ����
				pro_display();										//������ʾ����
				lcd_pos(0x49);break;								//���ص�ԭ����λ��
		case 2:armmin++;
				if (armmin>59) armmin=0;
				update_disbuf(0x50,"alarm:",armhour,armmin,armsec);
				pro_display();
				lcd_pos(0x4c);break;
		case 3:armsec++;
				if (armsec>59) armsec=0;
				update_disbuf(0x50,"alarm:",armhour,armmin,armsec);
				pro_display();
				lcd_pos(0x4f);break;

		case 4:year++;
				if	(year> 99) year= 0;
				week_proc();                        //�����Զ�����
				update_disbuf(0x50,"time: ",hour,min,sec);
				pro_display();
				lcd_pos(0x05);break;
	 	case 5:month++;
				if (month>12) month=1;
				week_proc();						//�����Զ�����
				update_disbuf(0x50,"time: ",hour,min,sec);
				pro_display();
				lcd_pos(0x08);break;
		case 6:date++;
				if (month==1||month==3||month==5||month==7||month==8||month==10||month==12)
					if (date>31) date=1;			//����31��
				if (month==4||month==6||month==9||month==11)		
				 	if (date>30) date=1;			//С��30��
				if (month==2)			
					{if(leap_year())				//���������
						{if (date>29) date=1;}		//����2��Ϊ29��
					 else
						{if (date>28) date=1;}}		//ƽ��2��Ϊ28��	
				week_proc();					    //�����Զ�����
				update_disbuf(0x50,"time: ",hour,min,sec);
				pro_display();
				lcd_pos(0x0b);break;
		
		case 7:hour++;
				if (hour>23) hour=0;
				update_disbuf(0x50,"time: ",hour,min,sec);
				pro_display();
				lcd_pos(0x49);break;	
		case 8:min++;
				if (min>59) min=0;
				update_disbuf(0x50,"time: ",hour,min,sec);
				pro_display();
				lcd_pos(0x4c);break;
		case 9:sec++;
				if (sec>59) sec=0;
				update_disbuf(0x50,"time: ",hour,min,sec);
				pro_display();
				lcd_pos(0x4f);break;
		default: break ;												 
		}
}	

//Timer1�жϴ������,��������������
void timer1() interrupt 3 
{
	TH1=0xff;				
	TL1=0x00;
	SPK=~SPK;
	 
				
}

//�ⲿ�ж�INT1�жϴ������,ֹͣ��������
void int1() interrupt 2
{
	if(TR1)
		TR1=0;				

} 
