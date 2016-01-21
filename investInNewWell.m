function producer = investInNewWell(producer,t)
% Function: Invest in a new well.
global T distribution_q0

producer.numWells(t) = producer.numWells(t)+1; % Number of total wells.
producer.newWells(t) = producer.newWells(t)+1; % Num new wells this month.
well = createWell(producer.investInput,T);

%[avg bbl/day] Initial production rate.
if(isempty(well.q0))
    y = 1+ floor(t/12);
    if(y>5)
        y = 5;
    end
    well.q0 = parameter_q0(distribution_q0{y});
end


% Put the newly created well into the producer's portfolio:
producer.wells = [producer.wells, well];

% Debit the drilling cost:
producer.capital(t) = producer.capital(t) - producer.wells(end).drillCost;
end

