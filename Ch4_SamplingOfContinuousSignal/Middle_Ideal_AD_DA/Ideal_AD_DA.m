%% This code simulate the AD/DA processing discussed in Chapter 4.8.3
close all;
clear all;

% add lib for Sampler, Quantizer module 
addpath('..\lib');

%% parameters.
% analog
analog_fps = 1500;
analog_window_time = 18; %sec
t = 0:1/analog_fps: analog_window_time-1/analog_fps;

% digital
digital_fps = 30;
n = downsample(t,analog_fps/digital_fps);

% ADC: Quantizer
X_m = 1;
B = 10;

%% Signal generation
HR = 80;
x_a = cos(2*pi*HR*t/60+0.1);

%% ADC
% Sampling
x_s = downsample(x_a,analog_fps/digital_fps);

% Quantizing 
x_d = Quantizing(x_s,15,X_m);

%% DAC
% up sample / DAC
x_up = upsample(x_d,analog_fps/digital_fps);

% LPF (Reconstruction Filters)
h = intfilt(analog_fps/digital_fps,2,0.5);

x_r = filter(h,1,x_up);
x_r(1:floor(mean(grpdelay(h)))) = [];
x_r = [x_r zeros(1,floor(mean(grpdelay(h))))];


%% Display

figure;
plot(t,x_a);
hold on;
plot(n,x_d);
title('Original signal v.s. digital signal');


figure;
plot(t,x_a);
hold on;
plot(t,x_up);
title('Original signal v.s. up sampled signal');


figure;
plot(t,x_a);
hold on;
plot(t,x_r);
title('Original signal v.s. up sampled signal');
