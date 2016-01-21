function out = loadDistributionOf_q0()
filename = 'q0_modified.xlsx';
sheet = 'Peak prod (bpd)';
range = 'A2:E927';
[data,text] = xlsread(filename,sheet,range);

[row, col] = find(isnan(data));


year2010 = data(1:(row(1)-1),1);

col2 = find(col==2,1);
end2 = row(col2); 
year2011 = data(1:(end2-1),2);

col3 = find(col==3,1);
end3 = row(col3); 
year2012 = data(1:(end3-1),3);

year2013 = data(:,4);

col5 = find(col==5,1);
end5 = row(col5); 
year2014 = data(1:(end5-1),5);

raw = {year2010,year2011,year2012,year2013,year2014};

%%
len = zeros(5,1);
len(1) = length(year2010);
len(2) = length(year2011);
len(3) = length(year2012);
len(4) = length(year2013);
len(5) = length(year2014);

right = 25:25:3000; 
right = right';
n = length(right);

freq = zeros(n,5);
prob = zeros(n,5);
% Frequency and probability distribution: 
for j = 1:5
    freq(1,j) = length(find(raw{j}<right(1)));
    
    for i = 2:n
        freq(i,j) = length(find(raw{j}<right(i)))-length(find(raw{j}<right(i-1)));
        
    end
    prob(:,j) = freq(:,j)/len(j);
end

cum = zeros(n,5);
% Cumulative distribution function
for j = 1:5
    cum(1,j) = prob(1,j);
    for i = 2:n
        cum(i,j) = cum(i-1,j)+prob(i,j);
    end
end

out = cell(1,5);
for j = 1:5
    out{j} = [right,cum(:,j)];
end

%end

