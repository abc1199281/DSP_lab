
# [Middle] What's the code of "Filter" in Matlab? Direction Form Filters
  
  **Main Scope:  6.3.1**    

As mentioned in this basic article, [Use Filter](../../Ch5_TransformAnalysisOfLTISystem/Basic_UseFilter). IIR Filter cannot be realized by **conv** due to the infinite length of impulse response. The command **filter** in matlab offers us a way to use IIR Filter with transfer function. Then, what's the implementation of this? We can find many types of filter structures in chapter 6, but how to implement them using matlab code?  
  
There are many filter realization methods like Direction forms, Cascade forms, Parallel form, ect. Among them, direction form is the simplest method. If the numeric precision is not taken into account or the order of IIR is small (less than 3), simply direct form is good enough for Realization of IIR .   
  
  There are two categories of the direct forms,
  - **Direct Form 1** 
	  - The most intuitive method. Just use the difference equation.
	  - **Pros**: 
		  - **free** of numerical overflow in fixed point scheme. Most structures do not have this property.
	  - **Cons**:
		  - **Waste** of delay operator(memory space). 
	![Fig1](https://upload.wikimedia.org/wikipedia/commons/c/c3/Biquad_filter_DF-I.svg)
  - **Direct Form 2**:
	  - This filter reverse the order of the numerator and denominator sections of Direct Form I
	  - **Pros**:
		  - **Least** usage of delay operator. 
	  - **Cons**:
		  - Not free for numerical overflow for fixed point. 
![Fig2](https://upload.wikimedia.org/wikipedia/commons/5/5e/Biquad_filter_DF-II.svg)
  - **The properties shared in common.**
	- Very sensitive to round-off errors in the filter coefficients, especially for higher order. In that case, other forms like cascade/parallel is recommended.

 **How about the filter in Matlab?**  
According to the official document, the **filter** command is implemented using Direct Form 2. (Because floating points scheme are required, there is no benefit when using direct form 1). In this article, the implementation of  mealtab filter called **myFilter** is provided and verified.   
  
**It is not as easy as it looks when implementing the shared delays for Direct Form 2. You can think it over.**
  
Reference:  
[1] [Wiki: Digital Filter](https://en.wikipedia.org/wiki/Digital_filter)  
[2] [Standford: DF 1](https://ccrma.stanford.edu/~jos/fp/Direct_Form_I.html)  
[3] [Standford: DF 2](https://ccrma.stanford.edu/~jos/fp/Direct_Form_II.html)  

Author: Po-Wei Huang  
Date: 2019/05/28
