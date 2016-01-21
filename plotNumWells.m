function plotNumWells()
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
global T producers

time = 1:T;

% New wells
pNewWells = figure();
hold on;
totNewWells = zeros(T,1);

% Active wells
pActiveWells = figure();
hold on;
activeWells = zeros(T,1);


colour = {'b','g','r','c','m','y','k',};
for pr = 1:length(producers)
    col = colour{pr};
    
    totNewWells = totNewWells + producers(pr).newWells;
    figure(pNewWells)
    plot(time,totNewWells,col);
    
    activeWells = activeWells + producers(pr).numWells;
    figure(pActiveWells)
    plot(time,activeWells,col);
    
end


% Active wells
figure(pNewWells)
xlabel('time [months]')
ylabel('New wells [freq]')
%str = sprintf('Aggregated production of a region with %0.0f different producers',numProd);
%title(str);
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',16,...
    'fontWeight','bold')
set(gca,'FontSize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
lineobj = findobj('type', 'line');
set(lineobj, 'linewidth', 1.5)
axis([0 T 0 max(totNewWells)*1.05])



% Active wells
figure(pActiveWells)
xlabel('time [months]')
ylabel('Active wells [freq]')
%str = sprintf('Aggregated production of a region with %0.0f different producers',numProd);
%title(str);
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',16,...
    'fontWeight','bold')
set(gca,'FontSize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
lineobj = findobj('type', 'line');
set(lineobj, 'linewidth', 1.5)
axis([0 T 0 max(activeWells)*1.05])


end

