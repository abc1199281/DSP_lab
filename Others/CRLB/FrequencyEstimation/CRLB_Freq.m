fo = .2;
A = 1;
N = 128;
Oversampling = 4;
M = Oversampling*N;

Nrun = 1000; % Montecarlo runs
snr = [-20:45]; % SNR is in dB scale
t = [1:N];
f = [-N/2:N/2-1];
MSE1 =zeros(length(snr),1);
MSE2 =zeros(length(snr),1);
for isnr = 1:length(snr)
    f_est1 = zeros(Nrun,1);
    f_est2 = zeros(Nrun,1);
    for run = 1:Nrun
        % Signal generation
        w = sqrt((A^2/2)*10^(-snr(isnr)/10))*randn(1,N);
        x = A*cos(2*pi*fo*t + 2*pi*rand) + w;
        % Freq. estimation: DFT on M samples
        S = (abs(fft(x,M)).^2)/N; % DFT on M > N samples (zero-padding)
        f_est1(run) = find(S(2:M/2) == max(S(2:M/2))); % Search f = (0:1/2)
        % Freq. estimation : quadratic interpolation
        f_cent = f_est1(run)+1;
        Num = S(f_cent-1)-S(f_cent+1);
        Den = S(f_cent-1)+S(f_cent+1)-2*S(f_cent);
        f_est2(run) = f_cent+.5*Num/Den-1;
    end
    MSE1(isnr) = mean((f_est1/M-fo).^2);
    MSE2(isnr) = mean((f_est2/M-fo).^2);
end
CRB = 12/(N*(N^2-1)).*(10.^(-snr/10)); % CRLB freq. estimation.
MSE_floor = (1/3)*(.5/M)^2; % quantization error +/-(.5/M) 
semilogy(snr,MSE1,'-',snr,MSE2,'-o',snr,CRB/(4*pi^2),'--', ...
    snr,MSE_floor*(1+0*snr),':',snr,((1/4)/12)*(1+0*snr),':')
xlabel('SNR [dB]'); ylabel('MSE_f');
