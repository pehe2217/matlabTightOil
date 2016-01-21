%------------------------------------------------------------------------
%|||||||||||||||||     MAIN FRAMEWORK    ||||||||||||||||||||||||||||||||
%------------------------------------------------------------------------
clc; close all; clear all;
fprintf('Loading Settings...');

f = loadData();
load(f)

fprintf('\nSettings completed. \n');



%% SIMULATION
fprintf('Starting the simulation... \n');

%printProgress = true;
printProgress = false;
res_timeItter = timeItter(printProgress);

fprintf('Simulation completed.\n');

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
    
    fprintf('Done plotting. \n');
    %%
end

fprintf('\nProgram ended.\n');
