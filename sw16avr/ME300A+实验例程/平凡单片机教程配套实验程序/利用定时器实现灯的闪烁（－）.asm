ORG 0000H
AJMP START
ORG 30H
START: MOV P0,#0FFH  ;�ر����еĵ�
MOV TMOD,#00000001B  ;��ʱ/������0�����ڷ�ʽ1
MOV TH0,#15H
MOV TL0,#0A0H        ;��������Ԥ�ü���5336��15A0H��
SETB TR0             ;��ʱ/������0��ʼ����
LOOP: JBC TF0,NEXT   ;���TF0����1����TF0��0��תnext��
AJMP LOOP            ;������ת��LOOP������
NEXT: CPL P0.0       ;����P0.0��
MOV TH0,#15H         ;
MOV TL0,#0A0H        ;���ö�ʱ/�������ĳ�ֵ
AJMP LOOP
END

