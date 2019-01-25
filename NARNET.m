clear, clc

% DEFINE TIME SERIES
TimeSeries = [];

% A=[maxNumDelays maxNumHiddenNeurons maxNumTrainingNetworks]
A = [12 10 10];

% WHERE THE FILE TO BE SAVED
filePath = C:\Users\Username\Downloads;

% DETECT OTULIERS BY HAMPEL FILTERING
[TimeSeries1,h] = hampel(TimeSeries,13);

% WAVELET DECOMPOSITION
[c,l] = wavedec(TimeSeries1,2,'db4');
a2 = wrcoef('a',c,l,'db4',2);
d1 = wrcoef('d',c,l,'db4',1);
d2 = wrcoef('d',c,l,'db4',2);

% PLOT WAVELET APPROXIMATED AND DETAILED SUB-SERIES
figure;
startdate = datenum('01-2003','mm-yyyy');
enddate = datenum('06-2012','mm-yyyy');
dt = linspace(startdate,enddate,114);
subplot(3,1,1)
plot(dt,a2(:,1:114),'LineWidth',4)
ylabel('A_2','fontweight','bold')
datetick('x','yyyy')
set(gca,'FontName','Times New Roman','FontSize',22,'linewidth',1,'box','off','color','none','TickDir','out')
axis tight;
subplot(3,1,2)
plot(dt,d1(:,1:114),'LineWidth',4)
ylabel('D_1','fontweight','bold')
datetick('x','yyyy')
set(gca,'FontName','Times New Roman','FontSize',22,'linewidth',1,'box','off','color','none','TickDir','out')
axis tight;
subplot(3,1,3)
plot(dt,d2(:,1:114),'LineWidth',4)
ylabel('D_2','fontweight','bold')
datetick('x','yyyy')
set(gca,'FontName','Times New Roman','FontSize',22,'linewidth',1,'box','off','color','none','TickDir','out')
axis tight;

% CONVERT NUMERIC ARRAY TO CELL ARRAY
T = num2cell(a2);

