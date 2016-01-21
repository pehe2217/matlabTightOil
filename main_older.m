clc; close all; clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Project Tight oil %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
staticMode = false;
if(staticMode)
    loadOilPrice = true;
    loadRigData = true;
    economicDynamics = false;
else%if(economicDynamics)
    economicDynamics = true;
    loadOilPrice = true;   % Optional
    numProd = 3;           % Optional
    maxAvailableRigs = 50; % Optional
    % NPV decides if the producer will drill a well or not. 
    
    % How to decide NPV: 
    % Single average well,
    % A portfolio of wells
    % calculation based on past wells. 
    %in = input('Do you want to load default rig data? [y]\n','s');
    %if(in=='y')
        loadRigData = true;
    %end
    
end

%%
drillTime = 1;
% [months]. The number of months it takes to drill the well.
compTime = 1; 
% [months]. The number of months it takes to complete the
                         % well after the drilling.
                         
%%


%% Values for estimating NPV:
fprintf('Setting values for NPV estimation... \n');
q0 = 644;             % [bb/day]
drillCost = 5e6;            % [USD]
comCost = 5e6;              % [USD]
royaltiesAndTaxes = 0.30;   % [Percentage]
operatingCost = 10;         % [USD/bbl]
fixedOperCost = 5000;        % [USD/bbl]
discountRate = 0.10;        % Percentage
timeHorizon = 120;          % [months] The time horizon.
D_estimate = 0.237;         % Decline curve parameter 1
b_estimate = 0.927;         % Decline curve parameter 2
b_preSet = [];
D_preSet = [];

fprintf('\nLoading data... \n');
%% Load oil Price
if(loadOilPrice)
    % Default file, sheet and range:
    fprintf('\nLoading oil price:\n');
    
    filename = 'RWTCm.xls';
    sheet = 'Data 1';
    range = 'A256:B359';
    
    needInput = 1; % Loop parameter. 
    while(needInput)
        try
            fprintf('\tTrying to read input file:\n');
            fprintf('\tFilename: %s\n',filename);
            fprintf('\tSheet: %s\n',sheet);
            fprintf('\tRange: %s\n',range);
            [oilPrice, Months] = xlsread(filename,sheet,range);
            T = length(oilPrice);
            needInput = 0;
        catch
            fprintf('\nError when trying to load file.\n');
            filename = input('Type filename incl file extension:\n');
            sheet = input('Type the name of the sheet:\n');
            range = input('Type the range:\n');
        end
    end
else % Else, we have an endogenous oil price:
    T = 150; % Number of simulated months.
    oilPrice = zeros(T,1);
    for t = 1:T
        if(t == 1)
            oilPrice(t) = 120; % Oil price
        elseif(t == 100 || t==40)
            oilPrice(t) = 60;
        elseif(1<t && t<40)
            oilPrice(t) = oilPrice(t-1)^(.01/12+1) + (rand()-0.5)*10;
            %oilPrice(t) = oilPrice(t-1) + (rand()-0.5)*10;
        elseif(200<t && t<=T)
            oilPrice(t) = oilPrice(t-1)^(.005/12+1) + (rand()-0.5)*10;
        else
            oilPrice(t) = oilPrice(t-1)^(.01/12+1) + (rand()-0.5)*10;
        end
    end
    
end

%%
% Number of wells a rig can drill each month. 
wellsPerRig = linspace(0.8,2,T);


fprintf('Introducing a dynamics parameter: Producers find the best wells first.\n');
% filename = input('Type :\n');
initProd_ajustment = linspace(0.7,1.3,T);



%%
if(loadRigData)
    % Load rig data
    fprintf('\nLoading Rig data:\n');
    filename = 'dpr-data.xlsx';
    sheet = 'Eagle Ford Region';
    range = 'B3:B106';
    
    fprintf('\tTrying to read input file:\n');
    fprintf('\tFilename: %s\n',filename);
    fprintf('\tSheet: %s\n',sheet);
    fprintf('\tRange: %s\n',range);
    
    rigCount = xlsread(filename,sheet,range);
