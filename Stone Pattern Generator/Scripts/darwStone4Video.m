function darwStone4Video(fig,stones_pos,hold_on,Lx_wall,Ly_wall)
figure(fig)

if (hold_on)
    hold on
else
    hold off
end
grey_nb = 0.7;
for i=1:length(stones_pos)
    poly=stones_pos{i};
    fill(poly(:,1),poly(:,2),[grey_nb grey_nb grey_nb],'LineWidth',1,'FaceAlpha',0.5)
    hold on
end
axis([0 Lx_wall 0 Ly_wall])
axis equal
end