%% PNR Estimation Basic Version.
function pnr = estimatePNR(PowerSpectrumDensity)
    [mag,index]=max(PowerSpectrumDensity);
    
    peak_power = PowerSpectrumDensity(index);
    if index>=2
        peak_power = peak_power+PowerSpectrumDensity(index-1);
    end
    if index<length(PowerSpectrumDensity)
        peak_power = peak_power+PowerSpectrumDensity(index+1);
    end
    noise_power = sum(PowerSpectrumDensity)-peak_power;
    pnr = 10*log10(peak_power/noise_power);
end