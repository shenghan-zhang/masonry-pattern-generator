function [] = save_parameters( folder,name,Lx_wall,Ly_wall,opt_contact_pts,epsilon,regular_pattern,min_vertices,l_edges,span,nb_it,c_fract,min_length_sieving,dl_crop,resolution,dl_brick_fundation,dl_mortar_fundation,option_corner,AThresholdVoronoi,limitAngleMerging,mergingRate,ratioMerging,aSubdiv,divisionOption,subdivisionRate,limitAngleShaking,minDist,randomNodesAdditionRate)
% SAVE_PARAMETERS is a function that will write in a txt file all the parameters used during the stone pattern generation. 
% For the parameters defined by the 3 functions get_params_erosion.m,
% get_params_stght_pattern.m and get_params_shaking.m, it will copy the
% text of the functions in the txt file. 
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - every parameter of the model 
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - none, it just creates a txt file. 
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : January 2016
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist(folder,'dir')~=7
    mkdir(folder);
end

fileID = fopen(strcat(folder,name,'.txt'),'Wt');


fprintf(fileID,['*************************************************************************************************** \n*************************************************************************************************** \nStone Pattern Generation parameters for the file ', name,' generated on the ',datestr(datetime),'\n*************************************************************************************************** \n ']);
fprintf(fileID,' \n\n\n');
fprintf(fileID,'1. General Parameters \n \n');
fprintf(fileID,strcat('Lx_wall = ',num2str(Lx_wall),'\n'));
fprintf(fileID,strcat('Ly_wall = ',num2str(Ly_wall),'\n'));
fprintf(fileID,strcat('dl_crop = ',num2str(dl_crop),'\n'));
fprintf(fileID,strcat('epsilon = ',num2str(epsilon),'\n'));
fprintf(fileID,strcat('regular_pattern = ',num2str(regular_pattern),'\n'));
fprintf(fileID,' \n\n\n');


stght_pattern_file = fullfile('\..','parameters','get_params_stght_pattern.m');
stght_pattern_text = fileread(stght_pattern_file);
fprintf(fileID,'2. Straight Pattern Parameters Fetch function \n \n');
fprintf(fileID,['option_corner = ', num2str(option_corner),'\n'])
fprintf(fileID,'%s\n',stght_pattern_text);
fprintf(fileID,' \n');
fprintf(fileID,' \n');
fprintf(fileID,' \n');

fprintf(fileID,'3. Voronoi Parameters \n');
fprintf(fileID,strcat('AThreshold = ',num2str(AThresholdVoronoi),'\n'));
fprintf(fileID,' \n\n\n');

fprintf(fileID,'4. Merging Parameters \n');
fprintf(fileID,strcat('limitAngleMerging = ',num2str(limitAngleMerging),'\n'));
fprintf(fileID,strcat('mergingRate = ',num2str(mergingRate),'\n'));
fprintf(fileID,strcat('ratioMerging = ',num2str(ratioMerging),'\n'));
fprintf(fileID,' \n\n\n');


fprintf(fileID,'4. Subdivision Parameters \n');
fprintf(fileID,strcat('aSubdiv = ',num2str(aSubdiv),'\n'));
fprintf(fileID,strcat('divisionOption = ',num2str(divisionOption),'\n'));
fprintf(fileID,strcat('subdivisionRate = ',num2str(subdivisionRate),'\n'));
fprintf(fileID,' \n\n\n');

shaking_file = fullfile('\..','parameters','get_params_shaking.m');
shaking_text = fileread(shaking_file);
fprintf(fileID,'4. Shaking Parameters Fetch function \n \n');
fprintf(fileID,strcat('limitAngleShaking = ',num2str(limitAngleShaking),'\n'));
fprintf(fileID,'%s\n',shaking_text);
fprintf(fileID,' \n\n\n');

minDist=0.05; % Minimum length of the edges on which we will add random nodes
randomNodesAdditionRate=20; % Rate of addition of random nodes on longer edges than minDist, in %. 

fprintf(fileID,'4. Random Nodes Addition Parameters \n');
fprintf(fileID,strcat('minDist = ',num2str(minDist),'\n'));
fprintf(fileID,strcat('randomNodesAdditionRate = ',num2str(randomNodesAdditionRate),'\n'));
fprintf(fileID,' \n\n\n');

erosion_file = fullfile('\..','parameters','get_params_erosion.m');
erosion_text = fileread(erosion_file);
fprintf(fileID,'5. Erosion Parameters Fetch function \n \n');
fprintf(fileID,strcat('opt_contact_points = ',num2str(opt_contact_pts),'\n'));
fprintf(fileID,'%s\n',erosion_text);
fprintf(fileID,' \n\n\n');

fprintf(fileID,'5. Resampling parameters \n');
fprintf(fileID,strcat('min_vertices = ',num2str(min_vertices),'\n'));
fprintf(fileID,strcat('l_edges = ',num2str(l_edges),'\n'));
fprintf(fileID,strcat('span = ',num2str(span),'\n'));
fprintf(fileID,' \n\n\n');

fprintf(fileID,'6. Fractalization parameters \n');
fprintf(fileID,strcat('nb_it = ',num2str(nb_it),'\n'));
fprintf(fileID,strcat('c_fract = ',num2str(c_fract),'\n'));
fprintf(fileID,' \n\n\n');

fprintf(fileID,'7. Sieving parmater \n');
fprintf(fileID,strcat('min_length_sieving = ',num2str(min_length_sieving),'\n'));
fprintf(fileID,' \n\n\n');

fprintf(fileID,'8. Drawing options \n');
fprintf(fileID,strcat('resolution = ',num2str(resolution),'\n'));
fprintf(fileID,strcat('dl_brick_fundation = ',num2str(dl_brick_fundation),'\n'));
fprintf(fileID,strcat('dl_mortar_fundation = ',num2str(dl_mortar_fundation),'\n'));
fprintf(fileID,' \n\n\n');

fclose(fileID);
end



