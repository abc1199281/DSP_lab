fps = 30;

LPF = 0.5;
HPF = 3.33; 

WinSec=1.6; %(was a 32 frame window with 20 fps camera)

n = -511:512;
n0 = 0;
imp = (n==n0);

%% Ideal BPF
tmp_N = 512;
tmp_n = 0:1:tmp_N-1;
freq = ( n .* fps) ./ tmp_N;
F = fft(imp, tmp_N);   
F_bpf = IdealBandpassFilter(F, fps, LPF, HPF);
imp_rep =[real(ifft(F_bpf))'];

% Zero padding to observe. Uncomment it and think.
imp_rep =[zeros(1,512) real(ifft(F_bpf))' zeros(1,512)];

title = "Ideal BPF with out windowing";
filter_analysis_imp(imp_rep,fps,title);


%% Function
function filered_signal = IdealBandpassFilter(input_signal, fs, w1, w2)

    N = length(input_signal);
    n = 0:1:N-1;
    freq = ( n .* fs) ./ N;
    
    filered_signal = zeros(N, 1);
    
    for i = 1:N
        if freq(i) > w1 & freq(i) < w2
            filered_signal(i) = input_signal(i);
        end

    end
end
