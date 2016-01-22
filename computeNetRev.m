function netRev = computeNetRev(well,price,t)
% Output: 
% Net revenue of the well from the given month at the given oil price. 
% 
global days

% Note: 
% The unit of q is [avg bbl/day], and when multiplying with 'days'
% the revenue is over the whole month.
grossRev = well.q(t)*days * price;
% Royalties and taxes
royNtax = grossRev * well.royaltiesAndTaxes;
% Operating costs
opCosts = well.q(t)*days * well.operatingCost + well.fixedOperCost;
% Net revenue
netRev = grossRev - royNtax - opCosts;
end

