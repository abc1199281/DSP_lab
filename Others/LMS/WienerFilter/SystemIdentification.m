addpath('..\lib');
%% Generate signals
% x = test signal.
x = randn(1,100); 

% System:
h = [1 0.38]

% the system to be identified.
sysout = filter(h ,1,x); 

% noise vector for inupt.
v = 0.5*(rand(1,100)-0.5); 

% the received data = system output + noise.
dn = sysout+v;

%% Filter.
[w,jm] = wiener_filter(x,dn,2);
w
