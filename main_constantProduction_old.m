%------------------------------------------------------------------------
% Static model trying to establish the oil production at a constant level. 
%------------------------------------------------------------------------
clc; close all; clear all;
fprintf('Static model trying to establish the oil production at a constant level.');
fprintf('Loading Settings...');

global T drillTime compTime numProd economicDynamics cutOffProd days 
global time initProd_ajustment producers b_preSet D_preSet 
global anticipated_q0 totalProduction
global NPVinput investInput 
NPVinput = constructInputs();
investInput = constructInputs();


global prodAim prodTol anticipatedProdAdd 

T = 100;
economicDynamics = false;
prodAim = 1e5;
prodTol = 1e4;
anticipatedProdAdd = zeros(T,1);


totalProduction = zeros(T,1);

drillTime = 1;
% [months]. The number of months it takes to drill the well.
compTime = 1; 
% [months]. The number of months it takes to complete the
% well after the drilling.

b_preSet = [];
D_preSet = [];
anticipated_q0 = 644; 
cutOffProd = 10;


time = 1:T;
days = 30.41; % Average number of days in a month.
initProd_ajustment = ones(T,1);

numProd =1;
producers = [createProducer(0,T,6)];

fprintf('\nSettings completed. \n');



%% SIMULATION
fprintf('Starting the simulation... \n');

res_timeItter = timeItter();

fprintf('Simulation completed.\n');

%% PLOTTING
fprintf('\nPlotting data... \n');


% Plotting number of active wells and new wells
fprintf('\nPlotting number of active wells and new wells: \n');
plotNumWells(); 

% Plot Production
fprintf('Plotting Production...')
plotProduction()


fprintf('Done plotting. \n');

fprintf('\nProgram ended.\n');
