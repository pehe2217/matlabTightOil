function res = timeItter(printProgress)
% +-----------------------------------
% | TIME ITTERATION: Stepping through time.
% | exe_x ---> timeItter ---> producerStrategy
% |
% | for each timestep:
% |     for each producer:
% |         for each well:
if nargin < 1
    printProgress = false;
end
global T economicDynamics days
global producers prod
global oilPrice

res = 0;

fprintf('\nLooping through time:\n');
for t = 1:T % Loop though time:
    if((mod(t,10) == 0) && printProgress)
        fprintf('\nTime step: %0.0f \n',t); % Print the time step
    end
    % (In each month t:) For each producer:
    for prod = 1:length(producers)
        
        if(t>1) % In each step in time, the capital and number of wells
            % need to be brought with.
            producers(prod).numWells(t) = producers(prod).numWells(t-1);
            producers(prod).capital(t) = producers(prod).capital(t-1);
        end
        
        % (For each time step:) For each well:
        for w = 1:(length(producers(prod).wells))
            % Increment the production time array:
            producers(prod).wells(w).prodTime = producers(prod).wells(w).prodTime +1;
            
            % COMPLETION MONTH:
            if(producers(prod).wells(w).prodTime<=0)
                
                % Deduct completion cost from the producer's capital:
                producers(prod).capital(t) = producers(prod).capital(t)...
                    - producers(prod).wells(w).comCost;
                
                
            % PRODUCING WELL;
            elseif(producers(prod).wells(w).prodTime>0 &&...
                    producers(prod).wells(w).decommissioned==T)
                
                % Compute average daily production in month t:
                % q: [average bbl/day]
                producers(prod).wells(w).q(t) = ...
                    producers(prod).wells(w).q0 * ...
                    (1 + producers(prod).wells(w).D...
                    *producers(prod).wells(w).b...
                    *producers(prod).wells(w).prodTime)...
                    .^((-1)/producers(prod).wells(w).b);
                
                % Add the production to the total production this month:
                % average [bbl/day] each month
                producers(prod).totalProd(t) = ...
                    producers(prod).totalProd(t) + producers(prod).wells(w).q(t);
                
                % Function: Compute net revenue:
                netRev = computeNetRev(producers(prod).wells(w),oilPrice(t),t);
                
                producers(prod).capital(t) = producers(prod).capital(t)+netRev;
                
                if(economicDynamics)
                    if(netRev<0)    % Decommission the well:
                        producers(prod).wells(w).decommissioned = t;
                        producers(prod).numWells(t) = producers(prod).numWells(t) -1;
                        
                        % Deduce decommission cost:
                        producers(prod).capital = producers(prod).capital ...
                            - investInput.decomCost;
                        
                        if(printProgress)
                            fprintf('Producer  no %0.0f: well no  %3.3f has a negative net revenue.\n',prod,w);
                            fprintf('Decision: Decommission the well.\n');
                        end
                    end % END: if netRev < 0
                else 
                    if(producers(prod).wells(w).q(t)<producers(prod).cutOffProd)
                        % If no economic dynamics, a cut-off production is used.
                        producers(prod).wells(w).decommissioned = t;
                        producers(prod).numWells(t) = producers(prod).numWells(t) -1;
                        if(printProgress)
                            fprintf('Decision: Decommission the well.\n');
                            fprintf('Cause: The production of the well reached the cut off limit.\n');
                            fprintf('\tMonth: %0.0f \n',t);
                            fprintf('\tProducer: %0.0f \n',prod);
                            fprintf('\tWell: %0.0f \n',w);
                        end
                    end
                end % IF economicDynamics
            end
        end % Looping through the wells of each producer.
        
        
        % PRODUCER STRATEGY:
        % DRILL WELLS ACCORDING TO THE PRODUCER'S STRATEGY.
        producers(prod)= producerStrategy(printProgress,producers(prod),t);
        
        
    end % END: Looping through producers.
end % END: Looping through time.
fprintf('\nLooping through time completed\n');

res = 1; % Returns 1 if the simulation ended in a natural way.
end

