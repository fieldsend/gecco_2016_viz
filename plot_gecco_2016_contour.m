function plot_gecco_2016_contour()

x = linspace(0,1,100);
y = linspace(0,1,100);
Z = zeros(100,100);
ZO = zeros(100,100,8);
for i=1:100
    for j=1:100
        ZO(i,j,:) = dist_example_5([x(i),y(j)],8);
    end 
end
for i=1:8
    figure;
    Z(:,:) = ZO(:,:,i);
    [cv,ch]=contourf(Z',100);
    set(ch,'edgecolor','none');
    axis square;
    shading flat
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
    colormap('bone');
    exportfig(gcf, strcat('gecco_2016_contour',int2str(i),'.eps'), 'FontMode', 'fixed', 'FontSize', 10, 'color', 'cmyk' );
end