function [a]=my_arcov(s,p)
    M = length(s)-1;
    
    phi=zeros(p,p);
    psi = zeros(p,1);

    for i = 1:p
        for k = 1:p
            for n_ = p:M
                phi(i,k) = phi(i,k) + s(n_-i+1)*s(n_-k+1);
            end
        end
    end


    for i = 1:p
        for n_ = p:M    
            psi(i,1) = psi(i,1) + s(n_-i+1)*s(n_+1);
        end
    end

    a = phi\psi; % whitening filter.
    a = [1 -a'];
end