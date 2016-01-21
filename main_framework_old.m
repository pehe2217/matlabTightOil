function main_framework(plotFigures,printProgress)
% NOT USED ANYMORE!!!

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

end
