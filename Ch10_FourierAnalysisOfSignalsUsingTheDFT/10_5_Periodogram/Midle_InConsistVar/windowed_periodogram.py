import numpy as np
from scipy.signal import windows

def windowed_periodogram(x, w, L):
    """
    Python equivalent of the windowed_periodogram.m function.
    Computes the periodogram of a signal x using a provided window vector.

    Args:
        x (np.ndarray): Input signal (row vector).
        w (np.ndarray): Window vector (column vector in Matlab, flattened for Python).
        L (int): Desired number of frequency points (bins).

    Returns:
        tuple: (s, as_, phs)
            s (np.ndarray): Complex spectrum.
            as_ (np.ndarray): Power spectrum (periodogram).
            phs (np.ndarray): Phase spectrum.
    """
    x = np.atleast_1d(x)
    w = np.atleast_1d(w)

    # Ensure w is a 1D array for broadcasting
    if w.ndim > 1:
        w = w.flatten()

    if len(x) != len(w):
        raise ValueError("Input signal x and window w must have the same length.")

    xw = x * w
    s = np.zeros(L, dtype=np.complex128)
    n = np.arange(len(x))

    for m in range(L):
        s[m] = np.sum(xw * np.exp(-1j * m * (2 * np.pi / L) * n))

    as_ = (np.abs(s)**2 / len(x)) / np.linalg.norm(w)
    phs = np.angle(s)

    return s, as_, phs

if __name__ == "__main__":
    print("Running test case for windowed_periodogram.py...")
    N_test = 128
    L_test = 256
    x_test = np.cos(2 * np.pi * 0.2 * np.arange(N_test)) + 0.2 * np.random.randn(N_test)
    
    # Test with a Hamming window
    hamming_win = windows.hamming(N_test)
    
    s_val, as_val, phs_val = windowed_periodogram(x_test, hamming_win, L_test)
    
    print("\nTest Case: Provided Hamming Window")
    assert s_val.shape == (L_test,), "Test Case Failed: Complex spectrum shape mismatch."
    assert as_val.shape == (L_test,), "Test Case Failed: Power spectrum shape mismatch."
    assert phs_val.shape == (L_test,), "Test Case Failed: Phase spectrum shape mismatch."
    print("Test Case Passed!")
    print("\nSimulation finished.")
