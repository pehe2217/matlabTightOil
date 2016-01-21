function npv = wellProspector(oilPrice,t,T)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Values for estimating NPV:
initProd = 644;             % [bb/day]
drillCost = 5e6;            % [USD]
comCost = 5e6;              % [USD]
RoyaltiesAndTaxes = 0.30;   % [Percentage]
operatingCost = 10;         % [USD/bbl]
fixedOperCost = 500;        % [USD/bbl]
%discountRate = producers(prod).ROC;    % Discount rate equals
                                        % the Return of investment
discountRate = 0.10;        % Percentage
numMonths = 120;            % [months] The time horizon.
D = 0.237;                  % Decline curve parameter 1
b = 0.927;                  % Decline curve parameter 2

% NPV estimator:
%   11 number of input parameters.
%   If you want to use default value, use [].
npv = NPVestimator(oilPrice(t),[],drillCost,comCost,...
    RoyaltiesAndTaxes,operatingCost,fixedOperCost,discountRate,T,D,b);




end

