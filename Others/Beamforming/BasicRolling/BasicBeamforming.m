clear all;
close all;

%% Parameters
H = 480;
fps = 30;
% td = 1/fps/H;
td = 1/fps/512;

T = 1/fps;
f0 = 1;
w0 = 2*pi*f0;

L=512; % temporal signal samples 
n = 0:T:(L-1)*T;

signal_var = 1;
amp = sqrt(signal_var*2);

noise_var = 20;

N =80; % spatio samples

%% Matrix Form of Received Signal


s = zeros(2,L);
s(1,:) = exp(j*w0*n)*amp/2; %
s(2,:) = conj(s(1,:));

a = zeros(N,2);
a(:,1) = exp(-j*w0*td*(0:N-1))';
a(:,2) = conj(a(:,1));

w = zeros(N,L);

for i =1:N
    w(i,:) = sqrt(noise_var)*randn(1,L);
end

y = a*s+w;
y_no_delay = ones(N,2)*s+w;

%% Covariance check.

R_s = cov(s');

verify_R_s =abs( signal_var - trace(R_s))<0.0001;  % power of signal is as expected.

R_a = cov(a);
R_y = cov(y');
R_w = cov(w'); % diag{noise_var,..., noise_var}

verify_R_w = abs(noise_var*N-trace(R_w))<0.1; % power of noise is as expected.

R_y_thy = a*R_s*a'+R_w;

verify_R_y = mean(mean(abs(R_y_thy - R_y)))<0.1;



%% Beamforming (EGC)

b_egc = ones(1,N)/N;
y_egc = b_egc*y;
snr_egc = snr(real(y_egc));

verify_b_ecg_norm = abs(1-b_egc*b_egc')<0.01;

%% Beamforming (MVDR) (only positive w0)

b_mvdr = (R_y\a(:,1))/(a(:,1)'*(R_y\a(:,1)));
b_mvdr = b_mvdr';
verify_b_mvdr_norm = abs(1-b_mvdr*b_mvdr')<0.01;

y_mvdr = b_mvdr*y;
snr_mvdr = snr(real(y_mvdr));

%% Multiple Constrint Beamforming (MVDR) 

c = ones(2,1);

tmp_matrix = a'*(R_y\a);
b_mc_mvdr = (R_y\a)*(tmp_matrix\c);
b_mc_mvdr = b_mc_mvdr';
verify_constraint = a'*b_mc_mvdr';
verify_b_mc_mvdr_norm = abs(1-b_mc_mvdr*b_mc_mvdr')<0.01;

y_mc_mvdr = b_mc_mvdr*y;
snr_mc_mvdr = snr(real(y_mc_mvdr));

%% Max SNR without using theta.
[V,D] = eig((R_w')^(1/2)*R_y*R_w^(1/2));
b_opt = R_w^(-1/2)*V(:,1);

y_opt = b_opt'*y;
snr_opt = snr(real(y_opt));

%% wo delay

snr_no_delay = snr(real(b_egc*y_no_delay));

%% figure temporal

figure;
title('temporal y');
hold on;
plot(n,y(1,:));
plot(n,y_egc-1.5);
plot(n,y_mvdr-3);
plot(n,y_mc_mvdr-4.5);
plot(n,y_opt-6);
legend('original 1 channel','egc','mvdr','mc_mvdr','opt');