elseif(economicDynamics)
    maxAvailableRigs = 300; % Maximum number of available rigs each month.
end


%% Load Total Production
filename = 'dpr-data.xlsx';
sheet = 'Eagle Ford Region';
range = 'E3:E106';

fprintf('\nLoading history data on total production:\n');
fprintf('\tTrying to read input file:\n');
fprintf('\tFilename: %s\n',filename);
fprintf('\tSheet: %s\n',sheet);
fprintf('\tRange: %s\n',range);

productionData = xlsread(filename,sheet,range);

%%
time = 1:T;
days = 30.41; % Average number of days in a month.


producers = [];
%sizes = {'small','medium','large'};
if(~economicDynamics)
    % Dumb static version
    numProd = 1;
    strategy = 4;
    %producerSize = sizes(strategy);
    initialCapital = 0;
    producers = [createProducer(initialCapital,T,strategy)];
else
    for i = 1:numProd
        strategy = mod(i,3) +1;
        %producerSize = sizes(strategy);
        initialCapital = 1e7*10^strategy;
        %if(i==1 || i==2) strategy = 1; else strategy = 2; end
        producers = [producers, createProducer(initialCapital,T,strategy)];
    end
end
fprintf('\nLoading data completed. \n');
fprintf('Starting the simulation... \n');

