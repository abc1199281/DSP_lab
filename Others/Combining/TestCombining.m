clear all;
close all;

%% Parameters
fps = 30;

T = 1/fps;
f0 = 1;
w0 = 2*pi*f0;

L=512; % temporal signal samples 
n = 0:T:(L-1)*T;

signal_var = 1;
amp = sqrt(signal_var*2);
snr_sim = 5;
noise_var =10^(-snr_sim/10)*signal_var;

N =200; % spatio samples

%% Matrix Form of Received Signal

w = zeros(N,L);
s = zeros(N,L);
x = zeros(N,L);
% phi_rand = 2*pi*rand(1,N)';
phi_rand = zeros(1,N); 
phi_rand(N/2:end) = pi;

for i =1:N
    w(i,:) = sqrt(noise_var)*randn(1,L);
    s(i,:) = amp*cos(w0*n+phi_rand(i));
    x(i,:) = s(i,:)+w(i,:);
end

%%
%% Receiver
%% 


%% Covariance check.

R_x = cov(x');
R_w = cov(w');

%% Phase Estimation
% phi_hat = zeros(1,N);
% for i = 1:N
%     signal = s(i,:);
%     phi_hat(i)= estimatePhase(fft(signal));
%     
% end

phi_hat = phi_rand;

% a vector simulation
a = zeros(N,2);
a(:,1) = exp(j*phi_hat)';
a(:,2) = conj(a(:,1));


%%
figure;
subplot(3,1,1);
plot(n,s(1,:));
subplot(3,1,2);
plot(n,s(2,:));
subplot(3,1,3);
plot(n,s(N,:));


%% EGC
b_egc = ones(1,N)/N;
y_egc = b_egc*x;
psd_egc = abs(fft(y_egc).^2)/L;

pnr_egc = estimatePNR(psd_egc)

inverse_egc = ifft(sqrt(psd_egc));
inverse_egc(1)=0;
inverse_egc=inverse_egc-mean(inverse_egc);

%% MRC spectrum
psd_mrc = zeros(1,L);

for i = 1:N
    S = abs(fft(x(i,:)).^2)/L;
%     alpha = sqrt(estimatePNR(S));
    db_snr = snr(s(i,:));
    alpha = sqrt(10^(db_snr/10));
    psd_mrc = psd_mrc + S*alpha;
    
end


inverse_mrc = ifft(sqrt(psd_mrc));
inverse_mrc(1) = 0;
inverse_mrc = inverse_mrc-mean(inverse_mrc);

new_psd_mrc = abs(fft(inverse_mrc).^2)/L;

old_snr_mrc = estimatePNR(psd_mrc)
new_snr_mrc = estimatePNR(new_psd_mrc)

%% MVDR with constraints, and the phase is given.
c = ones(2,1)*N;

tmp_matrix = a'*(R_x\a);
b_mc_mvdr = (R_x\a)*(tmp_matrix\c);
b_mc_mvdr = b_mc_mvdr';
verify_constraint = a'*b_mc_mvdr';
verify_b_mc_mvdr_norm = abs(1-b_mc_mvdr*b_mc_mvdr')<0.01;

y_mc_mvdr = b_mc_mvdr*x;

% Max SNR if the covariance of noise is given, and the phase is given.
[V,D] = eig((R_w')^(1/2)*R_x*R_w^(1/2));
b_opt = R_w^(-1/2)*V(:,1);

y_opt = b_opt'*x;

psd_mvdr = abs(fft(y_opt).^2)/L;
snr_mc_mvdr = estimatePNR(psd_mvdr)

inverse_mvdr = real(ifft((psd_mvdr)));
inverse_mvdr(1)=0;
inverse_mvdr=inverse_mvdr-mean(inverse_mvdr);

%% Plot spectrum
figure;
subplot(4,1,1);
plot(n,psd_egc);
title('egc');

subplot(4,1,2);
plot(n,psd_mrc);
title('mrc old');

subplot(4,1,3);
plot(n,new_psd_mrc);
title('white noise suppression');

subplot(4,1,4);
plot(n,psd_mvdr);
title('Max SNR');


%% Plot spectrum
figure;
subplot(3,1,1);
plot(n,inverse_egc);
title('egc');

subplot(3,1,2);
plot(n,inverse_mrc);
title('mrc');

subplot(3,1,3);
plot(n,inverse_mvdr);
title('Max SNR');

t1 = snr(inverse_egc)
t2 = snr(inverse_mrc)
t3 = snr(inverse_mvdr)

 %% PNR Estimation Basic Version.
function pnr = estimatePNR(PowerSpectrumDensity)
    [mag,index]=max(PowerSpectrumDensity);

    peak_power = PowerSpectrumDensity(index);
    if index>=2 % add the bin before the max.
        peak_power = peak_power+PowerSpectrumDensity(index-1);
    end
    if index<length(PowerSpectrumDensity) % add the bin after the max.
        peak_power = peak_power+PowerSpectrumDensity(index+1);
    end
    noise_power = sum(PowerSpectrumDensity)-peak_power;
    pnr =peak_power/noise_power;
end

 %% Basic phase estimation
 
function phi = estimatePhase(input_spectrum)
    [mag,index]=max(abs(input_spectrum(1:length(input_spectrum)/2)));

    phi = angle(input_spectrum(index));
end
 

