function theta_est4=DOA_Function(phi12,phi23,phi13)
%%
% 虚拟基线法测向：最短基线长度大于半波长，利用虚拟阵元产生的虚拟基线(小于半波长)来解模糊
% 3阵元；要求扫描范围正负65度内无模糊
display('测向函数的输入值为阵元间接收信号的相位差（弧度表示，范围在-pi~pi）');
%%
f0=140e9;
c=3e11;
lamta=c/f0;
K=2*pi/lamta;
N=3;
a1=1.0;a2=0.4;
d=a1*lamta;dx=a2*lamta;
d12=d;d23=d+dx;d13=d12+d23;
P3=[0;d12;d13];
%% baseline 1: 1_3
% phi12=phi2-phi1;%相位差
% phi23=phi3-phi2;
phi1_3=phi23-phi12;
if phi1_3<-pi
    phi1_3=phi1_3+2*pi;
else
    if phi1_3>pi
        phi1_3=phi1_3-2*pi;
    end
end
theta_est1=asind(phi1_3/K/dx);
%% baseline 2: 1 2
m=d12/dx;
k1=round((m*phi1_3-phi12)/2/pi);
phi12_real=phi12+2*k1*pi;
theta_est2=asind(phi12_real/K/d12);
%% baseline 3: 2 3
m=d23/d12;
k2=round((m*phi12_real-phi23)/2/pi);
phi23_real=phi23+2*k2*pi;
theta_est3=asind(phi23_real/K/d23);
%% baseline 4: 1 3
% phi13=phi3-phi1;%相位差
m=d13/d23;
k3=round((m*phi23_real-phi13)/2/pi);
phi13_real=phi13+2*k3*pi;
theta_est4=asind(phi13_real/K/d13);
display(['DOA=',num2str(theta_est4),'°']);
end











