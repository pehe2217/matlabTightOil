fig = figure();
[AX,H1,H2] =  plotyy(1:T,productionData/1e6,1:T,oilPrice);
xlabel('month')
axes(AX(1)); ylabel('Production [avg M-bbl/day]'); %axis([0 T 0 max(totNewWells)*1.1]);
axes(AX(2)); ylabel('Oil Price [USD/bbl]'); %axis([0 T 0 max(totCap)*1.1]);

set(get(AX(2),'Ylabel'),'fontSize',16)
set(get(AX(1),'Ylabel'),'fontSize',16)
set(get(AX(1),'Xlabel'),'fontSize',16)
lineobj = findobj('type', 'line');
set(lineobj, 'linewidth', 1.5)
axes(AX(1)); axis([0 T 0 max(productionData/1e6)*1.1])
axes(AX(2)); axis([0 T 0 max(oilPrice)*1.1])
%str = sprintf('Data from EIA');
%title(str);
