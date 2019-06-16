%% Signal
M = 60;
n = 0:M;
w = 0.54-0.46*cos(2*pi*n/M);

N = 512;
x1 = zeros(1,N);
x2 = zeros(1,N);
x3 = zeros(1,N);
dw = 2*pi/N;
w_freq = -pi:dw:pi-dw;

for i = 0:M
    
    x1(i+M) = w(i+1)*cos(0.2*pi*i);
    x2(i+2*M-1) = w(i+1)*cos(0.4*pi*i-pi/2);
    x3(i+1) = w(i+1)*cos(0.8*pi*i+pi/5);
end
x = x1+x2+x3;
X = abs(fft(x));
X = fftshift(X);

% Fig. 5.5
figure;
subplot(2,1,1);
plot(x);
title('x[n]');
xlim([0,300]);
subplot(2,1,2);
plot(w_freq,X);
xticks([-pi -0.8*pi -0.6*pi -0.4*pi -0.2*pi 0 0.2*pi 0.4*pi 0.6*pi 0.8*pi pi]);
xticklabels({'-\pi','-0.8\pi','-0.6\pi','-0.4\pi','-0.2\pi','0','0.2\pi','0.4\pi','0.6\pi','0.8\pi','\pi'});
xlim([-pi pi]);
ylabel('|H(e^(^j^w^)|');
title('DTFT of X');
suptitle('Input time/Freq., Fig 5.5');

%% Analysis
filter_analysis_imp(x,1,'Signal Analysis Using Group Delay');

%% Inverse Check

y = ifft(fft(x));

figure;
plot(y);
hold on;
plot(x-3);
legend('origin','inversed');




