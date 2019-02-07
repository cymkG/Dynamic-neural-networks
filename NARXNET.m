clear, clc

% A=[maxNumDelays maxNumHiddenNeurons maxNumTrainingRuns %trainingSet %validSet %testSet]
A = [12 10 10 0.7 0.15 0.15];

% DATA XLS FILE NAME
fileName = 'myFile.xlsx';

% TARGET FILE PATH
filePath = 'C:\Users\Username\Downloads';

% HEADLINES FOR PERFORMANCE MATRICES
headline = {'R2-Train(1)' 'R2-Val(1)' 'R2-Test(1)' 'MAE-Train(1)' 'MAE-Val(1)' 'MAE-Test(1)' 'MAPE-Train(1)' 'MAPE-Val(1)' 'MAPE-Test(1)' 'MPE-Train(1)' 'MPE-Val(1)' 'MPE-Test(1)' 'MSE-Train(1)' 'MSE-Val(1)' 'MSE-Test(1)' 'RMSE-Train(1)' 'RMSE-Val(1)' 'RMSE-Test(1)' 'R2-Train(2)' 'R2-Val(2)' 'R2-Test(2)' 'MAE-Train(2)' 'MAE-Val(2)' 'MAE-Test(2)' 'MAPE-Train(2)' 'MAPE-Val(2)' 'MAPE-Test(2)' 'MPE-Train(2)' 'MPE-Val(2)' 'MPE-Test(2)' 'MSE-Train(2)' 'MSE-Val(2)' 'MSE-Test(2)' 'RMSE-Train(2)' 'RMSE-Val(2)' 'RMSE-Test(2)' 'R2-Train(3)' 'R2-Val(3)' 'R2-Test(3)' 'MAE-Train(3)' 'MAE-Val(3)' 'MAE-Test(3)' 'MAPE-Train(3)' 'MAPE-Val(3)' 'MAPE-Test(3)' 'MPE-Train(3)' 'MPE-Val(3)' 'MPE-Test(3)' 'MSE-Train(3)' 'MSE-Val(3)' 'MSE-Test(3)' 'RMSE-Train(3)' 'RMSE-Val(3)' 'RMSE-Test(3)' 'R2-Train(4)' 'R2-Val(4)' 'R2-Test(4)' 'MAE-Train(4)' 'MAE-Val(4)' 'MAE-Test(4)' 'MAPE-Train(4)' 'MAPE-Val(4)' 'MAPE-Test(4)' 'MPE-Train(4)' 'MPE-Val(4)' 'MPE-Test(4)' 'MSE-Train(4)' 'MSE-Val(4)' 'MSE-Test(4)' 'RMSE-Train(4)' 'RMSE-Val(4)' 'RMSE-Test(4)' 'R2-Train(5)' 'R2-Val(5)' 'R2-Test(5)' 'MAE-Train(5)' 'MAE-Val(5)' 'MAE-Test(5)' 'MAPE-Train(5)' 'MAPE-(5)' 'MAPE-Test(5)' 'MPE-Train(5)' 'MPE-Val(5)' 'MPE-Test(5)' 'MSE-Train(5)' 'MSE-Val(5)' 'MSE-Test(5)' 'RMSE-Train(5)' 'RMSE-Val(5)' 'RMSE-Test(5)' 'R2-Train(6)' 'R2-Val(6)' 'R2-Test(6)' 'MAE-Train(6)' 'MAE-Val(6)' 'MAE-Test(6)' 'MAPE-Train(6)' 'MAPE-Val(6)' 'MAPE-Test(6)' 'MPE-Train(6)' 'MPE-Val(6)' 'MPE-Test(6)' 'MSE-Train(6)' 'MSE-Val(6)' 'MSE-Test(6)' 'RMSE-Train(6)' 'RMSE-Val(6)' 'RMSE-Test(6)' 'R2-Train(7)' 'R2-Val(7)' 'R2-Test(7)' 'MAE-Train(7)' 'MAE-Val(7)' 'MAE-Test(7)' 'MAPE-Train(7)' 'MAPE-Val(7)' 'MAPE-Test(7)' 'MPE-Train(7)' 'MPE-Val(7)' 'MPE-Test(7)' 'MSE-Train(7)' 'MSE-Val(7)' 'MSE-Test(7)' 'RMSE-Train(7)' 'RMSE-Val(7)' 'RMSE-Test(7)' 'R2-Train(8)' 'R2-Val(8)' 'R2-Test(8)' 'MAE-Train(8)' 'MAE-Val(8)' 'MAE-Test(8)' 'MAPE-Train(8)' 'MAPE-Val(8)' 'MAPE-Test(8)' 'MPE-Train(8)' 'MPE-Val(8)' 'MPE-Test(8)' 'MSE-Train(8)' 'MSE-Val(8)' 'MSE-Test(8)' 'RMSE-Train(8)' 'RMSE-Val(8)' 'RMSE-Test(8)' 'R2-Train(9)' 'R2-Val(9)' 'R2-Test(9)' 'MAE-Train(9)' 'MAE-Val(9)' 'MAE-Test(9)' 'MAPE-Train(9)' 'MAPE-Val(9)' 'MAPE-Test(9)' 'MPE-Train(9)' 'MPE-Val(9)' 'MPE-Test(9)' 'MSE-Train(9)' 'MSE-Val(9)' 'MSE-Test(9)' 'RMSE-Train(9)' 'RMSE-Val(9)' 'RMSE-Test(9)' 'R2-Train(10)' 'R2-Val(10)' 'R2-Test(10)' 'MAE-Train(10)' 'MAE-Val(10)' 'MAE-Test(10)' 'MAPE-Train(10)' 'MAPE-Val(10)' 'MAPE-Test(10)' 'MPE-Train(10)' 'MPE-Val(10)' 'MPE-Test(10)' 'MSE-Train(10)' 'MSE-Val(10)' 'MSE-Test(10)' 'RMSE-Train(10)' 'RMSE-Val(10)' 'RMSE-Test(10)'};

