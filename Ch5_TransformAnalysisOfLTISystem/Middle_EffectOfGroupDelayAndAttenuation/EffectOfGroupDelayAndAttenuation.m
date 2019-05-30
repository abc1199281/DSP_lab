
%% System
% H1[z]
b1 = conv([1 -.98*exp(j*.8*pi)],[1 -.98*exp(-j*.8*pi)]);
a1 = conv([1 -.8*exp(j*.4*pi)],[1 -.8*exp(-j*.4*pi)]);
H1 = tf(b1,a1,-1,'Variable','z^-1');

% H2[z]
H2 = tf(1,1,-1,'Variable','z^-1');
for k = 1:4
    ck = 0.95*exp(j*(0.15*pi+0.02*pi*k));
    ck_conj = conj(ck);
    b_tmp = conv([ck_conj -1],[ck -1]);
    b_tmp = conv(b_tmp,b_tmp);
    a_tmp = conv([1 -1*ck],[1 -1*ck_conj]);
    a_tmp = conv(a_tmp,a_tmp);
    H_tmp = tf(b_tmp,a_tmp,-1,'Variable','z^-1');

    H2 = series(H2,H_tmp);
end

% H[z]
H = series(H1,H2);

% Zero-Pole Plot, Fig. 5.2
[b_h,a_h] = tfdata(H );
b_h = cell2mat(b_h);
a_h = cell2mat(a_h);

figure;
zplane(b_h,a_h);
suptitle('Zero-Pole Plot, Fig 5.2');

% System Response.
L=1000;
dw=2*pi/L;
w = -pi:dw:pi-dw;
HH=freqz(b_h,a_h,w);
mag=abs(HH);
phase=angle(HH);

% Fig. 5.3
figure;
subplot(2,1,1);
plot(w,phase);
xticks([-pi -0.8*pi -0.6*pi -0.4*pi -0.2*pi 0 0.2*pi 0.4*pi 0.6*pi 0.8*pi pi]);
xticklabels({'-\pi','-0.8\pi','-0.6\pi','-0.4\pi','-0.2\pi','0','0.2\pi','0.4\pi','0.6\pi','0.8\pi','\pi'});
xlim([-pi pi]);
yticks([-4 -2 -0 2 4]);
ylabel('ARG[H(e^(^j^w^)]');
xlabel('w');
title('Phase response');

subplot(2,1,2);
plot(w,unwrap(phase));
xticks([-pi -0.8*pi -0.6*pi -0.4*pi -0.2*pi 0 0.2*pi 0.4*pi 0.6*pi 0.8*pi pi]);
xticklabels({'-\pi','-0.8\pi','-0.6\pi','-0.4\pi','-0.2\pi','0','0.2\pi','0.4\pi','0.6\pi','0.8\pi','\pi'});
xlim([-pi pi]);
ylabel('arg[H(e^(^j^w^)]');
xlabel('w');
title('Unwrap Phase response');
suptitle('ARG/arg Plot, Fig 5.3');

% Fig. 5.4
figure;
subplot(2,1,1);
plot(w(1:end-1),-1*diff(unwrap(phase))./diff(w));
xticks([-pi -0.8*pi -0.6*pi -0.4*pi -0.2*pi 0 0.2*pi 0.4*pi 0.6*pi 0.8*pi pi]);
xticklabels({'-\pi','-0.8\pi','-0.6\pi','-0.4\pi','-0.2\pi','0','0.2\pi','0.4\pi','0.6\pi','0.8\pi','\pi'});
xlim([-pi pi]);
ylabel('grd[H(e^(^j^w^)]');
title('Group Delay');

subplot(2,1,2);
plot(w,mag);
xticks([-pi -0.8*pi -0.6*pi -0.4*pi -0.2*pi 0 0.2*pi 0.4*pi 0.6*pi 0.8*pi pi]);
xticklabels({'-\pi','-0.8\pi','-0.6\pi','-0.4\pi','-0.2\pi','0','0.2\pi','0.4\pi','0.6\pi','0.8\pi','\pi'});
xlim([-pi pi]);
ylabel('|H(e^(^j^w^)|');
title('Magnitude response');
suptitle('GD/mag Plot, Fig 5.4');

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


%% Output
y = filter(b_h,a_h,x);

% Fig. 5.6
figure;
plot(y);
xlim([0,300]);
xlabel('n');
title('output y[n], Fig 5.6');


%= Compre the Delay sample point.
figure;
subplot(2,1,1);
plot(x);
xlim([0,300]);
xlabel('n');
ylabel('x[n]');
title('input');
subplot(2,1,2);
plot(y);
xlim([0,300]);
xlabel('n');
ylabel('y[n]');
title('output');