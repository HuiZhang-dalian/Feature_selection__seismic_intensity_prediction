function [Re]=distance(line7,line8,line2,line3)
sla = line7;   %台站纬度
slo = line8;   %台站经度
ela = line2;   %地震纬度
elo = line3;   %地震经度
% Re=abs(111.12*cos(1/(sin(sla)*sin(ela)+cos(sla)*cos(ela)*cos(elo-slo))));%震中距
C = sin(sla/57.2958)*sin(ela/57.2958) + cos(sla/57.2958)*cos(ela/57.2958)*cos((slo-elo)/57.2958);
Re = 6371.004*acos(C);