function data = loadDistributionOf_D()
filename = 'histogram_D.csv';
sheet = 'histogram_D';
range = 'A3:D20';
[data,text] = xlsread(filename,sheet,range);

data(18,1) = data(17,1) + (data(17,1)-data(16,1));

end

