import numpy as np
from .general_win_periodogram import general_win_periodogram

def linear_modified_periodogram(x):
    """
    Computes and compares periodograms of a signal and its linear modification.

    Args:
        x (np.ndarray): Input signal.

    Returns:
        tuple: (ax, ay, w, y)
    """
    # Periodogram of the original signal
    sx, ax, px = general_win_periodogram(x, 2, 512)

    # Create two modified signals y1 and y2
    len_x = len(x)
    total_len = len_x + 48
    
    y1 = np.zeros(total_len)
    y1[:len_x] = x
    y1 += 0.2 * np.random.rand(total_len)
    
    y2 = np.zeros(total_len)
    y2[48:] = x
    y2 += 0.2 * np.random.rand(total_len)

    # Linearly combine y1 and y2
    y = 0.2 * y1 + 0.2 * y2
    
    # Periodogram of the modified signal
    sy, ay, py = general_win_periodogram(y, 2, 512)
    
    # Frequency vector
    w = np.arange(0, 2 * np.pi, 2 * np.pi / 512)

    return ax, ay, w, y

if __name__ == "__main__":
    print("Running test case for linear_modified_periodogram.py...")
    x_test = np.sin(2 * np.pi * 0.1 * np.arange(64))
    
    ax, ay, w, y = linear_modified_periodogram(x_test)

    print("\nTest Case: Linear Modified Periodogram")
    assert ax.shape == (512,), "Test Case Failed: ax shape mismatch."
    assert ay.shape == (512,), "Test Case Failed: ay shape mismatch."
    assert w.shape == (512,), "Test Case Failed: w shape mismatch."
    assert y.shape == (64 + 48,), "Test Case Failed: y shape mismatch."
    print("Test Case Passed!")
    print("\nSimulation finished.")
