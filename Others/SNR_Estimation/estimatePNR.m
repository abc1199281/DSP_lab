%% PNR Estimation Basic Version.
function pnr = estimatePNR(spectrum)
    [mag,index]=max(spectrum);
    
    peak_power = spectrum(index);
    if index>=2
        peak_power = peak_power+spectrum(index-1);
    end
    if index<length(spectrum)
        peak_power = peak_power+spectrum(index+1);
    end
    noise_power = sum(spectrum)-peak_power;
    pnr = 10*log10(peak_power/noise_power);
end