% NUMBER OF DELAYS
j = 0;
for delay = 1:A(1)
    
    % NUMBER OF HIDDEN NEURONS
    for numHiddenNeurons = 1:A(2)
        
        % NUMBER OF TRAINING NETWORKS
        for run = 1:A(3)
            
            % DEFINE NETWORK ARCHITECTURE 
            net = narnet(1:delay,numHiddenNeurons); %narnet(inputDelays,numHiddenNeurons)
            
            % DEFINE TRANSFER FUNCTIONS FOR HIDDEN layer AND OUTPUT LAYER
            net.layers{1}.transferFcn = 'tansig';
            net.layers{2}.transferFcn = 'purelin';
            
            % DIVIDE DATA INTO THREE CONTIGUOUS BLOCKS
            net.divideFcn = 'divideind';
            
            % SET UP DIVISION OF TRAINING, VALIDATING, AND TESTING SETS 
            net.divideParam.trainInd = 1:114-delay;
            net.divideParam.valInd = 114-delay+1:138-delay;
            
            % PREPARE INPUT AND TARGET TIME SERIES DATA FOR NETWORK TRAINING
            [Xs,Xi,Ai,Ts] = preparets(net,{},{},T); %[inputs,inputStates,layerStates,targets] = preparets(net,{},{},target)
            
            % TRAIN NETWORK
            [net,tr] = train(net,Xs,Ts,Xi,Ai);
            
            % VIEW NETWORK ARCHITECTURE
            view(net)
            
            % CALCULATE NETWORK OUTPUT
            Y = net(Xs,Xi,Ai);
            
            % DEFINE TRAINING, VALIDATING, AND TESTING TARGET SETS
            j = j+1;
            targetTrain = cell2mat(Ts(1:length(tr.trainInd)));
            targetTrainMatrix(j,1:length(tr.trainInd)) = targetTrain;
            targetVal = cell2mat(Ts(length(tr.trainInd)+1:length(tr.trainInd)+length(tr.valInd)));
            targetValMatrix(j,1:length(tr.valInd)) = targetVal;
            targetTest = cell2mat(Ts(length(tr.trainInd)+length(tr.valInd)+1:end));
            targetTestMatrix(j,1:length(tr.testInd)) = targetTest;
            
            % DEFINE TRAINING AND VALIDATING PREDICTED SETS
            predictTrain = cell2mat(Y(1:length(tr.trainInd)));
            predictTrainMatrix(j,1:length(tr.trainInd)) = predictTrain;
            predictVal = cell2mat(Y(length(tr.trainInd)+1:length(tr.trainInd)+length(tr.valInd)));
            predictValMatrix(j,1:length(tr.valInd)) = predictVal;
            
            % CALCULATE ERRORS OF TRAINING and VALIDATING SETS
            errorTrain = targetTrain - predictTrain;
            errorVal = targetVal - predictVal;
            
            % CORRELATION OF DETERMINATION (R2) OF TRAINING AND VALIDATING SETS
            R = corrcoef(predictTrain,targetTrain);
            performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+1) = (R(2))^2;
            R = corrcoef(predictVal,targetVal);
            performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+2) = (R(2))^2;
            
            % MEAN ABSOLUTE ERROR (MAE)OF TRAINING and VALIDATING SETS
            performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+4) = mae(targetTrain,predictTrain);
            performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+5) = mae(targetVal,predictVal);
            
            % MEAN ABSOLUTE PERCENTAGE ERROR (MAPE)OF TRAINING and VALIDATING SETS
            performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+7) = (mean(abs(errorTrain)/abs(targetTrain)))*100;
            performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+8) = (mean(abs(errorVal)/abs(targetVal)))*100;
            
            % MEAN PERCENTAGE ERROR (MPE)OF TRAINING and VALIDATING SETS
            performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+10) = (mean(errorTrain/targetTrain))*100;
            performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+11) = (mean(errorVal/targetVal))*100;
            
            % MEAN SQUARED ERROR (MSE)OF TRAINING and VALIDATING SETS
            performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+13) = immse(targetTrain,predictTrain);
            performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+14) = immse(targetVal,predictVal);
            
            % ROOT MEAN SQUARED ERROR (RMSE)OF TRAINING and VALIDATING SETS
            performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+16) = sqrt(immse(targetTrain,predictTrain));
            performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+17) = sqrt(immse(targetVal,predictVal));
            
            % TRANSFORM NETWORK FROM OPEN LOOP TO CLOSED LOOP
            [Xs1,Xi1,Ai1,Ts1] = preparets(net,{},{},Ts(1:length(tr.trainInd)+length(tr.valInd)));
            [Y1,Xf,Af] = net(Xs1,Xi1,Ai1);
            [netc,Xic,Aic] = closeloop(net,Xf,Af);
            
            % VIEW CLOSED-LOOP NETWORK
            view(netc)
            
            % SIMULATE NETWORK OUTPUT FOR TESTING SET
            Yc = netc(cell(0,length(tr.testInd)),Xic,Aic);
            
            % DEFINE PREDICTED MATRIX OF TESTING SET
            predictTest = cell2mat(Yc);
            predictTestMatrix(j,1:length(tr.testInd)) = predictTest;
            
            % CALCULATE ERRORS OF TESTING SET
            errorTest = targetTest - predictTest;
            
            % CORRELATION OF DETERMINATION (R2) OF TESTING SET
            R = corrcoef(targetTest,predictTest); 
            performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+3) = (R(2))^2;
            
            % MEAN ABSOLUTE ERROR (MAE)OF TESTING SET
            performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+6) = mae(targetTest,predictTest);
            
            % MEAN ABSOLUTE PERCENTAGE ERROR (MAPE)OF TESTING SET
            performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+9) = (mean(abs(errorTest)/abs(targetTest)))*100;
            
            % MEAN PERCENTAGE ERROR (MPE)OF TESTING SET
            performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+12) = (mean(errorTest/targetTest))*100;
            
            % MEAN SQUARED ERROR (MSE)OF TESTING SET
            performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+15) = immse(targetTest,predictTest);
            
            % ROOT MEAN SQUARED ERROR (RMSE)OF TESTING SET
            performance(delay*A(3)-A(3)+run,numHiddenNeurons*18-18+18) = sqrt(immse(targetTest,predictTest));
        end 
    end 
end

