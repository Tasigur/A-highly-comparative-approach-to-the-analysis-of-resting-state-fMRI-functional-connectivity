a=rand(1000,500);
figure;
imagesc(a);
set(gcf,'Color',[1 1 1]);
set(gcf,'Position',[309         904        1782         420]);
imagesc(var_exp_all);
set(gca,'CLim',[0 1]);
set(gca,'Position',[0.0851    0.1822    0.8860    0.7428]);
cbh=colorbar;
xlabel('feature');
xlh = ylabel('xFC method');
xlh.Position(1) = xlh.Position(1) - 2;
for imeas=1:length(measvect)
    text(-2,y_meas_pos(imeas),measvect{imeas},'Interpreter','none','HorizontalAlignment','center','VerticalAlignment','middle','Color',color_mat(imeas,:),'Rotation',90);
end
pos_vect=get(cbh,'Position');
% th2=annotation('textbox',[pos_vect(1)+pos_vect(3)-0.012 pos_vect(2)+0.5*pos_vect(4) 0.012 0.046],'String','ve','LineStyle','none','VerticalAlignment','middle'); % need to be moved a bit to the right
% th2=annotation('textbox',[pos_vect(1)+pos_vect(3)-0.0 pos_vect(2)+0.5*pos_vect(4) 0.012 0.046],'String','ve','FontSize',20,'LineStyle','none','VerticalAlignment','middle'); % too small font
% th2=annotation('textbox',[pos_vect(1)+pos_vect(3)-0.0 pos_vect(2)+0.5*pos_vect(4) 0.012 0.046],'String','ve','FontSize',24,'LineStyle','none','VerticalAlignment','middle');
th2=annotation('textbox',[pos_vect(1)+pos_vect(3)+0.01 pos_vect(2)+0.46*pos_vect(4) 0.012 0.046],'String','ve','FontSize',24,'LineStyle','none','VerticalAlignment','middle');
figure_name=['random_fig'];
export_fig(gcf,[figure_name '.png']);