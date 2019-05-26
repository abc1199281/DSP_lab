function [w,y,e,J] = lms_self_correcting_lms(x,dn,mu,M,I)
    % function [w,y,e,J] = lms_self_correcting_lms(x,dn,mu,M,I);
    % I is the repeated number.
    
    N = length(x);
    w = zeros(I,M);
    y = zeros(I,N);
    e = zeros(I,N);
    [w(1,:),y(1,:),e(1,:)] = lms1(x,dn,mu,M);
    for i = 2:I
        [w(i,:),y(i,:),e(i,:)] = lms1(y(i-1,:),dn,mu,M);
    end
    J = e.^2;
    y = y(I,:);
    w = w(I,:);
    e = e(I,:);
    J = J(I,:);
end