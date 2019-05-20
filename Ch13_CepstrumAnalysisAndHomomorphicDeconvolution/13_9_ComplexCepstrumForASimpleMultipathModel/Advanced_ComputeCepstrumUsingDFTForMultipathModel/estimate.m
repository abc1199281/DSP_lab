%% Generate X by V & P.
% parameter setting
r = 0.9;
beta = 0.9;
theta = pi/6;
N_zero = 15;

% V[z]
b_v = [0 0.98 1];
a_v_1 = [1 -r*exp(j*theta)];
a_v_2 = [1 -r*exp(-j*theta)];
a_v = conv(a_v_1,a_v_2);

V = tf(b_v,a_v,-1,'Variable','z^-1');

% P[z]
b_p = zeros(1,3*N_zero+1);
b_p(1) =1;
b_p(3*N_zero+1)=-1*(beta^3);

a_p = zeros(1, N_zero+1);
a_p(1) = 1;
a_p(N_zero+1) = -1*(beta);

P = tf(b_p,a_p,-1,'Variable','z^-1');

% X[z]
X = series(P,V);

% Zero-Pole Plot, Fig. 13.9
[b_x,a_x] = tfdata(X);
b_x = cell2mat(b_x);
a_x = cell2mat(a_x);

figure;
zplane(b_x,a_x);
suptitle('Zero-Pole Plot, Fig 13.9');

% Plot Impulse response, Fig 13.10
[h_v, t_v] = impz(b_v,a_v);
[h_p, t_p] = impz(b_p,a_p);
[h_x, t_x] = impz(b_x,a_x);

figure;
subplot(3,1,1);
plot(t_v,h_v);
xlim([0,80]);
xlabel('v[n]');
subplot(3,1,2);
plot(t_p,h_p);
xlim([0,80]);
xlabel('p[n]');
subplot(3,1,3);
plot(t_x,h_x);
xlim([0,80]);
xlabel('x[n] = v[n]*p[n]');
suptitle('Time domain, Fig 13.10');

%% Estimate Cepstrum by DFT.
% parameter
N = 1024;
v = zeros(1,N);
n = -N/2:1:N/2-1;
for i = 1:length(h_v)
    v(i) = h_v(i);
end
p = h_p(1:N);
x = h_x(1:N);

% estimate cepstrum.
[c_v, C_v] = cepstrum(v,N);
[c_p, C_p] = cepstrum(p,N);
[c_x, C_x] = cepstrum(x,N);

% plot cepstrum, Fig. 13.12
figure;
subplot(3,1,1)
stem(n,c_v);
xlim([-100,+100]);
xlabel('c_v[n]');
subplot(3,1,2)
stem(n,c_p);
xlabel('c_p[n]');
xlim([-100,+100]);
subplot(3,1,3)
stem(n,c_x);
xlabel('c_x[n]');
xlim([-100,+100]);
suptitle('Cepstrum, Fig. 13.12');

%% Estimate Complex Cepstrum by DFT.
% parameter
N = 1024;
x = [0;h_x(1:N-1)];

% estimate cepstrum.
[x_hat, X_hat] = complex_cepstrum(x,N);
n_x =  -N/2+1:1:N/2;
% plot cepstrum, Fig. 13.14
figure;
subplot(2,1,1)
stem(n_x,x_hat);
xlabel('x^hat[n]');
xlim([-100,+100]);
subplot(2,1,2)
stem(n,c_x);
xlabel('c_x[n]');
xlim([-100,+100]);
suptitle('Complex Cepstrum, Fig. 13.14');

%% Low pass
N1 = 14;
N2 = 128;

x = h_x(1:N);
X_hat = (fft(x,N));
X_hat = log(X_hat);
x_hat = ifft(X_hat, N);

y_hat = zeros(1,N);
y_hat(1:N1) = x_hat(1:N1);
y_hat(N-N2:N) = x_hat(N-N2:N);

Y_hat = fft(y_hat,N);
Y_hat = exp(Y_hat);
y = ifft(Y_hat,N);

% plot cepstrum, Fig. 13.14
figure;
subplot(3,1,1)
plot(h_v);
xlabel('v[n]');
xlim([0,80]);
subplot(3,1,2)
plot(h_x);
xlabel('x[n] = v[n]*p[n]');
xlim([0,80]);
subplot(3,1,3)
stem(y);
xlabel('y[n]');
xlim([0,80]);
suptitle('y: Recovered v by low pass');


%% High pass
N1 = 14;
N2 = 128;

x = h_x(1:N);
X_hat = abs(fft(x,N));
X_hat = log(X_hat);
x_hat = ifft(X_hat, N);

y_hat = zeros(1,N);
y_hat(N1:N2) = x_hat(N1:N2);

Y_hat = fft(y_hat,N);
Y_hat = exp(Y_hat);
y = ifft(Y_hat,N);

% plot cepstrum, Fig. 13.14
figure;
subplot(3,1,1)
plot(h_p);
xlabel('p[n]');
xlim([0,80]);
subplot(3,1,2)
plot(h_x);
xlabel('x[n] = v[n]*p[n]');
xlim([0,80]);
subplot(3,1,3)
stem(y);
xlabel('y[n]');
xlim([0,80]);
suptitle('y: Recovered p by high pass');


