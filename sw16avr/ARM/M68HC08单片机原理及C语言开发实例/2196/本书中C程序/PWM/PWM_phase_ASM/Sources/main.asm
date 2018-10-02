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
            STA  CONFIG1  ;COP��ֹ�� 5Vģʽ
            BCLR 5,PTCL   ;�ر����໷
            LDA  #$40
            STA  PWMDR2
            STA  PWMDR1
            STA  PWMDR0
            LDA  #$02
            STA  PWMCCR   ;ѡ��CGMOUT��ΪPWM������ʱ�ӣ�Ԥ��Ƶϵ��Ϊ4
            LDA  #$1A     ;����PWM2��PWM1֮�����λ��Ϊ52������ʱ������
            STA  PWMPCR
            BSET 7,PWMPCR ;ʹ����λ����ơ�
            MOV  #num, delay
            LDA  #$E7
            STA  PWMCR     ;����PWM��  ������
      LOOP: LDA  delay
            CMP  #0
            DECA
            STA  delay
            BHI  LOOP
            LDA  #$8D      ;����PWM1��PWM0֮�����λ��Ϊ26������ʱ������
            STA  PWMPCR    
            JMP  *         ;�� �����������ܹ�����65��ʱ������
            
Entry:
            CLI               ; enable interrupts
            MOV #1,temp_byte  ; just some demonstration code
            BSR main          ; Insert here your own code
            BRA Entry         ; endless loop


