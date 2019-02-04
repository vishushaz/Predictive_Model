%% ReadData
Data = readtable('C:\Users\shastri.vishweshwer\Google Drive\F-V_AZ\Machine-Learning\DatasetOrganised.xlsx');

%%
%%Missing Data Preprocessing

complete_data = rmmissing(Data,'MinNumMissing',2);
%%
%%fature scaling

focus_data = complete_data(:,11:12);
New_Data = table2array(focus_data);

%%

wcss = [];
for k = 1:5
    sumall = 0;
    [idx, C,sumall] = kmeans(New_Data, k);
    wcss(k) = sum(sumall);
end
plot(1:5, wcss);
 

[idx, C] = kmeans(New_Data,3);




figure,

gscatter(New_Data(:,1),New_Data(:,2), idx);
hold on
for i =1:3
    scatter(C(1,1),C(1,2), 60, 'black', 'filled');
    
end
legend({'Gold 3', 'Gold 2', 'Gold 1',})
xlabel('FEV_1%');
ylabel('FEV_1/FVC');
hold off
