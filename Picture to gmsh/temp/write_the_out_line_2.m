function write_the_out_line_2(xd,yd,fileID,object_array,add_boundary)
    n = length(xd);
    [out_node_nb, out_line_nb, out_surface_nb] = Polygon.setNodeLineSurfaceNb(); 
    nb_poly = length(object_array);
 
    xy_min_max = Polygon.setgetVar();
    x_min = xy_min_max(1); x_max = xy_min_max(2); y_min = xy_min_max(3); y_max = xy_min_max(4); 
    % add coords 
    
    %%
    % in the following function, we loop over the outline for the specimen
    % the problem is that for points are along a line in the stone, it
    % seems to be omitted. Here in this section we add these omitted points
    insert_chunks = {}; 
    insert_position = []; 
    nb_insert = 0; 
%     insert_chunks_obj = [];
    tolerence = 1.0e-4; 
    for i = 1:n-1
        coord_p1 = [xd(i), yd(i)];
        coord_p2 = [xd(i+1), yd(i+1)];
        for j = 1: nb_poly
           poly_j = object_array{j};
           node_coords_misssing = poly_j.addMissingNode(coord_p1,coord_p2);
           if ~isempty(node_coords_misssing)
              nb_insert = nb_insert+1; 
              insert_chunks{nb_insert} = node_coords_misssing;
              insert_position = [insert_position i]; 
              break
           end
        end        
    end
    
    if nb_insert>0
        new_xd_yd = insertChunks(xd, yd, nb_insert, insert_position, insert_chunks);
        xd = new_xd_yd(:,1);
        yd = new_xd_yd(:,2);       
    end
    
    %% do another loop to find the remining point 
    [add_coords, is_on_stone] = Polygon.setAddCoords();
    nb_add_nodes = length(is_on_stone); 
    n = length(xd);
    mz = 0.05; 
    nb_insert = 0;
    insert_position = []; 
    insert_chunks = {}; 
    for k=1:nb_add_nodes
        if ~is_on_stone(k)
            coord_k = add_coords(k,:); 
            for i = 1:n-1
                coord_p1 = [xd(i), yd(i)];
                coord_p2 = [xd(i+1), yd(i+1)];
                if (abs(coord_k(2)-yd(i))<tolerence)&&(abs(coord_k(2)-yd(i+1))<tolerence)
                    if (coord_k(1)-coord_p1(1))*(coord_p2(1)-coord_k(1))>0
                       %%
                        [adj_p, add_point] = adjustAddCoord(coord_p1(1), coord_p2(2), coord_k(1), mz); 
                        if add_point
                           nb_insert = nb_insert + 1;
                           insert_position = [insert_position i];
                           insert_chunks{nb_insert} = coord_k; 
                        else
                           add_coords(i,1) = adj_p;         
                        end  
                    end
                end 
            end
        end 
    end 
    
    if nb_insert>0
        new_xd_yd = insertChunks(xd, yd, nb_insert, insert_position, insert_chunks);
        xd = new_xd_yd(:,1);
        yd = new_xd_yd(:,2);       
    end
    
    %% 
    % here we start to see whether a node already existed (should be apart 
    % from four corner points). If existed, we record the value, if not existed, 
    % we add a new value 
    
    n = length(xd);
    nodes_contour_IDs = zeros(n,1);
    Node_ID_pos = [];
    for i = 1:n-1
        % for the first loop find all points 
        coord_p = [xd(i), yd(i)];
        node_ID = 0;    
        for j = 1:nb_poly
            poly_j = object_array{j};
            node_ID = poly_j.findNodeOnCoord(coord_p);
            if node_ID > 0
                nodes_contour_IDs(i)= node_ID; 
                break
            end
        end
        node_ID = glbFindNodeOnCoord(object_array,coord_p);                
        if node_ID == 0
            % this means that the node does not exist
            % 
            out_node_nb = out_node_nb+1;
            nodes_contour_IDs(i)= out_node_nb; 
            formatSpec = 'Point(%d) = {%f, %f, 0, h};\n';
            fprintf(fileID, formatSpec, out_node_nb, coord_p(1), coord_p(2));
            Node_ID_pos = [Node_ID_pos; out_node_nb, coord_p(1), coord_p(2)];
        else
            nodes_contour_IDs(i)= node_ID; 
        end
    end
    nodes_contour_IDs(end) = nodes_contour_IDs(1);
    
    %% Based on node ID, check if a line exist, otherwise increase the line ID 
    lines_IDs = zeros(n-1,1); 
    count_line = 0; 
    lines_contour = []; 
    for i = 1:n-1
        coord_p1 = [xd(i), yd(i)];
        coord_p2 = [xd(i+1), yd(i+1)];
        for j = 1: nb_poly
           poly_j = object_array{j};
           line_ID = poly_j.findLineOnCoord(coord_p1,coord_p2); 
           if line_ID~=0
               count_line = count_line+1; 
               break
           end 
        end
        if line_ID == 0
           out_line_nb = out_line_nb+1;      
           line_ID = out_line_nb; 
           formatSpec = 'Line(%d) = {%d, %d};\n';
           fprintf(fileID, formatSpec, out_line_nb, nodes_contour_IDs(i), nodes_contour_IDs(i+1)); 
           lines_contour = [lines_contour; line_ID coord_p1 coord_p2 (coord_p1+coord_p2)/2];% Note that this is different from the Polygon class
        end
        lines_IDs(i) = line_ID; 
    end
    
    out_line_nb = out_line_nb+1;        
    fprintf(fileID, 'Line Loop(%d) = {',out_line_nb);
    for i = 1:n-1   
        fprintf(fileID, '%d', lines_IDs(i,1));
        if i==n-1
        % in case of the last point
            fprintf(fileID, '};\n');
        else
            fprintf(fileID, ', ');
        end    
    end 
    formatSpec = 'Plane Surface(%d) = {%d';
    
    fprintf(fileID, formatSpec,out_line_nb,-out_line_nb);
    
    for j = 1:nb_poly
        poly_j = object_array{j};
        if ~poly_j.nb_edge
          formatSpec = ', %d';
          fprintf(fileID, formatSpec,poly_j.nb_surface);      
        end
    end
    fprintf(fileID, '};\n');
    
    surface_brick=[]; 
    for j = 1:nb_poly
        poly_j = object_array{j};
        nb_surf = poly_j.nb_surface;
        surface_brick = [surface_brick nb_surf];
    end
    allOneString = sprintf('%.0f,' , surface_brick);
    allOneString = allOneString(1:end-1);% strip final comma
    formatSpec = 'Physical Surface("brick") = {%s};\n';
    fprintf(fileID, formatSpec, allOneString);
    
    formatSpec = 'Physical Surface("mortar") = {%d};';
    fprintf(fileID, formatSpec, out_line_nb);
    
