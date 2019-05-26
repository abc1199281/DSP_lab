function [r] = sample_biased_autoc(x,lg)
    N = length(x);
    for m = 1:lg
        for n = 1:N+1-m
            x1(n) = x(n-1+m)*x(n);
        end
        r(m) = sum(x1)/N;
    end
end