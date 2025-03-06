function [CAV]=CAVS(data,dt)
m=length(data);
CAV=0;
for k9=1:m-1
    if data(k9)*data(k9+1)>=0
        CAV=CAV+abs(data(k9)+data(k9+1))*dt/2;
    else 
        CAV=CAV+1/2*data(k9)*data(k9)*dt/(abs(data(k9))+abs(data(k9+1)))...
             +1/2*data(k9)*data(k9)*dt/(abs(data(k9))+abs(data(k9+1)));
    end
end