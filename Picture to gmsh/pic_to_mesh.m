function main
%%
% Get the gmsh file from picture 
% Shenghan Zhang <shenghan.zhang@epfl.ch>
% EESD EPFL Switzerland
% Nov.2017
%%
%name_spm = {'C1'}; 
close all
name_spm = {'TypoAN1', 'TypoEO1'};
scale_mesh = true; 
add_boundary = 0; % 0 with adding any boundary condition 
                  % 1 with only one beam on top of the specimen
                  % 2 with two shortened beams for diagonal compression
                  % test 

for i_glb = 1:length(name_spm)
clearvars -except i_glb name_spm scale_mesh add_boundary

clc;
addpath(genpath('..'));
%addpath('C:\Users\shzhang\Desktop\temp\')
folder='.\..\Italian topologies\'; % Folder in which the picture is
file = sprintf('%s.png',name_spm{i_glb});
filename = sprintf('%smy_mesh_from_pic_%s_2.geo',folder,name_spm{i_glb});

Lx=1.0; % Length of the picture
Ly=1.0; % Height of the picture
resolution=8;
dl=0.02;% If necessary, put non-zero value to add a mortar layer
min_vertices=5; % Minimum number of vertices by stone
l_edges=0.05; % Length of the resampled edges of the polygons
span=1; % Span of the averaging of the vertices coordinates during resampling

epsilon=0.0000001; % Approximation constraint
do_resample = true; 
do_skip = true; 
pic_type = 'bw';
[polygons]=get_polygons_from_picture(folder,file,pic_type,Lx,Ly,dl); % Get the polygons from BW picture
% resampled_stones=resample_polygons(polygons,min_vertices,l_edges,span); % Resampling + Deleting redundant vertices
colors=create_colors(2000);
min_length_sieving = 0.007;
[resampled_stones,colors_sieved]=sieving(polygons,min_length_sieving,colors);


%%

for i = 1:length(resampled_stones)
    new_coords = resampled_stones{i}; 

    % check the situation that when the points are arranged as 
    % ------1j----3l----2k 
    exist_violation = true; 
    % loop over every 3 points 
    % check if the condition is violated 
    % if violated 
    while exist_violation
        exist_violation = false; 
        nb_point = size(new_coords,1); 
  %      to_be_delete = []; 
        for j = 1:nb_point
            % find k, l as the next two indices 
            k = mod(j,nb_point)+1; 
            l = mod(j+1,nb_point)+1; 
            is_sanp = snap_back(new_coords(j,:), new_coords(k,:), new_coords(l,:)); 
            if (is_sanp)
                exist_violation = true; 
                new_coords(k,:) = []; 
                break
            end
        end
    end 
    
    
    new_coords = [new_coords
                  new_coords(1,:)];
    resampled_stones{i} = new_coords;     
    if ~ispolycw(resampled_stones{i}(:,1), resampled_stones{i}(:,2))
        msg = 'point not clock wise';
        error(msg)
    end
end
%resampled_stones = polygons;

%%
% plot resampled stones 
% figure
% hold on
% for i = 1:length(resampled_stones)
%     plot(resampled_stones{i}(:,1), resampled_stones{i}(:,2))
% end
%% add one point for each resampled stones


%%

findAndSetXYMM(resampled_stones)

if (scale_mesh)
    
    xy_min_max = Polygon.setgetVar();
    x_min = xy_min_max(1);
    x_max = xy_min_max(2);
    y_min = xy_min_max(3);
    y_max = xy_min_max(4); 
    for i = 1:length(resampled_stones)
        nb_stones = size(resampled_stones{i},1);
        for j = 1:nb_stones
            resampled_stones{i}(j,1) = (resampled_stones{i}(j,1) - x_min)/(x_max - x_min); 
            resampled_stones{i}(j,2) = (resampled_stones{i}(j,2) - y_min)/(y_max - y_min); 
        end 
    end
    findAndSetXYMM(resampled_stones)   
    xy_min_max = Polygon.setgetVar();
    x_min = xy_min_max(1);
    x_max = xy_min_max(2);
    y_min = xy_min_max(3);
    y_max = xy_min_max(4);     
end
    

% initiallize the global node line surface number 
Polygon.setNodeLineSurfaceNb(0,0,0);

if (add_boundary == 2)
    add_coords = [x_min+0.15*(x_max-x_min),y_max;
                  x_max-0.15*(x_max-x_min),y_max;
                  x_min+0.15*(x_max-x_min),y_min;
                  x_max-0.15*(x_max-x_min),y_min]; 
    is_on_stone = [false; false; false; false]; 
    Polygon.setAddCoords(add_coords,is_on_stone); 
elseif (add_boundary == 1)
    add_coords = [x_min,y_max;
                  x_max,y_max];
    is_on_stone = [false; false];
    Polygon.setAddCoords(add_coords,is_on_stone); 
elseif (add_boundary == 0)
    add_coords = [];
    is_on_stone = [];
    Polygon.setAddCoords(add_coords,is_on_stone); 
end


objArray = cell(length(resampled_stones),1);
for i = 1:length(resampled_stones)
    coord_temp = resampled_stones{i}; 
    objArray{i} = Polygon(coord_temp); 
end

% UseData.Data.x_min = x_min;
% UseData.Data.x_max = x_max;
% UseData.Data.y_min = y_min;
% UseData.Data.y_max = y_max;

% Polygon.xy_min_max.x_min = x_min; 
% Polygon.xy_min.x_max = x_max; 
% Polygon.xy_min.y_min = y_min; 
% Polygon.xy_min.y_max = y_max; 

box = [x_min, y_min
       x_min, y_max
       x_max, y_max
       x_max, y_min
       x_min, y_min]; 
xd = box(:,1);
yd = box(:,2);

% figure
% hold 
% for j = 1:length(polygons{1}(:,1))
%     plot(polygons{1}(j,1), polygons{1}(j,2),'ro')
% end

%% print all the infomation

mesh_size = 0.053;
mesh_size_2 = 0.07;

fileID = fopen(filename,'w');
% input mesh information
h = mesh_size;
h2 = mesh_size_2;
structured_mesh= true;
formatSpec = 'h = %f;\n';
fprintf(fileID, formatSpec, h);

formatSpec = 'h2 = %f;\n';
fprintf(fileID, formatSpec, h2);

for i = 1:length(resampled_stones)
    objArray{i}.writeGmsh(fileID,'node_info')
end

for i = 1:length(resampled_stones)
    objArray{i}.writeGmsh(fileID,'line_info')
end

for i = 1:length(resampled_stones)
    objArray{i} = objArray{i}.writeGmsh(fileID,'surface_info')
end


figure 
hold on
for i = 1:length(resampled_stones)
    plot(resampled_stones{i}(:,1),resampled_stones{i}(:,2))
end 
    
for i = 1:length(resampled_stones)
    if objArray{i}.nb_on_edge
        
        [xd, yd] = polybool('subtraction', xd, yd, objArray{i}.coords(:,1), objArray{i}.coords(:,2));   
    end
end
plot(xd,yd,'LineWidth',4)
write_the_out_line_2(xd,yd,fileID,objArray,add_boundary)
end
end

% figure
% hold on
% patch(xd, yd, 1, 'FaceColor', 'r')
% plot(xd,yd,'ro')
% for i = 1:length(resampled_stones)
% patch(polygons{i}(:,1), polygons{i}(:,2), 1, 'FaceColor', 'r')
% end
% 
% figure
% hold on 
% for i = 1:length(object_array)
%     ploygon_i = object_array{i}.coords; 
%     plot(ploygon_i(:,1),ploygon_i(:,2),'-or')
% end
% 
% plot(box(:,1),box(:,2))
% hold on
% plot(polygons{i}(:,1), polygons{i}(:,2))
% hold on 
% plot(resampled_stones{i}(:,1),resampled_stones{i}(:,2))
% 
% figure
% hold 
% for j = 1:length(polygons{i}(:,1))
%     plot(polygons{i}(:,1), polygons{i}(:,2),'ro')
% end
% for i = 1:nb_p
%     poly = polygons{i};
%     for j = 1:length(poly(:,1))
%         point = poly(j,:);
%         
%         if abs(point(1)-0)<epsilon
%             % x = 0 
%         end
%         if abs(point(1)-Lx)<epsilon
%             % x = Lx
%         end
%         if abs(point(2)-0)<epsilon
%             % y = 0 
%         end
%         if abs(point(2)-Ly)<epsilon
%             % y = Ly
%         end        
%     end
% end
% 
% figure
% hold on 
% for i = 1:nb_p
%     poly = polygons{i};
%     plot(poly(:,1),poly(:,2))
% end

function findAndSetXYMM(resampled_stones)
x_min_a = [];
x_max_a = [];
y_max_a = [];
y_min_a = []; 

for i = 1:length(resampled_stones)
    x_min_i = min(resampled_stones{i}(:,1));
    x_max_i = max(resampled_stones{i}(:,1));
    y_min_i = min(resampled_stones{i}(:,2));
    y_max_i = max(resampled_stones{i}(:,2));
    x_min_a = [x_min_a x_min_i]; 
    x_max_a = [x_max_a x_max_i]; 
    y_min_a = [y_min_a y_min_i];
    y_max_a = [y_max_a y_max_i];
end

x_min = min(x_min_a);
x_max = max(x_max_a);
y_min = min(y_min_a);
y_max = max(y_max_a);
disp(sprintf("the functions that we calculated is, x_min %f, x_max %f, y_min %f, y_max %f",x_min, x_max, y_min, y_max)); 
Polygon.setgetVar([x_min,x_max,y_min,y_max]);
end 

function out = snap_back(coords1, coords2, coords3)
    tol = 1e-9;
    Ax = coords1(1); 
    Ay = coords1(2); 
    Bx = coords2(1); 
    By = coords2(2); 
    Cx = coords3(1); 
    Cy = coords3(2);     
    area = Ax * (By - Cy) + Bx * (Cy - Ay) + Cx * (Ay - By); 
    if abs(area)<tol
        % check if they are in the same direction 
        if (coords2-coords1)*(coords3-coords2)'<0
            disp("eliminate one point");
            out = true;
            return; 
        end
    end
    out = false; 
end