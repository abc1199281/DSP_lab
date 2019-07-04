%% This code simulate the AD/DA processing discussed in Chapter 4.8.3
close all;
clear all;

% add lib for Sampler, Quantizer module 
addpath('..\lib');

%% parameters.
% analog
analog_fps = 1500;
analog_window_time = 3; %sec
t = 0:1/analog_fps: analog_window_time-1/analog_fps;

% digital
digital_fps = 30;
n = downsample(t,analog_fps/digital_fps);

% ADC: Quantizer
X_m = 1;
B = 10;

%% Signal generation
HR = 80;
x_a_1 = 0.5*cos(2*pi*HR*t/60+0.1);

% add a small high frequency component which can be amplified by diferental
% process
signal_freq = 6; %Hz
x_a_2 = 0.05*cos(2*pi*signal_freq*t+pi/2);
x_a = x_a_1 + x_a_2;

%% ADC
% Sampling
x_s = downsample(x_a,analog_fps/digital_fps);

% Quantizing (abs of input value should not over 1)
x_d = Quantizing(x_s,15,X_m);

%% DAC
% up sample / DAC
x_up = upsample(x_d,analog_fps/digital_fps);

% LPF (Reconstruction Filters)
h = intfilt(analog_fps/digital_fps,4,0.5); 
    %% Important
    % please not the parameter 0.5, ideally should be 1 for Nyquist rate.
    % 0.5 here is ratio of Nyquist.
    % Given known limit band signal, shourter ratio can enhance SNR by oversampling.
    %  (i,e, here I filterout the freq larger than 15(Nyquist rate) * 0.5 = 7.5)

x_r = filter(h,1,x_up);
x_r(1:floor(mean(grpdelay(h)))) = [];
x_r = [x_r zeros(1,floor(mean(grpdelay(h))))];


%% Display

figure;
plot(t,x_a);
hold on;
plot(n,x_d);
title('0 order: Original signal v.s. digital signal');
legend('x_a','x_d');

figure;
plot(t,x_a);
hold on;
plot(t,x_r);
title('0 order: Original signal v.s. reconstructed signal');
legend('x_a','x_r');

%% Display: Second Order (application: Features in time domain of higher order diff)
order = 2;

figure;
plot(t(1:end-order),diff(x_a,order));
hold on;
plot(n(1:end-order),diff(x_d,order)/[(analog_fps/digital_fps)^order]);
title([num2str(order) ' order: Original signal v.s. digital signal']);
legend('x_a','x_d');

figure;
plot(t(1:end-order),diff(x_a,order));
hold on;
plot(t(1:end-order),diff(x_r,order));
title([num2str(order) ' order: Original signal v.s. reconstructed signal']);
legend('x_a','x_r');
ylim([-1e-4,1e-4]);