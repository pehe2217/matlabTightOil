function producer = investInNewWell(producer,t)
% Function: Invest in a new well.
global T distribution_q0

producer.numWells(t) = producer.numWells(t)+1; % Number of total wells.
producer.newWells(t) = producer.newWells(t)+1; % Num new wells this month.
well = createWell(producer.investInput,T,t);

%[avg bbl/day] Initial production rate.
if(isempty(well.q0))
    y = 1+ floor(t/12); % Decides which distribution to use. 
    if(y>5)             % In 'distribution_q0' there are distributions 
        y = 5;          % for 5 different years: 2010-2014. 
    end
    well.q0 = parameter_q0(distribution_q0{y});
end


% Put the newly created well into the producer's portfolio:
producer.wells = [producer.wells, well];

% Debit the drilling cost:
producer.capital(t) = producer.capital(t) - producer.wells(end).drillCost;
end

