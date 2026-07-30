function [x, t] = Sampling(xa, ta, fs)
% SAMPLING Samples a continuous-time signal xa at times ta with sampling frequency fs.
%   [x, t] = Sampling(xa, ta, fs) returns the sampled sequence x and discrete time indices t.

    t = round(ta * fs);
    % Remove duplicate indices that may arise from rounding
    [t, ia] = unique(t);
    x = xa(ia);
end
