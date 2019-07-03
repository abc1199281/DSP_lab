# [Basic] How to simulate Parseval Theorem.
  **Main Scope: Chapter 2**  
     
   Parseval Theorem is very famous, easy, and useful. The theorem tell us that the power (or energy) observed in time domain always equals the power (or energy) represented in frequency domain. The continuous form is shown as follow
   ```math
   \int_{ - \infty}^{\infty} |x(t)|^{2} dt= \int_{ - \infty}^{\infty} |X(f)|^{2} df
   ```  
   
However, when implement this as follow, we cannot prove the Parseval Equality.  
Please think and guess what's wrong inside the code before opening the ParsevalEquationSimulation.m file,  
    
   
	%% Parameter Setting
	rng('default');
	signal_length = 1025;
	N = 2^nextpow2(signal_length);

	%% Signal Generation
	x = randn(1,signal_length);

	%% Intuative Version:

	% Time Domian Power
	time_energy = sum(conj(x).*x)

	% Frequency Domain Power
	Y = fft(x,N);           
	freq_energy = sum(conj(Y).*Y)

	% Result
	diff = time_energy-freq_energy            % Don't return 0.

**A funny Phenomenon**: Whether signal length equals the order of FFT or not, Parseval Equation always holds.

Author: Po-Wei Huang  
Date: 2019/07/04  