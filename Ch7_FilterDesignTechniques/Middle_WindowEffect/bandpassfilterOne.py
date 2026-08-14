import numpy as np
from bandpassfilter import _window


def bandpassfilter_one(input_signal, n, order, fc1, fc2, fps):
    wc1 = (fc1 / fps) * 2 * np.pi
    wc2 = (fc2 / fps) * 2 * np.pi
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
        y += h * input_signal[n - i + 1]
    return y
