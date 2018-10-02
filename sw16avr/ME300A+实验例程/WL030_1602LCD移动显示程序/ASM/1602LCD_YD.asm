;*******************************************************************    
;*                                                                      
;* ME300B��Ƭ������ϵͳ��ʾ���� - LCD1602 �ƶ���ʾC                     
;*                                                                      
;* ��ʾ���ݣ�   CHINESE                                                 
;*                 NEW  YEAR                                            
;*                                                                      
;* ��ʾ��ʽ��                                                           
;* 1��LCD��һ����ʾ�� CHINESE                                           
;*      LCD�ڶ�����ʾ�� NEW YEAR                                        
;* 2���Ƚ������ַ�д��DDRAM�У�Ȼ��������������Ƴ���ʾ��               
;* 3����ָ��λ��ͣ��1.6�����˸2�Σ�������                            
;* 4������ѭ��������ʾ��ʽ��                                            
;*                                                                      
;* ���䣺 gguoqing@willar.com                                           
;* ��վ�� http://www.willar.com                                         
;* ���ߣ� gguoqing                                                      
;* ʱ�䣺 2006/01/23                                                    
;*                                                                      
;*����Ȩ��COPYRIGHT(C)ΰ�ɵ��� www.willar.com ALL RIGHTS RESERVED       
;*���������˳��������ѧϰ��ο���������ע����Ȩ��������Ϣ��            
;*                                                                      
;*******************************************************************    
                                                                        
          LCD_RS  EQU P2.0                                              
          LCD_RW  EQU P2.1                                              
          LCD_EN  EQU P2.2                                              
                                                                        
;*******************************************************************    
             ORG  0000H                                                 
             AJMP  MAIN                                                 
             ORG  0030H                                                 
;*******************************************************************    
MAIN:                                                                   
             MOV SP,#60H                                                
             ACALL LCD_INIT           ;LCD��ʼ��                        
MAIN1:                                                                  
             ACALL CLR_LCD           ;��LCD                             
             MOV A,#90H                ;�ڵ�һ�е�17�е�λ��            
             ACALL LCD_CMD                                              
             MOV DPTR,#LINE1       ;��һ���ַ�������ʼ��ַ����DPTR��    
             ACALL WRITE                                                
             MOV A,#0D0H              ;�ڵڶ��е�17�е�λ��             
             ACALL LCD_CMD                                              
             MOV DPTR,#LINE2       ;�ڶ����ַ�������ʼ��ַ����DPTR��    
             ACALL WRITE                                                
                                                                        
             MOV  R3,#10H             ;�����ƶ�16��                     
LOOPA:                                                                  
             MOV  A,#18H               ;�ַ�ͬʱ����һ��                
             ACALL LCD_CMD                                              
             MOV  R5,#03H             ;��ʱ375MS                        
             ACALL  DELAY125MS                                          
             DJNZ  R3,LOOPA                                             
                                                                        
             ACALL  DELAY4            ;��ʱ1.6s                         
             ACALL  DELAY4                                              
             MOV  R4,#02H            ;������˸����                      
             ACALL  FLASH              ;��ʼ��˸                        
             AJMP  MAIN1                                                
                                                                        
LINE1:                                                                  
        DB "    CHINESE     ",00H                                       
LINE2:                                                                  
        DB "    NEW YEAR    ",00H                                       
                                                                        
;***************************************************************        
;LCD��ʼ���趨�ӳ���                                                    
;***************************************************************        
LCD_INIT:                                                               
          ACALL DELAY5MS            ;��ʱ15MS                           
          ACALL DELAY5MS            ;�ȴ�LCD��Դ�ȶ�                    
          ACALL DELAY5MS                                                
                                                                        
          MOV A,#38H                   ;16*2��ʾ��5*7����8λ����      
          ACALL LCD_CMD_NC      ;������LCDæ���                        
          ACALL DELAY5MS                                                
                                                                        
          MOV A,#38H                   ;16*2��ʾ��5*7����8λ����      
          ACALL LCD_CMD_NC      ;������LCDæ���                        
          ACALL DELAY5MS                                                
                                                                        
          MOV A,#38H                   ;16*2��ʾ��5*7����8λ����      
          ACALL LCD_CMD_NC      ;������LCDæ���                        
          ACALL DELAY5MS                                                
                                                                        
          MOV  A,#08H                 ;��ʾ��                           
          ACALL LCD_CMD            ;����LCDæ���                       
                                                                        
          MOV A,#01H                  ;�����Ļ                         
          ACALL LCD_CMD            ;����LCDæ���                       
                                                                        
          MOV  A,#0CH                ;��ʾ�����ع��                    
          ACALL LCD_CMD           ;����LCDæ���                        
                                                                        
          RET                                                           
