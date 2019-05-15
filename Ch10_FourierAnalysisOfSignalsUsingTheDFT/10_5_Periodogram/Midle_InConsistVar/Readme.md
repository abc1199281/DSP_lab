# [Middle] Why is the DFT Square not a good PSD Estimation? Inconsistent Estimation.

When taking the random properties into considerationm, there are two basic requirements, **asymptotically unbiased**, and **consistent**.  
The definition of **asymptotically unbiased** is shown as follow. The error between estimated mean and real mean approches to zero along with the increasing of N.  
```math
m = \lim_{L \to \infty }\widehat{m}_x=\lim_{L \to \infty }\frac{1}{L}\sum_{n=0}^{L-1}x[n]
```  
The definition of **consistent** is shown as follow. The error between estimated var and real var approches to zero along with the increasing of N.  
```math
\sigma_x^2 = \lim_{L \to \infty }\widehat{\sigma }_x^2=\lim_{L \to \infty }\frac{1}{L}\sum_{n=0}^{L-1}(x[n]-\widehat{m}_x)^2
```  
This experiment shows the two periodograms estimated using **DFT Square**.  
It is apparent that the variances does not decreases along witht the increase of N.  
Consequently, DFT Square is not a good PSD Estimation.

![Fig.1](./1.PNG)

Date: 2019/05/16