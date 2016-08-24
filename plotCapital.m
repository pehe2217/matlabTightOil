function plotCapital()
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
global producers T


fig = figure(); 
totCap = zeros(T,1);
capital = zeros(T,length(producers));
hold on;
time = 1:T;

colour = {'b','g','r','c','m','y','k',};
for pr = 1:length(producers)
    col = colour{pr};
    totCap = totCap + producers(pr).capital;
    capital(:,1) = producers(pr).capital;
    plot(time,totCap,col)
end

% Capital
figure(fig)
xlabel('time [months]')
ylabel('Capital [USD]')
%title('')
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',16,...
    'fontWeight','bold')
set(gca,'FontSize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
lineobj = findobj('type', 'line');
set(lineobj, 'linewidth', 1.5)

%%
% fname = 'simulation_results.xlsx';
% sheet = datestr(now,'yyyy-mm-dd-HHMMSS');
% 
% xlswrite(fname,{'Producers Capital'},sheet,'B1');
% xlRange2 = 'B2';
% xlswrite(fname,capital,sheet,xlRange2);
% 

end

