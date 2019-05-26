function [w,y,e,J,w1,Js] = nlms(x,dn,mu,M,c)
    % function [w,y,e,J,w1,J2] = lms1(x,dn,mu,M);
    % all quantities are real-valued;
    % x = input data to the filter; dn = desired signal;
    % M = order of the filter; 
    % mu = step size factor; x and dn must be of the same length;
    % Js = smooths the learning curve;
    % w1 = is a matrix of dimensions: length(x) x M;
    % each column represents the variation of each filter coefficient
    N = length(x);
    w = zeros(1,M);
    w1 = zeros(1,M);
    for n = M:N
        x1 = x(n:-1:n-M+1);
        y(n) =  w*x1';
        e(n)=dn(n)-y(n);
        w = w+((2*mu*e(n)*x1)/(c+x1*x1'));
        w1(n-M+1,:) = w(1,:);
    end
    J = e.^2;
    for n = 1:length(x)-5
        Js(n)= (J(n) + J(n+1) + J(n+2))/3;
    end
end