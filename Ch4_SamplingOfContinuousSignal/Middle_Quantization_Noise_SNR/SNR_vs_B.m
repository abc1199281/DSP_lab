%% This code can generate the Fig. 4.61 in Chapter 4.8.3, Example 4.12
close all;
clear all;

% add lib for Sampler, Quantizer module 
addpath('..\lib');

% parameters.
N = 101000;
n = 1:N;
X_m = 1;
Ratio =logspace(-0.9,2.3,50);
B_range = [5,7,9,11,13,15];
simulating_curves = zeros(length(B_range),length(Ratio));
ideal_curves = zeros(length(B_range),length(Ratio));


% Quantizing 
% B+1 = # of bit,

for i=1:length(B_range)
    
    for j = 1: length(Ratio)
        %% Simulation
        % signal generation
        A =sqrt(2)/Ratio(j); % from std of sinusoidal.
        x=A*cos(n/10);
        
        % quantization        
        quantized_signal = Quantizing(x,B_range(i),X_m); 
        
        % snr
        simulating_curves(i,j)=estimate_SNR(x,quantized_signal-x);
        
        %% Formula
        ideal_curves(i,j) = 10*log10(12) + 10*(2*B_range(i))*log10(2) - 20*log10(Ratio(j));
    end
    
end

% Plot
figure;
for i = 1:length(B_range)
    plot(Ratio,simulating_curves(i,:));
    hold on;
    plot(Ratio,ideal_curves(i,:));
end
set(gca,'xscale','log');
xlabel('X_m/sigma_x');
ylabel('SNR(dB)');
legend('simulate B=5','Ideal  B=5', ...
       'simulate B=7','Ideal  B=7', ...
       'simulate B=9','Ideal  B=9', ...
       'simulate B=11','Ideal  B=11', ... 
       'simulate B=13','Ideal  B=13', ... 
       'simulate B=15','Ideal  B=15');
title('Fig. 4.61, SNR v.s. B & Signal Ratio');
