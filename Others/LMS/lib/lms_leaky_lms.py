import numpy as np


def lms_leaky_lms(x, dn, mu, gamma, M):
    """
    Python equivalent of the real-valued Leaky LMS algorithm.

    Args:
        x (np.ndarray): Input data to the filter.
        dn (np.ndarray): Desired signal.
        mu (float): Step size factor (learning rate).
        gamma (float): Leakage factor.
        M (int): Order of the filter.

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
        x1 = x[n : n - M : -1]

        y[n] = np.dot(w, x1)

        e[n] = dn[n] - y[n]

        # Update weights using the Leaky LMS rule
        w = (1 - mu * gamma) * w + 2 * mu * e[n] * x1

        w1[n - M, :] = w

    J = e**2

    if len(J) > 5:
        Js = np.convolve(J, np.ones(3) / 3, mode="valid")
    else:
        Js = np.array([])

    return w, y, e, J, w1, Js


if __name__ == "__main__":
    print("Running test case for lms_leaky_lms.py...")

    true_w = np.array([0.1, 0.2, 0.3])
    M_test = len(true_w)

    N_test = 1000
    x_test = np.random.randn(N_test)

    d_n_clean = np.convolve(x_test, true_w, mode="full")[:N_test]
    noise = 0.05 * np.random.randn(N_test)
    d_n_test = d_n_clean + noise

    mu_test = 0.05
    gamma_test = 0.01
    w_final, _, _, _, _, _ = lms_leaky_lms(
        x_test, d_n_test, mu_test, gamma_test, M_test
    )

    print("\nTest Case: System Identification with Leaky LMS")
    print(f"True weights: {true_w}")
    print(f"Estimated weights: {w_final}")

    error_norm = np.linalg.norm(true_w - w_final)
    print(f"Norm of weight error: {error_norm:.4f}")
    assert error_norm < 0.1, "Test Case Failed!"
    print("Test Case Passed!")
    print("\nSimulation finished.")
