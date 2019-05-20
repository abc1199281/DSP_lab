function [c_x, C_x] = cepstrum(x,N)
    X = abs(fft(x,N));
    C_x = log(X);
    c_x = ifft(C_x, N);
    c_x = fftshift(c_x);
end