% DEFINE PERFORMANCE MATRIX
performance(isnan(performance))=0;
headline = {'R2-Train(1)' 'R2-Val(1)' 'R2-Test(1)' 'MAE-Train(1)' 'MAE-Val(1)' 'MAE-Test(1)' 'MAPE-Train(1)' 'MAPE-Val(1)' 'MAPE-Test(1)' 'MPE-Train(1)' 'MPE-Val(1)' 'MPE-Test(1)' 'MSE-Train(1)' 'MSE-Val(1)' 'MSE-Test(1)' 'RMSE-Train(1)' 'RMSE-Val(1)' 'RMSE-Test(1)' 'R2-Train(2)' 'R2-Val(2)' 'R2-Test(2)' 'MAE-Train(2)' 'MAE-Val(2)' 'MAE-Test(2)' 'MAPE-Train(2)' 'MAPE-Val(2)' 'MAPE-Test(2)' 'MPE-Train(2)' 'MPE-Val(2)' 'MPE-Test(2)' 'MSE-Train(2)' 'MSE-Val(2)' 'MSE-Test(2)' 'RMSE-Train(2)' 'RMSE-Val(2)' 'RMSE-Test(2)' 'R2-Train(3)' 'R2-Val(3)' 'R2-Test(3)' 'MAE-Train(3)' 'MAE-Val(3)' 'MAE-Test(3)' 'MAPE-Train(3)' 'MAPE-Val(3)' 'MAPE-Test(3)' 'MPE-Train(3)' 'MPE-Val(3)' 'MPE-Test(3)' 'MSE-Train(3)' 'MSE-Val(3)' 'MSE-Test(3)' 'RMSE-Train(3)' 'RMSE-Val(3)' 'RMSE-Test(3)' 'R2-Train(4)' 'R2-Val(4)' 'R2-Test(4)' 'MAE-Train(4)' 'MAE-Val(4)' 'MAE-Test(4)' 'MAPE-Train(4)' 'MAPE-Val(4)' 'MAPE-Test(4)' 'MPE-Train(4)' 'MPE-Val(4)' 'MPE-Test(4)' 'MSE-Train(4)' 'MSE-Val(4)' 'MSE-Test(4)' 'RMSE-Train(4)' 'RMSE-Val(4)' 'RMSE-Test(4)' 'R2-Train(5)' 'R2-Val(5)' 'R2-Test(5)' 'MAE-Train(5)' 'MAE-Val(5)' 'MAE-Test(5)' 'MAPE-Train(5)' 'MAPE-(5)' 'MAPE-Test(5)' 'MPE-Train(5)' 'MPE-Val(5)' 'MPE-Test(5)' 'MSE-Train(5)' 'MSE-Val(5)' 'MSE-Test(5)' 'RMSE-Train(5)' 'RMSE-Val(5)' 'RMSE-Test(5)' 'R2-Train(6)' 'R2-Val(6)' 'R2-Test(6)' 'MAE-Train(6)' 'MAE-Val(6)' 'MAE-Test(6)' 'MAPE-Train(6)' 'MAPE-Val(6)' 'MAPE-Test(6)' 'MPE-Train(6)' 'MPE-Val(6)' 'MPE-Test(6)' 'MSE-Train(6)' 'MSE-Val(6)' 'MSE-Test(6)' 'RMSE-Train(6)' 'RMSE-Val(6)' 'RMSE-Test(6)' 'R2-Train(7)' 'R2-Val(7)' 'R2-Test(7)' 'MAE-Train(7)' 'MAE-Val(7)' 'MAE-Test(7)' 'MAPE-Train(7)' 'MAPE-Val(7)' 'MAPE-Test(7)' 'MPE-Train(7)' 'MPE-Val(7)' 'MPE-Test(7)' 'MSE-Train(7)' 'MSE-Val(7)' 'MSE-Test(7)' 'RMSE-Train(7)' 'RMSE-Val(7)' 'RMSE-Test(7)' 'R2-Train(8)' 'R2-Val(8)' 'R2-Test(8)' 'MAE-Train(8)' 'MAE-Val(8)' 'MAE-Test(8)' 'MAPE-Train(8)' 'MAPE-Val(8)' 'MAPE-Test(8)' 'MPE-Train(8)' 'MPE-Val(8)' 'MPE-Test(8)' 'MSE-Train(8)' 'MSE-Val(8)' 'MSE-Test(8)' 'RMSE-Train(8)' 'RMSE-Val(8)' 'RMSE-Test(8)' 'R2-Train(9)' 'R2-Val(9)' 'R2-Test(9)' 'MAE-Train(9)' 'MAE-Val(9)' 'MAE-Test(9)' 'MAPE-Train(9)' 'MAPE-Val(9)' 'MAPE-Test(9)' 'MPE-Train(9)' 'MPE-Val(9)' 'MPE-Test(9)' 'MSE-Train(9)' 'MSE-Val(9)' 'MSE-Test(9)' 'RMSE-Train(9)' 'RMSE-Val(9)' 'RMSE-Test(9)' 'R2-Train(10)' 'R2-Val(10)' 'R2-Test(10)' 'MAE-Train(10)' 'MAE-Val(10)' 'MAE-Test(10)' 'MAPE-Train(10)' 'MAPE-Val(10)' 'MAPE-Test(10)' 'MPE-Train(10)' 'MPE-Val(10)' 'MPE-Test(10)' 'MSE-Train(10)' 'MSE-Val(10)' 'MSE-Test(10)' 'RMSE-Train(10)' 'RMSE-Val(10)' 'RMSE-Test(10)'};
performanceMatrix = [headline;num2cell(performance)];

% CALCULATE MEAN PERFORMANCE OF MULTI-TRAINED NETWORKS FOR EACH NUMBER OF DELAYS AND HIDDEN NEURONS
meanPerformance = zeros(size(performance,1)/A(3),size(performance,2));
for column = 1 : 1: size(performance,2)
r = 1;
for row = 1 : A(3) : size(performance,1)
r = r + 1;
meanPerformance(r,column) = mean(performance(row:row+(A(3)-1),column));
end
end

% DEFINE MEAN PERFORMANCE MATRIX
meanPerformanceMatrix = [headline;num2cell(meanPerformance)];

% SAVE MATRICES AS EXCEL FILE AND MOVE TO NEW DESTINATION
xlswrite('Approximations2',meanPerformanceMatrix,1)
xlswrite('Approximations2',performanceMatrix,2)
xlswrite('Approximations2',targetTrainMatrix,3)
xlswrite('Approximations2',predictTrainMatrix,4)
xlswrite('Approximations2',targetValMatrix,5)
xlswrite('Approximations2',predictValMatrix,6)
xlswrite('Approximations2',targetTestMatrix,7)
xlswrite('Approximations2',predictTestMatrix,8)
movefile('Approximations2.xls','filePath')
