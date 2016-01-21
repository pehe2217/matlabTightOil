function NPV = NPVestimator(p,NPVestimatorInput)
% NPV estimator: Outputs an estimate of the Net Present Value of a well.
% INPUT: A struct containing all the parameters for this
% function. 
global days

cc = NPVestimatorInput.drillCost + NPVestimatorInput.comCost;   
% Capital costs = drilling cost + completion cost

dailyProd = zeros(NPVestimatorInput.timeHorizon,1);     % NOTE: Production in barrels pers _DAY_. 
discountNetRev = zeros(1,NPVestimatorInput.timeHorizon);

% Loop through time. There is no production in month 1 and 2.
for i = 3:(NPVestimatorInput.timeHorizon)
    % [bbl/day]:
    dailyProd(i) = NPVestimatorInput.q0 / ...
        (1 + (NPVestimatorInput.D*NPVestimatorInput.b *(i-2) ))...
        ^(1/NPVestimatorInput.b);
    % Gross revenue [USD]:
    grossRev = dailyProd(i) * days * p;
    % Royalties and taxes [USD]:
    royNtax = grossRev * NPVestimatorInput.royaltiesAndTaxes;
    % Operating costs [USD]:
    opCosts = dailyProd(i) * days * NPVestimatorInput.operatingCost + NPVestimatorInput.fixedOperCost;
    % Net revenue [USD]:
    netRev = grossRev - royNtax - opCosts;
    % Deduce the decommission cost [USD]:
    if(i == NPVestimatorInput.timeHorizon)
        netRev = netRev - NPVestimatorInput.decomCost;
    end
    % Discounted net revenue [USD]:
    discountNetRev(i) = netRev / ((1 + NPVestimatorInput.discountRate)^(i/12));
end
% NPV = sum of all discounted cashflows:
NPV = sum(discountNetRev) -cc;

end

