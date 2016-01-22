function [q0,bin,r] = parameter_q0(data)
% Output: Parameter b for decline curve. 
% INPUT: 
% Columns:(Endpoint of bin) (freq)  (probability)  (Cumulative Distribution)
% rows:     bin 1
%           bin 2
%           bin 3
%           ... 
r = rand();
if(r<1e-3)
    r = 1e-3;
end
bin = find(r<data(:,2),1);
if(isempty(bin))
    bin = length(data(:,2));
end

if(bin==1)
    q0 = (data(bin,1))/2;
else
    q0 = (data(bin,1)-data((bin-1),1))/2 + data((bin-1),1);
end

end

