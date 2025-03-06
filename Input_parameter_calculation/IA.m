function [IA]=IA(data,dt)
% Riddle&Garcia指标
%data--数据
%dt--时间间隔
Vel(1)=0;
Dis(1)=0;
for k1=1:length(data)-1
    Vel(k1+1)=Vel(k1)+dt*data(k1)/2+dt*data(k1+1)/2;
    Dis(k1+1)=Dis(k1)+dt*Vel(k1)+dt*dt*data(k1)/3+dt*dt*data(k1+1)/6;
end
PGA=max(abs(data));
PGV=max(abs(Vel));  %单位是 m/s
PGD=max(abs(Dis));  %单位是 m
IT=0;
m=length(data);
for k4=1:m-1
    IT=IT+(data(k4)*data(k4)+data(k4+1)*data(k4+1)+data(k4)*data(k4+1))...
        *dt/3;
end
ITt=0;
T=(m-1)*dt;
for k5=1:m-1
   ITt=ITt+(data(k5)*data(k5)+data(k5+1)*data(k5+1)+data(k5)*data(k5+1))...
        *dt/3;
   if ITt>0.05*IT
       t1(k5)=dt*(k5-1);
   else t1(k5)=T;
   end
   if ITt>0.95*IT
       t2(k5)=dt*(k5-1);
   else t2(k5)=T;
   end
end
T1=min(t1);
T2=min(t2);
D90=T2-T1;
IA=PGA.*(D90).^(1/3);
