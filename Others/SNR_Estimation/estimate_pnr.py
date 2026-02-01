import numpy as np

def estimate_pnr(power_spectrum_density):
    """
    Estimates the Peak-to-Noise Ratio (PNR) from a Power Spectral Density (PSD).
    The peak power is calculated by summing the maximum point and its immediate neighbors.

    Args:
        power_spectrum_density (np.ndarray): Input Power Spectral Density (PSD) vector.

    Returns:
        float: The estimated PNR in dB.
    """
    psd = np.atleast_1d(power_spectrum_density)

    if np.sum(psd) == 0:
        return -np.inf # If total power is zero, PNR is negative infinity

    # Find the index of the maximum peak
    index = np.argmax(psd)

    # Calculate peak power by summing the maximum point and its immediate neighbors
    peak_power = psd[index]
    if index >= 1:
        peak_power += psd[index - 1]
    if index < len(psd) - 1:
        peak_power += psd[index + 1]

    # Calculate total noise power
    total_power = np.sum(psd)
    noise_power = total_power - peak_power

    # Handle cases where noise_power might be zero or negative (due to floating point inaccuracies)
    if noise_power <= 0:
        # If noise is effectively zero or negative, return a very large PNR
        # Or if peak_power is extremely dominant, noise_power can become negative due to precision.
        # In such cases, PNR is considered very high (approaching infinity).
        return np.inf

    pnr = 10 * np.log10(peak_power / noise_power)
    return pnr


if __name__ == "__main__":
    print("Running test cases for estimate_pnr.py...")

    # Test Case 1: Simple PSD with a clear peak and some noise
    # Expected PNR can be calculated manually
    psd_test1 = np.array([0.1, 0.2, 5.0, 0.3, 0.1, 0.05])
    # Peak at index 2 (value 5.0)
    # Neighbors: 0.2 (index 1), 0.3 (index 3)
    # Peak power = 0.2 + 5.0 + 0.3 = 5.5
    # Total power = 0.1 + 0.2 + 5.0 + 0.3 + 0.1 + 0.05 = 5.75
    # Noise power = 5.75 - 5.5 = 0.25
    # PNR = 10 * log10(5.5 / 0.25) = 10 * log10(22) approx 13.42 dB
    expected_pnr1 = 10 * np.log10(5.5 / 0.25)
    estimated_pnr1 = estimate_pnr(psd_test1)
    print(f"\nTest Case 1: Estimated PNR: {estimated_pnr1:.2f} dB (Expected ~{expected_pnr1:.2f} dB)")
    assert np.isclose(estimated_pnr1, expected_pnr1), "Test Case 1 Failed!"
    print("Test Case 1 Passed!")

    # Test Case 2: PSD with very high peak and low noise (PNR -> infinity)
    psd_test2 = np.array([0.01, 0.01, 100.0, 0.01, 0.01])
    # Peak power = 0.01 + 100.0 + 0.01 = 100.02
    # Total power = 0.01 + 0.01 + 100.0 + 0.01 + 0.01 = 100.04
    # Noise power = 100.04 - 100.02 = 0.02
    # PNR should be very high
    estimated_pnr2 = estimate_pnr(psd_test2)
    print(f"\nTest Case 2: Estimated PNR: {estimated_pnr2:.2f} dB (Expected very high)")
    assert estimated_pnr2 > 30, "Test Case 2 Failed! Expected very high PNR"
    print("Test Case 2 Passed!")

    # Test Case 3: All zeros (PNR -> -inf)
    psd_test3 = np.array([0.0, 0.0, 0.0])
    estimated_pnr3 = estimate_pnr(psd_test3)
    print(f"\nTest Case 3: Estimated PNR: {estimated_pnr3:.2f} dB (Expected -inf)")
    assert estimated_pnr3 == -np.inf, "Test Case 3 Failed! Expected -inf PNR"
    print("Test Case 3 Passed!")

    # Test Case 4: Only peak, no explicit noise (PNR -> inf)
    psd_test4 = np.array([0.0, 10.0, 0.0])
    # Peak power = 0.0 + 10.0 + 0.0 = 10.0
    # Total power = 10.0
    # Noise power = 10.0 - 10.0 = 0.0
    # Should return np.inf
    estimated_pnr4 = estimate_pnr(psd_test4)
    print(f"\nTest Case 4: Estimated PNR: {estimated_pnr4:.2f} dB (Expected inf)")
    assert estimated_pnr4 == np.inf, "Test Case 4 Failed! Expected inf PNR"
    print("Test Case 4 Passed!")

    print("\nAll test cases finished.")
