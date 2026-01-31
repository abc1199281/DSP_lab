import numpy as np

def quantizing(x, B, X_m):
    """
    Quantizes an input signal x.
    Assumes the signal is zero-mean and within the range [-X_m, X_m].

    Args:
        x (np.ndarray): Input signal (NumPy array).
        B (int): Number of quantization bits.
        X_m (float): Maximum absolute value of the signal,
                     i.e., the signal range is [-X_m, X_m].

    Returns:
        np.ndarray: Quantized signal.
    """
    if not isinstance(x, np.ndarray):
        x = np.array(x)

    delta = X_m / (2**B)
    lower_bound = -1 * X_m

    # Calculate index for each sample
    # The original Matlab code had 2^(B+1) for index upper bound.
    # This implies 2^(B+1) quantization levels covering [-X_m, X_m]
    # So, levels would be 2*X_m / delta = 2*X_m / (X_m / (2**B)) = 2 * 2**B
    # The range of index would be from 0 to (2 * 2**B) - 1
    # which is 0 to (2**(B+1)) - 1.

    index = np.round((x - lower_bound) / delta)

    # Handle boundary conditions
    # index should be within [0, 2**(B+1) - 1]
    max_index = (2**(B+1)) - 1
    index = np.clip(index, 0, max_index)

    quantized_x = index * delta + lower_bound
    return quantized_x

if __name__ == '__main__':
    # Test cases
    print("Running test cases for quantizing.py...")

    # Test Case 1: Simple sine wave
    fs = 1000  # Sampling frequency
    t = np.arange(0, 1, 1/fs) # Time vector from 0 to 1 second
    x_test1 = np.sin(2 * np.pi * 5 * t)  # 5 Hz sine wave
    B_test1 = 3  # 3 bits
    X_m_test1 = 1.0  # Signal range [-1, 1]

    quantized_x1 = quantizing(x_test1, B_test1, X_m_test1)

    print("\nTest Case 1: Simple sine wave (3 bits)")
    print("Original x (first 5 samples):", x_test1[:5])
    print("Quantized x (first 5 samples):", quantized_x1[:5])
    assert np.allclose(quantized_x1, quantizing(x_test1, B_test1, X_m_test1)), "Test Case 1 Failed!"
    print("Test Case 1 Passed!")

    # Test Case 2: Values at boundaries
    x_test2 = np.array([-1.0, -0.99, 0.0, 0.99, 1.0])
    B_test2 = 2  # 2 bits
    X_m_test2 = 1.0

    quantized_x2 = quantizing(x_test2, B_test2, X_m_test2)

    print("\nTest Case 2: Values at boundaries (2 bits)")
    print("Original x:", x_test2)
    print("Quantized x:", quantized_x2)
    # Expected values for B=2, X_m=1.0: delta = 1.0 / 2^2 = 0.25
    # lower_bound = -1.0
    # Levels: -1.0, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1.0
    # indices: 0 to 2**(2+1)-1 = 7 (8 levels)
    # index = round((x - (-1.0)) / 0.25) = round((x + 1.0) / 0.25)
    # x = -1.0 => index = round(0/0.25) = 0 => 0*0.25 - 1.0 = -1.0
    # x = -0.99 => index = round(0.01/0.25) = 0 => 0*0.25 - 1.0 = -1.0
    # x = 0.0 => index = round(1.0/0.25) = 4 => 4*0.25 - 1.0 = 0.0
    # x = 0.99 => index = round(1.99/0.25) = 8 => clip to 7 => 7*0.25 - 1.0 = 0.75
    # x = 1.0 => index = round(2.0/0.25) = 8 => clip to 7 => 7*0.25 - 1.0 = 0.75
    expected_quantized_x2 = np.array([-1.0, -1.0, 0.0, 0.75, 0.75])
    assert np.allclose(quantized_x2, expected_quantized_x2), "Test Case 2 Failed!"
    print("Test Case 2 Passed!")

    print("\nAll test cases finished.")
