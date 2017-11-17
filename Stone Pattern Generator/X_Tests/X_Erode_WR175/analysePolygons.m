%% Little script that will get all the polygons in WR175_1 given a datastruct I created using another script

clear all;
close all;
clc;
addpath(genpath('../..'));
% give the input mat file name, obtained from the graph picking procedure
% get_polygons.m
input_file_name = 'ppp.mat';%'try1.mat'; % ppp.mat
output_file_name = 'WR_unfinished.mat';%'WR1_175_polygons_2cm.mat';
load(input_file_name);
resolution=5;
Lx_wall=1.04;
Ly_wall=1.24;
maxIxm=0;
maxIym=0;

Imsize=[496,594];
dx=Lx_wall/Imsize(1);
dy=Ly_wall/Imsize(2);
k=1;
polygons_coordinates=polygons;
for i=1:numel(polygons_coordinates)
    if isempty(polygons_coordinates{i})==0
    for j=1:size(polygons_coordinates{i},1)
        polygons_coordinates_out{k}(j,1)=min(Lx_wall,max(0,polygons_coordinates{i}(j,1)*dx));
        polygons_coordinates_out{k}(j,2)=min(Ly_wall,max(0,Ly_wall-polygons_coordinates{i}(j,2)*dy));
    end
    k=k+1;
    end
end

polygons_coordinates=polygons_coordinates_out;
colors=create_colors(200);
draw_stones(polygons_coordinates_out,resolution,Lx_wall,Ly_wall,colors,0.01);
% write_stones(polygons_coordinates,gcf);
save(output_file_name,'polygons_coordinates');