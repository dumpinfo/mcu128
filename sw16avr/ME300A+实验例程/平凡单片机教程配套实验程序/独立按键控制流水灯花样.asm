; ʹ�ö�������K1��K2��K4��K4ʵ����ˮ�ƻ����仯
; (K1��P1.4  ��ʼ���˼���ƿ�ʼ����(��������) 
;��K2��P1.5  ֹͣ���˼���ֹͣ�������е�Ϊ�� 
; (K3��P1.6  ���󰴴˼���Ʒ��������������� 
;��K4��P1.7  ���Ұ��˼�������������������� 

UpDown EQU 00H ;�����б�־
StartEnd EQU 01H ;�𶯼�ֹͣ��־
LAMPCODE EQU 21H ;������������ݴ���
ORG 0000H
AJMP MAIN
ORG 30H
MAIN:
MOV SP,#5FH
MOV P0,#0FFH
CLR UpDown ;����ʱ�������ϵ�״̬
CLR StartEnd ;����ʱ����ֹͣ״̬
MOV LAMPCODE,#0FEH ;���������Ĵ��� 
LOOP:
ACALL KEY ;���ü��̳���
JNB F0,LNEXT ;����޼����£������
ACALL KEYPROC ;������ü��̴������
LNEXT:
ACALL LAMP ;���õ���ʾ����
AJMP LOOP ;����ѭ���������򵽴˽���
;---------------------------------------
DELAY:
MOV R7,#100
D1: MOV R6,#100
DJNZ R6,$
DJNZ R7,D1
RET
;----------------------------------------��ʱ���򣬼��̴����е���

KEYPROC:
MOV A,B ;��B�Ĵ����л�ȡ��ֵ
JB ACC.4,KeyStart ;�������Ĵ��룬ĳλ�����£����λΪ1����Ϊ�ڼ��̳�������ȡ����
JB ACC.5,KeyOver
JB ACC.6,KeyUp
JB ACC.7,KeyDown
AJMP KEY_RET
KeyStart:
SETB StartEnd ;��һ�������º�Ĵ���
AJMP KEY_RET
KeyOver:
CLR StartEnd ;�ڶ��������º�Ĵ���
AJMP KEY_RET
KeyUp: SETB UpDown ;�����������º�Ĵ���
AJMP KEY_RET
KeyDown:
CLR UpDown ;���ĸ������º�Ĵ���
KEY_RET:RET
KEY:
CLR F0 ;��F0����ʾ�޼����¡�
ORL P1,#11110000B ;��P1�ڵĽ��м�����λ��1
MOV A,P1 ;ȡP3��ֵ
ORL A,#00001111B ;������4λ��1
CPL A ;ȡ��
JZ K_RET ;���Ϊ0��һ���޼�����
ACALL DELAY ;������ʱȥ����
ORL P1,#11110000B
MOV A,P1
ORL A,#00001111B
CPL A
JZ K_RET
MOV B,A ;ȷʵ�м����£�����ֵ����B��
SETB F0 ;�����м����µı�־
K_RET: 
ORL P1,#11110000B ;�˴�ѭ���ȴ������ͷ�
MOV A,P1
ORL A,#00001111B
CPL A
JZ K_RET1 ;ֱ����ȡ������ȡ����Ϊ0˵�����ͷ��ˣ��ŴӼ��̴�������з���
AJMP K_RET
K_RET1: 
RET
;----------------------------------- 
D500MS: ;��ˮ�Ƶ��ӳ�ʱ��
PUSH PSW
SETB RS0
MOV R7,#200
D51: MOV R6,#250
D52: NOP
NOP
NOP
NOP
DJNZ R6,D52
DJNZ R7,D51
POP PSW
RET 
;-----------------------------------
LAMP:
JB StartEnd,LampStart ;���StartEnd=1��������
MOV P0,#0FFH
AJMP LAMPRET ;����ر�������ʾ������
LampStart:
JB UpDown,LAMPUP ;���UpDown=1������������
MOV A,LAMPCODE
RL A ;ʵ�ʾ�������λ����
MOV LAMPCODE,A 
MOV P0,A
LCALL D500MS
AJMP LAMPRET
LAMPUP:
MOV A,LAMPCODE
RR A ;��������ʵ�ʾ�������
MOV LAMPCODE,A
MOV P0,A
LCALL D500MS
LAMPRET: 
RET
END

