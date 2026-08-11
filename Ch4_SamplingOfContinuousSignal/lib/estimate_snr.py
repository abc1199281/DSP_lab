import numpy as np

def estimate_snr(signal, noise):
    """
    Estimates the Signal-to-Noise Ratio (SNR) given signal and noise components.

    Args:
        signal (np.ndarray): The pure signal component.
        noise (np.ndarray): The noise component.

    Returns:
        float: The estimated SNR in dB.
    """
    if not isinstance(signal, np.ndarray):
        signal = np.array(signal)
    if not isinstance(noise, np.ndarray):
        noise = np.array(noise)

    signal_power = np.mean(signal**2)
    noise_power = np.mean(noise**2)

    # Handle the case where noise_power is zero to avoid division by zero
    if noise_power == 0:
        noise_power = 1e-30 # A very small positive number
    
    snr = 10 * np.log10(signal_power / noise_power)
    return snr

if __name__ == '__main__':
    # Test cases
    print("Running test cases for estimate_snr.py...")

    # Test Case 1: Simple known SNR
    # Signal: a sine wave with amplitude 1
    # Noise: random noise with standard deviation such that SNR is 20dB
    # 20 dB = 10 * log10(Ps / Pn) => 2 = log10(Ps / Pn) => 100 = Ps / Pn
    # Ps = A^2 / 2 = 1^2 / 2 = 0.5
    # Pn = Ps / 100 = 0.5 / 100 = 0.005
    # std_dev = sqrt(Pn) = sqrt(0.005) approx 0.0707

    fs = 1000
    t = np.arange(0, 1, 1/fs)
    signal_test1 = np.sin(2 * np.pi * 5 * t)
    noise_std_dev1 = np.sqrt(0.5 / 100) # For 20dB SNR, assuming signal power is 0.5 (for sin wave amplitude 1)
    noise_test1 = noise_std_dev1 * np.random.randn(len(t))

    snr_test1 = estimate_snr(signal_test1, noise_test1)
    print("\nTest Case 1: Known SNR (expected ~20dB)")
    print(f"Estimated SNR: {snr_test1:.2f} dB")
    assert abs(snr_test1 - 20) < 1.0, "Test Case 1 Failed! Expected ~20dB"
    print("Test Case 1 Passed!")

    # Test Case 2: No noise (very high SNR)
    signal_test2 = np.array([1, 2, 3, 4, 5])
    noise_test2 = np.zeros_like(signal_test2)
    snr_test2 = estimate_snr(signal_test2, noise_test2)
    print("\nTest Case 2: No noise (expected very high SNR)")
    print(f"Estimated SNR: {snr_test2:.2f} dB")
    assert snr_test2 > 100, "Test Case 2 Failed! Expected very high SNR"
    print("Test Case 2 Passed!")

    # Test Case 3: Pure noise (low SNR)
    signal_test3 = np.zeros(100)
    noise_test3 = np.random.randn(100)
    snr_test3 = estimate_snr(signal_test3, noise_test3)
    print("\nTest Case 3: Pure noise (expected very low SNR)")
    print(f"Estimated SNR: {snr_test3:.2f} dB")
    assert snr_test3 < -50, "Test Case 3 Failed! Expected very low SNR"
    print("Test Case 3 Passed!")

    print("\nAll test cases finished.")
