% Design a filter in transfer function form.
[b, a] = ellip(6,3,50,300/500);

% Mag response.
fvtool(b,a);

% Sos form
sos = tf2sos(b,a);
fvtool(sos);

% Phase response.
h = fvtool(b,a);
h.Analysis = 'phase';
legend(h,'Phase plot')

% Transfer To Hz (given sampling rate)
h = fvtool(b,a);
h.Fs = 1000;
h.FrequencyRange='[0, Fs/2)';