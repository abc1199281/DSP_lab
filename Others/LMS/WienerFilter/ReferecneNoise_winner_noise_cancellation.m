%% This lab represent the ideal noise cancellation under different pathes 
%% between reference signal and received signal. (known systems, v1, v2).

addpath('..\lib');
N = 512;
n = 0:N-1;
dn = (0.99.^n).*sin(0.1*pi*n);

[d,w,xn] = modeled_wiener_noise_canceling(dn,0.9,6,N);

subplot(2,1,1);plot(n(1,1:200),dn(1,1:200),'k');
xlabel('n');ylabel('d(n)');
subplot(2,1,2);plot(n(1,1:200),xn(1,1:200),'k');
hold on;
plot(n(1,1:200),d(1,1:200),'k');
xlabel('n');ylabel('x(n), e~d');


function [d,w,xn] = modeled_wiener_noise_canceling(dn, a1, M, N)
    % dn = desired signal;
    % a1 = first order IIR; a2 = first order
    % v = noise path, v1 for received signal+noise, v2 for reference noise.
    % M = number of coeff.
    
    %% The known different pathes.
    v1(1) = 0;
    v2(1) = 0;
    for n = 2:N
        v1(n) = a1*v1(n-1) + (rand-0.5);
        v2(n) = 0.2*v1(n);
    end
    
    % v1 for received signal + noise.
    xn = dn + v1;
    
    if(M>N)
        disp(['error:M must less than N']);
    end
    
    v2autoc= sample_biased_autoc(v2,M); 
    Rv2 = toeplitz(v2autoc);
    p1 = xcorr(xn,v2,'biased');
    R = Rv2(1:M,1:M);
    p = p1(1,(length(p1)+1)/2:(length(p1)+1)/2+M-1);
    w = R\p';
    yw = filter(w,1,v2);
    d = xn-yw(:,1:N);
end

