function snr = estimate_SNR(signal,noise)

    signal_power = mean(signal.*signal);
    noise_power = mean(noise.*noise);

    if(noise_power==0)
        noise_power=1e-30;
    end
    
    snr = 10*log10(signal_power/noise_power);
end