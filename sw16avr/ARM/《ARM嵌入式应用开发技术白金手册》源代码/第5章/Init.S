                                                   ;EP7312处理器启动代码
;--------------------------------------------------
SBADDR        	EQU 0x80000000
rMEMCFG1      	EQU SBADDR+0x0180
rMEMCFG2      	EQU SBADDR+0x01C0
rINTMR1       	EQU SBADDR+0x0280
rINTMR2       	EQU SBADDR+0x1280
rINTSR1        	EQU SBADDR+0x0240
rINTSR2        	EQU SBADDR+0x1240
rSDCONF       	EQU SBADDR+0x2300
rSDRFPR       	EQU SBADDR+0x2340
rSYSCON2      	EQU SBADDR+0x1100
rSYSCON3      	EQU SBADDR+0x2200
;--------------------------------------------------
_SVC_STKSIZE  EQU 1024*1
;--------------------------------------------------
        AREA  |Assembly$$code|, CODE, READONLY
        ENTRY
        b ResetHandler  			                      ;复位向量	
        b .             				              ;保留handlerUndef
        b .             				              ;保留handlerSWI
        b .             				              ;保留handlerPAbort
        b .             				              ;保留handlerDAbort
        b .             				              ;保留handlerReserved
        b .             				              ;保留handlerIRQ
        b .             				              ;保留handlerFIQ
;-------------------------------------------------
ResetHandler
        ldr r0,=0x00000070		          	              ;禁止MMU
        mcr p15,0,r0,c1,c0,0		
;-------------------------------------------------
        ldr r0,=0x00000000			                      ;禁止中断
        ldr r12,=rINTMR1
        str r0,[r12]                			              ;INTMR1 = 0x8000.0280
        ldr r12,=rINTMR2
        str r0,[r12]                			              ;INTMR2 = 0x8000.1280
;------------------------------------------------       
DRAMControlvalue  EQU 0x00000543 	                              ;CASLAT=3, SDSIZE=128Mb, SDWIDTH=16
DRAMConfigvalue   EQU 0x00000900 	                              ;REFRATE=64uS at 36MHz BCLK
        ldr r1,=DRAMControlvalue		                      ;设置SDRAM参数
        ldr r12,=rSDCONF			                      ;rSDCONF = 0x8000.2300
        str r1,[r12]
        ldr r12,=rSYSCON2
        str r0,[r12]				                      ;rSYSCON2 = 0x8000.1100    
        ldr r1,=DRAMConfigvalue		                              ;设置SDRAM刷新速度
        ldr r12,=rSDRFPR
        str r1,[r12]				                      ;rSDRFPR = 0x8000.2340
;------------------------------------------------        
        ldr r1,=0x06				                      ;设置系统时钟为74MHz
        ldr r12,=rSYSCON3
        str r1,[r12]				                      ;rSYSCON3 = 0x8000.2200
;-----------------------------------------------                
MemConfig1value  EQU 0x0202023c	                                      ;nCS0 = NOR FLASH, 8-bit, 0 wait states
MemConfig2value  EQU 0x0000023f   	                              ;nCS4 = for FPGA, 16-bit, 0 wait states   
        ldr r1,=MemConfig1value		                              ;配置存储器位宽格式与等待状态
        ldr r12,=rMEMCFG1
        str r1,[r12]                			              ;MEMCFG1 = 0x8000.0180
        ldr r1,=MemConfig2value
        ldr r12,=rMEMCFG2
        str r1,[r12]                			              ;MEMCFG2 = 0x8000.01c0
;-----------------------------------------------
        ldr sp,=SVCStack			                      ;设置堆栈
;-----------------------------------------------
        IMPORT C_vMain
        bl C_vMain                  			              ;跳转到C程序入口
        b ResetHandler              		                      ;复位
;-----------------------------------------------
        AREA  SYS_STK, DATA, READWRITE, NOINIT
SVCStack_start    % _SVC_STKSIZE    	                              ;堆栈区
SVCStack
;-----------------------------------------------
        END