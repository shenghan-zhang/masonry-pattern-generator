function main
%name_spm = {'A1', 'A2', 'A3', 'B1', 'B2', 'B3', 'C1', 'C2', 'C3', 'D1', 'D2', 'D3', 'E1', 'E2', 'E3'};
%name_spm = {'INT1_eqv_t002_new2','INT4_eqv_t002_le1_new2','INT4_eqv_t002_le2_new2','INT4_eqv_t002_le3_new2'};
%name_spm = {'INT46_t00215_le1_new3','INT46_t00215_le2_new3','INT46_t00215_le3_new3','INT10_t00215_new3','INT20_t00215_new3','INT46_t00215_new3'};
%name_spm = {'INT1_eqv_t002','INT2_eqv_t002','INT4_eqv_t002'};
name_spm = {'INT20_t00215_new3'};%{'TypoAN1'};%{'INT20_t00215_new3'}
for i_glb = 1:length(name_spm)
clearvars -except i_glb name_spm 

do_scale = false;
loading_bracket_type = 'diag_comp';%'shear_comp'; % 'diag_comp', 'beam', 'shear_comp'
% folder_path = 'Z:\project\05_LMT_Sizeeffect\05_Mesh\'; 
folder_path = '.\'; 
file_name = sprintf('%smy_mesh_from_pic_%s_2_ms002.geo',folder_path,name_spm{i_glb}); 
file_name_r = sprintf('%smy_mesh_from_pic_%s_ms002_sm.geo',folder_path,name_spm{i_glb});
[points, lines, line_loops, plane_surfaces, physical_surfaces, physical_lines, mesh_sizes] = readFromGmshGeo(file_name);
mesh_sizes('h3') = 0.2;
%% find info about the mesh 
x_min = min(points(:,2));
x_max = max(points(:,2));
y_min = min(points(:,3));
y_max = max(points(:,3));
len_x = x_max-x_min; 
len_y = y_max-y_min; 
if (do_scale)
%     nb_points = length(points(:,2)); 
%     for n = 1:nb_points
    points(:,2) = (points(:,2)-x_min )/len_x; 
    points(:,3) = (points(:,3)-y_min )/len_y;
%     end 
    x_min = min(points(:,2));
    x_max = max(points(:,2));
    y_min = min(points(:,3));
    y_max = max(points(:,3));
    len_x = x_max-x_min; 
    len_y = y_max-y_min;
end
 
tol = 1e-6; 
PointAdded.setgetVar(points)
match_value = [x_min, x_max, y_min, y_max];
added_surfaces = []; 
%%
if (strcmp(loading_bracket_type,'diag_comp'))
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
elseif (loading_bracket_type=='shear_comp')
l_b = 1.9*len_x; 
l_sb = 0.1*len_x; 
l_left = 0.8*len_x; 
h_b_tot = 1.3*len_y;
h_b = 0.8*len_y; 
add_coords = [x_min, y_max
              x_max, y_max
              x_max, y_max+h_b
              x_min, y_max+h_b
              x_max-l_b, y_max+h_b
              x_max-l_b, y_max+h_b-h_b_tot
              x_max-l_b+l_left/2, y_max+h_b-h_b_tot
              x_max-l_b+l_left, y_max+h_b-h_b_tot
              x_max-l_b+l_left, len_y]; 
[points, lines, line_loops, plane_surfaces, physical_surfaces, physical_lines, mesh_sizes, added_surface] = addLineLoop(add_coords, points, lines, line_loops, plane_surfaces, physical_surfaces, physical_lines, mesh_sizes, match_value);
added_surfaces = [added_surfaces, added_surface];           
end
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
        max_line_id, id_pre, id_next
        if isempty(id_next)
            disp("hello")
        end 
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