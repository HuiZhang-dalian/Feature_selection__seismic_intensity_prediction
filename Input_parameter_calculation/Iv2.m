function [result]=Iv2(a,dt)
% if nargin==2
%     m=0;
%     n=length(a);
% elseif nargin==4
%     m=ceil(t1/dt);
%     n=floor(t2/dt);
% end
% if size(a,1)>1&&size(a,2)==1
%     
% elseif size(a,1)==1&&size(a,2)>1
%     a=a';
% else
%     disp('error')
% end
% k=length(a);
% a(1,1)=0;
% a(2:k+1,1)=a;
result=0;
for i=1:length(a)-1
    result=result+(a(i,1).^2+a(i,1).*a(i+1,1)+a(i+1,1).^2).*dt./3;
end
end