;***************************************************************        
;��LCD�ӳ���                                                            
;***************************************************************        
CLR_LCD:                                                                
           MOV A,#01H                ;�����Ļ                          
           ACALL LCD_CMD         ;����LCDæ���                         
           RET                                                          
                                                                        
;***************************************************************        
;дָ�����ݵ�LCD                                                        
;RS=L,RW=L,D0-D7=ָ���룬E=������                                       
;***************************************************************        
LCD_CMD:                                                                
          CALL  CHECKBUSY                                               
LCD_CMD_NC:                                                             
          CLR LCD_RS                                                    
          CLR LCD_RW                                                    
          MOV  P0,A                                                     
          SETB LCD_EN                                                   
          NOP                                                           
          NOP                                                           
          NOP                                                           
          NOP                                                           
          CLR  LCD_EN                                                   
          RET                                                           
;***************************************************************        
;д��ʾ���ݵ�LCD                                                        
;RS=H,RW=L,D0-D7=���ݣ�E=������                                         
;***************************************************************        
LCD_WDATA:                                                              
          ACALL  CHECKBUSY                                              
          SETB  LCD_RS                                                  
          CLR   LCD_RW                                                  
          MOV   P0,A                                                    
          SETB  LCD_EN                                                  
          NOP                                                           
          NOP                                                           
          NOP                                                           
          NOP                                                           
          CLR   LCD_EN                                                  
          RET                                                           
;***************************************************************        
;���LCD������æ״̬                                                    
;������                                                                 
;RS=L,RW=H,E=H,�����D0-D7=����                                         
;P0.7=1��LCDæ���ȴ���P0.7=0��LCD�У����Խ��ж�д������                 
;***************************************************************        
CHECKBUSY:                                                              
          PUSH  ACC                                                     
          MOV  P0,#0FFH                                                 
          CLR   LCD_RS                                                  
          SETB  LCD_RW                                                  
          SETB  LCD_EN                                                  
BUSYLOOP:                                                               
          NOP                                                           
          JB P0.7,BUSYLOOP                                              
          CLR  LCD_EN                                                   
          POP  ACC                                                      
          RET                                                           
;***************************************************************        
; �����ַ����ӳ���                                                      
;***************************************************************        
WRITE:                                                                  
          PUSH ACC                                                      
WRITE1:                                                                 
          CLR  A                                                        
          MOVC  A,@A+DPTR                                               
          JZ  WRITE2                                                    
          INC  DPTR                                                     
          ACALL LCD_WDATA                                               
          JMP  WRITE1                                                   
WRITE2:                                                                 
          POP  ACC                                                      
          RET                                                           
;***************************************************************        
;��˸�ӳ���                                                             
;***************************************************************        
FLASH:                                                                  
          MOV A,#08H                ;�ر���ʾ                           
          ACALL LCD_CMD                                                 
          ACALL DELAY4                                                  
          MOV A,#0CH                ;����ʾ���رչ��                   
          ACALL LCD_CMD                                                 
          ACALL DELAY4                                                  
          DJNZ R4,FLASH                                                 
          RET                                                           
;***************************************************************        
;��ʱ5MS�ӳ���                                                          
;LCD��ʼ��ʹ��                                                          
;***************************************************************        
DELAY5MS:                                                               
          MOV  R6,#10                                                   
 DL1:                                                                   
          MOV  R7,#249                                                  
 DL2:                                                                   
          DJNZ R7,DL2                                                   
          DJNZ R6,DL1                                                   
          RET                                                           
;***************************************************************        
;��ʱ125MS�ӳ���                                                        
;�ַ����ƶ�ʱʹ��                                                       
;***************************************************************        
DELAY125MS:                                                             
 DL3:                                                                   
          MOV  R6,#250                                                  
 DL4:                                                                   
          MOV  R7,#249                                                  
 DL5:                                                                   
          DJNZ R7,DL5                                                   
          DJNZ R6,DL4                                                   
          DJNZ R5,DL3                                                   
          RET                                                           
;***************************************************************        
;��ʱ800MS�ӳ���                                                        
;��˸ʱʹ��                                                             
;***************************************************************        
DELAY4:                                                                 
          MOV R5,#40                                                    
 DL6:                                                                   
          MOV R6,#100                                                   
 DL7:                                                                   
          MOV R7,#100                                                   
 DL8:                                                                   
          DJNZ R7,DL8                                                   
          DJNZ R6,DL7                                                   
          DJNZ R5,DL6                                                   
          RET                                                           
;***************************************************************        
          END                                                           