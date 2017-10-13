function  plot_gecco_2016( X, figname, prop, pareto_locs, old_prop )

close all;
plot(X(~pareto_locs,1),X(~pareto_locs,2),'k.','MarkerSize', 10);
hold on
plot(X(pareto_locs,1),X(pareto_locs,2),'r.','MarkerSize', 10);
plot([0, median(prop)],[0.05, 0.05], 'b-','LineWidth',5);
plot(prctile(prop,75),0.05, 'k*','MarkerSize',10);
plot(prctile(prop,25),0.05, 'k*','MarkerSize',10);

plot([0, median(old_prop)],[0.025, 0.025], 'g-','LineWidth',5);
plot(prctile(old_prop,75),0.025, 'k*','MarkerSize',10);
plot(prctile(old_prop,25),0.025, 'k*','MarkerSize',10);
axis([0 1 0 1]);
axis square;
set(gca,'YTickLabel',[]);

set(gca,'XTickLabel',[]);
exportfig(gcf, strcat(figname,'.eps'), 'FontMode', 'fixed', 'FontSize', 10, 'color', 'cmyk' );

end

