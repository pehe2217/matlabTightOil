function D = distributionOfParameter_D()
filename = '../histogram_D.csv';
sheet = 'histogram_D';
range = 'A3:D20';
[data,text] = xlsread(filename,sheet,range);

data(18,1) = data(17,1) + (data(17,1)-data(16,1));

r = rand(); 
bin = find(r<data(:,4),1); 
D = (data(bin,1)-data((bin-1),1))/2 + data((bin-1),1);

end

