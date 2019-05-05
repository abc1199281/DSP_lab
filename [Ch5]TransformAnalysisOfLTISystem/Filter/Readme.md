# [Basic] Use Matlab "Filter" to filter a signal.

This experiment provide an example of filtering a signal for any LTI Filters (including both **IIR** & FIR).  

When using command **conv**, we have to provide impulse response of a system. Due to limit of length in practice, it is impossible to **conv** a IIR system in matlab. So, another command **filter** is built. With the usage of rational function initial state (**zi**), we can filter a signal using any type of LTI filter.  
In the future, we will show how to analyize a filter in frequency domain.

```math
H(z)=\frac{\sum_{i=0}^Z b_i z^{-i}}{1+\sum_{j=1}^P b_j z^{-j}}
```
where P is the number of poles and Z is the number of zeros. 

**Please Note usage of initial condition (zi)**  
~~~~
filter(b,a,x,zi)
~~~~


![Fig.1](./1.PNG)
![Fig.2](./2.PNG)
![Fig.3](./3.PNG)