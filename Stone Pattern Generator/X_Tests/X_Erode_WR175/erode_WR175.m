clear all;
close all;
clc;

% input file name, input from the analysePolygons.m
input_file_name = 'WR_unfinished.mat';%'WR1_175_polygons_2cm.mat'
% output file name 
load(input_file_name);
addpath(genpath('..'));

resolution =5;
Lx_wall=1.04;
Ly_wall=1.24;

folder='';
out_put_name= 'WR2_unfinished_test';%'WR2_175_eroded_c0_003_rslength_005_span15';

min_vertices=5;
l_edges=0.05;
span=15;

nb_it=0;
c_fract=0.01;

dl_crop=0.02;

contact_points=cell(size(polygons_coordinates));
row_vec=zeros(size(polygons_coordinates,2),1);
colors=create_colors(size(polygons_coordinates,2));
%% EROSION OF THE STONES
tic;
disp('Eroding stones...');
[eroded_pos,del_stones]=erode_stones(polygons_coordinates,contact_points,row_vec);
timer=toc;
colors(del_stones,:)=[];
h2=draw_stones(eroded_pos,resolution,Lx_wall,Ly_wall,colors,'Eroded Pattern');
disp(['Erosion completed, ', num2str(length(del_stones)), ' stones deleted']);
%% RESAMPLING OF THE POLYGONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Resampling Polygons')
resampled_stones=resample_polygons(eroded_pos,min_vertices,l_edges,span);
added_text=['After resampling : n\_vertices =  ', num2str(min_vertices), ', span = ', num2str(span)];
draw_stones(resampled_stones,resolution,Lx_wall,Ly_wall,colors,added_text);

%% CROPPING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Cropping picture');
[cropped_poly,Lx_wall_cropped,Ly_wall_cropped,colors_cropped]=crop_picture(resampled_stones,dl_crop,Lx_wall,Ly_wall,colors);
draw_stones(cropped_poly,resolution,Lx_wall_cropped,Ly_wall_cropped,zeros(200,3),'After Cropping');
%%
save_picture(cropped_poly,resolution,'k',folder,out_put_name,Lx_wall_cropped,Ly_wall_cropped);% hold on;
