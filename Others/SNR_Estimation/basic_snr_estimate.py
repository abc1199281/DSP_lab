import numpy as np
from scipy.signal.windows import hann


def _my_welch_psd(signal, fs, N, window_func):
    """
    Python equivalent of Matlab's MyWelchPSD function.
    Computes the Power Spectral Density (PSD) using FFT.

    Args:
        signal (np.ndarray): Input signal.
        fs (float): Sampling frequency.
        N (int): Number of FFT points.
        window_func (np.ndarray): Window function to apply.

    Returns:
        tuple: (PSD, frequency_vector)
    """
    signal = np.atleast_1d(signal)  # Ensure it's at least 1D
    window_func = np.atleast_1d(window_func)  # Ensure it's at least 1D

    if len(signal) != len(window_func):
        raise ValueError("Signal and window function must have the same length.")

    x = signal * window_func

    # Compute FFT
    tmp = np.fft.fft(x, N)
    # Compute power spectrum (magnitude squared)
    tmp = tmp * np.conj(tmp)

    # Take the first half for single-sided spectrum (DC to Nyquist)
    # Matlab's PSD is usually single-sided and scaled
    # However, Matlab's periodogram often returns N/2 + 1 for even N, including Nyquist.
    # Let's try to match the original Matlab code's behavior: tmp(1:length(tmp)/2)
    # Which means Python's slicing tmp[:N//2] (0 to N//2-1) for N points, or tmp[:N/2 + 1] if Nyquist is included.
    # Given how Matlab's PSD is calculated and often includes Nyquist, let's use N//2 + 1
    # But the Matlab code has length(tmp)/2 which for N points gives N/2, so index from 1 to N/2.
    # For Python it would be index from 0 to N/2-1.
    # Let's check the size of the original Matlab's PSD output
    # If N is even, length(tmp)/2 means N/2 elements. if tmp is 1-indexed, it's 1 to N/2.
    # If N is odd, length(tmp)/2 means floor(N/2). It's 1 to floor(N/2).

    # Align with Matlab's length(tmp)/2 behavior for Pxx (non-inclusive of Nyquist for even N).
    PSD = tmp[: N // 2].real  # Take real part as it should be real

    # Scale the PSD. Matlab's periodogram scaling can be complex.
    # The original Matlab code scales by fs*fs (which might be due to a specific interpretation or normalization)
    # This is a key difference from standard PSD definitions which normalize by (fs * sum(window_func^2)).
    # For direct translation, we will adhere to the original scaling.
    PSD = PSD / (fs * fs)

    # Generate frequency vector
    freq_step = fs / N
    # Matlab's freq = 0:freq_step:freq_step*(length(PSD)-1)
    # length(PSD) in Matlab is N/2 (for even N)
    # so freq from 0 to freq_step*(N/2 - 1)
    freq = np.arange(0, freq_step * len(PSD), freq_step)

    return PSD, freq


def _my_get_tone(Pxx, F):
    """
    Python equivalent of Matlab's MyGetTone function.
    Identifies the dominant tone (peak) in the PSD.

    Args:
        Pxx (np.ndarray): Power Spectral Density (PSD) vector.
        F (np.ndarray): Frequency vector corresponding to Pxx.

    Returns:
        tuple: (power_of_tone, index_of_tone, left_boundary_index, right_boundary_index)
    """
    idx_tone = np.argmax(Pxx)

    # Sidelobes treated as noise
    idx_left = idx_tone - 1
    idx_right = idx_tone + 1

    # Roll down slope to left
    # Original Matlab: while idxLeft > 0 && Pxx(idxLeft) <= Pxx(idxLeft+1)
    # Python uses 0-indexed. So idx_left >= 0.
    while idx_left >= 0 and Pxx[idx_left] <= Pxx[idx_left + 1]:
        idx_left -= 1

    # Roll down slope to right
    # Original Matlab: while idxRight <= numel(Pxx) && Pxx(idxRight-1) >= Pxx(idxRight)
    # Python: idx_right < len(Pxx).
    while idx_right < len(Pxx) and Pxx[idx_right - 1] >= Pxx[idx_right]:
        idx_right += 1

    # Provide indices to the tone border (inclusive)
    # Matlab was 1-indexed, so it adjusted back for usage. For Python, it's fine as is.
    idx_left += 1  # Adjust to be inclusive boundary (start of tone)
    idx_right -= 1  # Adjust to be inclusive boundary (end of tone)

    # Ensure boundaries are within valid range
    idx_left = max(0, idx_left)
    idx_right = min(len(Pxx) - 1, idx_right)

    power = np.sum(Pxx[idx_left : idx_right + 1])  # Sum inclusively

    return power, idx_tone, idx_left, idx_right


def basic_snr_estimate(signal, f_hz):
    """
    Python equivalent of Matlab's BasicSNR_estimate function.
    Estimates SNR from a signal containing a dominant tone.

    Args:
        signal (np.ndarray): Input signal.
        f_hz (float): Sampling frequency in Hz.

    Returns:
        float: Estimated SNR in dB.
    """
    x = np.atleast_1d(signal)

    # Remove DC component
    x = x - np.mean(x)
    N = len(x)

    # Use Hanning window
    win = hann(N)

    # Compute PSD using MyWelchPSD equivalent
    Pxx, F = _my_welch_psd(x, f_hz, N, win)

    # Save a copy of the original PSD estimates
    origPxx = np.copy(Pxx)

    # Get an estimate of the actual frequency / amplitude, then remove it.
    Pfund, iFund, iLeft, iRight = _my_get_tone(Pxx, F)

    # Remove the main peak from Pxx for noise estimation
    # Ensure indices are valid for slicing
    Pxx_for_noise = np.copy(Pxx)  # Work on a copy to modify
    # Set the tone region to 0 for noise estimation
    Pxx_for_noise[iLeft : iRight + 1] = 0

    # Get an estimate of the noise floor by computing the median
    # noise power of the non-harmonic region
    # Filter out zeros from Pxx_for_noise before median calculation
    non_zero_pxx = Pxx_for_noise[Pxx_for_noise > 0]
    if len(non_zero_pxx) > 0:
        estimated_noise_density = np.median(non_zero_pxx)
    else:
        # If all Pxx values are zero after removing the tone, fall back to a small value
        estimated_noise_density = 1e-30

    # Extrapolate estimated noise density into dc/signal/harmonic regions
    # Where Pxx_for_noise was zero, replace with estimated_noise_density
    Pxx_for_noise[Pxx_for_noise == 0] = estimated_noise_density

    # Prevent estimate from obscuring low peaks
    # This part needs careful translation, min([Pxx origPxx],[],2) in Matlab
    # likely means element-wise minimum across two columns/vectors.
    # In Python, Pxx should be Pxx_for_noise after modifications.
    # So, element-wise minimum of Pxx_for_noise and original PSD (origPxx).
    Pxx_for_noise = np.minimum(Pxx_for_noise, origPxx)

    # Compute the noise distortion (total noise power)
    total_noise = np.sum(Pxx_for_noise)

    r = 10 * np.log10(Pfund / total_noise)
    return r


if __name__ == "__main__":
    print("Running test cases for basic_snr_estimate.py...")

    # Test Case 1: Simple sine wave with some noise
    fs = 1000  # Sampling frequency
    t = np.arange(0, 1, 1 / fs)  # Time vector
    freq_signal = 50  # Hz
    signal_amplitude = 1.0
    pure_signal = signal_amplitude * np.sin(2 * np.pi * freq_signal * t)

    # Add some noise (e.g., to get a known SNR)
    # Target SNR = 20 dB
    # Signal power = (amplitude^2) / 2 = 1^2 / 2 = 0.5
    # Noise power = Signal power / 10^(SNR_dB/10) = 0.5 / 10^(20/10) = 0.5 / 100 = 0.005
    # Noise std dev = sqrt(Noise power) = sqrt(0.005) approx 0.0707
    noise_std_dev = np.sqrt(0.005)
    noise_component = noise_std_dev * np.random.randn(len(t))

    input_signal_test1 = pure_signal + noise_component
    estimated_snr1 = basic_snr_estimate(input_signal_test1, fs)
    print(
        f"\nTest Case 1: Estimated SNR: {estimated_snr1:.2f} dB (Expected around 20 dB)"
    )
    assert abs(estimated_snr1 - 20) < 5, "Test Case 1 Failed! Expected around 20dB"
    print("Test Case 1 Passed!")

    # Test Case 2: Signal with very low noise (high SNR)
    noise_std_dev_low = np.sqrt(0.5 / 1000)  # Target 30dB SNR
    noise_component_low = noise_std_dev_low * np.random.randn(len(t))
    input_signal_test2 = pure_signal + noise_component_low
    estimated_snr2 = basic_snr_estimate(input_signal_test2, fs)
    print(
        f"\nTest Case 2: Estimated SNR: {estimated_snr2:.2f} dB (Expected around 30 dB)"
    )
    assert abs(estimated_snr2 - 30) < 5, "Test Case 2 Failed! Expected around 30dB"
    print("Test Case 2 Passed!")

    print("\nAll test cases finished.")