%     coord_start = [x_max,y_max]; 
%     coord_end = [x_min,y_max]; 
%     coords_add = [x_max, y_max+0.1*(y_max-y_min);
%                   x_min, y_max+0.1*(y_max-y_min)];
%     on_edge = 'top';
%    % write_info_load_beam(object_array, lines_contour, coord_start, coord_end, coords_add, on_edge, nodes_contour_IDs)
%     [nodes_load_IDs, lines_contour, out_node_nb, out_line_nb] = write_info_load_beam(fileID, object_array, lines_contour, Node_ID_pos, out_node_nb, out_line_nb, coord_start, coord_end, coords_add, on_edge, nodes_contour_IDs);
    if (add_boundary==2)
    coord_start = add_coords(2,:);
    coord_end = add_coords(1,:);
    coords_add = [add_coords(2,1), add_coords(2,2)+0.1*(y_max-y_min);
                  add_coords(1,1), add_coords(1,2)+0.1*(y_max-y_min)];
    on_edge = 'top';
   % write_info_load_beam(object_array, lines_contour, coord_start, coord_end, coords_add, on_edge, nodes_contour_IDs)
    [nodes_load_IDs, lines_contour, out_node_nb, out_line_nb, surface_1] = write_info_load_beam(fileID, object_array, lines_contour, Node_ID_pos, out_node_nb, out_line_nb, coord_start, coord_end, coords_add, on_edge, nodes_contour_IDs);

    coord_start = add_coords(3,:);
    coord_end = add_coords(4,:);
    coords_add = [add_coords(3,1), add_coords(3,2)-0.1*(y_max-y_min);
                  add_coords(4,1), add_coords(4,2)-0.1*(y_max-y_min)];
    on_edge = 'bot';
   % write_info_load_beam(object_array, lines_contour, coord_start, coord_end, coords_add, on_edge, nodes_contour_IDs)
    [nodes_load_IDs, lines_contour, out_node_nb, out_line_nb, surface_2] = write_info_load_beam(fileID, object_array, lines_contour, Node_ID_pos, out_node_nb, out_line_nb, coord_start, coord_end, coords_add, on_edge, nodes_contour_IDs);
    
    formatSpec = 'Physical Surface("steel") = {%d, %d};\n';
    fprintf(fileID, formatSpec, surface_1, surface_2);
    elseif (add_boundary==1)
    coord_start = add_coords(2,:);
    coord_end = add_coords(1,:);
    coords_add = [add_coords(2,1), add_coords(2,2)+0.1*(y_max-y_min);
                  add_coords(1,1), add_coords(1,2)+0.1*(y_max-y_min)];        
    on_edge = 'top';
    [nodes_load_IDs, lines_contour, out_node_nb, out_line_nb, surface_1] = write_info_load_beam(fileID, object_array, lines_contour, Node_ID_pos, out_node_nb, out_line_nb, coord_start, coord_end, coords_add, on_edge, nodes_contour_IDs);
    formatSpec = 'Physical Surface("steel") = {%d};\n';
    fprintf(fileID, formatSpec, surface_1);    
    end
