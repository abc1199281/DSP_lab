import numpy as np
from scipy.signal import butter, lfilter
from filter_analysis_imp import filter_analysis_imp

FS = 30
LPF = 0.5
HPF = 3.3
WinSec = 1.6  # unused but kept for reference

NyquistF = 0.5 * FS
B, A = butter(3, [LPF / NyquistF, HPF / NyquistF], btype="band")

n = np.arange(-511, 513)
imp = (n == 0).astype(float)

imp_rep = lfilter(B, A, imp)
imp_rep = np.concatenate([np.zeros(512), imp_rep, np.zeros(512)])

filter_analysis_imp(imp_rep, FS, "butter filter 3 order")
