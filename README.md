# Dynamic-neural-networks
This repository contains two codes for training dynamic neural networks:       
1)	Nonlinear AutoRegressive (NAR) network for predicting univariate time series data
2)	Nonlinear AutoRegressive with eXplanatory variables (NARX) network for predicting multivariate time series data.     
The code is written in MATLAB. The inputs to algorithm includes:
1.The maximum number of time delays, 
2maximum number of hidden neurons, 
3.number of trainings, and percentage of training, 
4.validating and testing set can be selected. 

The performance of each network architecture is calculated by several evaluation metrics 
1.R2, 
2.MAE, 
3.MAPE, 
4.MPE, and 
4.MSE) as a table. 

Data Engineering and Cleaing Phase:
Time series data is pre-processed before feeding to the networks by:            
First, outliers are detected and replaced by the median of the data window.           
Second, time series is decomposed into three sub-series (approximation and details) by discrete wavelet transform.