end

function node_ID = glbFindNodeOnCoord(object_array,coord_p)
        node_ID = 0; 
        nb_poly = length(object_array);
        for j = 1:nb_poly
            poly_j = object_array{j};
            node_ID = poly_j.findNodeOnCoord(coord_p);
            if node_ID > 0
%                 nodes_contour_IDs(i)= node_ID; 
                break
            end
        end
end

function [nodes_load_IDs, lines_contour, out_node_nb, out_line_nb, surface_steel] = write_info_load_beam(fileID, object_array, lines_contour, Node_ID_pos, out_node_nb, out_line_nb, coord_start, coord_end, coords_add, on_edge, nodes_contour_IDs)
    %% here we define the contour of the steel beam
    tol = 1e-3;
    % based on the pos info of the points, it could be 
    %       top p_end    p_start
    %  left                    right
    %   p_start                  p_end
    %
    %   p_end                    p_start
    %       bot p_start  p_end
    x1 = coord_start(1);
    y1 = coord_start(2); 
    x2 = coord_end(1); 
    y2 = coord_end(2); 
    x_min = min(x1,x2);
    x_max = max(x1,x2); 
    y_min = min(y1,y2); 
    y_max = max(y1,y2); 
    region = [x_min-tol x_max+tol y_min-tol y_max+tol];

    %% relect lines both in at the boundary of the stones and the contour 
    % boundary the selected lines are put in the array select_lines and
    % than sorted with line_region 
    
    [select_lines] = selectLinesInRegion(object_array, region); 
    [nb_lines_contour, temp] = size(lines_contour);
    for l = 1:nb_lines_contour
        line = lines_contour(l,:);
        if (region(1)<line(end-1))&&(region(2)>line(end-1))&&(region(3)<line(end))&&(region(4)>line(end))
            select_lines = [select_lines;line];
        end
    end
    [nb_lines_in_region, temp] = size(select_lines);
%     sort_dir = 'x';
    % remember that the structure of line_region has the following
    % component 1 line_ID 2 p1_x 3 p1_y 4 p2_x 5 p2_y 6 avg_x 7 avg_y     
    switch on_edge   
        case 'top'
          sort_ind = 6;
          ind_start = 2;
          ind_end = 4;    
          dirc = 'ascend'; 
        case 'bot'
          sort_ind = 6;
          ind_start = 2;
          ind_end = 4;    
          dirc = 'descend';             
        case 'left'
          sort_ind = 7;
          ind_start = 3;
          ind_end = 5;    
          dirc = 'ascend';               
        case 'right'
          sort_ind = 7;
          ind_start = 3;
          ind_end = 5;    
          dirc = 'descend';              
    end 
    
    select_lines_sorted = sortrows(select_lines, sort_ind,dirc);
    line_region = [];
    for l = 1:nb_lines_in_region
        line = select_lines_sorted(l,:);
        if ((line(ind_start)<line(ind_end))&&(strcmp(dirc,'ascend')))||...
                ((line(ind_start)>line(ind_end))&&(strcmp(dirc,'descend')))
            line_region = [line_region; line(1)];
        else     
            line_region = [line_region; -line(1)];
        end
    end
    
    %% add two nodes three lines
    %% coords to be added 

    nodes_load_IDs = [];
    nb_nodes_to_be_add = size(coords_add,1); 
    for n = 1:nb_nodes_to_be_add
        out_node_nb = out_node_nb+1;
        nodes_load_IDs(n)= out_node_nb;
        formatSpec = 'Point(%d) = {%f, %f, 0, h2};\n';
        fprintf(fileID, formatSpec, out_node_nb, coords_add(n,1), coords_add(n,2));
    end
