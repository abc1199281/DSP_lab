import numpy as np


def nlms(x, dn, mu, M, c=1e-6):
    """
    Python equivalent of the real-valued Normalized LMS (NLMS) algorithm.

    Args:
        x (np.ndarray): Input data to the filter.
        dn (np.ndarray): Desired signal.
        mu (float): Step size factor (learning rate).
        M (int): Order of the filter.
        c (float, optional): Small constant to prevent division by zero. Defaults to 1e-6.

    Returns:
        tuple: (w, y, e, J, w1, Js)
            w (np.ndarray): Final filter weights (1xM).
            y (np.ndarray): Filter output (1xN).
            e (np.ndarray): Error signal (dn - y) (1xN).
            J (np.ndarray): Instantaneous squared error (e^2) (1xN).
            w1 (np.ndarray): History of filter weights ( (N-M+1) x M ).
            Js (np.ndarray): Smoothed learning curve.
    """
    x = np.atleast_1d(x)
    dn = np.atleast_1d(dn)

    N = len(x)
    w = np.zeros(M)
    w1 = np.zeros((N - M + 1, M))
    y = np.zeros(N)
    e = np.zeros(N)

    for n in range(M, N):
        x1 = x[n : n - M : -1]  # Input vector for the filter tap

        # Calculate filter output
        y[n] = np.dot(w, x1)

        # Calculate error
        e[n] = dn[n] - y[n]

        # Calculate normalization term (energy of the input vector)
        norm_factor = np.dot(x1, x1) + c

        # Update weights using the NLMS rule
        w = w + (2 * mu * e[n] * x1) / norm_factor

        # Store weight history
        w1[n - M, :] = w

    J = e**2

    # Smooth the learning curve
    if len(J) > 5:
        Js = np.convolve(J, np.ones(3) / 3, mode="valid")
    else:
        Js = np.array([])

    return w, y, e, J, w1, Js


if __name__ == "__main__":
    print("Running test case for nlms.py...")

    # Test case: System Identification
    true_w = np.array([0.8, -0.4, 0.2])
    M_test = len(true_w)

    # Generate input signal
    N_test = 1000
    x_test = np.random.randn(N_test)

    # Generate desired signal
    d_n_clean = np.convolve(x_test, true_w, mode="full")[:N_test]
    noise = 0.1 * np.random.randn(N_test)
    d_n_test = d_n_clean + noise

    # Run the NLMS algorithm
    mu_test = 0.1  # NLMS is less sensitive to mu, can use a larger value
    w_final, y_out, e_out, J_out, w_history, Js_out = nlms(
        x_test, d_n_test, mu_test, M_test
    )

    print("\nTest Case: System Identification with NLMS")
    print(f"True weights: {true_w}")
    print(f"Estimated weights: {w_final}")

    error_norm = np.linalg.norm(true_w - w_final)
    print(f"Norm of weight error: {error_norm:.4f}")
    assert (
        error_norm < 0.15
    ), "Test Case Failed! Estimated weights are too far from true weights."
    print("Test Case Passed!")

    print("\nSimulation finished.")
