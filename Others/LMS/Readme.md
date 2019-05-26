
# [Advanced] Evolution of Least Squares Filters Series.

**Main Scope: -**    

The family of Least Squares filters  have so many types and applications. These filters are so popular, simple and practical that they have been applied on noise cancellation, (Inverse) system identification, prediction and so on.   
  
  There are three categories of the least square filters,
  - **The properties shared in common.**
	- Estimating the coefficients of a Linear Filter which minimizes MSE (mean square error).
	- Assuming that the given data is **stationary**.
	- Suffering convergence and stability issue.
  - **Wiener Filter**. 
	  - It assumes all data is given and then derives the optimal solution.
	  - We need to calculate matrix inversion and auto/cross-correlation matrix.
  - **LMS**:
	  - online version to solve Wiener Filter.
	  - least computing resources needed.
  - **RLS**, 
	  - online version to solve Wiener Filter.
	  - more computational intensive.
	  - work on all data till now. (It is not always good. So a forgetting factor is proposed.)
	  - better convergence speed and Stability.


**Why MSE?**
Because min square error represents minimum both variance and biased. 
```math
mse(\hat{\theta}) = E\left \{ (\hat{\theta}-\theta)^2)  \right \} = E\left \{ e^2 \right \} = var(\hat{\theta})+bias^2(\hat{\theta})
````

**Noise Cancellation**
This lab focuses on the application on denoising. Please refer to the section **Noise or Interference Cancellation** and **Prediction** in the article [1]. In noise cancellation, one reference source (pure noise signal) is required to compare the error. If we cannot find reference source, one sub-optimal method is to use the structure in **Prediction** section. That is, we compare the signal with **Delayed signal**. **We need to assume that the signal is either steady or slowly varying over time, and periodic over time as well.** In this method, white noise cam be eliminated in some level.

 **Note:** There are so many background knowledge about these filter. I cannot explain them all here. Some useful articles are listed as reference. **However, I think my code is concise and self-explainable.  You can try to run the codes first.**
  
Several good articles can be found here.
[1] [Overview of Adaptive Filters and Applications](https://www.mathworks.com/help/dsp/ug/overview-of-adaptive-filters-and-applications.html)
[2] [Different LMS Filters](https://www.mathworks.com/help/dsp/ug/lms-adaptive-filters.html#brdo1gr)

Author: Po-Wei Huang  
Date: 2019/05/27  
