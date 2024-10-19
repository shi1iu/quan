clear all;clc;
f0=140e9;
c=3e11;
lamta=c/f0;
K=2*pi/lamta;
N=3;
a1=1.0;a2=0.4;
d=a1*lamta;dx=a2*lamta;
d12=d;d23=d+dx;d13=d12+d23;
P3=[0;d12;d13];
t=0:1/(2*f0):1023/(2*f0);% 快拍个数
T=length(t);

theta0=65;
as=zeros(N,1);
for k=1:1:N
    as(k,1)=exp(1j*K*P3(k,1)*sind(theta0));
end
%% signal and noise
SNR=18;
A=sqrt(10^(SNR/10));                 %期望信号和干扰信号的幅度
S=A*exp(1j*2*pi*f0*t);
Noise=zeros(N,T);
for k=1:1:N
    Noise(k,:)=(randn(1,T)+1j*randn(1,T))/sqrt(2);
end;
X=as*S+Noise;       % 没信号条件下的数据

%% 输入相差（弧度，范围在-pi~pi）
phi12=angle(X(2,540)./X(1,540));%相位差
phi23=angle(X(3,540)./X(2,540));
phi13=angle(X(3,540)./X(1,540));
theta_est4=DOA_Function(phi12,phi23,phi13);

% gg

