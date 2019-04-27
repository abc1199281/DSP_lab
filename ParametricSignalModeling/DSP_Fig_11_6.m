%% Here is the code to generate Fig. 11.16 in the DSP bible v3.
n= 0:101;
s = 20*cos(0.2*pi*n-0.1*pi) + 22* cos(0.22*pi*n+0.9*pi);

[d, p] = aryule(s,4);
[a, e] = arcov(s,4);

[Ha, wa] = freqz(sqrt(p),d);
[Hc, wc] = freqz(sqrt(e),a);

periodogram(s)
hold on;
hp = plot(wa/pi, 20*log10(2*abs(Ha)/(2*pi)),'r'); % Scale to make on-sided PSD
hp.LineWidth=2;
hp = plot(wc/pi, 20*log10(2*abs(Hc)/(2*pi)),'b'); % Scale to make on-sided PSD
hp.LineWidth=2;
xlabel('Normalized frequency (\times \pi rad/sample)');
ylabel('One-sided PSD (dB/rad/sample)');
legend('PSD estimate of x', 'PSD of model output (auto)', 'PSD of model output (cov)');