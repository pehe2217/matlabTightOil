clc; close all; clear all;
% +-----------------------------------------------------------------------+
% |     Modeling of Tight Oil Production
% |     A Bottom-up Approach
% |     By: 
% |     Per Hedbrant
% |     Student at Uppsala University, Sweden
% |     M.Sc. in Engineering Physics
% |     October 2015
% +-----------------------------------------------------------------------+

fprintf('Loading Settings...');
% Global variables, edit only if you know what you are doing. 
global T economicDynamics days 
global producers
global oilPrice 
global distribution_D distribution_b distribution_q0
global productionData 

% >>>  INPUT DATA: 
T = 104;                             % [Months] Length of simulation
economicDynamics                        = false;     % true or false
loadOilPriceFromFile                    = false;     % true or false
loadProdDataFromFile                    = true;    % true or false
loadRigDataFromFile                     = true;    % true or false
if(~loadRigDataFromFile)
    maxRigs = 40; % Change here if you don't want to load data from file. 
end
loadWellsPerRigRateFromFile             = true; 
if(~loadWellsPerRigRateFromFile)
    constantWRR = 1;
end
loadMonthsFromFile                      = false;    % true or false
plotFigures                             = true;    % true or false

stochasticDeclinecurveVariables         = false;    % true or false
if(stochasticDeclinecurveVariables)
    % Loading distribution of decline parameters: 
    distribution_b = loadDistributionOf_b();        % Don't edit
    distribution_D = loadDistributionOf_D();        % Don't edit
    set_D = []; % Stochastic assignement for each well
    set_b = []; % Stochastic assignement for each well
else
    % Deterministic assignment, same value for all wells.
    % (if determininstic assignment) >>>>>>  INPUT DATA: 
    %set_D = .237; 
    %set_b = .927; 
    set_D = .488; 
    set_b = 1.1; 
end

stochasticInitialProduction             = false; 
if(stochasticInitialProduction)
    distribution_q0 = loadDistributionOf_q0();
    set_q01 = []; % Stochastic assignement for each well
else
    % Deterministic assignment, same value for all wells.
    % (if determininstic assignment) >>>>>>  INPUT DATA: 
    set_q01 = 500;
end

printProgress = true;                              % true or false

%% Loading of oil price
% Edit filename, sheet and range of the excel document of your choice:
if(loadOilPriceFromFile)
    f = 'RWTCm.xls';
    sheet    = 'Data 1';
    range    = 'A256:B359';
    oilPrice = decideOilPrice(f,sheet,range);
else
    oilPrice = decideOilPrice();
end
%% Loading Rig data from file
% Edit filename, sheet and range of the excel document of your choice:
if(loadRigDataFromFile)
    %f        = 'myDataInput.xlsx';
    %sheet    = 'Sheet1';
    %range    = 'B2:B6';
    f        = 'dpr-data.xlsx';
    sheet    = 'Eagle Ford Region';
    range    = 'B3:B106';
    rigs1 = loadRigs(f,sheet,range);
else
    rigs1 = loadRigs(maxRigs);
end

%% Loading Wells per rig
% The number of wells a rig can drill each month. 
% Edit filename, sheet and range of the excel document of your choice:
if(loadWellsPerRigRateFromFile)
    %f        = 'myDataInput.xlsx';
    %sheet    = 'Sheet1';
    %range    = 'B2:B6';
    f        = 'dpr-data_edited.xlsx';
    sheet    = 'Eagle Ford Region';
    range    = 'J3:J106';
    wellsPerRigRate = loadWellsPerRigRate(f,sheet,range);
else
    wellsPerRigRate = loadWellsPerRigRate(constantWRR);
end

%% Load Total Production
if(loadProdDataFromFile)
    filename = 'dpr-data.xlsx';
    sheet = 'Eagle Ford Region';
    range = 'B3:B106';
    
    fprintf('\nLoading history data on total production:\n');
    fprintf('\tTrying to read input file:\n');
    fprintf('\tFilename: %s\n',filename);
    fprintf('\tSheet: %s\n',sheet);
    fprintf('\tRange: %s\n',range);
    
    productionData = xlsread(filename,sheet,range);
end



% Do not edit.
days = 30.41; % Average number of days in a month.


% +--------------------------------------------------------------------+
% |         PRODUCER STRATEGIES
% | Invest in a new well if one or many of these constraints are met:
% | NPV > 0
% | capital > drilling cost and completion cost
% | Maximum rigs
% | Different strategies for a producer:
% | 'NPV'
% | 'cash'
% | 'rig'
% | 'NPV_cash'
% | 'NPV_rig'
% | 'cash_rig'
% | 'NPV_cash_rig'
% |
% | Additional strategy settings:
% | NPVaggrConserv (default = 0)
% | 
% +--------------------------------------------------------------------+
% >>>> INPUT: 
cap = 3e6;

%producers = [createProducer(5e8,T,'rig',rigs1)];

n = 1;
producers = [];
qqq = linspace(450,650,n);
DDD = [0.16675263, 0.408676386, 0.650600141, 0.892523896];
bbb = linspace(0.4,1.66,n);

for qq = 1:n
    for DD = 1:n
        for bb = 1:n
            pr = n*n*(qq-1) + n*(DD-1) + bb;
            producers = [producers,createProducer(cap,T,'rig',rigs1)];
            producers(pr).wellsPerRigRate = wellsPerRigRate;
            
            producers(pr).NPVestimatorInput.q0 = qqq(qq);%[bbl/day] Initial production rate.
            producers(pr).NPVestimatorInput.D = DDD(DD); % Decline curve parameter 1 (initial decline rate)
            producers(pr).NPVestimatorInput.b = bbb(bb); % Decline curve parameter 2 (curvature of line)
            
            producers(pr).investInput.q0 = qqq(qq);%[bbl/day] Initial production rate.
            producers(pr).investInput.D = DDD(DD);% Decline curve parameter 1 (initial decline rate)
            producers(pr).investInput.b = bbb(bb);% Decline curve parameter 2 (curvature of line)
            
        end
    end
end

%% END OF INPUT. 

fprintf('\nSettings completed. \n');

%% SIMULATION
fprintf('Starting the simulation... \n');

% This is where the magic happens: 
tic
res_timeItter = timeItter(printProgress);
toc
fprintf('Simulation completed.\n');

fprintf('Saving results...\n');
str = sprintf('results/simulation_');
dt = datestr(now,'yyyy-mm-dd-HHMMSS');
str = strcat(str,dt);
save(str);


%% PLOTTING
if(plotFigures)
    %%
    fprintf('\nPlotting data... \n');
    
    
    % Plot number of active wells and new wells
    fprintf('\nPlotting number of active wells and new wells: \n');
    plotNumWells();
    
    % Plot Production
    fprintf('Plotting Production...\n')
    plotProduction()
    
    % Plot Capital (cash flow) of producers:
    fprintf('Plotting capital or cash flow of producers... \n')
    plotCapital()
    
    % Plot Capital and number of new wells in the same plot:
    fprintf('Plotting capital and number of new wells in the same plot...\n')
    plotCapitalNewWells()
    
    % Plot New Wells and total production together:
    plotNewWellsProduction()
    
    fprintf('Done plotting. \n');
    %%
end



fprintf('\nProgram ended.\n');
