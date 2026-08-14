import numpy as np
from bandpassfilter import bandpassfilter
from filter_analysis_imp import filter_analysis_imp

fps = 30
LPF = 0.5
HPF = 3.33

n = np.arange(-511, 513)
imp = (n == 0).astype(float)

imp_rep = bandpassfilter(imp, 128, LPF, HPF, fps)
imp_rep = np.concatenate([np.zeros(2048), imp_rep, np.zeros(2048)])

filter_analysis_imp(imp_rep, fps, "Ideal BPF with windowing")
