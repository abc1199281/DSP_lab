import numpy as np
from scipy.signal import windows

def general_win_periodogram(x, win_type, L):
    """
    Computes the periodogram of a signal x using a specified window.

    Args:
        x (np.ndarray): Input signal.
        win_type (int): Window type identifier.
        L (int): Number of frequency points.

    Returns:
        tuple: (s, as, ps)
            s (np.ndarray): Complex spectrum.
            as (np.ndarray): Power spectrum (periodogram).
            ps (np.ndarray): Phase spectrum.
    """
    N = len(x)
    win_map = {
        2: windows.boxcar(N),
        3: windows.hamming(N),
        4: windows.bartlett(N),
        5: windows.tukey(N),
        6: windows.blackman(N),
        7: windows.triang(N),
        8: windows.blackmanharris(N),
    }
    w = win_map.get(win_type, np.ones(N)) # Default to rectangular if not found

    xw = x * w
    s = np.zeros(L, dtype=np.complex128)
    n = np.arange(N)

    for m in range(L):
        s[m] = np.sum(xw * np.exp(-1j * m * (2 * np.pi / L) * n))

    as_ = (np.abs(s)**2 / N) / np.linalg.norm(w)
    ps = np.angle(s) # More robust than atan(imag/real)

    return s, as_, ps

if __name__ == "__main__":
    print("Running test case for general_win_periodogram.py...")
    N_test = 64
    L_test = 128
    x_test = np.sin(2 * np.pi * 0.1 * np.arange(N_test)) + 0.1 * np.random.randn(N_test)
    
    # Test with Hamming window
    s_val, as_val, ps_val = general_win_periodogram(x_test, 3, L_test)
    
    print(f"\nTest Case: Hamming Window")
    assert s_val.shape == (L_test,), "Test Case Failed: Complex spectrum shape mismatch."
    assert as_val.shape == (L_test,), "Test Case Failed: Power spectrum shape mismatch."
    assert ps_val.shape == (L_test,), "Test Case Failed: Phase spectrum shape mismatch."
    print("Test Case Passed!")
    print("\nSimulation finished.")
