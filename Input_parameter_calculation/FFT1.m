function [f,P1,XW,XWC]= FFT1(t,Data1)
%t--ʱ����
%Data-��������
%P1--��ֵ
%Period--����
%f--Ƶ��
%�����ֵƵ��
T=t;
Fs=1/T;
L=length(Data1);
Y=fft(Data1);
P2=abs(Y/L);
P1=P2(1:L/2+1);
P1(2:end-1)=2*P1(2:end-1);
P1=P1*L/2*t;
f=Fs*(0:(L/2))/L;
a=real(Y);b=imag(Y);
XW=unwrap(angle(Y(1:L/2+1)));
for i=1:length(XW)-1
    ii=i+1;
    XWC(i)=XW(ii)-XW(i);
end




