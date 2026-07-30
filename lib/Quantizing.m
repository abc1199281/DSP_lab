function xq = Quantizing(x, B, X_m)
% QUANTIZING Quantizes a signal x using B bits and maximum amplitude X_m.
%   xq = Quantizing(x, B, X_m) returns the quantized signal.
%   Quantization step size Delta = 2*X_m / 2^B.

    Delta = 2 * X_m / (2^B);
    xq = floor((x / Delta) + 0.5) * Delta;
    % Clip values to the range [-X_m, X_m] to prevent overflow
    xq = max(min(xq, X_m), -X_m);
end
