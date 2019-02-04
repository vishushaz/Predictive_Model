%%
Data = readtable('C:\Users\vishu\Desktop\CDCRC\work\DatasetOrganised.xlsx');
%Per_FEV1 = (Data.FEV1_ / 100);
%Data.FEV1_ = Per_FEV1;
%Std_FEV1_FVC = (Data.FEV1_FVC /100);
%Data.FEV1_FVC = Std_FEV1_FVC;

%% PreProcessing
%%Missing Data Preprocessing

% complete_data = rmmissing(Data,'MinNumMissing',2);


%% KNN
%             ---------ClassificationKNN---------------
Classification_Model = fitcknn(Data,'GC~FEV1_+FEV1_FVC');
%Classification_Model.NumNeighbors = 5;
%         ----------------Test and Train sets--------------
%         -----------------CODE------------------------

cv = cvpartition(Classification_Model.NumObservations,'Holdout',0.25);
Cross_Validation_Model = crossval(Classification_Model,'cvpartition',cv);
%=========================Making Prediction for Test Sets==============

Predictions = predict(Cross_Validation_Model.Trained{1},Data(test(cv),1:end-1))
%% Analyzing the Prediction

result = confusionmat(Cross_Validation_Model.Y(test(cv)),Predictions)

%% Visualization Training Results

labels = unique(Data.GC);
classifier_name = 'Ensemble(Training Results)';

FEV1_range = min(Data.FEV1_(training(cv)))-1:0.01:max(Data.FEV1_(training(cv)))+1;
FEV1_FVC_range = min(Data.FEV1_FVC(training(cv)))-1:0.01:max(Data.FEV1_FVC(training(cv)))+1;
[xx1,xx2] = meshgrid(FEV1_range,FEV1_FVC_range);
XGrid = [xx1(:) xx2(:)];

prediction_meshgrid = predict(Cross_Validation_Model.Trained{1}, XGrid);
gscatter(xx1(:), xx2(:), prediction_meshgrid);

hold on

training_data = Data(training(cv),:);
Y = ismember(training_data.GC,labels{1});

scatter(training_data.FEV1_(Y),training_data.FEV1_FVC(Y),'o','MarkerEdgeColor','black','MarkerFaceColor','white');
scatter(training_data.FEV1_(~Y),training_data.FEV1_FVC(~Y),'o','MarkerEdgeColor','black','MarkerFaceColor','green');

xlabel('FEV1%');
ylabel('FEV1/FVC');

title(classifier_name);
legend off, axis tight

legend(labels,'Location',[0.45,0.01,0.45,0.05],'Orientation','Horizontal');

%% Visualization Testing Results
labels = unique(Data.GC);
classifier_name = 'Ensemble(Testing Results)';

FEV1_range = min(Data.FEV1_(training(cv)))-1:0.01:max(Data.FEV1_(training(cv)))+1;
FEV1_FVC_range = min(Data.FEV1_FVC(training(cv)))-1:0.01:max(Data.FEV1_FVC(training(cv)))+1;
[xx1,xx2] = meshgrid(FEV1_range,FEV1_FVC_range);
XGrid = [xx1(:) xx2(:)];

prediction_meshgrid = predict(Cross_Validation_Model.Trained{1}, XGrid);

figure(2);
gscatter(xx1(:),xx2(:),prediction_meshgrid);

hold on
testing_data = Data(test(cv),:);
Y = ismember(testing_data.GC,labels{1});

scatter(testing_data.FEV1_(Y),testing_data.FEV1_FVC(Y),'o','MarkerEdgeColor','black','MarkerFaceColor','white');
scatter(testing_data.FEV1_(~Y),testing_data.FEV1_FVC(~Y),'o','MarkerEdgeColor','black','MarkerFaceColor','black');

xlabel('FEV1%');
ylabel('FEV1/FVC');

title(classifier_name);
legend off, axis tight

legend(labels,'Location',[0.45,0.01,0.45,0.05],'Orientation','Horizontal');