% THIS FUNCTION PREPRCOSSES INPUT AND OUTPUT TIME SERIES DATA BEFORE FEEDING THE NETWORK USING HAMPEL FILTERING AND DISCRETE WAVELET TRANSFORM.
function [preprocessedOutput,preprocessedInput] = preprocess(outputTimeSeries,inputTimeSeries)
  [outputTimeSeries1,h] = hampel(outputTimeSeries,13);
  [c,l] = wavedec(outputTimeSeries1,2,'db4');
  a2Output = wrcoef('a',c,l,'db4',2);
  preprocessedOutput = num2cell(a2Output);
  [c,l] = wavedec(inputTimeSeries,2,'db4');
  a2Input = wrcoef('a',c,l,'db4',2);
  preprocessedInput = num2cell(a2Input);
end

% THIS FUNCTION TRAINS DYNAMIC NEURAL NETWORK USING OPENLOOP.
function [predictOpenloop,Xf,Af] = trainNetwork(preprocessedOutput,preprocessedInput,delay,numHiddenNeurons,A(4),A(5),A(6))
  net = narxnet(1:1,1:delay,numHiddenNeurons);
  net.layers{1}.transferFcn = 'tansig';
  net.layers{2}.transferFcn = 'purelin';
  net.divideFcn = 'divideblock';
  net.divideParam.trainRatio = A(4);
  net.divideParam.valRatio = A(5);
  net.divideParam.testRatio = A(6);
  [Xs,Xi,Ai,Ts] = preparets(net,preprocessedInput,{},preprocessedOutput);
  [net,tr] = train(net,Xs,Ts,Xi,Ai);
  [predictOpenloop,Xf,Af] = net(Xs,Xi,Ai);
end

% THIS FUNCTION CONVERTS TRAINED OPENLOOP NETWORK TO CLOSELOOP FOR MULTI-STEP AHEAD PREDICTION ON TESTING SET.
function predictCloseloop = convertToCloseloop(net,Ts,tr.trainRatio,tr.valRatio)
  [Xs1,Xi1,Ai1,Ts1] = preparets(net,preprocessedInputTs(1:length(tr.trainRatio)+length(tr.valRatio)),{},preprocessedOutputTs(1:length(tr.trainRatio)+length(tr.valRatio)));
  [Y1,Xf,Af] = net(Xs1,Xi1,Ai1);
  [netc,Xic,Aic] = closeloop(net,Xf,Af);
  predictCloseloop = netc(preprocessedOutput(length(tr.trainRatio)+length(tr.valRatio)+1:end)),Xic,Aic);
end

% THIS FUNCTION GENERATES MATRICES FOR TARGET AND PREDICTED VALUES OF TRAINING, VALIDATING, AND TESTING SET.
function [targetTrain,targetVal,targetTest,predictTrain,predictVal,predictTest] = targetPredict(Ts,tr.trainRatio,tr.valRatio,tr.testRatio,tr.testRatio,predictCloseloop)
  targetTrain = cell2mat(Ts(1:length(tr.trainRatio)));
  targetVal = cell2mat(Ts(length(tr.trainRatio)+1:length(tr.trainRatio)+length(tr.valRatio)));
  targetTest = cell2mat(Ts(length(tr.trainRatio)+length(tr.valRatio)+1:end));
  predictTrain = cell2mat(predictOpenloop(1:length(tr.trainRatio)));
  predictVal = cell2mat(predictOpenloop(length(tr.trainRatio)+1:length(tr.trainRatio)+length(tr.valRatio)));
  predictTest = cell2mat(predictCloseloop);
end

