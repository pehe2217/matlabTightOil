function netRev = computeNetRev(well,price,t)
% Output: 
% Net revenue of the well from the given month at the given oil price. 
% 
% Note: 
% The unit of q is [avg bbl/day], and the revenue is over the whole month. 

global days
% Revenue from production:
grossRev = well.q(t)*days * price;
% Royalties and taxes
royNtax = grossRev * well.royaltiesAndTaxes;
% Operating costs
opCosts = well.q(t)*days * well.operatingCost + well.fixedOperCost;
% Net revenue
netRev = grossRev - royNtax - opCosts;
end

