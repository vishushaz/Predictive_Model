%%
Data = load('allData01.mat');
T = load('allData01T.mat')
%Per_FEV1 = (Data.FEV1_ / 100);
%Data.FEV1_ = Per_FEV1;
%Std_FEV1_FVC = (Data.FEV1_FVC /100);
 %Data.FEV1_FVC = Std_FEV1_FVC;

%% PreProcessing
%%Missing Data Preprocessing

% complete_data = rmmissing(Data,'MinNumMissing',2);


%% KNN
%             ---------ClassificationKNN---------------
Classification_Model = fitcnb(Data.allData01,'Gold~RAR2+Inspiratory_Tidal_Volume');
%Classification_Model.NumNeighbors = 5;
%         ----------------Test and Train sets--------------
%         -----------------CODE------------------------

cv = cvpartition(Classification_Model.NumObservations,'Holdout');
Cross_Validation_Model = crossval(Classification_Model,'cvpartition',cv);
%=========================Making Prediction for Test Sets==============

Predictions = predict(Cross_Validation_Model.Trained{1},T.allData01)
%% Analyzing the Prediction

result = confusionmat(Cross_Validation_Model.Y,Predictions)

%% Visualization Training Results

labels = unique(Data.allData01.Gold);
classifier_name = 'KNN(Training Results)';

RAR2_range = min(Data.allData01.RAR2(training(cv)))-1:0.01:max(Data.allData01.RAR2(training(cv)))+1;
Inspiratory_Tidal_Volume_range = min(Data.allData01.Inspiratory_Tidal_Volume(training(cv)))-1:0.01:max(Data.allData01.Inspiratory_Tidal_Volume(training(cv)))+1;
[xx1,xx2] = meshgrid(RAR2_range,Inspiratory_Tidal_Volume_range);
XGrid = [xx1(:) xx2(:)];

prediction_meshgrid = predict(Cross_Validation_Model.Trained{1}, XGrid);
gscatter(xx1(:), xx2(:), prediction_meshgrid, 'rgb');

hold on

training_data = Data.allData01(training(cv),:);
Y = ismember(training_data.Gold,labels{1});

scatter(training_data.RAR2(Y),training_data.Inspiratory_Tidal_Volume(Y),'o','MarkerEdgeColor','black','MarkerFaceColor','black');
scatter(training_data.RAR2(~Y),training_data.Inspiratory_Tidal_Volume(~Y),'o','MarkerEdgeColor','black','MarkerFaceColor','yellow');

xlabel('RAR2');
ylabel('Inspiratory_Tidal_Volume');

title(classifier_name);
legend off, axis tight

legend(labels,'Location',[0.45,0.01,0.45,0.05],'Orientation','Horizontal');

%% Visualization Testing Results

labels = unique(Data.allData01.Gold);
classifier_name = 'Ensemble(Testing Results)';

D = load('allData01T.mat');
RAR2_range = min(Data.allData01.RAR2(training(cv)))-1:0.01:max(Data.allData01.RAR2(training(cv)))+1;
Inspiratory_Tidal_Volume_range = min(Data.allData01.Inspiratory_Tidal_Volume(training(cv)))-1:0.01:max(Data.allData01.Inspiratory_Tidal_Volume(training(cv)))+1;
[xx1,xx2] = meshgrid(RAR2_range,Inspiratory_Tidal_Volume_range);
XGrid = [xx1(:) xx2(:)];

prediction_meshgrid = predict(Cross_Validation_Model.Trained{1}, XGrid);

figure(2);
gscatter(xx1(:),xx2(:),prediction_meshgrid, 'rgb');

hold on
testing_data = load('allData01T.mat');
Y1 = ismember(testing_data.Gold,labels{1});

scatter(testing_data.RAR2(Y),testing_data.Inspiratory_Tidal_Volume(Y),'o','MarkerEdgeColor','black','MarkerFaceColor','black');
scatter(testing_data.RAR2(~Y),testing_data.Inspiratory_Tidal_Volume(~Y),'o','MarkerEdgeColor','black','MarkerFaceColor','yellow');

xlabel('RAR2');
ylabel('Inspiratory_Tidal_Volume');

title(classifier_name);
legend off, axis tight

legend(labels,'Location',[0.45,0.01,0.45,0.05],'Orientation','Horizontal');