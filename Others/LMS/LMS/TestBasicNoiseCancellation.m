%% Description
% All of these test is based on Prediction method.
% That is, the assumption is made. We assume that the signal is either steady or 
% slowly varying over time, and periodic over time as well.
% There are many coeff to be determined, for example, order, step size,
% leaky factor, and so on. 

clear all;close all;
addpath('..\lib');

%% Several parameters.
Length = 512;
n=1:Length;

%% Different kinds of signal.
s = 2*0.99.^n.*sin(0.2*pi*n);
% s = sin(0.1*pi*n);

%% Different kinds of noise.
% v = 0.5*randn(1,Length);
v = 1.2*rand(1,Length)-0.5;

%% Additive signal
d = s+v; % desired signal is also polluted.

%% Prediction scheme (Delay).
% default is delay one, you can try more.
x(1) = 0;
for n = 2:length(s)
    x(n) = v(n-1)+s(n-1); % x(n) is essentially just a delay of d.
end    

%% Filters

[w1,y1,e1,J1,w11,Js1] = lms1(x,d,0.02,8); % basic LMS.
% [w2,y2,e2,J2] = lms_leaky_lms(x,d,0.02,0.2,8); 
% [w2,y2,e2,J2] = lms_self_correcting_lms(x,d,0.02,8,2); % repeated filter.
% [w2,y2,e2,J2] = lms_sign_error(x,d,0.02,8);
% [w2,y2,e2,J2] = lms_sign_regressor(x,d,0.02,8);
% [w2,y2,e2,J2] = lms_sign_sign(x,d,0.02,8);
[w2,y2,e2,J2] = nlms(x,d,0.02,8,0.001);
% [w2,y2,e2,J2] = nlms_sign_error(x,d,0.02,8,0.001);
% [w2,y2,e2,J2] = nlms_sign_regressor(x,d,0.02,8,0.001);
% [w2,y2,e2,J2] = nlms_sign_sign(x,d,0.02,8,0.001);

%% Plot Time domain result.
subplot(4,1,1);
plot(s,'k');
ylabel('signal');
subplot(4,1,2);
plot(d,'k');
ylabel('s+v');
subplot(4,1,3)
plot(y1,'k');
ylabel('y1, lms');
subplot(4,1,4);
plot(y2,'k');
ylabel('y2, nlms');
xlabel('n');

%% Plot Frequency domain result.
S = abs(fft(s));
D = abs(fft(d));
Y1 = abs(fft(y1));
Y2 = abs(fft(y2));

figure;
subplot(4,1,1);
plot(S(1:256));
ylabel('signal');
subplot(4,1,2);
plot(D(1:256));
ylabel('s+v');
subplot(4,1,3);
plot(Y1(1:256));
subplot(4,1,4);
ylabel('y1, lms');
plot(Y2(1:256));
ylabel('y2, nlms');
xlabel('f');