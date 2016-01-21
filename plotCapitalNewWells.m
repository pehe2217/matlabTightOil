function plotCapitalNewWells()
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
global producers T

totNewWells = zeros(T,1);
time = 1:T;
colour = {'b','g','r','c','m','y','k',};
for pr = 1:length(producers)
    col = colour{pr};
    
    cap = producers(pr).capital;
    totNewWells = totNewWells + producers(pr).newWells;
    fig = figure();
    %[AX,H1,H2] = plotyy(time,totNewWells,col,time,totCap,col);
    [AX,H1,H2] = plotyy(time,totNewWells,time,cap);
    xlabel('month')
    axes(AX(1)); ylabel('New wells [freq]'); %axis([0 T 0 max(totNewWells)*1.1]);
    axes(AX(2)); ylabel('Capital [USD]'); %axis([0 T 0 max(totCap)*1.1]);
    
    set(get(AX(2),'Ylabel'),'fontSize',16)
    set(get(AX(1),'Ylabel'),'fontSize',16)
    set(get(AX(1),'Xlabel'),'fontSize',16)
    lineobj = findobj('type', 'line');
    set(lineobj, 'linewidth', 1.5)
    axes(AX(1)); axis([0 T 0 max(totNewWells)*1.1])
    axes(AX(2)); axis([0 T (min(cap)-abs(min(cap)*.1)) max(cap)*1.1])
    str = sprintf('Producer %0.0f',pr);
    title(str);
end

end

