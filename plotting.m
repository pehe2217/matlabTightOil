

filename = '../bp-statistical-review-of-world-energy-2015-workbook.xlsx';
sheet = 'Oil Production – Tonnes';
range = 'B71:AY71';
worldProduction = xlsread(filename,sheet,range);

range = 'B3:AY3';
years = xlsread(filename,sheet,range);

sheet = 'Oil - Crude prices since 1861';
range = 'C109:C158';
crudeOilPrice = xlsread(filename,sheet,range);

%%
figure()
[ax, h41, h42] = plotyy(years,worldProduction,years,crudeOilPrice);
xlabel('Year')
axes(ax(1)); ylabel('World Production [Tonnes]');
ylim([0 max(worldProduction)])
axes(ax(2)); ylabel('Crude Oil Price');


%str = sprintf(' production of a region with %0.0f different producers',numProd);
%title(str);
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',16,...
    'fontWeight','bold')
%set(gca,'FontSize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
lineobj = findobj('type', 'line');
set(lineobj, 'linewidth', 2.0)

%%
% EIA: US production 
filename = '../EIA_US_field_production_crudeOil.xls';
sheet = 'Data 1';
range = 'B4:B1150';
USproduction = xlsread(filename,sheet,range);


range = 'A4:A1150';
[ndata, text, alldata] = xlsread(filename,sheet,range);

figure()
plot(alldata,USproduction)

figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',16,...
    'fontWeight','bold')
%set(gca,'FontSize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
lineobj = findobj('type', 'line');
set(lineobj, 'linewidth', 2.0)


%%
T = 120;
input = constructInputs();
well = createWell(input,T);
%well2 = createWell(644,[],[],[],[],[],[],[],[],1.10,0.488,[],1);

for t = 1:T
    
    well.q(t) = well.q0 * (1 + well.D*well.b*(t-1)).^((-1)/well.b);
 %   well2.q(t) = well2.q0 * (1 + well.D*well.b*(t-1)).^((-1)/well.b);
end
hplot = plot(1:T,well.q);

%[ax, hplot, h52] = plotyy(1:T,well.q,1:T,well2.q);
xlabel('time [months]')
%axes(ax(1)); ylabel('Production [% of IP]')
%axes(ax(2)); ylabel('Production [avg bbl/day]');

hold on
%plot(1,0,'r*')
%plot(2,0,'r*')
%hplot = plot(3,well.q0,'r*');
%plot(4,well.q(4),'r*')
%plot(5,well.q(5),'r*')
%axis([0,T,0,119]);
%h = breakxaxis([65 95]);
xlabel('Time [month]')
ylabel('Production [% of IP]')

makedatatip(hplot,2)
makedatatip(hplot,3)
makedatatip(hplot,60)
makedatatip(hplot,120)

figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',16,...
    'fontWeight','bold')
%set(gca,'FontSize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
lineobj = findobj('type', 'line');
set(lineobj, 'linewidth', 2.0)

t1 = text(80,80,'Decline Curve Parameters: b = 1.10, D = 0.488', ...
          'BackgroundColor',[.7 .9 .7], ...
          'HorizontalAlignment','Center', ...
          'Clipping','On');  
      
      
%%
clear all
close all
clc;
T = 60;
wells = [];

sd = .3;

for i = -1:1
    %well = createWell(100,[],[],[],[],[],[],[],[],1.10+sd*i,0.488     ,[],1);
    %wells = [wells, well];
    
    well = createWell(100,[],[],[],[],[],[],[],[],1.10     ,0.488+sd*i,[],1);
    wells = [wells, well];
end

figure()
hold on; 
colour = {'b','g','r','c','m','k','y'};
str = [];
for w = 1:length(wells)
    for t = 1:T
        wells(w).q(t) = wells(w).q0 * (1 + wells(w).D*wells(w).b*(t-1)).^((-1)/wells(w).b);
    end
    col = colour{w};
    plot(1:T,wells(w).q,col);
    str = [str sprintf('b = %1.3f D = %1.3f, ',wells(w).b,wells(w).D)];
    
end

str = strsplit(str,', ');
legend(str)

%[ax, hplot, h52] = plotyy(1:T,well.q,1:T,well2.q);
%xlabel('time [months]')
%axes(ax(1)); ylabel('Production [% of IP]')
%axes(ax(2)); ylabel('Production [avg bbl/day]');

%hold on
%plot(1,0,'r*')
%plot(2,0,'r*')
%hplot = plot(3,well.q0,'r*');
%plot(4,well.q(4),'r*')
%plot(5,well.q(5),'r*')
%axis([0,T,0,119]);
%h = breakxaxis([65 95]);
xlabel('Time [month]')
ylabel('Production [% of IP]')

% makedatatip(hplot,2)
% makedatatip(hplot,3)
% makedatatip(hplot,60)
% makedatatip(hplot,120)

figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',16,...
    'fontWeight','bold')
%set(gca,'FontSize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
lineobj = findobj('type', 'line');
set(lineobj, 'linewidth', 2.0)

%t1 = text(80,80,'Decline Curve Parameters: b = 1.10, D = 0.488', ...
 %         'BackgroundColor',[.7 .9 .7], ...
  %        'HorizontalAlignment','Center', ...
   %       'Clipping','On');  
   
   
   
   
%%
co = get(gca,'ColorOrder') % Initial
% Change to new colors.
set(gca, 'ColorOrder', [0.5 0.5 0.5; 1 0 0], 'NextPlot', 'replacechildren');
co = get(gca,'ColorOrder') % Verify it changed
% Now plot with changed colors.
x = 1:3;
y = [1 2 3; 42 40 34];
plot(x,y, 'LineWidth', 3);

%%
clc; clear all; close all; 
rng('shuffle')
dataD = loadDistributionOf_D();
datab = loadDistributionOf_D();
n = 1000; 
D = zeros(n,1);
b = zeros(n,1);
binD = zeros(n,1);
binb = zeros(n,1);
rD = zeros(n,1);
rb = zeros(n,1);

for i = 1:n
    [D(i),binD(i),rD(i)] = parameter_D(dataD);
    [b(i),binb(i),rb(i)] = parameter_b(datab);
end
%%
hist(b)
hold off;
hist(D)
%%

IP = zeros(producers.numWells,1);
bb = zeros(size(IP));
DD = zeros(size(IP));

for w = 1:producers.numWells
    IP(w) = producers.wells(w).q0;
    bb(w) = producers.wells(w).b;
    DD(w) = producers.wells(w).D;
    
end

%%
filename = 'q0_modified.xlsx';
sheet = 'Peak prod (bpd)';
range = 'L8:T38';
[data1,text] = xlsread(filename,sheet,range);

