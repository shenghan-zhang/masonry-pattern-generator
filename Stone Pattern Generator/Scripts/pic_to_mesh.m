%%
% Get the gmsh file from picture 
%  
% 
%%
% name_spm = {'A1', 'A2', 'A3', 'C1', 'C2', 'C3'}; 
name_spm = {'A1'};
for i_glb = 1:length(name_spm)
clearvars -except i_glb name_spm
close all;
clc;
addpath(genpath('..'));
addpath('C:\Users\shzhang\Desktop\temp\')
folder='Z:\temp_pic\'; % Folder in which the picture is
file = sprintf('%s.png',name_spm{i_glb});
filename = sprintf('my_mesh_from_pic_%s_c.geo',name_spm{i_glb});

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
Polygon.setgetVar([x_min,x_max,y_min,y_max])
Polygon.setNodeLineSurfaceNb(0,0,0);

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

write_the_out_line(xd,yd,fileID,objArray)

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
% for i = 1:length(polygons)
%     ploygon_i = objArray{i}.coords; 
%     patch(ploygon_i(:,1),ploygon_i(:,2),'r')
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

