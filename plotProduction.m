function plotProduction()
% Total production
global T producers

fig = figure();
hold on;
production = zeros(T,1);
time = 1:T;

colour = {'b','g','r','c','m','y','k',};
for pr = 1:length(producers)
    for w = 1:(length(producers(pr).wells))
        production = production + producers(pr).wells(w).q;
    end
    col = colour{pr};
    plot(time,production/1000,col)
end

figure(fig)
%str = sprintf(' production of a region with %0.0f different producers',length(producers));
%title(str);
xlabel('Month')
ylabel('Production [ avg k-bbl/day]');
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',16,...
    'fontWeight','bold')
set(gca,'FontSize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
lineobj = findobj('type', 'line');
set(lineobj, 'linewidth', 1.5)

end

