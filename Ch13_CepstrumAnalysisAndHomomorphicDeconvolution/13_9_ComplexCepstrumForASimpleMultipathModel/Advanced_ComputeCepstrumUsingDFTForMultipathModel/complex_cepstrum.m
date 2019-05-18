function [x_hat, X_hat] = complex_cepstrum(x,N)
    X = fft(x,N);
    X_hat = log(X);
    x_hat = ifft(X_hat, N);
    x_hat = fftshift(x_hat);   
end