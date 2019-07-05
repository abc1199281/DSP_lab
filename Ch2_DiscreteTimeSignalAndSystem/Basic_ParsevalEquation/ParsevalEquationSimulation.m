

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

%% Correct Version:
% Freq domain Power:                  
freq_energy_correct = sum(conj(Y).*Y)/N

% Result
diff = time_energy - freq_energy_correct  % Should return small number.