% test signal generated
clear; close all;

n0 = 0;
t = -5:20;

% step signal
x_step = (t>=n0);

% impulse signal
x_imp = (t==n0);

% plot
figure;
subplot(2,1,1);
stem(t,x_step);
xlabel('time seq');
ylabel('input signal x');
title('step input signal');
subplot(2,1,2);
stem(t,x_imp);
xlabel('time seq');
ylabel('input signal x');
title('impulse input signal');
