import numpy as np
import matplotlib.pyplot as plt

def filter_analysis_imp(imp_rep, fps, title_):
    N = int(2 ** np.ceil(np.log2(len(imp_rep))))
    F = np.fft.fft(imp_rep, N)
    freq_step = fps / N
    freq = np.arange(-fps/2, fps/2, freq_step)
    freq = freq * 60  # Hz to bpm
    freq = freq[int(N/2):]

    plt.figure()
    plt.plot(freq, np.abs(F[:N//2]))
    plt.xlabel('freq(bpm)')
    plt.ylabel('mag')
    plt.title(title_)

    plt.figure()
    Y = np.angle(F) * 180 / np.pi
    plt.plot(freq, np.unwrap(Y[:N//2]))
    plt.xlabel('freq(bpm)')
    plt.ylabel('Phase (degree)')
    plt.title(title_)

    plt.figure()
    Y = np.angle(F)
    Y = -1 * np.diff(Y) / freq_step / (2 * np.pi * fps)
    plt.plot(freq[:-1], np.unwrap(Y[:N//2]))
    plt.xlabel('freq(bpm)')
    plt.ylabel('Group delay [sec]')
    plt.title(title_)

    plt.show()
