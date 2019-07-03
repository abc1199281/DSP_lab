%% This code can generate the Fig. 4.59 in Chapter 4.8.3 (Example 4.11)

% add lib for Sampler, Quantizer module 
addpath('..\lib');

% parameters.
n = 1:101000;
nbins = 101;
X_m = 1;

% signals
x=0.99*cos(n/10);

% Quantizing 
% B+1 = # of bit,
quantized_8bit_signal = Quantizing(x,7,X_m); 
quantized_16bit_signal = Quantizing(x,15,X_m);

% Error
error_8bit = quantized_8bit_signal-x;
error_16bit = quantized_16bit_signal-x;

% bin histogram.
figure;
suptitle('Fig. 4.59, Basic Quantization');
subplot(2,1,1);
histogram(error_16bit,nbins);
xlabel('e');
ylabel('number');
legend('B+1=16');
subplot(2,1,2);
histogram(error_8bit,nbins);
xlabel('e');
ylabel('number');
legend('B+1=8');