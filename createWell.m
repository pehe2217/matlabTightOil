function well = createWell(input,T)
% Creates a well:
% Output: A struct (Matlab object) 
% containing all the attributes of the well. 
% 
% INPUT: q0,drillTime,compTime,royaltiesAndTaxes,
% operatingCost,fixedOperCost,discountRate,b,D,T
global distribution_b distribution_D distribution_q0

q = zeros(T,1);             % [bbl]     Time serie of production.

% [months] Counter of the how many months the well is in production:
prodTime = -input.drillTime -input.comTime;

if(isempty(input.drillCost)); input.drillCost = 5e6;end%[USD] One-time drilling cost
if(isempty(input.comCost));   input.comCost = 5e6;  end%[USD] One-time completion cost
if(isempty(input.royaltiesAndTaxes));  input.royaltiesAndTaxes = 0.30; end%[percentage]
if(isempty(input.operatingCost));   input.operatingCost = 10; end%[USD/bbl] Variable
if(isempty(input.fixedOperCost));   input.fixedOperCost = 500;end%[USD/bbl] Fixed
if(isempty(input.discountRate));    input.discountRate = .10; end%[percentage] Discount rate

%[month] The month when the well is taken out of service. 
if(isempty(input.decommissioned)); input.decommissioned = T; end 


% Decline curve parameter 1 (initial decline rate)
if(isempty(input.D))
    input.D = parameter_D(distribution_D); 
end 

% Decline curve parameter 2 (curvature of line)
if(isempty(input.b))
    input.b = parameter_b(distribution_b);
end 
                    
% if(length(input.initProd_ajustment)==1)
%     input.q0 = input.q0 * input.initProd_ajustment;
% elseif(length(input.initProd_ajustment)==T && exist('t','var'))
%     input.q0 = input.q0 * input.initProd_ajustment(t);
% elseif(exist('input.initProd_ajustment','var'))
%     adj = mean(input.initProd_ajustment);
%     input.q0 = input.q0 * adj;
% end                   

well = struct('q0',input.q0,...
    'q',q,...
    'b',input.b,...
    'D',input.D,...
    'prodTime',prodTime,...
    'drillCost',input.drillCost,...
    'comCost',input.comCost,...
    'royaltiesAndTaxes',input.royaltiesAndTaxes,...
    'operatingCost',input.operatingCost,...
    'fixedOperCost',input.fixedOperCost,...
    'decommissioned',input.decommissioned);
end

