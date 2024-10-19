clear all;close all;clc;
%%
% 虚拟基线法测向：最短基线长度大于半波长，利用虚拟阵元产生的虚拟基线(小于半波长)来解模糊
% 3阵元；要求扫描范围正负65度内无模糊
%%
f0=124.8e9;
c=3e11;
lamta=c/f0;
K=2*pi/lamta;
N=3;
% a1=1;a2=0.4;
% d=a1*lamta;dx=a2*lamta;
% d12=d;d23=d+dx;

d12=2.5;d23=3.5;dx=d23-d12;
a1=d12/lamta;a2=dx/lamta;

d13=d12+d23;
P3=[0;d12;d13];

t=0:1/(2*f0):1023/(2*f0);% 快拍个数
T=length(t);

SNR=18 ;
theta=0:1:65;
for i_SNR=1:length(SNR)
    SNR(i_SNR)
%     ii=i_SNR;
    for i_theta=1:1:length(theta)
        ii=i_theta;
        theta0=theta(i_theta)
        as=zeros(N,1);
        for k=1:1:N
            as(k,1)=exp(1j*K*P3(k,1)*sind(theta0));
        end
        for i_Monte=1:1:10000   
            %% signal and noise
            A=sqrt(10^(SNR(i_SNR)/10));                 %期望信号和干扰信号的幅度
            S=A*exp(1j*2*pi*f0*t);
            Noise=zeros(N,T);
            for k=1:1:N
                Noise(k,:)=(randn(1,T)+1j*randn(1,T))/sqrt(2);
            end;
            X=as*S+Noise;       % 没信号条件下的数据
            %% baseline 1: 1_3
            phi12=angle(X(2,540)./X(1,540));%相位差
            phi23=angle(X(3,540)./X(2,540));
            phi1_3=phi23-phi12;
            if phi1_3<-pi
                phi1_3=phi1_3+2*pi; 
            else
                if phi1_3>pi
                    phi1_3=phi1_3-2*pi;
                end
            end
            theta_est1(ii,i_Monte)=asind(phi1_3/K/dx);
            %% baseline 2: 1 2
            m=d12/dx;
            k1=round((m*phi1_3-phi12)/2/pi);
            phi12_real=phi12+2*k1*pi;
            theta_est2(ii,i_Monte)=asind(phi12_real/K/d12);
            %% baseline 3: 2 3
            m=d23/d12;
            k2=round((m*phi12_real-phi23)/2/pi);
            phi23_real=phi23+2*k2*pi;
            theta_est3(ii,i_Monte)=asind(phi23_real/K/d23);
            %% baseline 4: 1 3
            phi13=angle(X(3,540)./X(1,540));%相位差
            m=d13/d23;
            k3=round((m*phi23_real-phi13)/2/pi);
            phi13_real=phi13+2*k3*pi;
            theta_est4(ii,i_Monte)=asind(phi13_real/K/d13);
            
            %         phi13=angle(X(3,540)./X(1,540));%相位差
            %         m=d13/dx;
            %         k=round((m*phi1_3-phi13)/2/pi);
            %         phi13_real=phi13+2*k*pi;
            %         theta_est2(i_SNR,i_Monte)=asind(phi13_real/K/d13);
        end
        error_theta(ii,:)=theta_est4(ii,:)-theta0;
        rmse_theta(ii)=sqrt(mean(error_theta(ii,:).^2));
    end  
end
figure;hold on;
subplot(2,1,1);
plot(P3,[0 0 0],'r*');
title(['d12=',num2str(d12,3),'mm, ','d23=',num2str(d23,3),'mm  ','(d=',num2str(a1),'*lamta, ','dx=',num2str(a2),'*lamta)']);
subplot(2,1,2);
% plot(SNR,rmse_theta,'r-*');xlabel('SNR (dB)');
plot(theta,rmse_theta,'r-*');xlabel('theta (degree)');
hold off;box on;
ylabel('RMSE (degree)');
