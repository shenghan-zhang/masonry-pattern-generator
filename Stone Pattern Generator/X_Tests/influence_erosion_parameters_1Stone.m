    %% Erosion parameters influence study script
% This script allows the user to study the influence of erosion parameters
% on stones. A simple polygon is defined and eroded with parameters, and
% then visualisation of the results is given with related durability.
clear;
close all;
clc;
addpath(genpath('..'));

n_pixels = 400;

%% Drawing parameters
resolution=15;
Lx_wall=0.4;
Ly_wall=0.4;
colors=[0.5,0.5,0.5;0,0,0];

%% Polygon definition 
polyong=[0.1,0.05;...
    0.3,0.05;...
    0.35,0.2;...
    0.1,0.3;...
    0.05,0.15];

%% Erosion parameters
reordering_method='angular'; % 'angular' or 'nearest_neighbor'
contact_points=[];
pe=3; %3
dl=0.01;
mean_durability=0.1;
r=0.02;
corr.n_random_field=50;
corr.name = 'gauss';
corr.c0 = 0.05;
corr.sigma = 0.0; %0.25;
seuil_area=0.5;
aa=0.1;
bb=0.25;
seuil_contact=0.45;

%% Resampling parameters
min_edges=5;
l_edges=0.04;
span=0;

%% Plotting stuff
polyong3d=[polyong,mean_durability*2*ones(size(polyong,1),1)];
polyong3d=[polyong3d;polyong3d(1,:)];

%% Erosion change it to step by step erosion
% nn = 10;
% dl = 1/nn;
[eroded_polygon(:,1),eroded_polygon(:,2),dur]=erode_polygon(polyong(:,1),polyong(:,2),dl,n_pixels,mean_durability,pe,r,corr,seuil_area,contact_points,aa,bb,seuil_contact,reordering_method);

% for i = 1:nn    
%     if i==1
%         [eroded_polygon(:,1),eroded_polygon(:,2),dur]=erode_polygon(polyong(:,1),polyong(:,2),dl,n_pixels,mean_durability,pe,r,corr,seuil_area,contact_points,aa,bb,seuil_contact,reordering_method);
%     else
%         [eroded_polygon(:,1),eroded_polygon(:,2),dur]=erode_polygon(eroded_polygon(:,1),eroded_polygon(:,2),dl,n_pixels,mean_durability,pe,r,corr,seuil_area,contact_points,aa,bb,seuil_contact,reordering_method);    
%     end
%     fill(eroded_polygon(:,1),eroded_polygon(:,2),[0.8 0.8 0.8])
% end
%% Drawing outputs suff
xx=linspace(0,max(polyong(:,1))+2*r,size(dur,2));
yy=linspace(0,max(polyong(:,2))+2*r,size(dur,1));
[X,Y]=meshgrid(xx,yy);
resampled_poly=resample_polygons({eroded_polygon},min_edges,l_edges,span);
resampled_poly=resampled_poly{1};
if (corr.sigma~=0)
figure
surf(X,Y,dur,'FaceAlpha',0.9,'LineStyle','none');
set(gca, 'XTick',[0:0.1:0.4])
view(33,46);
hold on;
plot3(polyong3d(:,1),polyong3d(:,2),polyong3d(:,3),'r','LineWidth',3);
fill(polyong3d(:,1),polyong3d(:,2),'r');
plot3(eroded_polygon(:,1),eroded_polygon(:,2),mean_durability*2*ones(size(eroded_polygon,1),1),'b','LineWidth',3);
plot3(resampled_poly(:,1),resampled_poly(:,2),mean_durability*2*ones(size(resampled_poly,1),1),'g','LineWidth',3);
set(gca,'fontsize',14)
xh  = xlabel('x','Rotation',-20);
pos = get(xh, 'Position');
set(xh, 'Position',pos.*[0.7,1,1])
yh =ylabel('y','Rotation',40);
pos = get(yh, 'Position');
set(yh, 'Position',pos.*[1,1.5,1])
zlabel('Durability')
% xticks([0 0.1 0.2 0.3 0.4])
figure 
hold on 
[C,h] = contour(X,Y,dur);
plot3(polyong3d(:,1),polyong3d(:,2),polyong3d(:,3),'r','LineWidth',3);
plot3(eroded_polygon(:,1),eroded_polygon(:,2),mean_durability*2*ones(size(eroded_polygon,1),1),'b','LineWidth',3);
plot3(resampled_poly(:,1),resampled_poly(:,2),mean_durability*2*ones(size(resampled_poly,1),1),'g','LineWidth',3);
set(gca,'fontsize',14)
c = colorbar;
c.Label.String = 'Durability';
xlabel('x');
ylabel('y');
clabel(C,'manual');
box on
else 
figure 
hold on
plot(polyong3d(:,1),polyong3d(:,2),'r','LineWidth',3);
plot(eroded_polygon(:,1),eroded_polygon(:,2),'b','LineWidth',3);
plot(resampled_poly(:,1),resampled_poly(:,2),'g','LineWidth',3);
lgd = legend('contour','after erosion','after resampling'); 
pos = lgd.Position;
lgd.Position = [pos(1)*0.96, pos(2)*1.024, pos(3), pos(4)]; 
set(gca,'fontsize',14)
box on 
legend boxon
xlabel('x');
ylabel('y');
end 
% draw_stones({eroded_polygon,polyong},resolution,Lx_wall,Ly_wall,colors,'Test');
% 
% set(gcf,'NextPlot','add');
% axes;
% h = title(['Sigma = ', num2str(corr.sigma),',   L_{c0} = ', num2str(corr.c0)]);
% set(gca,'Visible','off');
% set(h,'Visible','on');
