function [w,jm] = wiener_filter(x,d,M)
    % x = is the test signal.
    % d = the desired signal
    % M is the order (num of coefficients of the system)
    % w = wiener filter coeff
    % jm = minimum mse.
    
    pdx = xcorr(d,x,'biased');
    p = pdx(1,(length(pdx)+1)/2:((length(pdx)+1)/2)+M-1);
    rx = sample_biased_autoc(x,M);
    R = toeplitz(rx);
    w = R\p';
    jm = var(d)-p*w;
end