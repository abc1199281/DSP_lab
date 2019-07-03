%% This code can generate the Fig. 4.57 in Chapter 4.8.3 (Example 4.10)

% add lib for Sampler, Quantizer module 
addpath('..\lib');

% parameters.
n = 0:150;
X_m = 1;

% signals
x=0.99*cos(n/10);

% Quantizing
quantized_3bit_signal = Quantizing(x,2,X_m); % B + 1 = 3, 3 bit.
quantized_8bit_signal = Quantizing(x,7,X_m); % B + 1 = 8, 8 bit.

% Error
error_3bit = quantized_3bit_signal-x;
error_8bit = quantized_8bit_signal-x;

% Display
figure;
suptitle('Fig. 4.57, Basic Quantization');
subplot(4,1,1);
stem(n,x);
xlabel('sampled signal, not quantized');

subplot(4,1,2);
stem(n,quantized_3bit_signal);
xlabel('sampled signal, quantized with 3 bit');

subplot(4,1,3);
stem(n,error_3bit);
xlabel('quantized with 3 bit');

subplot(4,1,4);
stem(n,error_8bit);
xlabel('quantized with 8 bit');
