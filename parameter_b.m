function [b,bin,r] = parameter_b(data)
% Output: Parameter b for decline curve. 
% Input: 
% (Endpoint of bin) (freq)  (probability)  (Cumulative Distribution)
% bin 1
% bin 2
% bin 3
% ... 
r = rand();
if(r<1e-4)
    r = 1e-4;
end
bin = find(r<data(:,4),1);
if(bin==1)
    b = (data(bin,1))/2;
else
    b = (data(bin,1)-data((bin-1),1))/2 + data((bin-1),1);
end

end

