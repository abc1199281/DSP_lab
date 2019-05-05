% parameter setting
t = linspace(-pi,pi,100);

% generate signal
rng default  %initialize random number generator
x = sin(t) + 0.25*rand(size(t));

%% IIR Filter
% coefficients of IIR filter (i.e. order of a != 1)
b = [1];
a = [1, -0.3];

% filtering
y = filter(b,a,x);

% Plot
figure;
plot(t,x)
hold on
plot(t,y);
legend('Input Data','Filtered Data')
xlabel('time (sec)');
ylabel('mag');
title("1 order IIR Low Pass Filter");