clc; clear all; close all;
% Test program. I wanted to see if I can have the same results as 
% John Kemp, Reuters, in his Excel model. 

% I have renamed some of the fields in the Excel sheet because the variable
% names otherwise would be very long. 
filename = 'SIMPLE OIL WELL CALCULATOR (version 2).xlsx';
sheet = 'Data';
range = 'B5:D13';
[data, header] = xlsread(filename,sheet,range);


for i = 1:length(data)
    v = genvarname([header{i,1}]);
    eval([v '= data(i, 1);']);
end

T = 240;
capCost = zeros(T,1);
dailyProd = zeros(T,1);
grossRev = zeros(T,1);
royNtax = zeros(T,1);
opCosts = zeros(T,1);
netRev = zeros(T,1);
discountNetRev = zeros(T,1);
NPV = [];

for t = 1:T
    % Capital Cost
    if(t==1)
        capCost(t) = DrillingCost;
    elseif(t==2)
        capCost(t) = CompletionCost;
    end
    % Daily Production (bbl)
    if(t>2)
        dailyProd(t) = InitialProductionRate ...
            / (1 + (D*b *(t-2) ))^(1/b);
    end
    % Gross revenue
    grossRev(t) = dailyProd(t) * 30.41 * OilPrice;
    % Royalties and taxes
    royNtax(t) = grossRev(t) * RoyaltiesAndTaxes/100;
    % Operating costs
    opCosts(t) = dailyProd(t) * 30.41 * OperatingCosts;
    % Net revenue
    netRev(t) = grossRev(t) - royNtax(t) - opCosts(t); 
    % Discounted net revenue
    discountNetRev(t) = netRev(t) / ((1 + DiscountRate/100)^(t/12));
    if(t == 60 || t == 120 || t==240)
        NPV = [NPV, sum(discountNetRev)-sum(capCost) ];
    end
    
end

NPV


