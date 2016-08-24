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

%______  [bbl/day] Initial production rate. ________________________

%q0 = 644; % Used by John Kemp.  


% These come originaly from Henrik Wachtmeister + Linnea Lund et al. 
% Means and medians are calculated from in excel file 'q0_modified.xlxsl':

q0 = [380 492 513 512 539]; % Mean for year 2010 - 2014
%q0 = 487;   % Mean of mean q0 from 2010-2014, 
%q0 = 514;   % Mean of mean q0 from 2011-2014, 
%q0 = 456;   % Median of 2010-2014,
%q0 = 462;   % Median of 2011-2014,
% _________________________________________________________________

drillCost = 4e6;                        %[USD] One-time drilling cost
comCost =   4e6;                          %[USD] One-time completion cost
drillTime = 1;
comTime = 1;
royaltiesAndTaxes = 0.20;               %[percentage]
operatingCost = 10;                     %[USD/bbl] Variable
fixedOperCost = 0;                      %[USD/bbl] Fixed
discountRate = .10;                     %[percentage] Discount rate

% Decommission cost is NOT used by John Kemp. 
decomCost = 5e4;                        %[USD] One-time decommission cost

%[months]: Number of months used when computing NPV.
timeHorizon = 240;

% Used by John Kemp. 
%b = .927;               % Decline curve parameter 2 (curvature of line)
%D = .237;               % Decline curve parameter 1 (initial decline rate)

% Values used by Lennea Lund et al (2014)
%b = 1.08;
%D = .309;

% Based on the histgrams
b = 1;
D = .35;


distribution_q0= [];
distribution_b = [];
distribution_D = [];



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
    'decomCost',decomCost,...
    'distribution_q0', distribution_q0,...
    'distribution_b',  distribution_b,...
    'distribution_D',  distribution_D);
end

