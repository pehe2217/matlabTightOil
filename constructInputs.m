function inputs = constructInputs()
% To make it easier to pass on function variables into the function of
% NPV-estimation and creation of wells, we here make a struct which is
% sent instead. 
% OUTPUT: A struct containing all the input variables for NPV estimation 
% and for creation of well. 
global T

%% Default values 
% Values used in Excel model made by
% John Kemp, Senior Market Analyst, Reuters
% Twitter: @JKempEnergy
% Phone: +44 7789 483 325
% Check if variables exist or are unset:
q0 = 644;                               %[bbl/day] Initial production rate.
drillCost = 5e6;                        %[USD] One-time drilling cost
comCost = 4e6;                          %[USD] One-time completion cost
drillTime = 1;
comTime = 1;
royaltiesAndTaxes = 0.30;               %[percentage]
operatingCost = 10;                     %[USD/bbl] Variable
fixedOperCost = 0;                      %[USD/bbl] Fixed
discountRate = .10;                     %[percentage] Discount rate

% Decommission cost is not used by John Kemp. 
decomCost = 3e6;                        %[USD] One-time decommission cost

%[months]: Number of months used when computing NPV.
timeHorizon = 240;
D = .237;               % Decline curve parameter 1 (initial decline rate)
b = .927;               % Decline curve parameter 2 (curvature of line)

% Values used by Lennea Lund et al (2014)
%b = 1.08;
%D = .309;
decommissioned = T; %[month] Defining which month the well is decommissioned.
%%


% OUTPUT: The struct
inputs = struct(...
    'q0',q0,...
    'drillCost',drillCost,...
    'comCost',comCost,...
    'drillTime',drillTime,...
    'comTime',comTime,...
    'royaltiesAndTaxes',royaltiesAndTaxes,...
    'operatingCost',operatingCost,...
    'fixedOperCost',fixedOperCost,...
    'discountRate',discountRate,...
    'timeHorizon',timeHorizon,...
    'D',D,...
    'b',b,...
    'decommissioned',decommissioned,...
    'decomCost',decomCost);
end

