function main
% name_spm = {'A1', 'A2', 'A3', 'B1', 'B2', 'B3', 'C1', 'C2', 'C3', 'D1', 'D2', 'D3', 'E1', 'E2', 'E3'};
name_spm = {'C1'};
for i_glb = 1:length(name_spm)
clearvars -except i_glb name_spm 
folder_path = 'Z:\temp_pic\';
file_name = sprintf('%smy_mesh_from_pic_%s_2.geo',folder_path,name_spm{i_glb})
file_name_r = sprintf('%smy_mesh_from_pic_%s_r.geo',folder_path,name_spm{i_glb});
[points, lines, line_loops, plane_surfaces, physical_surfaces, physical_lines, mesh_sizes] = readFromGmshGeo(file_name);

%% find info about the mesh 
x_min = min(points(:,2));
x_max = max(points(:,2));
y_min = min(points(:,3));
y_max = max(points(:,3));

len_x = x_max-x_min; 
len_y = y_max-y_min; 
tol = 1e-6; 
match_value = [x_min, x_max, y_min, y_max];
added_surfaces = []; 
%%
len_loading_shoe = 0.10; 

dir = [1,-1]; 
add_coords = [x_max, y_min+0.1*len_y
              x_max, y_min
              x_max-0.1*len_x, y_min
             [x_max-0.1*len_x, y_min]+dir*len_loading_shoe*len_x
             [x_max, y_min+0.1*len_y]+dir*len_loading_shoe*len_x]; 
[points, lines, line_loops, plane_surfaces, physical_surfaces, physical_lines, mesh_sizes, added_surface] = addLineLoop(add_coords, points, lines, line_loops, plane_surfaces, physical_surfaces, physical_lines, mesh_sizes, match_value);
added_surfaces = [added_surfaces, added_surface]; 

dir = [-1, 1]; 
add_coords = [x_min, y_max-0.1*len_y
              x_min, y_max
              x_min+0.1*len_x, y_max
              [x_min+0.1*len_x, y_max]+dir*len_loading_shoe*len_x
              [x_min, y_max-0.1*len_y]+dir*len_loading_shoe*len_x]; 

[points, lines, line_loops, plane_surfaces, physical_surfaces, physical_lines, mesh_sizes, added_surface] = addLineLoop(add_coords, points, lines, line_loops, plane_surfaces, physical_surfaces, physical_lines, mesh_sizes, match_value);

added_surfaces = [added_surfaces, added_surface]; 

physical_surfaces('"steel"')=added_surfaces;
writeToGmshGeo(file_name_r, points, lines, line_loops, plane_surfaces, physical_surfaces, physical_lines, mesh_sizes);

end
end

function [points, lines, line_loops, plane_surfaces, physical_surfaces, physical_lines, mesh_sizes, added_surface] = addLineLoop(add_coords, points, lines, line_loops, plane_surfaces, physical_surfaces, physical_lines, mesh_sizes, match_value)
    %% initilize
objArray = {}; 
for p = 1:size(add_coords,1) 
    objArray{p} = PointAdded(add_coords(p,:));
%     objArray{p}.checkInList(points); 
    [objArray{p}, points,lines,line_loops]=objArray{p}.modifyLines(points,lines,line_loops); 
end 
   
line_loop = []; 
check_index = [1, 1, 2, 2]; % check if on edge or not  
pos_index = [2, 2, 1, 1];   % compare the position on the edge 


tol = 1e-6;
for o = 1:length(objArray)
    p_pre = objArray{o};
    if o == length(objArray)
        p_next = objArray{1};
    else
        p_next = objArray{o+1};
    end
    lines_selected = [];
    [on_edge_num, on_edge_pos] = max(p_pre.on_edge+p_next.on_edge);
    id_pre = p_pre.id; 
    id_next = p_next.id;
    if on_edge_num==2
        % find the line 

        coord_pre = p_pre.coord; 
        coord_next = p_next.coord; 
        % select line on the correct edge
        c_ind = check_index(on_edge_pos);
        m_val = match_value(on_edge_pos); 
        p_ind = pos_index(on_edge_pos);
        if coord_next(p_ind)>coord_pre(p_ind)
            % the 
            seq = 'ascend'; 
        else 
            seq = 'descend'; 
        end
        for l = 1:size(lines,1)
            for i = 1:size(points,1)
                if lines(l,2) == points(i,1)
                    coord_1 = points(i,2:3);
                    mz1 = points(i,4);
                end
                if lines(l,3) == points(i,1)
                    coord_2 = points(i,2:3);
                    mz2 = points(i,4);
                end
            end
            pos_l = (coord_1(p_ind)+coord_2(p_ind))/2.0;
            if (norm(coord_1(c_ind)-m_val)<tol) && (norm(coord_2(c_ind)-m_val)<tol)...
                    &&(coord_pre(p_ind)-pos_l)*(coord_next(p_ind)-pos_l)<0
                if (strcmp(seq,'ascend')&&(coord_1(p_ind)<coord_2(p_ind)))||...
                        (strcmp(seq,'descend')&&(coord_1(p_ind)>coord_2(p_ind)))
                    lines_selected = [lines_selected
                                      lines(l,1), pos_l];     
                else 
                     lines_selected = [lines_selected
                                      -lines(l,1), pos_l];                     
                end
            end
        end
            lines_selected = sortrows(lines_selected,2,seq); 
            line_loop = [line_loop lines_selected(:,1)'];
        % find the first line starting form node_pre if not end in
        % node_next, keep find the next one
        
        
        
    else
        line_loops_id = zeros(1,length(line_loops));
        for l_lp = 1:length(line_loops)
            line_loops_id(l_lp) = line_loops{l_lp}(1);
        end
        max_line_id = max([max(line_loops_id),max(lines(:,1))]);
        % add a line 
        max_line_id = max_line_id+1; 
        lines = [lines
                 max_line_id id_pre id_next]; 
        line_loop = [line_loop max_line_id]; 
    end
    
end
max_line_id = max_line_id+1;
n_ll = length(plane_surfaces);
line_loops{n_ll+1} = [max_line_id line_loop]; 
n_ps = length(plane_surfaces); 
plane_surfaces{n_ps+1} = [max_line_id max_line_id];
added_surface = max_line_id; 
end    
% function existing_lines = getExistingLines(node_id1, node_id2, lines, points) 
% 
% end

% function isAlmostEqual()
% 
% 
% end