import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import periodogram, freqz
from scipy.linalg import solve_toeplitz

def aryule_compat(x, order):
    """
    A basic Python equivalent for Matlab's aryule function.
    """
    if x.ndim > 1:
        x = x.flatten()
    r = np.correlate(x, x, mode='full')
    r = r[len(x)-1:] / len(x)
    
    a = solve_toeplitz((r[:-1], r[:-1]), -r[1:])
    a = np.insert(a, 0, 1)
    p = np.sum(a * r[:order+1])
    return a, p

def arcov_compat(x, order):
    """
    A basic Python equivalent for Matlab's arcov function.
    """
    if x.ndim > 1:
        x = x.flatten()
    N = len(x)
    
    C = np.zeros((order, order))
    c = np.zeros(order)
    
    for i in range(order):
        for j in range(order):
            C[i,j] = np.dot(x[order-1-i:N-1-i], x[order-1-j:N-1-j])
        c[i] = -np.dot(x[order-1-i:N-1-i], x[order:N])

    a_coeffs = np.linalg.solve(C, c)
    a = np.insert(a_coeffs, 0, 1)
    e = np.var(np.convolve(x, a)[order:-order])
    return a, e

def dsp_fig_11_6():
    n = np.arange(102)
    s = 20 * np.cos(0.2 * np.pi * n - 0.1 * np.pi) + \
        22 * np.cos(0.22 * np.pi * n + 0.9 * np.pi)

    order = 4
    d, p = aryule_compat(s, order)
    a, e = arcov_compat(s, order)
    
    wa, Ha = freqz(np.sqrt(p), d)
    wc, Hc = freqz(np.sqrt(e), a)

    f, Pxx = periodogram(s)

    plt.figure(figsize=(12, 8))
    plt.plot(f / np.pi, 10 * np.log10(Pxx), label='PSD estimate of x')
    plt.plot(wa / np.pi, 20 * np.log10(np.abs(Ha)), 'r', linewidth=2, label='PSD of model output (Yule-Walker)')
    plt.plot(wc / np.pi, 20 * np.log10(np.abs(Hc)), 'b', linewidth=2, label='PSD of model output (Covariance)')
    
    plt.xlabel('Normalized frequency (×π rad/sample)')
    plt.ylabel('One-sided PSD (dB/rad/sample)')
    plt.legend()
    plt.title('AR Model PSD Estimation vs. Periodogram')
    plt.grid(True)

    f_max_index = np.argmax(np.abs(Hc))
    freq = wc[f_max_index] / np.pi
    print(f"Estimated dominant frequency (Covariance method): {freq:.4f} (x pi rad/sample)")

if __name__ == "__main__":
    dsp_fig_11_6()
