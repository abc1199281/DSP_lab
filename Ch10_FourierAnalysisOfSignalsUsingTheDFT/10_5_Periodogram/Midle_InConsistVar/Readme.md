# [Middle] Why is the DFT Square not a good PSD Estimation? Inconsistent Estimation.

When taking the random properties into considerationm, there are two basic requirements, **asymptotically unbiased**, and **consistent**.  
The definition of consistent is as follow.  

```math
\sigma_x^2 = \lim_{L \to \infty }\widehat{\sigma }_x^2=\lim_{L \to \infty }\sum_{n=0}^{L-1}(x[n]-\widehat{m}_x)^2
```  
This experiment shows the two periodograms estimated using **DFT Square**.  
It is apparent that the variances does not decreases along witht the increase of N.  
Consequently, DFT Square is not a good PSD Estimation.

![Fig.1](./1.PNG)

Date: 2019/05/16