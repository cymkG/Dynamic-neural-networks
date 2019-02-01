This MATLAB package implements machine learning algorithm for training two dynamic neural networks:       
1) Nonlinear AutoRegressive (NAR) network for predicting univariate time series data
2) Nonlinear AutoRegressive with eXplanatory variables (NARX) network for predicting multivariate time series data.     

It is written purely in MATLAB language. It is self-contained. There is no external dependency.

Design Goal:
The algorithm is intended to find the optimum number of lag time and number of hidden neurons for the specific time series data based on multiple evaluation criteria. The flowchart of training dynamic neural network is added to the repository (Dynamic_Neural_Network_by_Farhad_Faghihi.JPG).

The inputs to algorithm includes:
1) Input and output time series variables
2) Maximum number of time delays (lag time), which is used as the neural network inputs
3)  Maximum number of hidden neurons, which the networks are trained
4)  Percentage division of training, validating, and testing set. 

Data Engineering and Cleaning Phase:
1)	Outliers are detected and replaced by the median of the data window by Hampel filtering,       
2)	Time series is passed through two (low-frequency and high-frequency) filters using discrete wavelet transform to extract trend structure of the original time series
3)	Data is normalized in the range of transfer function.

The performance of each neural network architecture is calculated by several evaluation criteria, including: 
1) R2: Correlation of determination
2) MAE: Mean Absolute Error 
3) MAPE: Mean Absolute Percentage Error
4) MPE: Mean Percentage Error
5) MSE: Mean Squared Error.
