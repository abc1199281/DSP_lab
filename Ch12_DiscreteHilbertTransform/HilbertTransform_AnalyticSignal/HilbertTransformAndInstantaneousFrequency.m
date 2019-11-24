clear all;
close all;

%% Parameter
fs = 1e2;
t = 0:1/fs:2;
N = length(t);
snr = 50; % You can change the SNR and observe the influence on frequency estimation results.


%% Signal Generation
x = chirp(t,0,1,10);
w =  sqrt(10^(-snr/10))*randn(1,N); % All band white noise.
x = x+w;
y = hilbert(x);

%% Instaneous Phase And Frequency Estimation
% phase
phase = unwrap(angle(y));

% Frequency
inst_freq = diff(phase)*fs/2/pi;


%% Plot Result
% signal
plot(t,x);
legend('Origin signal');
% hold on
% plot(t,real(y))
% plot(t,imag(y))
% hold off
% xlabel('t(sec)');
% legend('Origin signal','Real Part','Imaginary Part')


% phase
figure;
plot(t,phase);
ylabel('unwraped phase(rad)');
xlabel('t(sec)');
legend('instantaneous phase');


% Frequency
figure;
plot(t(1:end-1),inst_freq);
xlabel('t(sec)');
ylabel('freq(Hz)');
legend('instantaneous frequency');

