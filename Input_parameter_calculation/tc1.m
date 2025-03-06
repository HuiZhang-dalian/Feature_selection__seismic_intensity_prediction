function [tc]=tc1(dis,vel,dt)
%dis-完整位移时程,vel-完整速度时程,dt-时间间隔,t1-�?始时�?,t2-结束时刻
if length(dis)~=length(vel)
    disp('error')
end
a=length(dis);
Dis(1,1)=0;Dis(2:a+1,1)=dis;
Vel(1,1)=0;Vel(2:a+1,1)=vel;
s1=0;
for i=1:length(dis)
    s1=s1+(Dis(i,1)*Dis(i,1)+Dis(i,1)*Dis(i+1,1)+Dis(i+1,1)*Dis(i+1,1))/3;
end
s2=0;
for i=1:length(dis)
    s2=s2+(Vel(i,1)*Vel(i,1)+Vel(i,1)*Vel(i+1,1)+Vel(i+1,1)*Vel(i+1,1))/3;
end
tc=2*pi*sqrt(s1/s2);
end