%%
clear all
Data1 = load('Total.mat');

%% PreProcessing
%%Missing Data Preprocessing

% complete_data = rmmissing(Data,'MinNumMissing',2);


%% KNN
%             ---------ClassificationKNN---------------
Classification_Model = fitcsvm(Data1.Total,'Gold~RAR2+tv75ratio+Peak_Intrabreath_Flow+Relative_Vmax_Volume+Tidal_Volume+End_Expiratory_Flow+TiTtot+Ttot+Te+Peak_Ins_Intrabreath_Flow+Relative_Vmin_Volume+Inspiratory_Tidal_Volume+tv25ratio+tv50ratio');
%Classification_Model.NumNeighbors = 5;
%         ----------------Test and Train sets--------------
%         -----------------CODE------------------------

cv = cvpartition(Classification_Model.NumObservations,'Holdout',0.5);
Cross_Validation_Model = crossval(Classification_Model,'cvpartition',cv);
%=========================Making Prediction for Test Sets==============

Predictions = predict(Cross_Validation_Model.Trained{1},Data1.Total(test(cv),1:end-1))
%% Analyzing the Prediction

result = confusionmat(Cross_Validation_Model.Y(test(cv)),Predictions)

%% Visualization Training Results
% 
% labels = unique(Data1.Total.Gold);
% classifier_name = 'Ensemble(Training Results)';
% 
% RAR2_range = min(Data1.Total.RAR2(training(cv)))-1:0.01:max(Data1.Total.RAR2(training(cv)))+1;
% tv75ratio_range = min(Data1.Total.tv75ratio(training(cv)))-1:0.01:max(Data1.Total.tv75ratio(training(cv)))+1;
% 
% [xx1,xx2] = meshgrid(RAR2_range,tv75ratio_range);
% XGrid = [xx1(:) xx2(:)];
% 
% prediction_meshgrid = predict(Cross_Validation_Model.Trained{1}, XGrid);
% gscatter(xx1(:), xx2(:), prediction_meshgrid);
% 
% hold on
% 
% training_data = Data1.Total(training(cv),:);
% Y = ismember(training_data.Gold,labels{1});
% 
% scatter(training_data.RAR2(Y),training_data.tv75ratio(Y),'o','MarkerEdgeColor','black','MarkerFaceColor','white');
% scatter(training_data.RAR2(~Y),training_data.tv75ratio(~Y),'o','MarkerEdgeColor','black','MarkerFaceColor','green');
% 
% xlabel('RAR2');
% ylabel('tv75ratio');
% 
% title(classifier_name);
% legend off, axis tight
% 
% legend(labels,'Location',[0.45,0.01,0.45,0.05],'Orientation','Horizontal');
% 
% %% Visualization Testing Results
% labels = unique(Data1.Total.Gold);
% classifier_name = 'Ensemble(Testing Results)';
% 
% RAR2_range = min(Data1.Total.RAR2(training(cv)))-1:0.01:max(Data1.Total.RAR2(training(cv)))+1;
% tv75ratio_range = min(Data1.Total.tv75ratio(training(cv)))-1:0.01:max(Data1.Total.tv75ratio(training(cv)))+1;
% [xx1,xx2] = meshgrid(RAR2_range,tv75ratio_range);
% XGrid = [xx1(:) xx2(:)];
% 
% prediction_meshgrid = predict(Cross_Validation_Model.Trained{1}, XGrid);
% 
% figure(2);
% gscatter(xx1(:),xx2(:),prediction_meshgrid);
% 
% hold on
% testing_data = Data1.Total(test(cv),:);
% Y = ismember(testing_data.Gold,labels{1});
% 
% scatter(testing_data.RAR2(Y),testing_data.tv75ratio(Y),'o','MarkerEdgeColor','black','MarkerFaceColor','white');
% scatter(testing_data.RAR2(~Y),testing_data.tv75ratio(~Y),'o','MarkerEdgeColor','black','MarkerFaceColor','black');
% 
% xlabel('RAR2');
% ylabel('tv75ratio');
% 
% title(classifier_name);
% legend off, axis tight
% 
% legend(labels,'Location',[0.45,0.01,0.45,0.05],'Orientation','Horizontal');

%% SPECIFICITY & SENSITIVITY
M = Classification_Model;
Actual_Label = M.Y;
Prediction_Label = resubPredict(M);

V = classperf(Actual_Label, Prediction_Label);

Error_Rate = V.ErrorRate
Correction_Rate = V.CorrectRate
Specificity_M = V.Specificity
Sensitivity_M = V.Sensitivity
Matrix_M = V.CountingMatrix
result
%%

%%%% Generating ROC
% test_indx = test(cv,1);
% G = Cross_Validation_Model;
% Act_class_Lab = G.Y(test_indx);
% [Lab,Score] = kfoldPredict(G);
% Predicted_Labs = (test_indx);
% Classification_Score = Score(test_indx,:);
% [X1,Y1] = perfcurve(Act_class_Lab,Predicted_Labs(:,1),'Two');

[labela,scores] = resubPredict(M);
[X1,Y1,T1,AUC1,OPTROCPT1] = perfcurve(M.Y,scores(:,1),'One')
figure();
hold on
plot(X1,Y1);


hold on
[X2,Y2,T2,AUC2,OPTROCPT2] = perfcurve(M.Y,scores(:,2),'Three')
plot(X2,Y2);

hold on
[X3,Y3,T3,AUC3,OPTROCPT3] = perfcurve(M.Y,scores(:,3),'Two')
plot(X3,Y3);

legend('One','Three','Two','Location','Best')
xlabel('False positive rate'); ylabel('True positive rate');
title('ROC Curves Classification')

hold on
plot(OPTROCPT1(1),OPTROCPT1(2),'ro')
plot(OPTROCPT2(1),OPTROCPT2(2),'go')
plot(OPTROCPT3(1),OPTROCPT3(2),'bo')

hold off
