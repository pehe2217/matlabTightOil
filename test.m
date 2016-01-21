clc; clear all; close all;

p = 50:100;
for i = 1:length(p)
npv(i) = NPVestimator(p(i),[],[],[],[],[],[],[],[],[],[]);
end

plot(p,npv)