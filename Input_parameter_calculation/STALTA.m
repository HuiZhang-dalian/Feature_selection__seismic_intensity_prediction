function [SL]=STALTA(Data,dt)
%Data列向量!!!
a=30/dt;
b=0.5/dt;
c=length(Data);
D(1:a,1)=zeros(a,1);
D(1+a:c+a,1)=Data;
CF(1)=0;
for i=2:c+a
    CF(i)=D(i,1).^2+(D(i,1)-D(i-1,1)).^2;
end
d=CF(a+1);
e=CF(a+1);
SL(1)=(d*(a+1))/(e*(b+1));
for i=a+2:a+c
    d=d+CF(i)-CF(i-1-b);
    e=e+CF(i)-CF(i-1-a);
    SL(i-a)=(d*(a+1))/(e*(b+1));
end
end