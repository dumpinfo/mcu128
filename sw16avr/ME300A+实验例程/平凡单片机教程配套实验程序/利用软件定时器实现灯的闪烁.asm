;�������ʱ��ʵ��P0.0�����ӵư�1S/�ζ�P0.1�����ӵư�2S/����˸
ORG 0000H
AJMP START
ORG 000BH                ;��ʱ��0���ж�������ַ
AJMP TIME0               ;��ת�������Ķ�ʱ������
ORG 0030H
START: MOV P0,#0FFH      ;�����е�
MOV 30H,#00H             ;�������������
MOV TMOD,#00000001B      ;��ʱ/������0�����ڷ�ʽ1
MOV TH0,#3CH 
MOV TL0,#0A0H            ;��������Ԥ��������15536
SETB EA                  ;�����ж�����
SETB ET0                 ;����ʱ/������0����
SETB TR0                 ;��ʱ/������0��ʼ����
LOOP: AJMP LOOP          ;��������ʱ,�����д�������
TIME0:                   ;��ʱ��0���жϴ������
PUSH ACC                 ;��ACC�����ջ����
PUSH PSW                 ;��PSW�����ջ����
INC 30H
INC 31H                  ;��������������1
MOV A,30H
CJNE A,#255,TNEXT         ;30H��Ԫ�е�ֵ����20����         
CPL P0.0                 ;���ˣ�ȡ��P0.0
MOV 30H,#0               ;�����������
TNEXT:MOV A,31H
CJNE A,#40,TRET           ;31H��Ԫ�е�ֵ����40����
CPL P0.1
MOV 31H,#0                ;���ˣ�ȡ��P1.1�����������������
TRET: MOV TH0,#15H        ;���ö�ʱ����
MOV TL0,#9FH            
POP PSW
POP ACC
RETI
END

