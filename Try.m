Data = readtable('C:\....\Mall_Customers.csv');

td_AnnualIncome = (Data.AnnualIncome - mean(Data.AnnualIncome))/std(Data.AnnualIncome);
Data.AnnualIncome

Std_SpendingScore = (Data.SpendingScore - mean(Data.SpendingScore))/std(Data.SpendingScore);
Data.AnnualIncome

Data = Data(:,4:5);
Data = table2array(Data);


z = linkage(Data,'ward');


dendrogram(z);

I = inconsistent(z,6);
[a, b] = max(I(:,4));

c = cluster(z,'cutoff', z(b,3)-0.1,'Criterion','distance');

wcss = [];
for k = 1:10
    sumall = 0;
    [idx, C, sumall] = kmeans(Data, k);
    wcss(k) = sum(sumall);
end
plot(1:10, wcss);


[idx, C] = kmeans(Data,5);




figure,

gscatter(Data(:,1), Data(:,2), c);
% hold on
% for i =1:5
%     scatter(C(1,1),C(1,2), 96, 'black', 'filled');
%     
% end
legend({'Cluster 1', 'Cluster 2', 'Cluster 3', 'Cluster 4', 'Cluster 5'})
xlabel('Annual Income');
ylabel('Spending Scores');
hold off