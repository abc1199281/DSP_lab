import numpy as np

def my_arcov(s, p):
    """
    Python equivalent of my_arcov.m using the covariance method.
    """
    s = np.atleast_1d(s)
    N = len(s)
    
    # Create the data matrix X for the covariance method
    X = np.zeros((N - p, p))
    for i in range(N - p):
        X[i, :] = s[i+p-1::-1][p-i-1:p] if i<p else s[i+p-1:i-1:-1]

    # Target vector
    y = s[p:]

    # Solve the normal equations: (X.T * X) * a = X.T * y
    phi = np.dot(X.T, X)
    psi = np.dot(X.T, y)
    
    # Solve for the AR coefficients
    a_coeffs = np.linalg.solve(phi, psi)
    
    # a = [1, -a_coeffs]
    a = np.concatenate(([1], -a_coeffs))
    
    return a

if __name__ == "__main__":
    print("Running test case for my_arcov.py...")
    # Generate a test signal from a known AR process
    # a = [1, -0.9, 0.2] => y(n) = 0.9*y(n-1) - 0.2*y(n-2) + e(n)
    ar_coeffs_true = np.array([1, -0.9, 0.2])
    p_test = 2
    
    N_test = 1000
    noise = np.random.randn(N_test)
    s_test = np.zeros(N_test)
    for i in range(p_test, N_test):
        s_test[i] = 0.9 * s_test[i-1] - 0.2 * s_test[i-2] + noise[i]
        
    ar_coeffs_est = my_arcov(s_test, p_test)

    print(f"\nTest Case: AR(2) Process")
    print(f"True AR coefficients: {ar_coeffs_true}")
    print(f"Estimated AR coefficients: {ar_coeffs_est}")

    error_norm = np.linalg.norm(ar_coeffs_true - ar_coeffs_est)
    print(f"Norm of coefficient error: {error_norm:.4f}")
    assert error_norm < 0.1, "Test Case Failed!"
    print("Test Case Passed!")
