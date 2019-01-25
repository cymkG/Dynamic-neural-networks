# Dynamic-neural-networks
This repository contains two codes for training dynamic NN:       
1)	Nonlinear AutoRegressive (NAR) network for univariate time series data and
2)	Nonlinear AutoRegressive with eXplanatory variables (NARX) network for multivariate time series data.     
The code is written in MATLAB. The maximum number of time delays, maximum number of hidden neurons, number of trainings, and percentage of training, validating and testing set can be selected. The performance of each network architecture is calculated by several criteria (R2, MAE, MAPE, MPE, and MSE) as a table. 
Time series is preprocessed before feeding to the networks by:            
First, outliers are detected and replaced by the median of the data window.           
Second, time series is decomposed into three sub-series (approximation and details) by discrete wavelet transform.

