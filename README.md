# Dynamic-neural-networks
The repository includes two algorithms for training dynamic NN: 
1) Nonlinear AutoRegressive (NAR) Network for training univariate time series and
2) Nonlinear AutoRegressive with eXplanatory variables (NARX) Network for training multivariate time series.
The maximum number of time delays, maximum number of hidden neurons, and number of trainings for each network architecture can be selected before execute the code. 
The performance of the trained networks for each architecture is provided by multiple criteria (R2, MAE, MAPE, MPE, and MSE) in a table at the end. 
The training and validating sets are preprocessed through:
First, the otuliers  are detected and replaced by the median of the data window.
Second, the training set is decomposed into three sub-series (Approximations 2, Details 1, and Details 2) the discrete wavelet transform.
