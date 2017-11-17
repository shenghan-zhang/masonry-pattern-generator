function write_the_out_line(xd,yd,fileID,object_array)
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
        new_xd_yd = [xd(1:insert_position(1)) yd(1:insert_position(1))];
        for i = 1:nb_insert
            
            new_xd_yd = [new_xd_yd
                insert_chunks{i}];
            if i ~= nb_insert
                D = sprintf('insert chunk %d',i);
                disp(D)
                new_xd_yd = [new_xd_yd
                    xd(insert_position(i)+1:insert_position(i+1)) yd(insert_position(i)+1:insert_position(i+1))];
            end
        end
        new_xd_yd = [new_xd_yd
            xd(insert_position(i)+1:end,:) yd(insert_position(i)+1:end,:)];
        xd = new_xd_yd(:,1);
        yd = new_xd_yd(:,2);
    end
    
    %% 
    % here we start to see whether a node already existed (should be apart 
    % from four corner points). If existed, we record the value, if not existed, 
    % we add a new value 
    
    n = length(xd);
    nodes_contour_IDs = zeros(n,1);
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
    
    write_info_load_beam(object_array,lines_contour, coord_start, coord_end, coords_add,on_edge)


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

function [nodes_load_IDs ] = write_info_load_beam(object_array,lines_contour, coord_start, coord_end, coords_add,on_edge)
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
    x2 = coord_p2(1); 
    y2 = coord_p2(2); 
    x_min = min(x); 
    region = [x_min-tol x_max+tol y_max-tol y_max+tol];
    switch on_edge
        case "top"
            region = [x_min-tol x_max+tol y_max-tol y_max+tol];
        case "bot"
            region = [x2-tol x1+tol y1-tol y1+tol];
        case "left"
            region =; 
        case "right"
            region =;
    end
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
    sort_dir = 'x';
    if (sort_dir == 'x')
        sort_ind = 6;
        coord_start = 2;
        coord_end = 4; 
    end
    select_lines_sorted = sortrows(select_lines, sort_ind);
    line_region = [];
    for l = 1:nb_lines_in_region
        line = select_lines_sorted(l,:);
        if line(coord_start)>line(coord_start)
            line_region = [line_region;-line(1)];
        else
            line_region = [line_region;line(1)];
        end
    end
    
    %% add two nodes three lines
    %% coords to be added 
    coords_add = [x_max, y_max+0.1*(y_max-y_min);
                  x_min, y_max+0.1*(y_max-y_min)];
    nodes_load_IDs = [];
    nb_nodes_to_be_add = size(coords_add,1); 
    for n = 1:nb_nodes_to_be_add
        out_node_nb = out_node_nb+1;
        nodes_load_IDs(n)= out_node_nb;
        formatSpec = 'Point(%d) = {%f, %f, 0, h2};\n';
        fprintf(fileID, formatSpec, out_node_nb, coords_add(n,1), coords_add(n,2));
    end
    coord_start = [x_max y_max];
    coord_end = [x_min y_max]; 
    nb_obj = length(object_array); 
    
    node_ID_start = glbFindNodeOnCoord(object_array,coord_start);  
    node_ID_end = glbFindNodeOnCoord(object_array,coord_end);  
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
        line_region = [line_region; line_ID];% Note that this is different from the Polygon class
    end
    %% writing the geometry information 
    allOneString = sprintf('%.0f,' , line_region);
    allOneString = allOneString(1:end-1);% strip final comma
    out_line_nb = out_line_nb+1;        
    fprintf(fileID, 'Line Loop(%d) = {%s};\n',out_line_nb,allOneString);
    formatSpec = 'Plane Surface(%d) = {%d};\n';
    fprintf(fileID, formatSpec,out_line_nb,out_line_nb);   
    formatSpec = 'Physical Surface("steel") = {%d};\n';
    fprintf(fileID, formatSpec, out_line_nb);
    
end