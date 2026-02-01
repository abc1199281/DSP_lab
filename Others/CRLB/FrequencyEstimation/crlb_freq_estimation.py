import numpy as np
import matplotlib.pyplot as plt


def crlb_freq_estimation():
    fo = 0.2  # True frequency
    A = 1  # Amplitude
    N = 128  # Number of samples
    Oversampling = 4
    M = Oversampling * N  # Number of FFT points (zero-padding)

    Nrun = 1000  # Montecarlo runs
    snr_db = np.arange(-20, 46)  # SNR is in dB scale (-20 to 45 inclusive)
    t = np.arange(1, N + 1)  # Time vector (Matlab 1-indexed)

    # Initialize MSE arrays
    mse1 = np.zeros(len(snr_db))
    mse2 = np.zeros(len(snr_db))

    for isnr_idx, current_snr_db in enumerate(snr_db):
        f_est1_runs = np.zeros(Nrun)
        f_est2_runs = np.zeros(Nrun)

        for run in range(Nrun):
            # Signal generation
            # Calculate noise power based on signal power and SNR
            # Signal power for A*cos(phi) is A^2/2
            signal_power = A**2 / 2
            noise_power = signal_power / (10 ** (current_snr_db / 10))
            # Standard deviation of noise for real Gaussian noise is sqrt(noise_power)
            std_dev_noise = np.sqrt(noise_power)

            w = std_dev_noise * np.random.randn(N)  # Gaussian noise
            phase = 2 * np.pi * np.random.rand()  # Random phase for the cosine wave
            x = A * np.cos(2 * np.pi * fo * t + phase) + w

            # Freq. estimation: DFT on M samples (zero-padding)
            # Apply zero-padding to x up to M samples
            x_padded = np.pad(x, (0, M - N), "constant")
            S = (np.abs(np.fft.fft(x_padded, M)) ** 2) / N  # PSD scaled by N

            # Search f = (0:1/2), Matlab's find(S(2:M/2) == max(S(2:M/2))) is 1-indexed
            # In Python, S[1:M//2] corresponds to S(2:M/2) in Matlab
            # np.argmax returns 0-indexed relative to the slice
            peak_idx_relative = np.argmax(S[1 : M // 2])

            # Convert back to absolute 0-indexed position in S
            # +1 to account for 0-index of S[1:M//2]
            f_est1_runs[run] = peak_idx_relative + 1

            # Freq. estimation : quadratic interpolation
            # Matlab's f_cent is 1-indexed. We need to convert to 0-indexed for Python.
            # If f_est1_runs[run] is the 0-indexed peak, then
            # f_cent_py = f_est1_runs[run]
            # S_values = [S[f_cent_py-1], S[f_cent_py], S[f_cent_py+1]]
            # Matlab's f_cent = f_est1(run)+1 (because f_est1 is already 1-indexed)

            # Let's use f_cent_abs which is the 0-indexed absolute peak position in S
            f_cent_abs = int(f_est1_runs[run])  # This is 0-indexed now

            # Ensure bounds for interpolation are valid
            if f_cent_abs < 1 or f_cent_abs >= (M // 2) - 1:  # Check if neighbors exist
                f_est2_runs[run] = (
                    f_cent_abs  # Fallback to DFT peak if interpolation not possible
                )
            else:
                S_left = S[f_cent_abs - 1]
                S_center = S[f_cent_abs]
                S_right = S[f_cent_abs + 1]

                # Matlab: Num = S(f_cent-1)-S(f_cent+1);
                # Python: Num = S_left - S_right
                Num = S_left - S_right

                # Matlab: Den = S(f_cent-1)+S(f_cent+1)-2*S(f_cent);
                # Python: Den = S_left + S_right - 2*S_center
                Den = S_left + S_right - 2 * S_center

                if Den == 0:
                    f_est2_runs[run] = f_cent_abs  # Avoid division by zero
                else:
                    # Matlab: f_est2(run) = f_cent+.5*Num/Den-1;
                    # This is relative interpolation, -1 is to adjust back to 0-indexed result
                    f_est2_runs[run] = f_cent_abs + 0.5 * Num / Den

        # Convert DFT peak index to actual frequency (normalize by M)
        # Matlab used f_est1/M and f_est2/M, where f_est1/2 are 1-indexed values
        # Here f_est1/2_runs are 0-indexed frequency bin numbers.
        # So we need to convert bin number to frequency: bin_number / M * fs
        # The result from DFT is bin index from 0 to M-1. S[1:M//2] means bin 1 to M//2-1
        # So f_est1_runs and f_est2_runs are actually bin numbers (0-indexed)
        # fo is normalized freq (0 to 0.5).

        # Correct frequency for MSE calculation needs to be normalized by M (total FFT points)
        # Since fo is already normalized (0 to 0.5), we divide by M/2 (for single sided)
        # The estimated bin is relative to M.
        # So, estimated_freq = estimated_bin / M (normalized to 0 to 1)
        # Or, estimated_freq = estimated_bin / (M/2) * 0.5 (normalized to 0 to 0.5)
        # Let's stick to the Matlab version: (f_est_run / M - fo)^2
        # Where f_est_run is bin number (0-indexed, 1-indexed in Matlab)
        # So, (bin_number / M - fo)^2

        mse1[isnr_idx] = np.mean(((f_est1_runs + 1) / M - fo) ** 2)
        mse2[isnr_idx] = np.mean(((f_est2_runs + 1) / M - fo) ** 2)

    # CRLB freq. estimation.
    # CRB = 12/(N*(N^2-1)).*(10.^(-snr/10));
    # Matlab's formula: 12 / (N * (N^2 - 1)) * (10^(-snr_db/10))
    # Note division by 4*pi^2 in Matlab's semilogy for CRLB.
    # CRLB in terms of frequency (Hz or normalized) is often this formula divided by (2*pi)^2
    # So, CRLB_f = CRLB_angular / (2*pi)^2 = CRLB_angular / (4*pi^2)
    crlb = 12 / (N * (N**2 - 1)) * (10 ** (-snr_db / 10))

    # MSE_floor = (1/3)*(.5/M)^2; # quantization error +/-(.5/M)
    # Matlab's: MSE_floor*(1+0*snr) means a constant value over all SNRs
    # (0.5/M)^2 is the square of the quantization step size for frequency bin
    # And 1/3 is for uniform distribution quantization error variance.
    mse_floor = (1 / 3) * (0.5 / M) ** 2

    # Matlab's: ((1/4)/12)*(1+0*snr),':'
    # This term seems like another form of quantization error or a basic noise floor.
    # (1/4)/12 = 1 / 48. This is also a constant.
    constant_noise_floor = (1 / 4) / 12

    # Plotting
    plt.figure(figsize=(10, 6))
    plt.semilogy(snr_db, mse1, "-", label="DFT Estimator MSE")
    plt.semilogy(snr_db, mse2, "-o", label="Quadratic Interpolation Estimator MSE")
    plt.semilogy(
        snr_db, crlb / (4 * np.pi**2), "--", label="CRLB"
    )  # Convert CRLB from angular freq^2 to freq^2
    plt.semilogy(
        snr_db, mse_floor * np.ones_like(snr_db), ":", label="Quantization Floor 1"
    )
    plt.semilogy(
        snr_db,
        constant_noise_floor * np.ones_like(snr_db),
        ":",
        label="Quantization Floor 2",
    )

    plt.xlabel("SNR [dB]")
    plt.ylabel("MSE_f")
    plt.title("Frequency Estimation MSE vs. SNR")
    plt.legend()
    plt.grid(True, which="both", ls="-")
    # plt.savefig('crlb_freq_estimation.png') # Save the figure if needed
    # plt.show() # Don't show if running in headless environment


if __name__ == "__main__":
    print("Running CRLB Frequency Estimation Simulation...")
    crlb_freq_estimation()
    print(
        "Simulation finished. If running in a graphical environment, a plot should appear."
    )
