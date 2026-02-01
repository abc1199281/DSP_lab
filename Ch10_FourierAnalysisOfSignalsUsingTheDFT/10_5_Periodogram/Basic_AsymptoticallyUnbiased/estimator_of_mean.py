import numpy as np

def estimator_of_mean_demo():
    """
    Python equivalent of the EstimatorOfMean.m script.
    Demonstrates how the sample mean varies with the number of samples.
    """
    # for reproducibility
    np.random.seed(0) 

    x = np.random.rand(10000) - 0.5

    m1 = np.mean(x)
    m2 = np.mean(x[:1000])
    m3 = np.mean(x[:100])
    m4 = np.mean(x[:10])
    
    print("Sample means for different numbers of samples:")
    print(f"N = 10000: Mean = {m1:.6f}")
    print(f"N = 1000:  Mean = {m2:.6f}")
    print(f"N = 100:   Mean = {m3:.6f}")
    print(f"N = 10:    Mean = {m4:.6f}")
    
    # The true mean of a uniform distribution from -0.5 to 0.5 is 0.
    # We expect the sample mean to approach 0 as N increases.
    assert np.abs(m1) < np.abs(m2) < np.abs(m3)
    
    return m1, m2, m3, m4

if __name__ == "__main__":
    estimator_of_mean_demo()
