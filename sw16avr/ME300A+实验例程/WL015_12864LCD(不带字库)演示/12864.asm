;********************************************************************************      
;*  标题:  ME300系列单片机开发系统演示程序 - 12864LCD(不带字库）演示            *    
;*  硬件： ME300A+,ME300B                                                       *  
;*  文件:  wl015.asm                                                            *      
;*  日期:  2005-3-20                                                            *      
;*  版本:  1.0                                                                  *      
;*  作者:  sauwa                                                                *      
;*  邮箱:  sauwa@willar.com                                                     *      
;*  网站： http://www.willar.com                                                *      
;********************************************************************************      
;*  描述:                                                                       *      
;*         12864LCD(不带字库）演示程序                                          *      
;*                                                                              *      
;*          控制器：KS0107                                                      *
;*          LCD型号：TS12864A-2或兼容型号                                       *
;*          MCU:AT89S52 ,晶体频率：11.0592MHz                                   *
;*          取模方式：纵向字节倒序                                              *
;*          CS1和CS2为高电平有效                                                * 
;********************************************************************************
;*  跳线设置：                                                                  *
;*     ME300A+    JP1 全部短接，JP2短接1-2端                                    *
;*     ME300B     JP1 短接，JP2短接1-2端                                        *                                                                          *      
;*                                                                              *      
;********************************************************************************      
;* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *      
;* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *      
;********************************************************************************      

        
;***************硬件端口定义***********
          RS       EQU   P2.0
          RW       EQU   P2.1
          E        EQU   P2.2
          CS1      EQU   P2.3
          CS2      EQU   P2.4
          RST      EQU   P2.5   
          COM      EQU   20H    ;指令数据寄存器
          DAT      EQU   21H    ;显示数据寄存器

;**********************************主程序入口地址 
        ORG     0000H  
        AJMP    STR  
        ORG     0003H           
     
;*********************************中断程序入口地址
STR:    
        AJMP    L0100
  
L0100:  CLR     RST
        NOP
        NOP
        SETB    RST
        
;********************************以上是软件复位
        MOV	SP,#60H
        MOV     IE,#81H            ;中断允许
        MOV     IP,#01H            ;优先中断
        MOV     TCON,#00H          ;电平中断
        MOV     COM,#3FH         ;显示开
        LCALL   S02A9            ;左半屏写指令子程序
        LCALL   S02C1            ;右半屏写指令子程序
;----------------------------------------------------------------------
        MOV     COM,#0C0H        ;第一行        
        LCALL   S02A9            ;左半屏写指令子程序
        LCALL   S02C1            ;右半屏写指令子程序
;----------------------------------------------------------------------
        MOV     COM,#0B8H       ;第一页        
        LCALL   S02A9           ;左半屏写指令子程序
        LCALL   S02C1           ;右半屏写指令子程序
;----------------------------------------------------------------------
        MOV     COM,#40H        ;第一列
        LCALL   S02A9           ;左半屏写指令子程序
        LCALL   S02C1           ;右半屏写指令子程序
;********************************************************以上是软件初始化
        MOV     B,#0AAH
        LCALL   XIHX            ;显示横线1
        LCALL   DELAY 
      ; MOV     B,#55H
       ; LCALL   XIHX    
       ; LCALL   DELAY           ;显示横线2
        MOV     B,#0FFH
        MOV     29H,#00H       
        LCALL   XISX    
        LCALL   DELAY            ;显示竖线1
       ; MOV     B,#00H
       ; MOV     29H,#0FFH
      ; LCALL   XISX    
       ; LCALL   DELAY            ;显示竖线2

        MOV     DPTR,#TAB1
        LCALL   LEFT
        MOV     DPTR,#TAB2
        LCALL   RIGHT       
        LCALL   DELAY             ;显示第一幅图片

        MOV     DPTR,#TAB3
        LCALL   LEFT
        MOV     DPTR,#TAB4
        LCALL   RIGHT       
        LCALL   DELAY              ;显示第二幅图片

        MOV     DPTR,#TAB5
        LCALL   LEFT
        MOV     DPTR,#TAB6
        LCALL   RIGHT       
        LCALL   DELAY              ;显示第三幅图片
        AJMP    L0100
;=======================================================以上是主程序
LEFT:   MOV     R1,#0B8H
_AB:     MOV     COM,R1          ;第一页        
        LCALL   S02A9           ;左半屏写指令子程序     
        MOV     COM,#40H        ;第一列
        LCALL   S02A9           ;左半屏写指令子程序      
        MOV     R0, #64 
S027B:  MOV     A,#00H
        MOVC    A,@A+DPTR               
        MOV     DAT,A        
        LCALL   S02B1           ;左半屏写数据子程序         
        INC     DPTR    
        DJNZ    R0,S027B
        INC     R1        
        CJNE    R1, #0C0H,_AB      
        RET
;======================================================以上是左半屏写数据子程序
RIGHT:  MOV     R1,#0B8H
ABC:    MOV     COM,R1          ;第一页        
        LCALL   S02C1           ;右半屏写指令子程序     
        MOV     COM,#40H        ;第一列
        LCALL   S02C1           ;右半屏写指令子程序      
        MOV     R0, #64 
S027D:  MOV     A,#00H
        MOVC    A,@A+DPTR               
        MOV     DAT,A        
        LCALL   S02B9           ;右半屏写数据子程序         
        INC     DPTR    
        DJNZ    R0,S027D
        INC     R1        
        CJNE    R1, #0C0H,ABC       
        RET

;*******************************************************以上是右半屏写数据子程序

XIHX:   MOV     R1,#0B8H       
BA:     MOV     COM,R1          ;第一页        
        LCALL   S02A9           ;左半屏写指令子程序
        LCALL   S02C1           ;右半屏写指令子程序
        MOV     COM,#40H        ;第一列
        LCALL   S02A9           ;左半屏写指令子程序 
        LCALL   S02C1           ;右半屏写指令子程序
        MOV     R0, #64 
W027B:  MOV     DAT,B        
        LCALL   S02B1           ;左半屏写数据子程序         
        LCALL   S02B9           ;右半屏写数据子程序    
        DJNZ    R0,W027B
        INC     R1        
        CJNE    R1, #0C0H,BA      
        RET 
;--------------------------------------------------------- 
XISX:   MOV     R1,#0B8H       
CA:     MOV     COM,R1          ;第一页        
        LCALL   S02A9           ;左半屏写指令子程序
        LCALL   S02C1           ;右半屏写指令子程序
        MOV     COM,#40H        ;第一列
        LCALL   S02A9           ;左半屏写指令子程序 
        LCALL   S02C1           ;右半屏写指令子程序
        MOV     R0, #32 
X027B:  MOV     DAT,B        
        LCALL   S02B1           ;左半屏写数据子程序         
        LCALL   S02B9           ;右半屏写数据子程序   
        MOV     DAT,29H
        LCALL   S02B1           ;左半屏写数据子程序         
        LCALL   S02B9           ;右半屏写数据子程序
        DJNZ    R0,X027B
        INC     R1        
        CJNE    R1, #0C0H,CA      
        RET  
;****************************************************以上是显示线条程序
S02A9:  SETB    CS1
        LCALL   S02C9
        CLR     CS1         ;左半屏写指令子程序
        RET   
  
S02B1:  SETB    CS1         ;左半屏写数据子程序        
        LCALL   S02E0  
        CLR     CS1     
        RET  

S02C1:  SETB    CS2         ;右半屏写指令子程序        
        LCALL   S02C9  
        CLR     CS2      
        RET    

S02B9:  SETB    CS2         ;右半屏写数据子程序       
        LCALL   S02E0    
        CLR     CS2
        RET     
;**************************************************** 

S02C9:  CLR     RS         
        SETB    RW        
S02C9A: MOV     P0,#0FFH
        SETB    E
        MOV     A, P0
        CLR     E
        JB      ACC.7,S02C9A
        CLR     RW
        MOV     P0,COM       
        SETB    E
        NOP
        CLR     E
        RET     
;*************************************************以上是写指令子程序
S02E0:  CLR     RS         
        SETB    RW        
S02E0A: MOV     P0,#0FFH
        SETB    E
        MOV     A, P0
        CLR     E
        JB      ACC.7,S02E0A
        SETB    RS
        CLR     RW
        MOV     P0,DAT      
        SETB    E
        NOP
        CLR     E
        RET      
          
;************************************************以上是写数据子程序

DELAY:  MOV     R5,#0BH            ;延时
D1:     MOV     R7,#0FFH
D2:     MOV     R6,#0FFH
D3:     DJNZ    R6,$
        DJNZ    R7,D2
        DJNZ    R5,D1
        RET     
 ;****************************************************************  
TAB1:
;--  调入菲戈幅图像左半屏：纵向取模下高位,数据排列:从左到右从上到下 
;--  宽度x高度=64x64 
        db       00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 80h, 20h, 0Ah
	db	 4Ah, 3Ch, 40h,0BEh, 00h, 54h, 00h, 24h, 42h,0A8h, 00h,0EEh, 00h, 42h, 06h, 48h
	db	 12h, 44h, 12h, 44h,0A8h, 02h, 20h, 04h, 22h,0C0h, 82h,0E4h,0C0h,0E0h,0C0h,0C0h
	db 	 0A0h,0C0h,0C0h, 80h,0A0h, 00h, 00h, 20h, 00h, 00h, 04h, 48h, 12h, 2Ch, 1Ah, 1Ch
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 01h, 00h
	db	 01h, 00h, 00h, 05h, 00h, 01h, 00h, 00h, 00h, 02h, 00h, 01h, 05h, 00h, 01h, 00h
	db	 01h, 04h, 00h, 02h, 28h, 01h,0A8h, 10h,0FEh,0FDh,0DFh, 1Fh, 3Fh, 7Fh, 0Fh, 8Bh
	db	 03h, 23h, 23h, 03h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 20h,0FDh
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 80h, 00h, 20h,0A0h,0E8h, 68h,0F4h,0F0h
	db	 0F8h,0F0h, 78h,0E0h,0D0h, 14h,0A0h, 20h, 43h, 11h, 20h, 71h, 74h, 76h, 7Ch, 9Ch
	db	 42h,0D4h, 21h, 80h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h,0FFh,0D2h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 00h, 80h, 00h,0C0h, 80h, 40h,0B8h,0F8h,0F8h,0BCh, 3Eh, 3Fh, 3Eh,0FFh,0FFh,0FFh
	db	 0FFh,0FFh,0FFh,0FEh,0FDh,0FCh,0F9h,0F9h,0FDh,0F9h,0FAh,0C1h, 0Ah, 9Ah,0F9h,0F3h
	db	 0E4h,0E0h,0E2h,0FCh,0FFh,0FFh, 7Fh,0DFh,0FCh,0C0h, 00h, 00h, 01h, 48h, 33h,0BFh
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 40h, 08h, 00h
	db	 02h, 01h, 03h, 01h, 01h, 04h,0A1h, 0Ah, 24h, 0Bh, 1Ah, 41h, 9Eh,0DFh, 97h,0A9h
	db	 5Eh, 53h,0F5h,0D7h, 7Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FCh,0FEh,0FFh,0FFh,0FFh
	db	 0FFh,0FFh, 3Fh,0BFh,0FFh, 0Fh, 07h, 0Eh, 00h, 08h, 00h, 00h, 00h, 00h,0C2h, 3Fh
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 20h, 00h, 00h, 00h, 00h, 00h, 12h, 00h, 00h, 02h,0C6h, 06h, 22h, 35h, 05h, 23h
	db	 23h, 2Ch, 33h, 66h,0D7h,0FFh,0F7h,0DFh,0FFh,0CFh,0EFh,0EFh,0FFh,0FFh,0FFh, 1Fh
	db	 0Fh, 8Ah, 20h, 00h, 44h, 8Ch, 04h, 00h, 00h, 00h, 00h, 80h, 00h, 40h, 12h, 44h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 40h, 40h
	db	 40h,0E0h, 40h, 40h, 40h,0E0h, 40h, 40h, 40h, 00h, 01h, 10h, 01h, 00h, 01h, 00h
	db	 0E0h, 00h, 00h,0A0h,0C3h,0BFh,0BFh, 07h, 3Fh, 3Fh, 3Fh, 1Fh, 05h, 02h, 00h, 00h
	db	 00h, 00h, 01h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 01h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 22h, 2Ah
	db	 2Ah, 2Ah,0FFh, 00h,0FFh, 2Ah, 2Ah, 2Ah, 22h, 00h, 00h, 00h, 81h, 81h, 41h, 41h
	db	 23h, 1Dh, 31h, 48h, 84h, 82h,0E0h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h

TAB2:
;--  调入菲戈幅图像右半屏：纵向取模下高位,数据排列:从左到右从上到下 
;--  宽度x高度=64x64 
        db       76h,0BCh,0FCh,0EEh, 80h,0F6h,0F6h,0FEh,0FEh,0FFh, 80h,0FFh, 7Eh,0FFh, 81h, 3Eh
	db	 3Eh, 36h, 45h, 3Fh, 1Fh, 3Fh, 01h, 3Eh, 3Eh, 3Eh, 41h, 7Fh,0FFh, 7Fh,0FFh, 7Fh
	db	 7Fh, 3Fh, 1Fh, 3Fh, 1Fh, 9Fh, 3Fh, 9Fh, 1Fh, 3Fh, 5Fh, 1Fh, 7Fh, 7Fh,0FFh,0FFh
	db	 0FFh,0FFh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db  	 0A3h,0FEh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0BFh,0D3h, 41h, 02h, 01h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 20h, 00h, 20h, 00h
	db	 40h, 00h, 08h, 00h, 40h, 04h, 08h, 12h, 00h, 04h, 00h, 00h, 00h, 00h, 00h, 03h
	db	 0Fh, 7Fh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh, 0Dh, 24h, 00h, 00h, 80h,0A0h
	db	 40h,0E0h, 70h, 70h, 60h,0F8h,0F0h,0F0h,0F8h,0F0h,0F0h,0E0h,0F8h,0F0h, 68h, 00h
	db	 80h, 08h,0B0h,0B8h,0F0h,0F4h,0F0h,0FCh,0F9h,0F8h,0BAh,0F8h,0DCh,0B8h, 70h, 90h
	db	 20h, 4Bh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 3Fh, 3Fh, 7Fh, 7Fh,0FFh,0FFh,0FFh,0FFh, 5Fh, 00h, 00h, 01h, 00h, 05h, 02h, 05h
	db	 05h, 0Eh, 03h, 07h, 0Bh, 0Bh, 97h, 0Fh, 25h, 0Bh, 0Bh, 0Fh, 03h, 02h, 00h, 80h
	db	 00h, 14h, 00h, 01h, 0Bh, 0Bh, 1Dh, 1Bh,0E7h, 0Fh, 5Bh, 03h, 03h, 03h, 05h, 04h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 0E3h, 02h,0A6h, 60h,0F4h, 41h, 07h, 7Fh,0FDh, 50h,0C2h, 28h, 20h, 80h, 20h, 00h
	db	 80h, 00h, 80h, 00h, 00h, 00h, 04h, 00h,0A0h, 40h, 18h, 20h, 21h, 70h, 30h,0E0h
	db	 3Ah,0E0h, 39h,0E0h, 38h, 70h, 30h, 00h, 10h, 45h, 89h, 12h, 04h, 10h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 11h, 04h, 09h, 01h, 53h, 84h,0C0h, 88h, 61h,0D5h, 24h, 49h, 22h, 88h, 10h, 42h
	db	 00h, 00h, 24h, 00h, 00h, 00h, 00h, 44h,0A8h,0E0h,0C2h, 48h,0D1h, 64h, 60h, 64h
	db	 52h, 6Dh, 60h,0EBh,0B2h, 74h,0E4h, 60h,0CCh, 70h,0C0h, 82h, 08h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 01h, 03h, 04h, 05h, 10h, 05h, 50h, 80h, 14h, 01h
	db	 28h, 10h, 01h, 48h,0A0h, 00h,0A5h, 00h, 40h, 00h, 08h, 80h, 10h, 06h, 04h, 2Fh
	db	 8Eh, 1Fh, 2Eh,0CEh, 1Dh,0A6h, 16h, 0Ch, 22h, 48h,0B2h, 04h, 00h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 40h, 20h, 28h, 08h, 00h, 00h, 00h, 00h, 02h, 15h
	db	 22h, 04h, 2Ah, 18h, 22h, 5Ch, 52h, 2Ch, 52h, 38h, 64h, 52h, 7Ch, 61h, 3Ah, 6Ch
	db	 79h, 76h, 7Dh, 7Eh, 7Ch, 7Bh, 7Eh, 7Ah, 7Ah, 74h, 7Ch, 52h, 2Ch, 0Ah, 00h, 00h
	db	 00h, 1Eh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h

TAB3:
;--  调入了ME300B宣传文字图像：纵向取模下高位,数据排列:从左到右从上到下 
;--  宽度x高度=64x64 
        db       0FFh, 01h, 01h, 01h,0C1h, 01h, 01h, 01h,0C1h, 01h,0C1h, 41h, 41h, 41h, 41h, 01h
	db	 81h, 41h, 41h, 41h, 81h, 01h, 81h, 41h, 41h, 41h, 81h, 01h, 81h, 41h, 41h, 41h
	db	 81h, 01h,0C1h, 41h, 41h, 41h, 81h, 01h, 01h, 01h, 01h,0C1h, 41h, 61h,0C1h, 41h
	db	 61h, 41h,0C1h, 01h, 01h, 01h, 01h, 01h,0E1h, 01h, 01h, 01h,0F1h, 01h, 01h, 01h
	db	 0FFh, 00h, 00h, 00h, 3Fh, 03h, 3Ch, 03h, 3Fh, 00h, 3Fh, 22h, 22h, 22h, 20h, 00h
	db	 18h, 20h, 22h, 22h, 1Dh, 00h, 1Fh, 20h, 20h, 20h, 1Fh, 00h, 1Fh, 20h, 20h, 20h
	db	 1Fh, 00h, 3Fh, 22h, 22h, 22h, 1Dh, 00h, 00h, 00h, 10h, 17h, 15h, 15h, 7Fh, 15h
	db	 15h, 15h, 17h, 10h, 00h, 00h, 40h, 70h, 0Fh, 05h, 05h, 05h, 04h, 7Dh, 01h, 00h
	db	 0FFh, 00h, 00h, 00h, 00h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h
	db	 02h, 02h, 02h, 02h, 02h, 02h, 02h, 82h, 62h, 22h,0A2h, 22h, 32h,0A2h, 22h, 22h
	db	 0A2h, 62h, 02h, 12h,0D2h, 12h,0F2h, 02h, 82h, 42h, 32h, 42h, 82h, 02h, 02h, 02h
	db	 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 82h, 42h, 32h, 82h,0E2h
	db	 0FFh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 08h, 48h, 4Ah, 4Ch, 29h, 18h, 0Fh, 18h, 28h
	db	 48h, 08h, 00h, 12h, 53h, 4Ah, 3Fh, 41h, 5Ch, 41h, 5Dh, 61h, 5Ch, 41h, 00h, 08h
	db	 10h, 30h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 2Dh, 2Bh, 55h, 24h, 7Fh
	db	 0FFh, 00h, 00h, 00h, 10h, 10h,0F0h, 10h, 10h, 00h, 60h, 90h, 90h, 10h, 30h, 00h
	db	 10h,0F0h, 90h, 90h, 60h, 00h, 00h, 00h, 00h, 18h, 08h, 28h, 28h, 28h, 2Ch, 28h
	db	 28h, 28h, 08h, 18h, 00h, 80h,0A8h,0A8h,0ACh,0A8h,0F8h,0A8h,0ACh,0A8h,0A8h, 80h
	db	 00h, 60h, 50h,0CCh, 30h, 00h,0F8h, 48h, 48h, 48h,0FCh, 08h, 00h, 40h, 40h, 20h
	db	 0FFh, 00h, 00h, 00h, 08h, 08h, 0Fh, 08h, 08h, 00h, 0Ch, 08h, 08h, 09h, 06h, 00h
	db	 08h, 0Fh, 08h, 00h, 00h, 00h, 00h, 00h, 00h, 11h, 11h, 09h, 07h, 01h, 01h, 1Fh
	db	 11h, 11h, 11h, 1Dh, 00h, 10h, 12h, 12h, 0Ah, 06h, 03h, 06h, 0Ah, 12h, 12h, 10h
	db	 00h, 12h, 0Bh, 0Ah, 15h, 10h, 1Fh, 12h, 12h, 12h, 1Fh, 10h, 00h, 00h, 00h, 1Eh
	db	 0FFh, 00h, 00h, 00h, 00h, 00h,0FEh, 20h, 20h, 20h, 00h,0FEh, 20h, 20h, 10h, 08h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 38h, 08h, 2Ah, 2Ch, 2Ah,0ACh, 68h, 28h, 0Eh
	db	 28h, 18h, 00h, 00h, 04h, 04h, 0Ch, 34h, 04h, 84h, 84h, 04h,0FEh, 04h, 00h, 40h
	db	 44h, 44h,0FCh, 44h, 44h, 44h,0FCh, 44h, 46h, 44h, 00h, 10h, 1Ch, 10h,0F0h, 5Eh
	db	 0FFh, 80h, 80h, 80h, 80h, 80h, 8Fh, 84h, 84h, 82h, 80h, 8Fh, 88h, 88h, 88h, 8Fh
	db	 80h, 80h, 90h, 9Eh, 8Eh, 80h, 80h, 81h, 81h, 81h, 89h, 89h, 8Fh, 81h, 81h, 81h
	db	 81h, 81h, 80h, 82h, 86h, 82h, 82h, 81h, 81h, 88h, 88h, 88h, 87h, 80h, 80h, 88h
	db	 88h, 84h, 83h, 80h, 80h, 80h, 8Fh, 80h, 80h, 80h, 80h, 88h, 84h, 8Bh, 88h, 84h


TAB4: 
;--  调入了ME300B宣传文字图像：纵向取模下高位,数据排列:从左到右从上到下 
;--  宽度x高度=64x64 
        db       01h, 01h, 81h,0F1h, 81h, 81h, 01h,0E1h, 21h, 21h,0E1h, 01h, 01h, 01h, 01h, 21h
	db	 21h,0E1h, 21h, 21h,0E1h, 21h, 21h, 21h, 01h, 01h, 81h,0E1h,0A1h, 81h,0F1h, 81h
	db	 81h,0E1h, 81h, 81h, 01h, 01h, 01h, 21h, 21h,0A1h, 61h, 21h,0E1h,0A1h, 11h, 01h
	db	 01h, 01h, 81h, 61h, 81h, 81h, 41h, 41h,0C1h, 61h, 41h, 41h, 01h, 01h, 01h,0FFh
	db	 00h, 00h, 0Ch, 7Fh, 02h, 44h, 70h, 0Fh, 00h, 00h, 7Fh, 60h, 00h, 00h, 02h, 62h
	db	 32h, 0Fh, 02h, 02h, 7Fh, 02h, 02h, 02h, 00h, 00h, 30h, 58h, 4Ch, 43h, 2Eh, 32h
	db	 32h, 2Eh, 42h, 40h, 00h, 00h, 20h, 24h, 15h, 07h, 45h, 7Dh, 04h, 16h, 3Eh, 24h
	db	 00h, 00h, 2Dh, 2Bh, 29h, 60h, 42h, 3Fh, 02h, 7Eh, 43h, 62h, 00h, 00h, 00h,0FFh
	db	 0A2h,0A2h,0B2h,0A2h,0A2h,0E2h, 02h,0A2h,0A2h,0F2h, 92h, 02h,0F2h, 92h, 92h, 92h
	db	 0F2h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h
	db	 82h,0E2h, 52h, 42h, 42h,0D2h, 62h, 42h, 42h, 42h, 02h, 22h, 22h,0E2h, 62h, 62h
	db	 72h, 62h,0E2h, 22h, 22h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 00h, 00h, 00h,0FFh
	db	 0Ah, 3Eh, 0Ah, 3Eh, 4Ah, 7Eh, 00h, 18h, 06h, 7Fh, 04h, 42h, 4Ah, 4Ah, 7Eh, 4Ah
	db	 4Ah, 42h, 00h, 08h, 10h, 30h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 01h
	db	 00h, 7Fh, 40h, 20h, 18h, 07h, 41h, 41h, 3Fh, 00h, 00h, 50h, 50h, 5Fh, 35h, 15h
	db	 15h, 15h, 3Fh, 50h, 50h, 10h, 00h, 08h, 10h, 30h, 00h, 00h, 00h, 00h, 00h,0FFh
	db	 50h, 48h, 44h, 48h, 50h, 20h, 40h, 40h, 00h, 00h, 00h, 00h, 00h, 00h, 10h, 90h
	db	 90h, 90h,0FCh, 00h,0FCh, 90h, 90h, 90h, 10h, 00h, 00h, 00h, 00h,0F8h, 48h, 88h
	db	 08h,0FCh, 08h, 00h, 00h, 00h, 60h,0FCh, 20h, 80h, 78h, 20h, 20h,0FCh, 20h, 30h
	db	 20h, 00h, 40h, 20h,0F8h, 44h, 20h,0D0h, 0Ch, 08h,0D0h, 20h, 40h, 00h, 00h,0FFh
	db	 12h, 12h, 12h, 12h, 12h, 1Eh, 00h, 00h, 00h, 20h, 3Ch, 1Ch, 00h, 00h, 04h, 04h
	db	 04h, 04h, 1Fh, 00h, 1Fh, 04h, 04h, 04h, 04h, 00h, 10h, 08h, 04h, 03h, 00h, 01h
	db	 00h, 1Fh, 10h, 10h, 1Eh, 00h, 00h, 1Fh, 00h, 10h, 11h, 11h, 11h, 1Fh, 11h, 11h
	db	 11h, 00h, 00h, 00h, 1Fh, 10h, 08h, 07h, 00h, 00h, 1Fh, 00h, 00h, 00h, 00h,0FFh
	db	 0D0h, 50h, 52h,0D4h, 10h, 10h, 00h, 64h, 5Ch,0F6h, 44h, 44h,0C2h,0A2h, 92h, 8Ah
	db	 96h, 60h, 00h, 88h, 48h,0FEh, 48h, 20h, 18h, 06h,0C0h, 0Eh, 30h, 40h, 00h, 00h
	db	 00h,0FCh, 24h, 24h, 26h, 24h, 24h, 24h,0FCh, 00h, 00h, 08h,0C8h, 3Eh, 08h,0F8h
	db	 00h,0F8h, 08h, 08h, 08h,0F8h, 00h, 00h, 38h,0FCh,0FCh, 38h, 00h, 00h, 00h,0FFh
	db	 85h, 82h, 85h, 84h, 88h, 88h, 80h, 82h, 82h, 8Fh, 81h, 89h, 88h, 88h, 8Fh, 88h
	db	 88h, 88h, 80h, 81h, 80h, 8Fh, 80h, 88h, 8Ch, 8Bh, 88h, 8Ah, 8Ch, 80h, 80h, 80h
	db	 80h, 8Fh, 89h, 89h, 89h, 89h, 89h, 89h, 8Fh, 80h, 80h, 88h, 89h, 85h, 82h, 85h
	db	 80h, 87h, 84h, 84h, 84h, 87h, 80h, 80h, 80h, 86h, 86h, 80h, 80h, 80h, 80h,0FFh
      
TAB5:
;--  调入了伟纳logo图像：纵向取模下高位,数据排列:从左到右从上到下 
;--  宽度x高度=64x64 
        db       0FFh, 01h, 01h, 01h,0C1h, 01h, 01h, 01h,0C1h, 01h,0C1h, 41h, 41h, 41h, 41h, 01h
	db	 81h, 41h, 41h, 41h, 81h, 01h, 81h, 41h, 41h, 41h, 81h, 01h, 81h, 41h, 41h, 41h
	db	 81h, 01h,0C1h, 41h, 41h, 41h, 81h, 01h, 01h, 01h, 01h,0C1h, 41h, 61h,0C1h, 41h
	db	 61h, 41h,0C1h, 01h, 01h, 01h, 01h, 01h,0E1h, 01h, 01h, 01h,0F1h, 01h, 01h, 01h
	db	 0FFh, 00h, 00h, 00h, 3Fh, 03h, 3Ch, 03h, 3Fh, 00h, 3Fh, 22h, 22h, 22h, 20h, 00h
	db	 18h, 20h, 22h, 22h, 1Dh, 00h, 1Fh, 20h, 20h, 20h, 1Fh, 00h, 1Fh, 20h, 20h, 20h
	db	 1Fh, 00h, 3Fh, 22h, 22h, 22h, 1Dh, 00h, 00h, 00h, 10h, 17h, 15h, 15h, 7Fh, 15h
	db	 15h, 15h, 17h, 10h, 00h, 00h, 40h, 70h, 0Fh, 05h, 05h, 05h, 04h, 7Dh, 01h, 00h
	db	 0FFh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 0FFh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h,0FEh,0FEh,0FEh,0FEh,0FEh
	db	 0FEh,0F0h, 00h, 00h, 00h, 0Eh,0FEh,0FEh,0FEh,0FEh,0FEh, 80h, 80h,0C0h,0C0h,0C0h
	db	 0FEh,0FEh,0FEh,0FEh,0FEh,0FEh,0E0h,0E0h,0E0h,0C0h,0C0h, 00h, 00h, 00h, 00h, 18h
	db	 18h, 0Ch,0FCh,0FEh, 82h,0ECh,0D4h, 54h, 54h,0FFh,0FFh, 54h, 54h, 54h, 54h,0C0h
	db	 0FFh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 80h,0CFh,0FFh,0FFh,0FFh
	db	 0FFh,0FFh,0FCh, 1Ch, 0Eh, 0Eh, 07h, 7Fh,0FFh,0FFh,0FFh,0FFh,0C1h, 00h, 00h, 00h
	db	 00h, 07h,0FFh,0FFh,0FFh, 80h,0E0h,0F0h, 38h, 3Fh, 1Fh, 03h, 00h, 00h, 00h, 00h
	db	 00h, 00h, 1Fh, 0Fh, 00h, 00h, 00h, 00h, 00h, 1Fh, 1Fh, 04h, 02h, 02h, 03h, 01h
	db	 0FFh, 00h, 00h, 00h,0C0h,0E0h,0F0h, 3Ch, 1Ch, 0Eh, 03h, 03h, 01h, 07h, 7Fh,0FFh
	db	 0FFh,0FFh,0FFh,0FFh, 00h, 00h, 00h, 00h,0FFh,0FFh,0FFh,0FFh,0FFh,0F0h, 70h, 38h
	db	 3Ch, 1Ch, 0Eh,0FFh, 07h, 03h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h
	db  	 0FFh, 00h, 00h, 06h, 0Fh, 0Fh, 1Ch, 18h, 18h, 18h, 18h, 18h, 18h, 18h, 18h, 3Fh
	db 	 0FFh,0FFh,0FFh,0FFh,0FEh,0E6h, 07h, 07h, 07h, 7Fh,0FFh,0FFh,0FFh,0FFh,0F0h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 03h, 1Ch, 60h, 1Ch, 03h
	db	 03h, 1Ch, 60h, 1Ch, 03h, 1Ch, 60h, 1Ch, 03h, 03h, 1Ch, 60h, 1Ch, 03h, 1Ch, 60h
	db	 0FFh, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h
	db	 81h, 81h, 81h, 81h, 81h, 81h, 80h, 80h, 80h, 80h, 81h, 81h, 81h, 81h, 81h, 80h
	db	 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h
	db	 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h


TAB6:
;--  调入了伟纳logo图像：纵向取模下高位,数据排列:从左到右从上到下 
;--  宽度x高度=64x64  
        db       01h, 01h, 81h,0F1h, 81h, 81h, 01h,0E1h, 21h, 21h,0E1h, 01h, 01h, 01h, 01h, 21h
	db	 21h,0E1h, 21h, 21h,0E1h, 21h, 21h, 21h, 01h, 01h, 81h,0E1h,0A1h, 81h,0F1h, 81h
	db	 81h,0E1h, 81h, 81h, 01h, 01h, 01h, 21h, 21h,0A1h, 61h, 21h,0E1h,0A1h, 11h, 01h
	db	 01h, 01h, 81h, 61h, 81h, 81h, 41h, 41h,0C1h, 61h, 41h, 41h, 01h, 01h, 01h,0FFh
	db	 00h, 00h, 0Ch, 7Fh, 02h, 44h, 70h, 0Fh, 00h, 00h, 7Fh, 60h, 00h, 00h, 02h, 62h
	db	 32h, 0Fh, 02h, 02h, 7Fh, 02h, 02h, 02h, 00h, 00h, 30h, 58h, 4Ch, 43h, 2Eh, 32h
	db	 32h, 2Eh, 42h, 40h, 00h, 00h, 20h, 24h, 15h, 07h, 45h, 7Dh, 04h, 16h, 3Eh, 24h
	db	 00h, 00h, 2Dh, 2Bh, 29h, 60h, 42h, 3Fh, 02h, 7Eh, 43h, 62h, 00h, 00h, 00h,0FFh
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h,0FFh
	db	 0C0h, 00h, 00h, 00h, 30h,0B0h,0E8h,0A4h,0B6h, 10h, 08h,0F8h, 18h, 88h,0FEh,0FEh
	db	 88h, 08h,0F8h,0F8h, 00h, 00h, 00h, 00h, 7Ch,0FCh,0ACh,0A4h,0A4h,0FCh,0FFh,0A4h
	db	 0A4h,0A4h,0A4h,0FCh,0FCh, 00h, 00h, 00h, 00h, 00h, 00h, 60h, 60h, 60h, 64h, 26h
	db	 26h, 22h, 22h, 2Ah,0FAh,0FAh, 2Eh, 26h, 66h, 60h, 60h, 60h, 60h, 00h, 00h,0FFh
	db	 00h, 00h, 04h, 0Ch, 04h, 05h, 05h, 02h, 0Ah, 0Ah, 0Eh, 07h, 03h, 01h, 00h, 00h
	db	 01h, 01h, 0Fh, 0Fh, 00h, 00h, 00h, 00h, 00h, 01h, 01h, 01h, 01h, 00h, 07h, 0Eh
	db	 0Ch, 0Ch, 1Ch, 1Dh, 1Ch, 1Ch, 1Ch, 0Ch, 06h, 00h, 00h, 00h, 00h, 00h, 00h, 08h
	db	 08h, 18h, 18h, 1Ch, 0Fh, 07h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h,0FFh
	db	 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 42h
	db	 02h, 02h,0C2h, 02h, 02h,0C2h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h
	db	 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h
	db	 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 00h, 00h, 00h,0FFh
	db	 1Ch, 03h, 00h, 40h, 00h, 03h, 1Ch, 60h, 1Ch, 03h, 1Ch, 60h, 1Ch, 03h, 00h, 7Fh
	db	 00h, 00h, 7Fh, 00h, 00h, 7Fh, 00h, 00h, 32h, 49h, 49h, 29h, 7Eh, 00h, 00h, 7Fh
	db	 02h, 01h, 40h, 00h, 00h, 3Eh, 41h, 41h, 22h, 00h, 00h, 3Eh, 41h, 41h, 41h, 3Eh
	db	 00h, 00h, 7Fh, 02h, 01h, 01h, 7Eh, 02h, 01h, 01h, 7Eh, 00h, 00h, 00h, 00h,0FFh
	db	 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h
	db	 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h
	db	 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h
	db	 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h,0FFh

  END
	

