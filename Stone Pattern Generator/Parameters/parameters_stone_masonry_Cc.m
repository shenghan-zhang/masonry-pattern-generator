%PARAMETERS_STONE_MASONRY This script has to be launched before every calculation as it defines some of the basic parameters of the stone pattern generation algorith, such as wall length, and so on.
% Space dependent parameters such as size of the bricks, erosion 
% parameters, aredefined in the three dedicated function (in this same 
% folder) get_params_erosion.m, get_params_stght_pattern.m and 
% get_params_shaking.m.  
%% Saving parameters
if (~exist('in_dedicated_function','var'))
folder='..\Saved_Pictures_temp_martin\C\';
name='wall_trytry_EO1';
end
%%
% define procedures to implement or skip 
do_add_random_points = true; 
do_merging = false; 
do_subdivision = false;
do_shaking = true; 
do_voronoi = false; 
do_erosion = true;
do_resampling = true; 
do_facterization = true; 
do_sieving = true; 
do_drawing = true; 
do_shortest_path = false; 

%% Size of the wall 
if (~exist('in_dedicated_function','var'))||(strcmp(in_dedicated_function, 'wall_size'))
Lx_wall =1.05; % Widtht of the wall
Ly_wall =1.05; % Height of the wall 
dl_crop=0.025; % Cropping length after the whole process

epsilon = 0.01; % Geometrical approximation constant
regular_pattern=0; % has to be one if the wall to be generated is made of square bricks. 

Lx_wall=epsilon*round(Lx_wall/epsilon);
Ly_wall=epsilon*round(Ly_wall/epsilon);
end
%% Straight pattern options (IN DEDICATED FUNCTION)
if (~exist('in_dedicated_function','var')||(strcmp(in_dedicated_function, 'straight_pattern')))
option_corner = 1; % Option that says if the normal straight pattern should be computed (0) or if the new option should be used (1)
option_long = 'odd'; % in with row do we start the long brick
% option = 'uniform'; 
% Lxy = [0.23, 0.18];
% nxy = [0.25, 0.1667];
option = 'uniform';
Lx_ = 0.22;%*ones(1,length(Ly_));
Ly_ = 0.14;%[0.14,0.14,0.14,0.18,0.18,0.18,0.18]; 
nx_ = 0.3333;
ny_ = 0.1667;   
% Lx_bricks = defined in dedicated function;
% Ly_bricks = defined in dedicated function;
% 
% nx = defined in dedicated function;
% ny = defined in dedicated function;
end
%% Voronoi splitting Options
if (~exist('in_dedicated_function','var'))
tresholdArea=0.055;
AThresholdVoronoi = tresholdArea; % sh: probably should change the input of line 92 in the main function  
end
%% Merging parameters 
if (~exist('in_dedicated_function','var'))
limitAngleMerging = 1.3*pi;
mergingRate = 20;
ratioMerging = 1.15; % The merged polygon must have an area that satisfy the relation ratioMerging*A<A_convexhull
end

%% Subdivison of stones 
if (~exist('in_dedicated_function','var'))
aSubdiv=0.03; % Minimum limit on the area of the stones that will be divided
divisionOption=3; % 1 means that the stones will be divided along a diagonal (to use especially if the stones are rectangular)
subdivisionRate = 25;
end
%% Shaken pattern options (IN DEDICATED FUNCTION)
if (~exist('in_dedicated_function','var'))||(strcmp(in_dedicated_function, 'shaken_pattern'))
% check function get_params_shaking.m Modification to put all parameters
% togher; 
option = 'uniform'; % Choose between 'uniform' or 'by_zone' 
noise = [0.01 0.01]; 
% % together, change needed to read a certain part of the function 
% % nxr = defined here noise(1);
% % nyr = defined here noise(2);
limitAngleShaking=1.05*pi;
end
%% Random node addition parameters
if (~exist('in_dedicated_function','var'))
minDist=0.05; % Minimum length of the edges on which we will add random nodes
randomNodesAdditionRate=20; % Rate of addition of random nodes on longer edges than minDist, in %. 
end
%% Drawing options
if (~exist('in_dedicated_function','var'))
dl_brick_fundation=0.00; % Thickness of the brick layer in the fundation
dl_mortar_fundation=0.00; % Thickness of the mortar layer in the fundation
resolution=6; % Pixels per cm 
end
%% Erosion options (IN DEDICATED FUNCTION)
if (~exist('in_dedicated_function','var')||(strcmp(in_dedicated_function, 'erosion')))
opt_contact_points=1;
option = 'uniform';
pe_ = 1.5;
len_erosion = 0.009;
n_pixels_=140;
dlVarType_='rand'; % 'constant' 'rand', 'AProportional'
dlRandRange_=50;
AThreshold_=0.05;
mean_durability_=0.1;
r_=0.02;
corr_n_random_field=50;
corr_name = 'gauss';
seuil_area_ = 0.5;
corr_c0 = 0.004;
corr_sigma = 0.15;
a_ = 0.1;
b_ = 0.25;
seuil_contact_ = 0.45;
reordering_method_='angular';
end
%% Resampling options
if (~exist('in_dedicated_function','var'))
min_vertices=10; % Minimum number of vertices
l_edges=0.05; % if 0, no resmampling 
span=4; % The value of the resampled vertices is averaged using a certain span defined by this parameter.
end
%% Fractalization options
if (~exist('in_dedicated_function','var'))
nb_it=0; % Number of fractalization iterration, if 0, no fractalization. (Caution the number of vertices increases as 2^nb_it)
c_fract=0.025; % Magnitude of the fractalization
end
%% Sieving
if (~exist('in_dedicated_function','var'))
min_length_sieving = 0.01; % Minimum length for the sieving step.
end
%% Shortest path options 
if (~exist('in_dedicated_function','var'))
alpha=0.1; % Weight of the travel along the edges
vlim=0.025; % Width of the forbidden zones on the left and right hand sides (it forbids the algorithm to take straight shortcuts around the wall) 
epsilonSP=0.0001; % Epsilon used while computing shortest path graph. 
point_start_end = {[0.5, 0.025; 0.5, 1.025], [0.2, 0.025; 0.2, 1.025],[0.8, 0.025; 0.8, 1.025]};
end