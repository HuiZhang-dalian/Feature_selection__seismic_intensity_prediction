function [Re]=distance(line7,line8,line2,line3)
sla = line7;   %̨վγ��
slo = line8;   %̨վ����
ela = line2;   %����γ��
elo = line3;   %���𾭶�
% Re=abs(111.12*cos(1/(sin(sla)*sin(ela)+cos(sla)*cos(ela)*cos(elo-slo))));%���о�
C = sin(sla/57.2958)*sin(ela/57.2958) + cos(sla/57.2958)*cos(ela/57.2958)*cos((slo-elo)/57.2958);
Re = 6371.004*acos(C);