folder='C:\Users\......\Desktop\CDCRC\ABC'
d=dir(folder)
e={d.datenum}
f=e(~cellfun(@isempty,regexp(e,'.+(?=\.xlsx)','match')))

for k=1:numel(f)-1
  data{k,1}=xlsread(f{k})
end
M=cell2mat(data)
xlswrite('new_file',M)
