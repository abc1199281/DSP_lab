% parameter setting
t = linspace(-pi,pi,100);

% generate signal
rng default  %initialize random number generator
x = sin(t) + 0.25*rand(size(t));

%% FIR Signal
% 5 order moving average.
windowSize = 5; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;

% filtering
y = filter(b,a,x);

% plot
figure;
plot(t,x);
hold on;
plot(t,y);
legend('Input Data','Filtered Data');
xlabel('time (sec)');
ylabel('mag');
title("Moving Average");






