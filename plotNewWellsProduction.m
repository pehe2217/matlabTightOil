function plotNewWellsProduction()
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
global producers T tMonths

time = 1:T;
colour = {'b','g','r','c','m','y','k',};

for pr = 1:length(producers)
    fig = figure();
    production = zeros(T,1);
    totNewWells = zeros(T,1);
    hold on;
    col = colour{pr};
    
    for w = 1:(length(producers(pr).wells))
        production = production + producers(pr).wells(w).q;
    end
    
    totNewWells = totNewWells + producers(pr).newWells;
    figure(fig)
    [AX,H1,H2] = plotyy(time,totNewWells,time,production);
    figure(fig)
    xlabel('time [months]')
    set(gca,'XTickLabel',tMonths)
    axes(AX(1)); ylabel('New wells [freq]'); %axis([0 T 0 max(totNewWells)*1.1]);
    axes(AX(2)); ylabel('Production [ avg bbl/day]'); %axis([0 T 0 max(totCap)*1.1]);
    
    set(get(AX(2),'Ylabel'),'fontSize',16)
    set(get(AX(1),'Ylabel'),'fontSize',16)
    set(get(AX(1),'Xlabel'),'fontSize',16)
    lineobj = findobj('type', 'line');
    set(lineobj, 'linewidth', 1.5)
    axes(AX(1)); axis([0 T 0 max(totNewWells)*1.1])
    axes(AX(2)); axis([0 T (min(production)-abs(min(production)*.1)) max(production)*1.1])
    %set(gca,'XTickLabel',tMonths)
    
    
    
end

end

