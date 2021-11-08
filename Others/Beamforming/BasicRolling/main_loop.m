
fps = 30;
td = 1/fps/512;

T = 1/fps;
f0 = 1;
w0 = 2*pi*f0;

L=512; % temporal signal samples 
n = 0:T:(L-1)*T;


snr_range = [-20:45]; % SNR is in dB scale
N =480; % spatio samples

snr_no_delay = zeros(1,length(snr_range));
snr_egc = zeros(1,length(snr_range));
snr_mvdr = zeros(1,length(snr_range));
snr_mc_mvdr = zeros(1,length(snr_range));
snr_opt = zeros(1,length(snr_range));

for isnr = 1:length(snr_range)
    
    signal_var = 1;
    noise_var =10^(-snr_range(isnr)/10)*signal_var;
    [nsr_no_delay(isnr),snr_egc(isnr),snr_mvdr(isnr),snr_mc_mvdr(isnr),snr_opt(isnr)]=simulate_beamforming_rolling(fps,td,f0,L,N,signal_var,noise_var);
        
end

%% plot

figure;
plot(snr_range,snr_no_delay);hold on;
plot(snr_range,snr_egc);
plot(snr_range,snr_mvdr);
plot(snr_range,snr_mc_mvdr);
plot(snr_range,snr_opt);
legend('no delay','egc','mvdr','mc mvdr','opt');
