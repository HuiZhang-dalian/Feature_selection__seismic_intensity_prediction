function [Ia]=Arias(data,dt)
m=length(data);
Ia=0;
g=980;    %��λgal
for k6=1:m-1
    Ia=Ia+(data(k6)*data(k6)+data(k6+1)*data(k6+1)+data(k6)*data(k6+1))*dt*pi/(6*g);   %��λ��cm/s
end