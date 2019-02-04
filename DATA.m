%%
Data = load('allData.mat')
%Per_FEV1 = (Data.FEV1_ / 100);
%Data.FEV1_ = Per_FEV1;
%Std_FEV1_FVC = (Data.FEV1_FVC /100);
%Data.FEV1_FVC = Std_FEV1_FVC;

%% PreProcessing
%%Missing Data Preprocessing

% complete_data = rmmissing(Data,'MinNumMissing',2);


%% KNN
%             ---------ClassificationKNN---------------
Classification_Model = fitcdiscr(Data.allData,'Gold~RAR2+tv75ratio');
%Classification_Model.NumNeighbors = 5;
%         ----------------Test and Train sets--------------
%         -----------------CODE------------------------

cv = cvpartition(Classification_Model.NumObservations,'Holdout',0.25);
Cross_Validation_Model = crossval(Classification_Model,'cvpartition',cv);
%=========================Making Prediction for Test Sets==============

Predictions = predict(Cross_Validation_Model.Trained{1},Data.allData(test(cv),1:end-1))
%% Analyzing the Prediction

result = confusionmat(Cross_Validation_Model.Y(test(cv)),Predictions)

%% Visualization Training Results

labels = unique(Data.allData.Gold);
classifier_name = 'Ensemble(Training Results)';

RAR2_range = min(Data.allData.RAR2(training(cv)))-1:0.01:max(Data.allData.RAR2(training(cv)))+1;
tv75ratio_range = min(Data.allData.tv75ratio(training(cv)))-1:0.01:max(Data.allData.tv75ratio(training(cv)))+1;
[xx1,xx2] = meshgrid(RAR2_range,tv75ratio_range);
XGrid = [xx1(:) xx2(:)];

prediction_meshgrid = predict(Cross_Validation_Model.Trained{1}, XGrid);
gscatter(xx1(:), xx2(:), prediction_meshgrid);

hold on

training_data = Data.allData(training(cv),:);
Y = ismember(training_data.Gold,labels{1});

scatter(training_data.RAR2(Y),training_data.tv75ratio(Y),'o','MarkerEdgeColor','black','MarkerFaceColor','white');
scatter(training_data.RAR2(~Y),training_data.tv75ratio(~Y),'o','MarkerEdgeColor','black','MarkerFaceColor','green');

xlabel('RAR2');
ylabel('tv75ratio');

title(classifier_name);
legend off, axis tight

legend(labels,'Location',[0.45,0.01,0.45,0.05],'Orientation','Horizontal');

%% Visualization Testing Results
labels = unique(Data.allData.Gold);
classifier_name = 'Ensemble(Testing Results)';

RAR2_range = min(Data.allData.RAR2(training(cv)))-1:0.01:max(Data.allData.RAR2(training(cv)))+1;
tv75ratio_range = min(Data.allData.tv75ratio(training(cv)))-1:0.01:max(Data.allData.tv75ratio(training(cv)))+1;
[xx1,xx2] = meshgrid(RAR2_range,tv75ratio_range);
XGrid = [xx1(:) xx2(:)];

prediction_meshgrid = predict(Cross_Validation_Model.Trained{1}, XGrid);

figure(2);
gscatter(xx1(:),xx2(:),prediction_meshgrid);

hold on
testing_data = Data.allData(test(cv),:);
Y = ismember(testing_data.Gold,labels{1});

scatter(testing_data.RAR2(Y),testing_data.tv75ratio(Y),'o','MarkerEdgeColor','black','MarkerFaceColor','white');
scatter(testing_data.RAR2(~Y),testing_data.tv75ratio(~Y),'o','MarkerEdgeColor','black','MarkerFaceColor','black');

xlabel('RAR2');
ylabel('tv75ratio');

title(classifier_name);
legend off, axis tight

legend(labels,'Location',[0.45,0.01,0.45,0.05],'Orientation','Horizontal');