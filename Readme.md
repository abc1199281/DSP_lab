﻿# DSP Lab

## Motivation: Simulation in Learning
In this repository, some DSP experiments are provided to **bridge the theory and practice**.

To link the experiment to theory, the layouts of forders follows the outline of [1]. Besides, the experiments which are not covered in the book are located in the folder **other**.

There are several levels for you to explore.
- [Basic] :  
If you're a beginner, these experiments are designed for you. It won't be hard. Just relax and give it a try.
- [Middle] :  
If you have learned several concepts from DSP, but sometimes you may be confused by several phenomenon, this class is designed for you. Some experiments in this level are started with a confusing question.
- [Advanced] :  
The concepts beyond conventional DSP classes are included here. Take up these challanges.


## Outline  

### Basic
- [Ch2:Time Invariance System (19/05/05)](/Ch2_DiscreteTimeSignalAndSystem/Basic_TimeInvariance)
- [Ch2:Test Signals Generation (19/05/05)](/Ch2_DiscreteTimeSignalAndSystem/Basic_TestSignalsGeneration)
- [Ch2:Phase Of Basic Signals (19/05/05)](/Ch2_DiscreteTimeSignalAndSystem/Basic_MagPhaseOfSignal)  
- [Ch2:Parseval Equation (19/07/04)](/Ch2_DiscreteTimeSignalAndSystem/Basic_ParsevalEquation)  
- [Ch4:Basic ADC: Visualize Quantization Noise (19/07/04)](/Ch4_SamplingOfContinuousSignal/Basic_VisualizeQuantizationNoise)  
- [Ch5:Filter a signal with IIR Filter (19/05/05)](/Ch5_TransformAnalysisOfLTISystem/Basic_UseFilter)  
- [Ch5:Basic Filter Visualization (19/05/10)](/Ch5_TransformAnalysisOfLTISystem/Basic_FilterVisualization)
- [Ch10:What is the definition of asymptotically biased. (19/05/16)](/Ch10_FourierAnalysisOfSignalsUsingTheDFT/10_5_Periodogram/Basic_AsymptoticallyUnbiased)

### Middle
- [Ch4:A little more about Quantization Noise (1) (19/07/05)](/Ch4_SamplingOfContinuousSignal/Middle_Quantization_Noise_SNR)  
- [Ch5:What's the unit of Group Delay? Effect of Group Delay and Attenuation (19/05/31)](/Ch5_TransformAnalysisOfLTISystem/Middle_EffectOfGroupDelayAndAttenuation)  
- [Ch6:What's the code of **"Filter"** in Matlab? Direction Form Filters (19/05/26)](/Ch6_StructureForDiscreteTimeSystems/Middle_DirectFormFilters)  
- [Ch7:Why is it a bad idea to filter by zeroing out FFT bins? Window Effect(19/04/23)](/Ch7_FilterDesignTechniques/Middle_WindowEffect) 
- [Ch10:Why is the DFT Square not a good PSD Estimation? Inconsistent Estimation(19/05/16)](/Ch10_FourierAnalysisOfSignalsUsingTheDFT/10_5_Periodogram/Midle_InConsistVar) 
- [Ch10:Do you realy understand the SNR? (19/10/31)](/Others/SNR_Estimation)  

### Advanced  
- [Ch4:What is the really meaning of Interpolation? ADC/DAC (19/07/05)](/Ch4_SamplingOfContinuousSignal/Middle_Ideal_AD_DA)  
- [Ch5:What's the meaning for group delay of a signal? Insight to group delay (19/06/16)](/Ch5_TransformAnalysisOfLTISystem/Advanced_EffectOfGroupDelayOnSignals)  
- [Ch10:Better Resolution Using Transformation of the Random Variables (19/05/16)](/Ch10_FourierAnalysisOfSignalsUsingTheDFT/10_5_Periodogram/Advanced_BetterResolutionUsingTransformationOfRandomVariables)
- [Ch11:Parametric Signal Modeling: Spectrum Analysis (19/04/28)](/Ch11_ParametricSignalModeling/Advanced_SpectrumAnalysis) 
- [Ch12:What's the physical meaning of Hilbert Transform, Hilbert Huang Transform, Analytic signal, and Instantaneous Frequency? (19/11/24)](/Ch12_DiscreteHilbertTransform/HilbertTransform_AnalyticSignal) 
- [Ch13:How to De-convolution? Cepstrum Using DFT For Multipath Model(19/05/18)](/Ch13_CepstrumAnalysisAndHomomorphicDeconvolution/13_9_ComplexCepstrumForASimpleMultipathModel/Advanced_ComputeCepstrumUsingDFTForMultipathModel)
- [ADSP: MSE (Adaptive) Filters (19/05/27)](/Others/LMS) 


## Recommendation Welcome
This is my side project to verify some DSP Theorem. Recommendation to this repo is very wellcome!  
If you have any idea about this repo, just send your precious recommendation to me (poweihuang.ece06g@nctu.edu.tw). Thanks a lot.

## Recommended Book List and Reference


1. [A. Oppenheim and R. Schafer, *Discrete Time Signal Processing 3rd*. 2009](https://dl.acm.org/citation.cfm?id=1795494)  
As others have said, the book [1] is called the DSP bible. Unless stated otherwise, the chapter number in this repository follows this book.
2. [以MATLAB透視DSP](https://www.kingstone.com.tw/new/basic/2014712029455)  
These book provide matlab code foe basic concepts.
3. [Understanding Digital Signal Processing with MATLAB and Solutions](https://www.mathworks.com/academia/books/understanding-digital-signal-processing-with-matlab-and-solutions-poularikas.html)  
This book provide matlab code for advanced concepts.