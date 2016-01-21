function initialProduction = initProductDist()
% INITPRODUCTDIST Summary of this function goes here
% Pick a random number from the given distribution function of 
% initial production.

mu = 644;   % [bbl/day] Mean value
sigma = 50; %           Standard diviation
initialProduction = normrnd(mu,sigma); % Normal distribution. 
end

