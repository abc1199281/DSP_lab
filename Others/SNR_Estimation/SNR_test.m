close all;
clear all;
A = 0.7;
N = 512;
Oversampling =4;
T = 1/30; % sec
fo = 1; % Hz
M = Oversampling*N;
rng('default');
Nrun = 1000; % Montecarlo runs
snr_step =1;
snr_range = [-20:snr_step:30]; % SNR is in dB scale
n = [1:N];
f = [-N/2:N/2-1];


avg_estimated_pnr = zeros(length(snr_range),1);
avg_matlab_snr = zeros(length(snr_range),1);

for isnr = 1:length(snr_range)

    for run = 1:Nrun
        %% No band limit.
        % Signal generation
        w = sqrt((A^2/2)*10^(-snr_range(isnr)/10))*randn(1,N); % All band white noise.
        x = A*cos(2*pi*fo*T*n + 2*pi*rand) + w;
        % Freq. estimation: DFT on M samples
        S = (abs(fft(x,M)).^2)/N; % DFT on M > N samples (zero-padding)
        
        avg_estimated_pnr(isnr) = avg_estimated_pnr(isnr)+estimatePNR(S(2:M/2)); % Both Signal and Noise limited.
        avg_matlab_snr(isnr) = avg_matlab_snr(isnr)+snr(x);
    end
end
avg_estimated_pnr = avg_estimated_pnr./Nrun;
avg_matlab_snr = avg_matlab_snr./Nrun;

%% PNR Estimation Basic Version.
figure;
plot(snr_range,avg_matlab_snr);
hold on;
plot(snr_range,avg_estimated_pnr);
xlabel('True SNR [dB]');
ylabel('Estimated SNR');
legend('Matlab Built-in SNR Estimation','Conventional Method');

%% PNR Estimation Basic Version.
function pnr = estimatePNR(spectrum)
    [mag,index]=max(spectrum);
    
    peak_power = spectrum(index);
    if index>=2
        peak_power = peak_power+spectrum(index-1);
    end
    if index<length(spectrum)
        peak_power = peak_power+spectrum(index+1);
    end
    noise_power = sum(spectrum)-peak_power;
    pnr = 10*log10(peak_power/noise_power);
end

%% Implementation of SNR Function
function snr = betterSNR()
    % comming soon.
end