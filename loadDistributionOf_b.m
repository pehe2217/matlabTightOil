function data = loadDistributionOf_b()
filename = 'histogram_b.csv';
sheet = 'histogram_b';
range = 'A3:D20';
[data,text] = xlsread(filename,sheet,range);

data(18,1) = data(17,1) + (data(17,1)-data(16,1));


end

