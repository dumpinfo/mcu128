;**************************************************************
;* This stationery is meant to serve as the framework for a   *
;* user application. For a more comprehensive program that    *
;* demonstrates the more advanced functionality of this       *
;* processor, please see the demonstration applications       *
;* located in the examples subdirectory of the                *
;* Metrowerks Codewarrior for the HC08 Program directory      *
;**************************************************************

; export symbols
            XDEF Entry, main
            ; we use export 'Entry' as symbol. This allows us to
            ; reference 'Entry' either in the linker .prm file
            ; or from C/C++ later on
                       
; include derivative specific macros
            Include 'sr12_registers.inc'

; variable/data section
MY_ZEROPAGE: SECTION  SHORT
; Insert here your data definition. For demonstration, temp_byte is used.
temp_byte ds.b 1
delay  ds.b   1
num  EQU  5
; code section
MyCode:     SECTION
main
            SEI 
            CLRA
            CLRX
            LDA  #$09
            STA  CONFIG1  ;COP禁止， 5V模式
            BCLR 5,PTCL   ;关闭锁相环
            LDA  #$40
            STA  PWMDR2
            STA  PWMDR1
            STA  PWMDR0
            LDA  #$02
            STA  PWMCCR   ;选用CGMOUT作为PWM的输入时钟，预分频系数为4
            LDA  #$1A     ;设置PWM2与PWM1之间的相位差为52个总线时钟周期
            STA  PWMPCR
            BSET 7,PWMPCR ;使能相位差控制。
            MOV  #num, delay
            LDA  #$E7
            STA  PWMCR     ;启动PWM，  ￥￥￥
      LOOP: LDA  delay
            CMP  #0
            DECA
            STA  delay
            BHI  LOOP
            LDA  #$8D      ;设置PWM1与PWM0之间的相位差为26个总线时钟周期
            STA  PWMPCR    
            JMP  *         ;从 ￥￥￥到此总共运行65个时钟周期
            
Entry:
            CLI               ; enable interrupts
            MOV #1,temp_byte  ; just some demonstration code
            BSR main          ; Insert here your own code
            BRA Entry         ; endless loop