% THIS FUNCTION CALCULATES SIX PERFORMANCE CRITERIA FOR TRAINING, VALIDATING, AND TESTING SET.
function performance = calculatePerformanceMatrix(targetTrain,targetVal,targetTest,predictTrain,predictVal,predictTest,delay,A(3),run,numHiddenNeurons)
  errorTrain = targetTrain - predictTrain;
  errorVal = targetVal - predictVal;
  errorTest = targetTest - predictTest;
  R = corrcoef(predictTrain,targetTrain);
  performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+1) = (R(2))^2;
  R = corrcoef(predictVal,targetVal);
  performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+2) = (R(2))^2;
  R = corrcoef(targetTest,predictTest);
  performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+3) = (R(2))^2;
  performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+4) = mae(targetTrain,predictTrain);
  performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+5) = mae(targetVal,predictVal);
  performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+6) = mae(targetTest,predictTest);
  performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+7) = (mean(abs(errorTrain)/abs(targetTrain)))*100;
  performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+8) = (mean(abs(errorVal)/abs(targetVal)))*100;
  performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+9) = (mean(abs(errorTest)/abs(targetTest)))*100;
  performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+10) = (mean(errorTrain/targetTrain))*100;
  performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+11) = (mean(errorVal/targetVal))*100;
  performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+12) = (mean(errorTest/targetTest))*100;
  performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+13) = immse(targetTrain,predictTrain);
  performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+14) = immse(targetVal,predictVal);
  performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+15) = immse(targetTest,predictTest);
  performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+16) = sqrt(immse(targetTrain,predictTrain));
  performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+17) = sqrt(immse(targetVal,predictVal));
  performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+18) = sqrt(immse(targetTest,predictTest));
end

% THIS FUNCTION CALCULATES THE AVERAGE OF PERFORMANCE CRITERIA OVER SEVERAL RUNS FOR A NETWORK ARCHITECTURE.
function meanPerformanceMatrix = generateMeanPerformanceMatrix(performance)
  meanPerformance = zeros(size(performance,1)/A(3),size(performance,2));
  for column = 1 : 1: size(performance,2)
    r = 1;
    for row = 1 : A(3) : size(performance,1)
      r = r + 1;
      meanPerformance(r,column) = mean(performance(row:row+(A(3)-1),column));
    end
  end
  meanPerformanceMatrix = [headline;num2cell(meanPerformance)];
end

% THIS FUNCTION CREATES XLS FILE FROM GENERATED MATRICES.
function generateXLSFile(meanPerformanceMatrix,performanceMatrix,targetTrainMatrix,predictTrainMatrix,targetValMatrix,predictValMatrix,targetTestMatrix,predictTestMatrix)
  xlswrite('dynamicNeuralNetwork',meanPerformanceMatrix,1)
  xlswrite('dynamicNeuralNetwork',performanceMatrix,2)
  xlswrite('dynamicNeuralNetwork',targetTrainMatrix,3)
  xlswrite('dynamicNeuralNetwork',predictTrainMatrix,4)
  xlswrite('dynamicNeuralNetwork',targetValMatrix,5)
  xlswrite('dynamicNeuralNetwork',predictValMatrix,6)
  xlswrite('dynamicNeuralNetwork',targetTestMatrix,7)
  xlswrite('dynamicNeuralNetwork',predictTestMatrix,8)
  movefile('dynamicNeuralNetwork.xls',filePath)
end

j = 0;
for delay = 1:A(1)
  for numHiddenNeurons = 1:A(2)
    for run = 1:A(3)
    j = j+1;
    predictCloseloop = convertToCloseloop(net,Ts,tr.trainRatio,tr.valRatio,tr.testRatio)
    % GENERATING TARGET AND PREDICT VALUES MATRICES FOR ALL NETWORK ARCHITECTURE
    [targetTrain,targetVal,targetTest,predictTrain,predictVal,predictTest] = targetPredict(Ts,tr.trainRatio,tr.valRatio,tr.testRatio,tr.testRatio,Yc)
    targetTrainMatrix(j,1:length(tr.trainRatio)) = targetTrain;
    targetValMatrix(j,1:length(tr.valRatio)) = targetVal;
    targetTestMatrix(j,1:length(tr.testRatio)) = targetTest;
    predictTrainMatrix(j,1:length(tr.trainRatio)) = predictTrain;
    predictValMatrix(j,1:length(tr.valRatio)) = predictVal;
    predictTestMatrix(j,1:length(tr.testRatio)) = predictTest;
    performance = calculatePerformanceMatrix(targetTrain,targetVal,targetTest,predictTrain,predictVal,predictTest,delay,A(3),run,numHiddenNeurons)
    end
  end
end

performance(isnan(performance))=0;
performanceMatrix = [headline;num2cell(performance)];
meanPerformanceMatrix = generateMeanPerformanceMatrix(performance)
generateXLSFile(meanPerformanceMatrix,performanceMatrix,targetTrainMatrix,predictTrainMatrix,targetValMatrix,predictValMatrix,targetTestMatrix,predictTestMatrix)
