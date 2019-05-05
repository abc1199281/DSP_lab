fps = 30;

LPF = 0.5;
HPF = 3.33;

n = -511:512;
n0 = 0;
imp = (n==n0);


%% Original filter in C
tmp_N = 512;
tmp_n = 0:1:tmp_N-1;
freq = ( n .* fps) ./ tmp_N;
imp_rep = bandpassfilter(imp, 128, LPF, HPF,fps);
imp_rep =[zeros(1,2048) imp_rep' zeros(1,2048)];
filter_analysis_imp(imp_rep,fps);
title("Ideal BPF with windowing");