%     coord_start = [x_max y_max];
%     coord_end = [x_min y_max]; 
    nb_obj = length(object_array); 
    
    node_ID_start = glbFindNodeOnCoord(object_array,coord_start);  
    node_ID_end = glbFindNodeOnCoord(object_array,coord_end);  
    if (node_ID_start==0)
        node_ID_start = findNodeOnLineContour(coord_start,Node_ID_pos);
    end
    if (node_ID_end==0)
        node_ID_end = findNodeOnLineContour(coord_end,Node_ID_pos);
    end
    if (node_ID_start==0)||(node_ID_end==0)
        error('starting point or ending point does not existed')
    end
    nodes_load_IDs = [node_ID_start, nodes_load_IDs, node_ID_end]; 
    
        %% furhter modify line_region to constitute line loop
    for n = 1:nb_nodes_to_be_add+1
        out_line_nb = out_line_nb+1;
        line_ID = out_line_nb;
        formatSpec = 'Line(%d) = {%d, %d};\n';
        fprintf(fileID, formatSpec, out_line_nb, nodes_load_IDs(n), nodes_load_IDs(n+1));
%         if (n == 2)
%         disp("add physical line name for the second line added of the loading shoe"); 
%         if (on_edge == 'top')
%            formatSpec = 'Physical Line("up") = {%d};\n';
%            fprintf(fileID, formatSpec, line_ID);            
%         elseif (on_edge == 'bot')
%            formatSpec = 'Physical Line("down") = {%d};\n';
%            fprintf(fileID, formatSpec, line_ID);                
%         end 
%         end
        line_region = [line_region; line_ID];% Note that this is different from the Polygon class
    end
    %% writing the geometry information 
    allOneString = sprintf('%.0f,' , line_region);
    allOneString = allOneString(1:end-1);% strip final comma
    out_line_nb = out_line_nb+1;        
    fprintf(fileID, 'Line Loop(%d) = {%s};\n',out_line_nb,allOneString);
    formatSpec = 'Plane Surface(%d) = {%d};\n';
    fprintf(fileID, formatSpec,out_line_nb,out_line_nb);   
    surface_steel = out_line_nb;
    
end

function NodeID = findNodeOnLineContour(ref_coord,Node_ID_pos)
    tol = 1e-3;    
    nb_node = size(Node_ID_pos,1);
    NodeID = 0;      
    for i = 1:nb_node
        node_coord = Node_ID_pos(i,2:3);
        if norm(node_coord-ref_coord)<tol
            NodeID = Node_ID_pos(i);
            break
        end
    end
end

function [adj_p, add_point] = adjustAddCoord(coord_s, coord_e, coord_p, mz)
            % Duplication with the function within the class
            
            % get the closest distance of the point of Point p with Point
            % start and Point end. 
            dis_s = abs(coord_p-coord_s); 
            dis_e = abs(coord_p-coord_e);
            [min_dis,I_min] = min([dis_s,dis_e]); 
            if min_dis < 0.5*mz
                if I_min == 1
                   adj_p = coord_s;
                   add_point = false;
                   return;  
                elseif I_min == 2
                   adj_p = coord_e;
                   add_point = false;
                   return; 
                end 
            else
               adj_p = coord_p; 
               add_point = true;
               return; 
            end
end  

function new_xd_yd = insertChunks(xd, yd, nb_insert, insert_position, insert_chunks)
    if nb_insert >0
        new_xd_yd = [xd(1:insert_position(1)) yd(1:insert_position(1))];
        for i = 1:nb_insert
            new_xd_yd = [new_xd_yd
                insert_chunks{i}];
            if i ~= nb_insert
                D = sprintf('insert chunk %d',i);
                disp(D)
                new_xd_yd = [new_xd_yd
                    xd(insert_position(i)+1:insert_position(i+1)) yd(insert_position(i)+1:insert_position(i+1))];
%             else
%                 error('not impletmented yet')
            end
        end
        new_xd_yd = [new_xd_yd
            xd(insert_position(i)+1:end,:) yd(insert_position(i)+1:end,:)];
    end 
end 