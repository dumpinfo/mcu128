ORG 0000H
AJMP START
ORG 000BH                ;��ʱ��0���ж�������ַ
AJMP TIME0               ;��ת�������Ķ�ʱ������
ORG 30H
START: MOV P0,#0FFH      ;�����е�
MOV TMOD,#00000001B      ;��ʱ/������0�����ڷ�ʽ1
MOV TH0,#15H 
MOV TL0,#0A0H            ;��������Ԥ��������5536
SETB EA                  ;�����ж�����
SETB ET0                 ;����ʱ/������0����
SETB TR0                 ;��ʱ/������0��ʼ����
LOOP: AJMP LOOP          ;��������ʱ,�����д�������
mov r7, #09H
djnz r7,start
TIME0:                   ;��ʱ��0���жϴ������
PUSH ACC                 ;��ACC�����ջ����
PUSH PSW                 ;��PSW�����ջ����
CPL P0.0                 ;ȡ��P0.0
MOV TH0,#15H
MOV TL0,#0A0H            ;���ö�ʱ����
POP PSW
POP ACC
RETI
END

