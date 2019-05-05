% check mag and phase of signal.
clear; close all;

% parameter setting.
w = 0.1*pi;
t = 0:0.5:20;

% signal generation
x_sin = sin(w*t);
x_cos = cos(w*t);
x_exp = exp(w*j*t);

% get mag & phase
sin_ap = abs(x_sin);
sin_ph = angle(x_sin)/pi*180; % note the conversion, from rad to deg.

cos_ap = abs(x_cos);
cos_ph = angle(x_cos)/pi*180;

exp_ap = abs(x_exp);
exp_ph = angle(x_exp)/pi*180;

% Plot
plot_graph(t,sin_ap,sin_ph,"sin");
plot_graph(t,cos_ap,cos_ph,"cos");
plot_graph(t,exp_ap,exp_ph,"exp");

function plot_graph(t,mag,ph,signal_name)
    figure;
    subplot(2,1,1);
    stem(t,mag);
    line(t,zeros(1,length(t)));
    xlabel('time seq');
    ylabel('mag');
    title(["mag signal of " signal_name]);
    subplot(2,1,2);
    stem(t,ph);
    xlabel('time seq');
    ylabel(["angle of "+signal_name+"(deg)"]);
    line(t,zeros(1,length(t)));
end