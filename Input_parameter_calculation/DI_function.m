function [DI]=DI_function(dt,a1,a2,a3)
% if nargin==4
    a=sqrt(a1.*a1+a2.*a2+a3.*a3);
    [~,~,v1,~]=PGA_PGD_Vel_Dis(a1,dt);
    [~,~,v2,~]=PGA_PGD_Vel_Dis(a2,dt);
    [~,~,v3,~]=PGA_PGD_Vel_Dis(a3,dt);
    v=sqrt(v1.*v1+v2.*v2+v3.*v3);
% elseif nargin==7
%     a=sqrt(a1.*a1+a2.*a2+a3.*a3);
%     v=sqrt(v1.*v1+v2.*v2+v3.*v3);
% end
DI=max(log((abs(a.*v))));
end

function [PGV,PGD,Vel,Dis]=PGA_PGD_Vel_Dis(data,dt)
%data--数据
%dt--时间间隔
Vel(1)=0;
Dis(1)=0;
for k1=1:length(data)-1
    Vel(k1+1,1)=Vel(k1,1)+dt*data(k1,1)/2+dt*data(k1+1,1)/2;
    Dis(k1+1,1)=Dis(k1,1)+dt*Vel(k1,1)+dt*dt*data(k1,1)/3+dt*dt*data(k1+1,1)/6;
end
PGV=max(abs(Vel));  %单位�? m/s
PGD=max(abs(Dis));  %单位�? m
end