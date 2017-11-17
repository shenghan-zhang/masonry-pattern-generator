clear all;
close all;
clc;
addpath(genpath('C:\Users\shzhang\Google Drive\for_martin\Resources Shenghan v2\Stone Pattern Generator\'))
Lx_wall=5; % size of the "wall"
Ly_wall=5;
alpha=0.3; % cost of travel along interfaces relatively to travel along mortar
vlim=0.2; % vertical band where travel is forbidden to avoid shortcuts on sides
epsilon=0.00001; % approximation constant
nlev = 0;
p1=[0.5,1;...
    0.5,2;...
    1.5,2;...
    1.5,1];
p1 = p1 + nlev*randn(4,2);
p2=[2,3;...
    2,4;...
    3,4;...
    3,3];
p2 = p2 + nlev*randn(4,2);
p3=[2,2;...
    4,2;...
    3,1];
p3 = p3 + nlev*randn(3,2);
polygonsList{1}=p1;
polygonsList{2}=p2;
polygonsList{3}=p3;


[environnement,ref_tab]=make_environnement(polygonsList,Lx_wall,Ly_wall);
[A,C,xy]=compute_visibility_graph_from_vis_polygon(environnement,epsilon,1,vlim,ref_tab,Lx_wall);
[A,Calpha,xy]=compute_visibility_graph_from_vis_polygon(environnement,epsilon,alpha,vlim,ref_tab,Lx_wall);

[p,p2]=plot_shortest_path(A,C{1},Calpha{1},xy,environnement,vlim);

