;��ѹK1��P1.4��,D00�������𡣰�ѹK2��P1.5����D01��������
ORG 000H
AJMP START
ORG 30H
START: MOV SP,5FH
MOV P0,#0FFH
MOV P1,#0FFH
L1: JNB P1.4,L2      ;���°�������K1��ȡ��һ��P0.0�����������ٰ�һ����
JNB P1.5,L3          ;���°�������K2��ȡ��һ��P0.1�����������ٰ�һ����
LJMP L1
L2: CPL P0.0
LJMP L1
L3: CPL P0.1
LJMP L1
END
