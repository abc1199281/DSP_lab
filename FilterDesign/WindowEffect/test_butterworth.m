FS = 30;

LPF = 0.5;
HPF = 3.3;

WinSec=1.6; %(was a 32 frame window with 20 fps camera)

NyquistF = 1/2*FS;
[B,A] = butter(3,[LPF/NyquistF HPF/NyquistF]);
imp_rep = filter(B,A,double(imp));

% Zero padding to observe. Uncomment it and think.
imp_rep =[zeros(1,512) imp_rep zeros(1,512)];

title="butter filter 3 order";
filter_analysis_imp(imp_rep,fps,title);
