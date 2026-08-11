import numpy as np
import matplotlib.pyplot as plt
from .linear_modified_periodogram import linear_modified_periodogram

def test_linear_modified_periodogram():
    """
    Test script for linear_modified_periodogram function.
    """
    n = np.arange(64)
    x = np.sin(0.3 * np.pi * n) + np.sin(0.32 * np.pi * n) + 0.5 * np.random.randn(64)
    
    ax, ay, w, y = linear_modified_periodogram(x)
    
    # Plotting
    plt.figure(figsize=(10, 8))
    
    plt.subplot(2, 1, 1)
    plt.plot(w, ax, 'k')
    plt.xlabel('w')
    plt.ylabel('PSD')
    plt.title('Original Periodogram')
    
    plt.subplot(2, 1, 2)
    plt.plot(w, ay, 'k')
    plt.xlabel('w')
    plt.ylabel('Modified PSD')
    plt.title('Linearly Modified Periodogram')
    
    plt.tight_layout()
    # plt.savefig('test_linear_modified_periodogram.png')
    # plt.show()

if __name__ == "__main__":
    print("Running test for linear_modified_periodogram...")
    test_linear_modified_periodogram()
    print("Test finished.")
