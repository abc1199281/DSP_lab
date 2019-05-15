function [s,as,phs] = windowed_periodogram(x,w,L)
    % w = name(length), w is in column form.
    % name = hamming, kaiser, hann, rectwin, bartlett, turkeywin,...
    % L = desired number of points (bins) of the spectrum.
    % x = data in row form; s = complex form of its DFT;
    
    xw = x.*w';
    
    for m = 1:L
        n = 1:length(x);
        s(m) = sum(xw.*exp(-j*(m-1)*(2*pi/L)*n));
    end
    as = ((abs(s)).^2/length(x))/norm(w);
    phs = (atan(imag(s)./real(s)));
end
