import numpy as np

def lms1(x, dn, mu, M):
    """
    Python equivalent of the real-valued LMS algorithm from lms1.m.

    Args:
        x (np.ndarray): Input data to the filter.
        dn (np.ndarray): Desired signal.
        mu (float): Step size factor.
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
        x1 = x[n : n - M : -1] # Equivalent to x(n:-1:n-M+1)
        
        # Calculate filter output
        y[n] = np.dot(w, x1)
        
        # Calculate error
        e[n] = dn[n] - y[n]
        
        # Update weights
        w = w + 2 * mu * e[n] * x1
        
        # Store weight history
        w1[n - M, :] = w

    J = e**2

    # Smooth the learning curve
    # Matlab: Js(n)= (J(n) + J(n+1) + J(n+2))/3;
    # This can be done with convolution with a moving average filter
    if len(J) > 5:
        Js = np.convolve(J, np.ones(3)/3, mode='valid')
    else:
        Js = np.array([]) # Not enough data to smooth

    return w, y, e, J, w1, Js

if __name__ == "__main__":
    print("Running test case for lms1.py...")
    
    # Test case: System Identification
    # Define a simple system
    true_w = np.array([0.5, -0.25, 0.1])
    M_test = len(true_w)
    
    # Generate input signal
    N_test = 500
    x_test = np.random.randn(N_test)
    
    # Generate desired signal by passing input through the true system + noise
    d_n_clean = np.convolve(x_test, true_w, mode='full')[:N_test]
    noise = 0.1 * np.random.randn(N_test)
    d_n_test = d_n_clean + noise
    
    # Run the LMS algorithm
    mu_test = 0.01
    w_final, y_out, e_out, J_out, w_history, Js_out = lms1(x_test, d_n_test, mu_test, M_test)

    print(f"\nTest Case: System Identification")
    print(f"True weights: {true_w}")
    print(f"Estimated weights: {w_final}")
    
    # Check if the estimated weights are close to the true weights
    # This is a stochastic process, so we check if the error is within a reasonable bound
    error_norm = np.linalg.norm(true_w - w_final)
    print(f"Norm of weight error: {error_norm:.4f}")
    assert error_norm < 0.2, "Test Case Failed! Estimated weights are too far from true weights."
    print("Test Case Passed!")

    print("\nSimulation finished.")
