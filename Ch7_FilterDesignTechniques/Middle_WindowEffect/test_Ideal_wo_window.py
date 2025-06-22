import numpy as np
from filter_analysis_imp import filter_analysis_imp


def ideal_bandpass_filter(input_signal, fs, w1, w2):
    N = len(input_signal)
    n = np.arange(N)
    freq = (n * fs) / N
    filtered = np.zeros(N, dtype=complex)
    for i in range(N):
        if w1 < freq[i] < w2:
            filtered[i] = input_signal[i]
    return filtered


fps = 30
LPF = 0.5
HPF = 3.33
WinSec = 1.6  # unused but kept for reference

n = np.arange(-511, 513)
imp = (n == 0).astype(float)

tmp_N = 512
F = np.fft.fft(imp, tmp_N)
F_bpf = ideal_bandpass_filter(F, fps, LPF, HPF)
imp_rep = np.real(np.fft.ifft(F_bpf))
imp_rep = np.concatenate([np.zeros(512), imp_rep, np.zeros(512)])

filter_analysis_imp(imp_rep, fps, "Ideal BPF with out windowing")
