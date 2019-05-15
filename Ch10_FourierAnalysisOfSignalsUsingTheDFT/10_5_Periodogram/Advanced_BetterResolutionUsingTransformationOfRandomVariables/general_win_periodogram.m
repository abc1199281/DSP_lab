function [s, as, ps] = general_win_periodogram(x, win,L)
    if(win == 2) w = rectwin(length(x));
    elseif (win ==3) w = hamming(length(x));
    elseif (win ==4) w = bartlett(length(x));
    elseif (win ==5) w = tukeywin(length(x));
    elseif (win ==6) w = blackman(length(x));
    elseif (win ==7) w = triang(length(x));
    elseif (win ==8) w = blackmanharris(length(x));
    end
    xw = x.*w';
    s = zeros(L,length(x));
    for m = 1:L
        n = 1:length(x);
        s(m) = sum(xw.*exp(-j*(m-1)*(2*pi/L)*n));
    end
    as = ((abs(s)).^2/length(x))/norm(w);
    ps = atan(imag(s)./real(s));
end