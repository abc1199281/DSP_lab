import numpy as np
from Ch4_SamplingOfContinuousSignal.lib.estimate_snr import estimate_snr


def snr_test(N=1024, f_hz=1000, f_signal=10, snr_db=20):
    """
    Python equivalent of Matlab's SNR_Test function.
    Generates a signal with specified SNR.

    Args:
        N (int): Number of samples.
        f_hz (float): Sampling frequency in Hz.
        f_signal (float): Signal frequency in Hz.
        snr_db (float): Desired SNR in dB.

    Returns:
        tuple: (clean_signal, noisy_signal, noise_component, estimated_snr_db)
    """
    t = np.arange(N) / f_hz  # Time vector

    # Generate clean signal (sine wave)
    clean_signal = np.sin(2 * np.pi * f_signal * t)

    # Calculate signal power
    signal_power = np.mean(clean_signal**2)

    # Calculate desired noise power based on SNR_db
    # SNR_db = 10 * log10(signal_power / noise_power)
    # noise_power = signal_power / (10^(SNR_db/10))
    desired_noise_power = signal_power / (10 ** (snr_db / 10))

    # Generate Gaussian noise
    unscaled_noise = np.random.randn(N)

    # Scale noise to achieve desired noise power
    current_noise_power = np.mean(unscaled_noise**2)
    # Handle case where current_noise_power is zero to avoid division by zero
    if current_noise_power == 0:
        scaling_factor = 0
    else:
        scaling_factor = np.sqrt(desired_noise_power / current_noise_power)
    
    noise_component = unscaled_noise * scaling_factor

    # Create noisy signal
    noisy_signal = clean_signal + noise_component

    # Verify the generated SNR using estimate_snr function
    # Adding a small epsilon to noise_component power if it's zero to avoid log10(0)
    estimated_snr_db = estimate_snr(clean_signal, noise_component)

    return clean_signal, noisy_signal, noise_component, estimated_snr_db


if __name__ == "__main__":
    print("Running test cases for snr_test.py...")

    # Test Case 1: Default parameters
    N1, f_hz1, f_signal1, snr_db1 = 1024, 1000, 10, 20
    clean1, noisy1, noise1, estimated_snr1 = snr_test(
        N1, f_hz1, f_signal1, snr_db1
    )
    print(f"\nTest Case 1 (Default): Desired SNR: {snr_db1:.2f} dB, "
          f"Generated SNR: {estimated_snr1:.2f} dB")
    assert np.isclose(estimated_snr1, snr_db1, atol=1.0), \
        f"Test Case 1 Failed! Expected ~{snr_db1:.2f} dB, got {estimated_snr1:.2f} dB"
    print("Test Case 1 Passed!")

    # Test Case 2: Different SNR
    N2, f_hz2, f_signal2, snr_db2 = 2048, 2000, 50, 10
    clean2, noisy2, noise2, estimated_snr2 = snr_test(
        N2, f_hz2, f_signal2, snr_db2
    )
    print(f"\nTest Case 2 (SNR=10dB): Desired SNR: {snr_db2:.2f} dB, "
          f"Generated SNR: {estimated_snr2:.2f} dB")
    assert np.isclose(estimated_snr2, snr_db2, atol=1.0), \
        f"Test Case 2 Failed! Expected ~{snr_db2:.2f} dB, got {estimated_snr2:.2f} dB"
    print("Test Case 2 Passed!")

    # Test Case 3: Zero noise (very high SNR)
    # To achieve effectively zero noise, set desired_noise_power to a very small number
    # or handle noise_component directly if it results in zero.
    # For simplicity, let's manually create a scenario with minimal noise.
    N3, f_hz3, f_signal3 = 512, 100, 5
    clean3 = np.sin(2 * np.pi * f_signal3 * np.arange(N3) / f_hz3)
    noise3 = np.zeros(N3) # Effectively zero noise
    # We expect estimate_snr to return np.inf or a very large number for this.
    estimated_snr3 = estimate_snr(clean3, noise3)
    print(f"\nTest Case 3 (Zero Noise): Generated SNR: {estimated_snr3:.2f} dB")
    assert estimated_snr3 > 100, "Test Case 3 Failed! Expected very high SNR"
    print("Test Case 3 Passed!")

    print("\nAll test cases finished.")