fprintf('\nLooping through time:\n');
for t = 1:T % Loop though time:
    if(mod(t,10) == 0)
        fprintf('\nTime step: %0.0f \n',t); % Print the time step
    end
    % (In each month t:) For each producer:
    for prod = 1:length(producers)
        
        if(t>1) % In each step in time, the capital and number of wells
            % need to be brought with.
            producers(prod).numWells(t) = producers(prod).numWells(t-1);
            producers(prod).capital(t) = producers(prod).capital(t-1);
        end
        
        if(economicDynamics)
            npv = NPVestimator(oilPrice(t),q0,drillCost,comCost,...
                royaltiesAndTaxes,operatingCost,fixedOperCost,...
                discountRate,T,D_estimate,b_estimate,initProd_ajustment(t));
            if(mod(t,10) == 0)
                fprintf('Producer %0.0f: Inspection of well.\n',prod);
                fprintf('Estimated Net Present Value: %f \n',npv); 
            end
        end
        
        switch producers(prod).strategy
            case 1
                availableRigs = 2;
                while(npv > 0 && ...
                        (producers(prod).capital(t) > (drillCost+comCost))...
                        && availableRigs>0)
                    
                    availableRigs = availableRigs -1;
                    producers(prod) = investInNewWell(producers(prod),t,[],...
                        drillTime,compTime,drillCost,comCost,royaltiesAndTaxes,...
                        operatingCost,fixedOperCost,discountRate,b_preSet,D_preSet,T,initProd_ajustment(t));
                    npv = NPVestimator(oilPrice(t),q0,drillCost,...
                        comCost,royaltiesAndTaxes,operatingCost,...
                        fixedOperCost,discountRate,timeHorizon,D_estimate,b_estimate,initProd_ajustment(t));
                end
            case 2
                availableRigs = 4;
                while(npv > 0 && ...
                        (producers(prod).capital(t) > (drillCost+comCost))...
                        && availableRigs>0)
                    
                    availableRigs = availableRigs -1;
                    producers(prod) = investInNewWell(producers(prod),t,[],...
                        drillTime,compTime,drillCost,comCost,royaltiesAndTaxes,...
                        operatingCost,fixedOperCost,discountRate,b_preSet,D_preSet,T,initProd_ajustment(t));
                    npv = NPVestimator(oilPrice(t),q0,drillCost,...
                        comCost,royaltiesAndTaxes,operatingCost,...
                        fixedOperCost,discountRate,timeHorizon,D_estimate,b_estimate,initProd_ajustment(t));
                end
            case 3
                availableRigs = rigCount(t);
                while(availableRigs>0)
                    
                    availableRigs = availableRigs -1;
                    producers(prod) = investInNewWell(producers(prod),t,[],...
                        drillTime,compTime,drillCost,comCost,royaltiesAndTaxes,...
                        operatingCost,fixedOperCost,discountRate,b_preSet,D_preSet,T,initProd_ajustment(t));
                end
            case 4
                if(~loadRigData)
                    availableRigs = maxAvailableRigs;
                else
                    availableRigs = round(rigCount(t)); %*wellsPerRig(t));
                end
                while(availableRigs>0)
                    availableRigs = availableRigs -1;
                    producers(prod) = investInNewWell(producers(prod),t,[],...
                        drillTime,compTime,drillCost,comCost,royaltiesAndTaxes,...
                        operatingCost,fixedOperCost,discountRate,b_preSet,D_preSet,T,initProd_ajustment(t));
                end
            case 5
                availableRigs = round(maxAvailableRigs*wellsPerRig(t));
                while(availableRigs>0)
                    availableRigs = availableRigs -1;
                    producers(prod) = investInNewWell(producers(prod),t,[],...
                        drillTime,compTime,drillCost,comCost,royaltiesAndTaxes,...
                        operatingCost,fixedOperCost,discountRate,b_preSet,D_preSet,T,initProd_ajustment(t));
                end
            otherwise
                str = sprintf('Unknown strategy of producer no: %3.3f',prod);
                disp(str);
        end % End: switch strategy
        
        
        % (For each time step:) For each well:
        for w = 1:(length(producers(prod).wells))
            % Increment the production time array:
            producers(prod).wells(w).prodTime = producers(prod).wells(w).prodTime +1;
            
            % If the well is drilled last month, it will be completed
            % this month. Completion cost is debited:
            if(producers(prod).wells(w).prodTime==0)
                producers(prod).capital(t) = producers(prod).capital(t)...
                    - producers(prod).wells(w).comCost;
                
                % If the drilling time and the completion time has passed,
                % the well is producing:
            elseif(producers(prod).wells(w).prodTime>0 &&...
                    producers(prod).wells(w).decommissioned==T)
                
                % Compute average daily production in month t:
                producers(prod).wells(w).q(t) = ...
                    producers(prod).wells(w).q0 * ...
                    (1 + producers(prod).wells(w).D...
                    *producers(prod).wells(w).b...
                    *producers(prod).wells(w).prodTime)...
                    .^((-1)/producers(prod).wells(w).b);
                
                % Revenue from production:
                grossRev = producers(prod).wells(w).q(t) * days * oilPrice(t);
                % Royalties and taxes
                royNtax = grossRev * producers(prod).wells(w).royaltiesAndTaxes;
                % Operating costs
                opCosts = producers(prod).wells(w).q(t) * days...
                    * producers(prod).wells(w).operatingCost...
                    + producers(prod).wells(w).fixedOperCost;
                % Net revenue
                netRev = grossRev - royNtax - opCosts;
                
                producers(prod).capital(t) = producers(prod).capital(t)+netRev;
                if(netRev<0)    % Decommission the well:
                    producers(prod).wells(w).decommissioned = t;
                    producers(prod).numWells(t) = producers(prod).numWells(t) -1;
                    fprintf('Producer  no %0.0f: well no  %3.3f has a negative net revenue.\n',prod,w);
                    fprintf('Decision: Decommission the well.\n');
                end
            end
        end
    end
end
fprintf('\nLooping through time completed\n');
fprintf('Simulation completed.\n');

%%
fprintf('\nPlotting data... \n');
% New wells
figure(1)
hold on;
totNewWells = zeros(T,1);

% Active wells
figure(2)
hold on;
activeWells = zeros(T,1);

% Capital
figure(3)
hold on;

% Total production
figure(4)
hold on;
production = zeros(T,1);

figure(9)
decom = zeros(T,1);

