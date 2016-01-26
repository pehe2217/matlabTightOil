function plotProdHistProd()
% Total production
global T producers

fig = figure();
hold on;
production = zeros(T,length(producers));

time = 1:T;
% %%
% time_str = [];
% for i = time
%     time_str = {time_str, my_yearmonth(2010,t)};
% end


colour = {'b','g','r'};
% for pr = 1:length(producers)
%     col = colour{pr};
%     if(pr==1 || pr==2 || pr==3) 
%         col = strcat(col,'+');
%     end
%     production(:,pr) = producers(pr).totalProd;
%     plot(time,production(:,pr)/1000,col)
%     %plot(time,production(:,pr)/1000)
% end

sign = 'o-';
for pr = 1:length(producers)
    col = colour{pr};
    col = strcat(col,sign);
    production(:,pr) = producers(pr).totalProd;
    plot(time,production(:,pr)/1000,col)
    %plot(time,production(:,pr)/1000)
end
sign = 's-';
% for pr = 4:6
%     col = colour{pr-3};
%     col = strcat(col,sign);
%     production(:,pr) = producers(pr).totalProd;
%     plot(time,production(:,pr)/1000,col)
%     %plot(time,production(:,pr)/1000)
% end


%% Load Total Production
filename = 'dpr-data_edited.xlsx';
sheet = 'Eagle Ford Region';
range = 'E39:E110'; % Jan 2010 to aug 2015

fprintf('\nLoading history data on total production:\n');
fprintf('\tTrying to read input file:\n');
fprintf('\tFilename: %s\n',filename);
fprintf('\tSheet: %s\n',sheet);
fprintf('\tRange: %s\n',range);

histProd = xlsread(filename,sheet,range);

%%
%str = strcat(colour{pr+1},'k+-');
plot(1:length(histProd),histProd/1000,'k+-');

%%
xlabel('Month')
ylabel('Production [avg k-bbl/day]');
% legend('static parameters - Aggressive','Static parameters - Neutral','Static parameters - Conservative',...
%     'Production data from EIA')
%legend('Aggressive Investment Strategy (5 Milion USD)','Neutral Investment Strategy','Conservative Investment Strategy (5 Milion USD)',...
%    'Production data from EIA')
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',16,...
    'fontWeight','bold')
set(gca,'FontSize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
lineobj = findobj('type', 'line');
set(lineobj, 'linewidth', 1.5)

axis([0 72 0 2000])
%axis([0 T 0     max(max(max(production,[],2),histProd))/1000*1.1 ])



%%
fname = 'simulation_results.xlsx';
sheet = datestr(now,'yyyy-mm-dd-HHMMSS');
xlswrite(fname,{'Historical production'},sheet,'B1');
xlRange1 = 'B2';
xlswrite(fname,histProd,sheet,xlRange1);

xlswrite(fname,{'Simulated production'},sheet,'C1');
xlRange2 = 'C2';
xlswrite(fname,production,sheet,xlRange2);


end

