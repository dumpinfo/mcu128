ORG  001BH   ;��ʱ��T1���ж���� 
MOV  TH1,R1  ;��װ��ʱ��ֵ 
MOV  TL1,R0  ; 
CPL  P3.7      ;P1.0������� 
RETI           ;�жϷ��� 
ORG  100H     ;������ 
START:MOV  TMOD,#01H ;��ʱ��T1������ʽ1 
MOV  IE,#88H           ;����T1�ж� 
MOV  DPTR,#TAB        ;����׵�ַ 
LOOP:CLR  A           ; 
MOVC  A,@A+DPTR     ;��� 
MOV  R1,A              ;��ʱ����8Ϊ��R1 
INC  DPTR              ; 
CLR  A                 ; 
MOVC  A,@A+DPTR     ;��� 
MOV  R0,A              ;��ʱ����8Ϊ��R0 
ORL  A,R1               ; 
JZ  NEXT0               ;ȫ0Ϊ��ֹ�� 
MOV  A,R0              ; 
ANL  A,R1               ; 
CJNE  A,#0FFH,NEXT     ;ȫ1��ʾ�������� 
SJMP  START              ;��ͷ��ʼѭ������ 
NEXT:MOV  TH1,R1       ;װ�붨ʱֵ 
MOV  TL1,R0             ; 
SETB  TR1                ;������ʱ�� 
SJMP  NEXT1             ; 
NEXT0:CLR  TR1          ;�رն�ʱ��ֹͣ���� 
NEXT1:CLR  A            ; 
INC  DPTR                ; 
MOVC  A,@A+DPTR       ;���ӳٳ��� 
MOV  R2,A                ; 
LOOP1:LCALL  D200       ;������ʱ200mS�ӳ��� 
DJNZ  R2,LOOP1           ;�����ӳٴ��� 
INC  DPTR                 ; 
AJMP  LOOP               ;������һ������ 
D200:MOV  R4,#81H        ;��ʱ20mS�ӳ��� 
D200B:MOV  A,#0FFH      ; 
D200A:DEC  A             ; 
JNZ  D200A                ; 
DEC  R4                   ; 
CJNE  R4,#00H,D200B       ; 
RET                        ; 
TAB:      DB  0FEH,25H,02H,0FEH,25H,02H;   
          DB  0FEH,84H,02H,0FEH,84H,02H; 
          DB  0FEH,84H,04H,0FEH,25H,04H;    
	  DB  0FEH,25H,02H,0FEH,84H,02H; 
          DB  0FEH,0C0H,04H,0FEH,0C0H,04H; 
	  DB  0FEH,98H,02H,0FEH,84H,02H; 
          DB  0FEH,57H,08H,00H,00H,04H;     
	  DB  0FFH,0FFH; 
          END 

