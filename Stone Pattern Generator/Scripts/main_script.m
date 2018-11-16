% This script is the main script of the stone pattern generation algorithm.
% It calls all the functions in order to generate a wall, from the straight
% pattern generation to the last post-processing operations as computing
% the shortest path. 
% name_group = {'Ta_A1','Ta_A2','Ta_A3','Ta_A4','Ta_A5'};
name_group = {'A','B','C','D','E','E1'};
for g = 1:1
    for s = 1:1
% for g = 1:5
%% INITIALISATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars -except g name_group s%clear;
close all;
clc;

addpath(genpath('..'));
%addpath('Y:\06_File_Transfer\For_Shenghan\Resources Shenghan v2\Stone Pattern Generator\Parameters\');
%parameters_stone_masonry_Eb;
% The folder for the parameters is in ".\masonry-pattern-generator\Stone
% Pattern Generator\Parameters"
switch name_group{g}
    case 'A'
    parameters_stone_masonry_Ac;
    file_params = 'parameters_stone_masonry_Ad;';%'parameters_stone_masonry_Ac;';
    case 'B'
    parameters_stone_masonry_Bc;
    file_params = 'parameters_stone_masonry_Bc;';
    case 'C'
    parameters_stone_masonry_Cc;
    file_params = 'parameters_stone_masonry_Cc;';
    case 'D'
    parameters_stone_masonry_Dc;
    file_params = 'parameters_stone_masonry_Dc;';
    case 'E'
    parameters_stone_masonry_Ec;
    file_params = 'parameters_stone_masonry_Ec;';
    case 'E1'
    parameters_stone_masonry_Eb1;
    file_params = 'parameters_stone_masonry_Ec1;';
end
name = sprintf('%s_%d',name_group{g},s);        
% name = name_group{g};
%% STRAIGHT PATTERN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Creating straight pattern...')
[Pos_tab,topline,stones_nodes,pos_tab_straight,row_vec,neighbors]=fill_wall(Lx_wall,Ly_wall,epsilon,option_corner,file_params);
colors=create_colors(length(stones_nodes)*2000);
rect=draw_stones(pos_tab_straight,resolution,Lx_wall,Ly_wall,colors,0.01,'Straight Pattern');
disp(['Pattern Created, ' num2str(length(stones_nodes)), ' stones created']);


%% ADDING POINTS ON STRAIGHT EDGES
if (do_add_random_points)
disp('Adding random points on straight edges'); 
[Pos_tab,stones_nodes,posTabRandomNodes]=addRandomNodes(Pos_tab,stones_nodes,minDist,randomNodesAdditionRate,epsilon);
h=draw_stones(posTabRandomNodes,resolution,Lx_wall,Ly_wall,colors,0.01,'Random Nodes Added ');
end
%% SUBDIVISON OF BIG STONES
% disp('Subdividing the big stones');
% [stones_nodes,row_vec,stonesPosDivided]=divide_big_stones(Pos_tab,stones_nodes,aSubdiv,row_vec,divisionOption,epsilon,subdivisionRate);
% colors=[colors;colors];
% figure_triangles=draw_stones(stonesPosDivided,resolution,Lx_wall,Ly_wall,colors,0.01,'Subdivided Pattern');

%% MERGING OF THE POLYGONS

% disp('Merging Polygons...');
% [ Pos_tab,stones_nodes,stonesPosMerged,row_vec] = mergePolygons( Pos_tab,stones_nodes,row_vec,Lx_wall,Ly_wall,epsilon,limitAngleMerging,mergingRate,ratioMerging);
% draw_stones(stonesPosMerged,resolution,Lx_wall,Ly_wall,colors,0.01,'Merged Pattern');    

%% VORONOI SUBDIVISION OF BIG STONES
if (do_voronoi)
disp('Voronoi splitting of big stones...');
% epsilon=20*eps; % We change the precision for voronoi splittin
[Pos_tab,stones_nodes,posTabVoronoi,row_vec] = divide_in_voronoi_polygons( Pos_tab,stones_nodes,tresholdArea,0.00001,row_vec,Lx_wall,Ly_wall);
draw_stones(posTabVoronoi,resolution,Lx_wall,Ly_wall,colors,0.01,'Voronoi Splitted Pattern');
fig1b=figure();darwStone4Video(fig1b,posTabVoronoi,true,Lx_wall,Ly_wall);axis equal;set(fig1b.CurrentAxes,'visible','off');
             axis([0 Lx_wall 0 Ly_wall])
end
%% SHAKEN PATTERN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Shaking stones...');
[Pos_tab,stones_nodes,posTabShaken] = shake(Pos_tab,Lx_wall,Ly_wall,stones_nodes,limitAngleShaking,file_params);
figureref=draw_stones(posTabShaken,resolution,Lx_wall,Ly_wall,colors,0.01,'Shaken Pattern');
fig2=figure();darwStone4Video(fig2,posTabShaken,true,Lx_wall,Ly_wall);axis equal;set(fig2.CurrentAxes,'visible','off');
             axis([0 Lx_wall 0 Ly_wall])
%% GET CONTACT POINTS
disp('Getting Contact Points...');
contact_points=get_contact_points(stones_nodes,posTabShaken,opt_contact_points);

%% EROSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Eroding stones...');
[eroded_pos,del_stones]=erode_stones(posTabShaken,contact_points,row_vec,file_params);
colors(del_stones,:)=[];
h2=draw_stones(eroded_pos,resolution,Lx_wall,Ly_wall,colors,'Eroded Pattern');
disp(['Erosion completed, ', num2str(length(del_stones)), ' stones deleted']);
fig3=figure();darwStone4Video(fig3,eroded_pos,true,Lx_wall,Ly_wall);axis equal;set(fig3.CurrentAxes,'visible','off');
             axis([0 Lx_wall 0 Ly_wall])
%% RESAMPLING OF THE POLYGONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Resampling Polygons')
resampled_stones=resample_polygons(eroded_pos,min_vertices,l_edges,span);
added_text=['After resampling : n\_vertices =  ', num2str(min_vertices), ', span = ', num2str(span)];
draw_stones(resampled_stones,resolution,Lx_wall,Ly_wall,colors,added_text);

%% FRACTALIZATION OF EDGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Fractalizing edges...');
[fract_poly]=fractalize_polygons(resampled_stones,nb_it,c_fract);
added_text=(['Fractalization : Itererations : ', num2str(nb_it), ', C = ', num2str(c_fract)]);
draw_stones(fract_poly,resolution,Lx_wall,Ly_wall,colors,added_text); 

%% REMOVE SMALL STONES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (do_sieving)
disp('Removing small stones');
[sieved_stones,colors_sieved]=sieving(fract_poly,min_length_sieving,colors);
draw_stones(sieved_stones,resolution,Lx_wall,Ly_wall,colors_sieved,'After Sieving');
end
%% STRAIGHT PATTERN POST PROCESSING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if regular_pattern==1
    sieved_stones=put_corners(sieved_stones);
end


%% CROPPING OF THE FRAME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Cropping picture');
[cropped_poly,Lx_wall_cropped,Ly_wall_cropped,colors_cropped]=crop_picture(sieved_stones,dl_crop,Lx_wall,Ly_wall,colors_sieved);
draw_stones(cropped_poly,resolution,Lx_wall_cropped,Ly_wall_cropped,colors_cropped,'After Cropping');

%% ADDING OF THE FUNDATION AND SAVING OF THE PICTURE
[funded_poly,Ly_wall_funded]=add_fundation(cropped_poly,Lx_wall_cropped,Ly_wall_cropped,dl_mortar_fundation,dl_brick_fundation);
save_picture(funded_poly,resolution,'k',folder,name,Lx_wall_cropped,Ly_wall_funded,dl_crop);% hold on;
% save_parameters( folder,name,Lx_wall,Ly_wall,opt_contact_points,epsilon,regular_pattern,min_vertices,l_edges,span,nb_it,c_fract,min_length_sieving,dl_crop,resolution,dl_brick_fundation,dl_mortar_fundation,option_corner,AThresholdVoronoi,limitAngleMerging,mergingRate,ratioMerging,aSubdiv,divisionOption,subdivisionRate,limitAngleShaking,minDist,randomNodesAdditionRate);
    end
end
%% SHORTEST PATH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (do_shortest_path)
disp('Computing Visibility graph...');
[environnement,ref_tab]=make_environnement(sieved_stones,Lx_wall,Ly_wall);
[A,xy]=compute_visibility_graph_from_vis_polygon(environnement,epsilonSP);

disp(['Visibility graph computed, now getting shortest paths...']);
n_vertices=get_number_vertices(sieved_stones);
n_holes=length(sieved_stones);
[p,int]=plot_shortest_path(A,xy,ref_tab,environnement,alpha,vlim,point_start_end);
end
%% END OF PROCESS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% disp('Process completed');
% end