colour = {'b','g','r','c','m','y','k',};
for pr = 1:numProd
    col = colour{pr};
    
    totNewWells = totNewWells + producers(pr).newWells;
    figure(1)
    plot(time,totNewWells,col);
    
    activeWells = activeWells + producers(pr).numWells;
    figure(2)
    plot(time,activeWells,col);
    
    figure(3)
    plot(time,producers(pr).capital,col);
    
    for w = 1:(length(producers(pr).wells))
        production = production + producers(pr).wells(w).q;
        decom(producers(pr).wells(w).decommissioned) = decom(producers(pr).wells(w).decommissioned) +1;
        
        %figure(4)
        %plot(time,production,col);
        
        %figure(5)
        %I = find(producers(pr).wells(w).q,1)
        %plot(time,producers(pr).numWells,col);
    end
end

% New wells
figure(1)
%xlabel('time [months]')
%ylabel('Drilling of new wells [freq]')
%str = sprintf('Aggregated production of a region with %0.0f different producers',numProd);
%title(str);
[ax, h11, h12] = plotyy(time,totNewWells,time,rigCount);
xlabel('time [months]')
axes(ax(1)); ylabel('Simulated new wells per month');
axes(ax(2)); ylabel('Rig Count Data');
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',16,...
    'fontWeight','bold')
set(gca,'FontSize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
%lineobj = findobj('type', 'line');
%set(lineobj, 'linewidth', 1.0)
%axis([-1 1 -1 1 -1 1])


% Active wells
figure(2)
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


% Capital
figure(3)
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


% Production of a region
figure(4)
plot(time,production,col);
str = sprintf(' production of a region with %0.0f different producers',numProd);
title(str);
xlabel('time [months]')
ylabel('Production [bbl/day]');
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',16,...
    'fontWeight','bold')
set(gca,'FontSize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
lineobj = findobj('type', 'line');
set(lineobj, 'linewidth', 1.5)



% Production vs Oil Price
figure(6)
str = sprintf('Production of a region with %0.0f different producers',numProd);
title(str);
[ax, h41, h42] = plotyy(time,production,time,oilPrice);
xlabel('time [months]')
axes(ax(1)); ylabel('Production [bbl/day]');
axes(ax(2)); ylabel('OilPrice [USD/bbl]');
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',16,...
    'fontWeight','bold')
set(gca,'FontSize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
lineobj = findobj('type', 'line');
set(lineobj, 'linewidth', 1.5)


figure(7)
[ax, h51, h52] = plotyy(time,totNewWells,time,oilPrice);
xlabel('time [months]')
axes(ax(1)); ylabel('Number of new wells per month');
axes(ax(2)); ylabel('OilPrice [USD/bbl]');
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',16,...
    'fontWeight','bold')
set(gca,'FontSize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
lineobj = findobj('type', 'line');
set(lineobj, 'linewidth', 1.5)

%%
figure(8)
str = sprintf('Simulated production respectively actual production');
title(str);
[ax, h41, h42] = plotyy(time,production,time,productionData);
xlabel('time [months]')
axes(ax(1)); ylabel('Simulated production [bbl/month]');
axes(ax(2)); ylabel('Actual production [bbl/day]');
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',16,...
    'fontWeight','bold')
set(gca,'FontSize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
lineobj = findobj('type', 'line');
set(lineobj, 'linewidth', 1.5)


figure(9)
% Active wells)
[ax, h41, h42] = plotyy(time,activeWells,time,decom);
xlabel('time [months]')
axes(ax(1)); ylabel('Active Wells [Freq]');
axes(ax(2)); ylabel('Decommissioned wells [Freq]');
%str = sprintf('Aggregated production of a region with %0.0f different producers',numProd);
%title(str);
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',16,...
    'fontWeight','bold')
set(gca,'FontSize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
lineobj = findobj('type', 'line');
set(lineobj, 'linewidth', 1.5)





fprintf('Done plotting. \n');

fprintf('\nProgram ended.\n');


%%
figure()
hold on; 
for i = 1:20
    plot(time,producers(1).wells(i).q)
end

% %%
% brunnar = [];
% hold on; 
% for i = 1:20
%     brunnar = [brunnar, createWell(q0,drillTime,compTime,drillCost,comCost,royaltiesAndTaxes,...
%                             operatingCost,fixedOperCost,discountRate,[],[],T)];
% end
