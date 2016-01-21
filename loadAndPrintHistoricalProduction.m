clear all; clc;
% Load Total Production
filename = '../EIA_US_field_production_crudeOil.xls';
sheet = 'Data 1';
range = 'A4:B1150';

fprintf('\nLoading history data on total production:\n');
fprintf('\tTrying to read input file:\n');
fprintf('\tFilename: %s\n',filename);
fprintf('\tSheet: %s\n',sheet);
fprintf('\tRange: %s\n',range);

[ndata, text, alldata] = xlsread(filename,sheet,range);
[yyyy, mm, dd, i, ii, iii] = datevec(alldata(:,1));
yy = floor(linspace(1920,2015,1147));

figure1 = figure;
axes1 = axes('Parent',figure1,'XTickLabel',alldata(:,1));
box(axes1,'on');
hold(axes1,'all');
% Create plot
%plot(cell2mat(alldata(:,2)));
plot(yy,cell2mat(alldata(:,2)));