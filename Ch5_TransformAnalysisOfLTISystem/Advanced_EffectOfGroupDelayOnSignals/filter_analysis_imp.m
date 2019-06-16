function filter_analysis_imp(imp_rep,fps,title_)

N = 2^nextpow2(length(imp_rep));
F = fft(imp_rep,N);
freq_step = fps/N;
freq = -fps/2:freq_step:fps/2-freq_step;
freq = freq.*60; %Hz to bpm
freq = freq(N/2+1:end)';

figure;
plot(freq,abs(F(1:N/2)));
xlabel('freq(bpm)');
ylabel('mag');
title(title_);

figure;
Y = angle(F(1:end))*180/pi;

plot(freq,  (Y(1:N/2)));
% Uncomment and think.
% plot(freq,  unwrap(Y(1:N/2)));

xlabel('freq(bpm)');
ylabel('Phase (degree)');
title(title_);

figure;
Y = angle(F(1:end));
Y = -1*diff(Y)/freq_step/2/pi/fps;

plot(freq,  (Y(1:N/2)));
% Uncomment and think.
% plot(freq,  unwrap(Y(1:N/2)));

xlabel('freq(bpm)');
ylabel('Group delay [sec]');
title(title_);


end