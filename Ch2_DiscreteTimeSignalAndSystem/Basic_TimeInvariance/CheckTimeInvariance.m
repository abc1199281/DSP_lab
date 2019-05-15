% check time invariant system
clear all; close all;

t = 0:100;

%sys1
x = 2*t;
y = 2*x; 

figure(1);
subplot(2,1,1);
plot(t,y);
xlabel('time');
ylabel('y');
legend("x=2t");
title('original x');
suptitle("time invariant system: y=2x");

x = 2*(t-10);
y = 2*x;
subplot(2,1,2);
plot(t,y);
xlabel('time');
ylabel('y');
title("time shift of x");
legend("x=2(t-10)");

% time variant system
x = 2*t;
y = (2.*x)./t;

figure(2);
subplot(2,1,1);
plot(t,y);
xlabel('time');
ylabel('y');
legend("x=2t");
title('original x');
suptitle("time variant system: y=(2x)/t");

x = 2*(t-10);
y = (2.*x)./t;
subplot(2,1,2);
plot(t,y);
xlabel('time');
ylabel('y');
legend("x=2(t-10)");
title("time shift of x");
