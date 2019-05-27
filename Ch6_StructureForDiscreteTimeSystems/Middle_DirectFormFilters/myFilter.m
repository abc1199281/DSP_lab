function [Y, z] = myFilter(b, a, X, z)
    n = max(length(a),length(b));
    a = [a zeros(1,n-length(a))];
    b = [b zeros(1,n-length(b))];
    z(n) = 0;     
    b = b / a(1); 
    a = a / a(1);
    Y    = zeros(size(X));
    for m = 1:length(Y)
       Y(m) = b(1) * X(m) + z(1);
       for i = 2:n
          z(i - 1) = b(i) * X(m) + z(i) - a(i) * Y(m);
       end
    end
    z = z(1:n - 1);
end