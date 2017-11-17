%% Interlocking Convergence study script
% This script tests the convergence of the interlocking through shortest
% path computation. It constructs a regular wall with 6 points bricks :
%
%            x---------------x--------------x
%            |                              |
%            |                              |
%            |                              |
%            |                              |
%            x---------------x--------------x
%
% After that, a fractalization operation can multiply the number of points
% along the edges (first 6 if n=0, then 12 if n=1, then 24 if n=2, 48 if
% n=3, etc.)
% The user is then allowed to pick to points and the shortest path is then
% calculated between the two points. For alpha = 1, the theoretical
% interlocking is given by : (H+sqrt(0.25*(5*e^2+L^2-2*e*L)))/(H+e).
% For values of alpha different of 1, see i_opt.m


clear;
close all;
clc;
addpath(genpath('../../'));

n=3; % Number of fractalization operations (the number of edges of the brick grows as 6*2^n)
L=0.14;
H=0.06;
e=0.01;
epsilon=0.000000001;
alpha=0.3333333333331;
vlim=0.04;

k=1;
bricks=cell(1,9);
for i=1:3
    if mod(i,2)==1
        s=0.01;
    else
        s=0.01+L/2+e/2;
    end
    hb=(i-1)*(H+e)+.01;
    hh=hb+H;
    for j=1:3
        ls=s+(j-1)*(L+e);
        lm=ls+L/2;
        lf=ls+L;
        bricks{k}=[ls,hb;ls,hh;lm,hh;lf,hh;lf,hb;lm,hb];
        k=k+1;
    end
end
c=create_colors(length(bricks));
Lx=0.835;
Ly=0.36;
draw_stones(bricks,8,Lx,Ly,c);

bricks_fract=fractalize_polygons(bricks,n,0.00000);


disp('Computing Shortest path...');
[environment,ref_tab]=make_environnement(bricks_fract,Lx,Ly);
figure;
patch( environment{1}(:,1) , environment{1}(:,2),0.1*ones(size(environment{1},1),1) , ...
    'w','linewidth',1.5);
maxy=max(environment{1}(:,2)); % Determine max y  coordinate for displaying values
maxx=max(environment{1}(:,1)); % Determine max x coordinate for displaying forbidden rectangles
pv1=-0.05*maxy; % Coordinates of the display 1
pv2=-0.1*maxy; % Coordinates of the display 2
pv3=-0.15*maxy;

for i = 2 : size(environment,2) % Plot every stone
    patch( environment{i}(:,1), environment{i}(:,2),0.1*ones(size(environment{i},1),1), ...
        'k' , 'EdgeColor' , [0 0 0] , 'FaceColor' , [0.8 0.8 0.8] , 'linewidth' , 1.5 );
end

[A,xy]=compute_visibility_graph_from_vis_polygon(environment,epsilon);
n_vertices=0;
for i=1:length(environment)
    n_vertices=n_vertices+size(environment{i},1);
end
n_holes=length(bricks_fract);


close all;
[p,p2]=plot_shortest_path(A,xy,ref_tab,environment,alpha,vlim);  
