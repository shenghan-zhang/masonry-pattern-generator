clear 
close all;
clc
addpath(genpath('../../'));

x = rand(10,1);
y = rand(10,1);
[vx,vy] = voronoi(x,y);
plot(x,y,'r+',vx,vy,'b-')
bs_ext=[-3,-3,3,3;-3,3,3,-3]';
hold on
plot(bs_ext(1,:),bs_ext(2,:));
figure;
[vx,vy]=extendVoronoiGraph(vx,vy);
plot(x,y,'r+',vx,vy,'b-')
hold on
plot(bs_ext(1,:),bs_ext(2,:));

axis equal