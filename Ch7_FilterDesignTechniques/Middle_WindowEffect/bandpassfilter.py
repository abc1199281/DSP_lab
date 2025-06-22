import numpy as np


def _window(n, M):
    if 0 <= n <= M:
        return 0.54 - 0.46 * np.cos(2 * np.pi * n / M)
    return 0


def bandpassfilter(input_signal, order, fc1, fc2, fps):
    wc1 = (fc1 / fps) * 2 * np.pi
    wc2 = (fc2 / fps) * 2 * np.pi
    output = np.zeros(len(input_signal) - order + 1)
    for j in range(len(output)):
        y = 0
        M = order
        for i in range(1, M + 1):
            if i == M / 2:
                hd = (wc2 - wc1) / np.pi
            else:
                hd = (np.sin(wc2 * (i - M / 2)) - np.sin(wc1 * (i - M / 2))) / (
                    np.pi * (i - M / 2)
                )
            h = hd * _window(i, M)
            y += h * input_signal[order + j - i]
        output[j] = y
    return output
