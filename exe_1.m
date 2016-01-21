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
plotFigures                             = false;    % true or false

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

printProgress = false;                              % true or false

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
const = 3e6;

producers = [createProducer(5e8,T,'rig',rigs1)];
producers(1).wellsPerRigRate = wellsPerRigRate;
% producers(1).NPVaggrConserv = ones(T,1) * (-const);  % Aggressive. NPV > negative value
%producers(1).prodAim = productionData;

% producers = [producers,createProducer(5e8,T,'NPV_cash',rigs1)];
% producers(2).wellsPerRigRate = wellsPerRigRate;
% producers(3).NPVaggrConserv = ones(T,1) * const;  % Conservative. NPV > positive value

% producers = [producers,createProducer(5e8,T,'NPV_cash',rigs1)];
% producers(3).wellsPerRigRate = wellsPerRigRate;





% producers = [producers,createProducer(1e8,T,'NPV_rig',rigs1)];
% producers(3).wellsPerRigRate = wellsPerRigRate;
% producers(3).NPVaggrConserv = ones(T,1) * (-const);  % Aggressive. NPV > negative value
% % 
% % producers = [producers,createProducer(1e8,T,'NPV_risk',rigs1)];
% % producers(5).wellsPerRigRate = wellsPerRigRate;
% % 
% producers = [producers,createProducer(1e8,T,'NPV_rig',rigs1)];
% producers(4).wellsPerRigRate = wellsPerRigRate;
% producers(4).NPVaggrConserv = ones(T,1) * const;  % Conservative. NPV > positive value



% f        = 'output.xlsx';
% sheet    = 'prodAim1';
% range    = 'C2:C105';
% rigs2 = loadRigs(f,sheet,range);
% % >>>> INPUT: 
% %rigs2 = loadRigs(5);
%producers(2).NPVaggrConserv = zeros(T,1); % Default, no need to change. 

% >>>> INPUT: 
%rigs3 = loadRigs(5);
%producers = [producers,createProducer(1e8,T,'rig',rigs1)];
%producers(3).NPVaggrConserv = ones(T,1) * 1e6;   % Conservative. NPV > possitive value



%% VALUES FOR ESTIMATING NET PRESENT VALUE

% ----->>> INPUT
%If you want change the values, un-comment the row and add a value: 

%           This (1) or (2) etc is the number of number of producer.
%           |
% producers(2).NPVestimatorInput.q0 = 644;                               %[bbl/day] Initial production rate.
% producers(2).NPVestimatorInput.drillCost = 5e6;                        %[USD] One-time drilling cost
% producers(2).NPVestimatorInput.comCost = 5e6;                          %[USD] One-time completion cost
% producers(2).NPVestimatorInput.drillTime = 1;
% producers(2).NPVestimatorInput.comTime = 1;
% producers(2).NPVestimatorInput.royaltiesAndTaxes = 0.30;               %[percentage]
% producers(2).NPVestimatorInput.operatingCost = 10;                     %[USD/bbl] Variable
% producers(2).NPVestimatorInput.fixedOperCost = 10000;                      %[USD/bbl] Fixed
% producers(2).NPVestimatorInput.discountRate = .10;                     %[percentage] Discount rate
% 
% % Time horizon: [months] Number of months used when computing NPV.
% producers(2).NPVestimatorInput.timeHorizon = 240;
% producers(2).NPVestimatorInput.D = .237;               % Decline curve parameter 1 (initial decline rate)
% producers(2).NPVestimatorInput.b = .927;               % Decline curve parameter 2 (curvature of line)


%% VALUES USED WHEN CONSTRUCTING WELLS
% >>> INPUT: 
% If you want change the values, un-comment the row and add a value: 


% producers(2).investInput.drillCost = 5e6;                        %[USD] One-time drilling cost
% producers(2).investInput.comCost = 5e6;                          %[USD] One-time completion cost
% producers(2).investInput.drillTime = 1;
% producers(2).investInput.comTime = 1;
% producers(2).investInput.royaltiesAndTaxes = 0.30;               %[percentage]
% producers(2).investInput.operatingCost = 10;                     %[USD/bbl] Variable
% producers(2).investInput.fixedOperCost = 10000;                      %[USD/bbl] Fixed
% producers(2).investInput.discountRate = .10;                     %[percentage] Discount rate
% 
% These are set above, please change them only at one place. 
producers(1).investInput.D = 0.488;     % Decline curve parameter 1 (initial decline rate)
producers(1).investInput.b = 1.1;     % Decline curve parameter 2 (curvature of line)
producers(1).investInput.q0 = 520;  %[bbl/day] Initial production rate.

% producers(2).investInput.D = 0.488;      % Decline curve parameter 1 (initial decline rate)
% producers(2).investInput.b = 1.1;     % Decline curve parameter 2 (curvature of line)
% producers(2).investInput.q0 = 520;  %[bbl/day] Initial production rate.

% producers(3).investInput.D = 0.488;     % Decline curve parameter 1 (initial decline rate)
% producers(3).investInput.b = 1.1;     % Decline curve parameter 2 (curvature of line)
% producers(3).investInput.q0 = 520;  %[bbl/day] Initial production rate.

% producers(3).investInput.D = set_D;     % Decline curve parameter 1 (initial decline rate)
% producers(3).investInput.b = set_b;     % Decline curve parameter 2 (curvature of line)
% producers(3).investInput.q0 = set_q01;  %[bbl/day] Initial production rate.
% 
% producers(4).investInput.D = set_D;     % Decline curve parameter 1 (initial decline rate)
% producers(4).investInput.b = set_b;     % Decline curve parameter 2 (curvature of line)
% producers(4).investInput.q0 = set_q01;  %[bbl/day] Initial production rate.
% 
% producers(6).investInput.D = set_D;     % Decline curve parameter 1 (initial decline rate)
% producers(6).investInput.b = set_b;     % Decline curve parameter 2 (curvature of line)
% producers(6).investInput.q0 = set_q01;  %[bbl/day] Initial production rate.

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
