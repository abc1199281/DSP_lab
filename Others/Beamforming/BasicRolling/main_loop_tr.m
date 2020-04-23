
fps = 30;

T = 1/fps;
f0 = 1;
w0 = 2*pi*f0;

L=512; % temporal signal samples 
n = 0:T:(L-1)*T;


td_range = [0.0000001:0.01:5]; % SNR is in dB scale
N =80; % spatio samples

snr_no_delay = zeros(1,length(td_range));
snr_egc = zeros(1,length(td_range));
snr_mvdr = zeros(1,length(td_range));
snr_mc_mvdr = zeros(1,length(td_range));
snr_opt = zeros(1,length(td_range));

for idx = 1:length(td_range)
    
    signal_var = 1;
    noise_var =10;
    
    [nsr_no_delay(idx),snr_egc(idx),snr_mvdr(idx),snr_mc_mvdr(idx),snr_opt(idx)]=simulate_beamforming_rolling(fps,td_range(idx),f0,L,N,signal_var,noise_var);
        
end

%% plot

figure;
plot(td_range,snr_no_delay);hold on;
plot(td_range,snr_egc);
plot(td_range,snr_mvdr);
plot(td_range,snr_mc_mvdr);
plot(td_range,snr_opt);
legend('no delay','egc','mvdr','mc mvdr','opt');
