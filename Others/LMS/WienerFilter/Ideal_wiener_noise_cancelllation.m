%% The usage of real desired signal make this case is impossible for reald applications.
addpath('..\lib');
%% Signal generation
n = 0:511;
d = sin(.2*pi*n); % desired signal;
v = 0.5*randn(1,512); %white noise.
x = d+v;

%% Code version.
% % Note, for optimal solution the desired signal is given (inpractical)
% rd1 = xcorr(d,20,'biased'); 
% rd = rd1(1,20+1:39);
% 
% % Note, let noise pattern of v is known.
% rv1 = xcorr(v,20,'biased');
% rv = rv1(1,20+1:39);
% 
% R = toeplitz(rd(1,1:15))+toeplitz(rv(1,1:15)); 
% pdx = rd(1,1:15);
% w = R\pdx';

%% Function Version.
[w,jm] = wiener_filter(x,d,2);
y = filter(w',1,x); % output of the filter

%% plot
figure;
plot(x(1,1:511),'k'); 
hold on;
plot(y(1,1:511)-4,'g');
legend('before','after');

