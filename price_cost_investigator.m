clear all; close all; clc;

%% Numbers taken from Excel model made by
% John Kemp, Senior Market Analyst, Reuters
% Twitter: @JKempEnergy
% Phone: +44 7789 483 325
%
drillCost = 5e6; % Drilling cost
comCost = 5e6; % Completion cost
q0 = 644; % Initial production rate
D = .237; % Decline curve parameter 1 (initial decline rate)
b = .927; % Decline curve parameter 2 (curvature of line)
RoyaltiesAndTaxes = 0.30; % Royalties and taxes
operatingCost = 10; % Operating costs
fixedOperCost = 0;
discountRate = .10; % Discount rate
oilPrice = 50; % Oil price (wellhead)
days = 30.41; % Average number of days per month.
%%
cc = drillCost + comCost; % Sum of the initial capital/investment costs. 

T = 240; % Number of months used when estimating NPV. 
dailyProd = zeros(T,1); % [bbl/day] NOTE: Production per _DAY_. 

% b = distributionOfParameter_b();
% D = distributionOfParameter_D();
%q0 = initProductDist();
%b = 1.08;                  % Number taken from Linnea Lund et al. 
%D = .309;                  % Number taken from Linnea Lund et al. 
%ii = .1; % quoted annual discount rate
%n = 12; % Number of compounding periods
%r = (1 + ii/n)^n -1; % effective annual interest rate


dailyProd(3) = q0; % Probably not needed to assign this value here... 

marginal = zeros(length(fixedOperCost),length(operatingCost),T);

time = 1:T;
NPV = zeros(length(fixedOperCost),length(operatingCost));



for i = 1:length(fixedOperCost)
    for j = 1:length(operatingCost)
        discountNetRev = zeros(1,T);
        for t = 3:T
            dailyProd(t) = q0 ...
            / (1 + (D*b *(t-2) ))^(1/b);
            % Gross revenue
            grossRev = dailyProd(t) * days * oilPrice;
            % Royalties and taxes
            royNtax = grossRev * RoyaltiesAndTaxes;
            % Operating costs
            opCosts = dailyProd(t) * days * operatingCost + fixedOperCost;
            % Net revenue
            netRev = grossRev - royNtax - opCosts;
            % Discounted net revenue
            discountNetRev(t) = netRev / ((1 + discountRate)^(t/12));
        end
        NPV(i,j) = sum(discountNetRev) -cc;
    end
end

% figure
% surf(cv/p,cf,NPV)
%
% o = zeros(size(NPV));
% hold on
% surf(cv/p,cf,o)
% xlabel('Variable Cost [Procentage of oil price]')
% ylabel('Fixed cost [USD/month]')
%
% str = sprintf('NPV when oilprice = %.0f USD/barrel, ',p);
% title(str)
%
% [rows,cols,vals] = find(abs(NPV)<1000);
