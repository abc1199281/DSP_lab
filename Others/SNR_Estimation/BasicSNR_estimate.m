function [r]=BasicSNR_estimate(signal,f_hz)
    x = signal;    
    
    %% implement
    % remove DC component
    x = x - mean(x);
    N = length(x);
    % use Kaiser window to reduce effects of leakage
%    win = kaiser(N,38);
    win = hanning(N);
    %rbw = enbw(win,f_hz);%這是啥小
%     [Pxx1, F1] = periodogram(x,win,N,f_hz,'psd');
    [Pxx, F] = MyWelchPSD(x,f_hz,N,win);

    % save a copy of the original PSD estimates
    origPxx = Pxx;

    % get an estimate of the actual frequency / amplitude, then remove it.
%      [Pfund, Ffund, iFund, iLeft, iRight] =getToneFromPSD_(Pxx, F, rbw);%%找最大的   
     [Pfund, iFund, iLeft, iRight] =MyGetTone(Pxx, F);%%找最大的
    
    %% Ffund 是找到最大的
    Pxx(iLeft:iRight) = 0;

    % get an estimate of the noise floor by computing the median
    % noise power of the non-harmonic region
    estimatedNoiseDensity = median(Pxx(Pxx>0));

    % extrapolate estimated noise density into dc/signal/harmonic regions
    Pxx(Pxx==0) = estimatedNoiseDensity;

    % prevent estimate from obscuring low peaks
    Pxx = min([Pxx origPxx],[],2);

    % compute the noise distortion.
    totalNoise = sum(Pxx);  
    
%     main_peak_hz = iFund*(f_hz/N);
    r = 10*log10(Pfund / totalNoise);
%     noisePow = 10*log10(totalNoise);
%     signalPow = 10*log10(Pfund);
end

function  [power, idxTone, idxLeft, idxRight]  = MyGetTone(Pxx,F)

   [~, idxTone] = max(Pxx);

    % sidelobes treated as noise
    idxLeft = idxTone - 1;
    idxRight = idxTone + 1;

%%%%%%%%%%%%% 要往左往右幾根
    % roll down slope to left
    while idxLeft > 0 && Pxx(idxLeft) <= Pxx(idxLeft+1)
      idxLeft = idxLeft - 1;
    end

    % roll down slope to right
    while idxRight <= numel(Pxx) && Pxx(idxRight-1) >= Pxx(idxRight)
      idxRight = idxRight + 1;
    end

    % provide indices to the tone border (inclusive)
    idxLeft = idxLeft+1;
    idxRight = idxRight-1;
    
    power = sum(Pxx(idxLeft:idxRight));
end

function [PSD,freq]=MyWelchPSD(signal, fs,N,window_func)
signal =signal(:);
window_func = window_func(:);
    x = signal.*window_func;
    x=x(:);
    tmp=fft(x,N);
    tmp = tmp.*conj(tmp);
    
    PSD = tmp(1:length(tmp)/2);
    PSD = PSD./fs./fs;
    
    freq_step = fs/N;
    freq= 0:freq_step:freq_step*(length(PSD)-1);    
    freq = freq(:);
end