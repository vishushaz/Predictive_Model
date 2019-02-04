location = ('C:\Users\vishu\Google Drive\F-V_AZ\Machine-Learning\Data\Added');
dir(location)

%%
ds = spreadsheetDatastore(location)

%%

Total = readall(ds);
size(Total)

%%

% T = table(allData.RAR2,allData.Peak_Intrabreath_Flow, allData.Tidal_Volume, allData.Relative_Vmax_Volume, allData.End_Expiratory_Flow, allData.TiTtot);
% T.Properties.VariableNames{1} = 'RAR2';
% T.Properties.VariableNames{2} = 'V_Max';
% T.Properties.VariableNames{3} = 'V_tidal';
% T.Properties.VariableNames{4} = 'Rel_V_Max';
% T.Properties.VariableNames{5} = 'V_EE';
% T.Properties.VariableNames{6} = 'TiTtot';
