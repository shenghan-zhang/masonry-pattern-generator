classdef Polygon
    properties
        coords        % array containing points  
        nodes_id         % array containing the node id
        coords_edge   %
        is_on_left_edge
        is_on_right_edge
        is_on_up_edge
        is_on_down_edge
        lines % contain three coulumns, the first is line number, 
              % the next two are the nodes
        nb_surface
        xy_min_max
        nb_point     % this is actually the number of points in a polygon +1
        pos_ind
        nb_on_edge
        nb_edge
    end
    
    methods
        function obj = Polygon(mat_coords)
            if nargin > 0
                obj.coords = mat_coords; 
                %%
                % set all the parameters 
                %obj.xy_min_max = UseData.Data;
                [obj.nb_point, dim] = size(obj.coords); 
                obj.is_on_left_edge = false;
                obj.is_on_right_edge = false;
                obj.is_on_up_edge = false;
                obj.is_on_down_edge = false;      
                obj.pos_ind = zeros(obj.nb_point,4); % indicate if on the boundary 
                                                     % (left, right, down, up)
                obj.nb_on_edge = 0; 
                obj = obj.adjustCoord();
                obj = adjustSeq(obj);
                obj = obj.setNodeLineInfo(); 
%                obj = reduceEdge(obj);
                %obj = reduceEdge(obj);
            end 
        end
       
        function obj = adjustCoord(obj)
            obj.xy_min_max = obj.setgetVar();
            x_min = obj.xy_min_max(1);
            x_max = obj.xy_min_max(2);
            y_min = obj.xy_min_max(3);
            y_max = obj.xy_min_max(4);            
            tol = (x_max-x_min)/1000; 
            tol2 = (x_max-x_min)/1000; 
            for i = 1:obj.nb_point
                coord = obj.coords(i,:); 
                if abs(coord(1)-x_min)<tol
                    obj.coords(i,1) = x_min;
                    obj.is_on_left_edge = true;
                    obj.pos_ind(i,1) = 1; 
                    if abs(obj.coords(i,2)-y_min)<tol2
                        obj.coords(i,2) = y_min;
                    elseif abs(obj.coords(i,2)-y_max)<tol2
                        obj.coords(i,2) = y_max;
                    end
                end 
                if abs(coord(1)-x_max)<tol
                    obj.coords(i,1) = x_max;
                    obj.is_on_right_edge = true;
                    obj.pos_ind(i,2) = 1;
                    if abs(obj.coords(i,2)-y_min)<tol2
                        obj.coords(i,2) = y_min;
                    elseif abs(obj.coords(i,2)-y_max)<tol2
                        obj.coords(i,2) = y_max;
                    end                    
                end 
                if abs(coord(2)-y_min)<tol
                    obj.coords(i,2) = y_min;
                    obj.is_on_down_edge = true; 
                    obj.pos_ind(i,3) = 1;     
                    if abs(obj.coords(i,1)-x_min)<tol2
                        obj.coords(i,1) = x_min;
                    elseif abs(obj.coords(i,1)-x_max)<tol2
                        obj.coords(i,1) = x_max;
                    end
                end 
                if abs(coord(2)-y_max)<tol
                    obj.coords(i,2) = y_max;
                    obj.is_on_up_edge = true;
                    obj.pos_ind(i,4) = 1; 
                    if abs(obj.coords(i,1)-x_min)<tol2
                        obj.coords(i,1) = x_min;
                    elseif abs(obj.coords(i,1)-x_max)<tol2
                        obj.coords(i,1) = x_max;
                    end                    
                end 
            end 
           obj.nb_edge = double(obj.is_on_left_edge) + double(obj.is_on_right_edge) + ...
                  + double(obj.is_on_up_edge) + double(obj.is_on_down_edge); 
           if obj.nb_edge > 2.5
               error('There is something wrong with the stone, it seems to have been in contact with at lease three edges')
           end
           nb_sum = sum(sum(obj.pos_ind)); 
           obj.nb_on_edge = nb_sum; 
        end
        
        function out_node_id = findNodeOnCoord(obj,coord)
            tol = 1e-6;
            out_node_id = 0; 
            for i = 1:obj.nb_point-1 
                if norm(obj.coords(i,:)-coord)<tol
                    out_node_id = obj.nodes_id(i);
                    break
                end
            end
           
        end
        function out_coord = findCoordOnNodeID(obj,NodeID)
            out_coord = -1; 
            for i = 1:obj.nb_point-1 
                if (obj.nodes_id(i) == NodeID)
                    out_coord = obj.coords(i,:);
                    break
                end
            end
            if (out_coord==-1)
            error('cound not find the node')
            end
        end
        function node_coords_misssing = addMissingNode(obj,coord1,coord2)
                        tol = 1e-6;
            node_coords_misssing = []; 
            pos_1 = [];
            pos_2 = []; 
            coord1_on_boun = false; 
            coord2_on_boun = false; 
            for i = 1:obj.nb_point % note that it is possible that one of coord is on the first node 
                                   % such that pos_1 or pos_2 has length 2  
                if norm(obj.coords(i,:)-coord1)<tol
                   pos_1 = [pos_1 i]; 
                   coord1_on_boun = true; 
                end
                if norm(obj.coords(i,:)-coord2)<tol
                   pos_2 = [pos_2 i]; 
                   coord2_on_boun = true; 
                end
            end
            if (coord1_on_boun && coord2_on_boun)
                if min(abs(pos_1-pos_2))>1
                    % fill in the nodes in the opposite direction 
                    start_pos = pos_1(end); 
                    end_pos = pos_2(1); 
                    if start_pos > end_pos
                        for i = 1:(start_pos-end_pos-1)
                            node_coords_misssing = [node_coords_misssing
                                                   obj.coords(start_pos-i,:)];
                        end 
                    elseif start_pos < end_pos
                        for i = 1:start_pos-1 % add points before starting point  
                            node_coords_misssing = [node_coords_misssing
                                                   obj.coords(start_pos-i,:)];                           
                        end 
                        for i = (end_pos+1):obj.nb_point % add points id after end point 
                            node_coords_misssing = [node_coords_misssing
                                                   obj.coords(i,:)];                              
                        end 
                    elseif start_pos < end_pos
                        error('input two points the same?')
                    end
                    
                   

                end
            end

            
        end 
        function out_line_id = findLineOnCoord(obj,coord1,coord2) 
            node_id_1 = obj.findNodeOnCoord(coord1);
            node_id_2 = obj.findNodeOnCoord(coord2);
            out_line_id = 0;
            for i = 1:obj.nb_point-1 
                line_id = obj.lines(i,2:3);
                if (sum(line_id==[node_id_1,node_id_2])==2)
                    out_line_id = obj.lines(i,1); 
                elseif (sum(line_id==[node_id_2,node_id_1])==2)
                    out_line_id = -obj.lines(i,1);    
                end
            end
        end
        
        function obj = adjustSeq(obj)
            %%
            if sum(obj.pos_ind(1,:)) == 0
                    
            else % for the ease of reducation, the polygon shall start from 
                 % a point which is not on the boundary 
                 for i = 2:obj.nb_point
                     if sum(obj.pos_ind(i,:))==0
                         % find a new starting point 
                         coords2 = zeros(obj.nb_point,2);
                         coords2(1:(obj.nb_point-i),:) = obj.coords(i:end-1,:); % i:nb_point-1 --> 1:nb_point-i                                                  
                         coords2((obj.nb_point-i+1):obj.nb_point,:) = obj.coords(1:i,:); % 1:i -> nb_point-i+1: nb_point
                                                                          % Note that here the i appeared twice
                         obj.coords = coords2;    
                         
                         
                         pos_ind2 = zeros(obj.nb_point,4);
                         pos_ind2(1:(obj.nb_point-i),:) = obj.pos_ind(i:end-1,:); % i:nb_point-1 --> 1:nb_point-i                                                  
                         pos_ind2((obj.nb_point-i+1):obj.nb_point,:) = obj.pos_ind(1:i,:); % 1:i -> nb_point-i+1: nb_point
                                                                          % Note that here the i appeared twice
                         obj.pos_ind = pos_ind2;                                             
                         break 
                     end 
                 end 
            end
            %%
            % for the stones that have been cut on one edge 
            % find the first, find the last
            [start_p,end_p] = findStartEnd(obj);
            
            if (0.5<obj.nb_edge)&&(obj.nb_edge<1.5)
                % check if we the add coords add between the two points 
                obj.pos_ind(start_p+1:end_p-1,:)=[]; 
                obj.coords(start_p+1:end_p-1,:)=[]; 
                obj = obj.addCoords([start_p]); 
%                 x_min = obj.xy_min_max(1);
%                 x_max = obj.xy_min_max(2);
%                 y_min = obj.xy_min_max(3);
%                 y_max = obj.xy_min_max(4);
%                 coords_corner = [x_min y_min
%                                  x_max y_min
%                                  x_max y_max
%                                  x_min y_max];
%                 tolerence = 0.005; 
%                 for ss = 1:4 
%                     if norm(coords_corner(ss,:)-obj.coords(start_p+1:end_p-1,:))
%                     end 
%                     if 
%                     end 
%                 end 
            elseif (1.5<obj.nb_edge)&&(obj.nb_edge<2.5) 
                obj.xy_min_max = obj.setgetVar();
                x_min = obj.xy_min_max(1);
                x_max = obj.xy_min_max(2);
                y_min = obj.xy_min_max(3);
                y_max = obj.xy_min_max(4);      
                if obj.is_on_left_edge&&obj.is_on_down_edge
                    corner_point = [x_min,y_min];
                    indicate_edges = [1 0 1 0];
                elseif obj.is_on_right_edge&&obj.is_on_down_edge
                    corner_point = [x_max,y_min];
                    indicate_edges = [0 1 1 0];
                elseif obj.is_on_right_edge&&obj.is_on_up_edge
                    corner_point = [x_max,y_max];
                    indicate_edges = [0 1 0 1];
                elseif obj.is_on_left_edge&&obj.is_on_up_edge
                    corner_point = [x_min,y_max];
                    indicate_edges = [1 0 0 1];
                end
                if ~((norm(corner_point-obj.coords(start_p,:))<0.00001)||(norm(corner_point-obj.coords(end_p,:))<0.00001))
                obj.pos_ind = [ obj.pos_ind(1:start_p,:)
                                indicate_edges
                                obj.pos_ind(end_p:end,:)]; 
                            
                obj.coords = [obj.coords(1:start_p,:)
                              corner_point
                              obj.coords(end_p:end,:)]; 
                obj = obj.addCoords([start_p,start_p+1]);      
                else
                obj.pos_ind(start_p+1:end_p-1,:)=[]; 
                obj.coords(start_p+1:end_p-1,:)=[]; 
                obj = obj.addCoords([start_p]); 
                end 
                
            end 
            [obj.nb_point, dim] = size(obj.coords); 
            [start_p,end_p] = findStartEnd(obj);
           %%
            % for the stones that situated in the corner 
            % find the first, find the last, add one point
            
           %%
            % resampling the stones 
            % calculating the nb of points needed 
            tot_length = 0;
%             end_p = start_p+int16(obj.nb_edge); 
            obj.nb_point

            if (end_p == obj.nb_point)
                end_p = 1;
            end 
            if (max(obj.pos_ind(end_p+1,:))>0.5)
                % in case of adding a point, starting point end_p also increase 1
                error('shouldnt be this value'); 
            end
            for i = 1:obj.nb_point
                j = mod((end_p+i-2),obj.nb_point-1)+1;
                k = mod((end_p+i-1),obj.nb_point-1)+1; % 
                tot_length = tot_length + norm(obj.coords(j,:)-obj.coords(k,:)); 
                if k == start_p
                    break
                end
            end 
            % calculating the total length (on the edge)
                
            % calculate how many points are needed 
            
            if int16(obj.nb_edge)==1
                nb_p_min = 2;
            elseif int16(obj.nb_edge)==2
                nb_p_min = 1; 
            else 
                nb_p_min = 3;                 
            end
            resampling_len = 0.02;% for elps elps2 0.02;%for A-E 0.05; 
            nb_points_cal = floor(tot_length / resampling_len); 
            if (nb_points_cal < nb_p_min)
                nb_points_cal = nb_p_min; 
            end
            
            resampling_len_real = tot_length/(nb_points_cal+1); 
            nb_i = 0;
            coords_resampled = []; 
            coords_edge_resampled =[];
            span = 0;
            length_ = 0.;
            for i = 1:obj.nb_point
                j = mod((end_p+i-2),obj.nb_point-1)+1;
                k = mod((end_p+i-1),obj.nb_point-1)+1; %
                if i==1
                    coords_resampled = obj.coords(j,:);
                    pos_ind_resampled = obj.pos_ind(j,:);
                end
                
                length_ = length_ + norm(obj.coords(j,:)-obj.coords(k,:));
                if length_ > (nb_i+1)*resampling_len_real
                    nb_i = nb_i+1;
                    if (k-span)<=0
                        disp('k-span<0');
                    end
                    if (span==0)
                        new_point = obj.coords(k,:);                        
                    else
                        new_point = mean(obj.coords(k-span:k+span,:));
                    end
                    coords_resampled = [coords_resampled
                        new_point];
                    pos_ind_resampled = [pos_ind_resampled
                        obj.pos_ind(k,:)];
                end
                if nb_i>=nb_points_cal
                    break
                end
                if k == start_p
                    msg = 'sth is wrong, it should reach this far';
                    error(msg);
                end
            end
            
            if int16(obj.nb_edge)==0
              %%
                % 
                 coords_resampled = [coords_resampled
                                     coords_resampled(1,:)];
                 pos_ind_resampled = [pos_ind_resampled
                                      pos_ind_resampled(1,:)];              
            else
              %%
                %   
                 coords_resampled = [coords_resampled
                                     obj.coords(start_p:end_p-1,:)  
                                     coords_resampled(1,:)];
                 pos_ind_resampled = [pos_ind_resampled
                                         obj.pos_ind(start_p:end_p-1,:) 
                                          pos_ind_resampled(1,:)];                                
            end 
            
            % starting from the last point in the sequence, ending in the
            % first point in the sequence
            obj.coords = coords_resampled; 
            obj.pos_ind = pos_ind_resampled; 
            [obj.nb_point, dim] = size(obj.coords); 
        end
        function obj = setNodeLineInfo(obj)
            [out_node_nb, out_line_nb, out_surface_nb] = obj.setNodeLineSurfaceNb();
            obj.nodes_id = zeros(obj.nb_point-1,1); 
            for i = 1:obj.nb_point-1
                out_node_nb = out_node_nb + 1; 
                obj.nodes_id(i) = out_node_nb;
            end
            
            obj.lines = zeros(obj.nb_point-1,3);
            for i = 1:obj.nb_point-1
                out_line_nb = out_line_nb + 1; 
                obj.lines(i,1) = out_line_nb; 
                obj.lines(i,2) = obj.nodes_id(i);
                if i == obj.nb_point-1
                    obj.lines(i,3) = obj.nodes_id(1); 
                else
                    obj.lines(i,3) = obj.nodes_id(i+1);
                end
            end
            obj.setNodeLineSurfaceNb(out_node_nb, out_line_nb, out_surface_nb); 
        end 
        function reduceEdge(obj)
            %%
            % for a sequece of points 
            % reduce by sequence 
            % reduce by top / end 
            if (obj.is_on_left_edge)
            
            end
            
            if (obj.is_on_right_edge)
            
            end
            
            if (obj.is_on_down_edge)
            
            end
            
            if (obj.is_on_up_edge)
            
            end            
            
        end         
        
        function getInternalLines(Obj)
            %%
            % 
            % 
            
            
        end 
        
        function plot(Obj)
            %%
            %
            %
            
            
            
        end
        function obj = writeGmsh(obj,fileID,content)
            %%
            [out_node_nb, out_line_nb, out_surface_nb] = obj.setNodeLineSurfaceNb();
            % write node info
            if (strcmp(content,'node_info'))
                for i = 1:obj.nb_point-1    
                    formatSpec = 'Point(%d) = {%f, %f, 0, h};\n';
                    fprintf(fileID, formatSpec, obj.nodes_id(i), obj.coords(i,1), obj.coords(i,2));
                end
            end
            % write line info
            if (strcmp(content,'line_info'))
                for i = 1:obj.nb_point-1   
                     formatSpec = 'Line(%d) = {%d, %d};\n';
                     fprintf(fileID, formatSpec, obj.lines(i,1), obj.lines(i,2), obj.lines(i,3));
                end 
            end
            % write surface info
            if (strcmp(content,'surface_info'))
                out_line_nb = out_line_nb+1;    
                fprintf(fileID, 'Line Loop(%d) = {',out_line_nb);
                for i = 1:obj.nb_point-1   
                    fprintf(fileID, '%d', obj.lines(i,1));
                    if i==obj.nb_point-1
                       % in case of the last point
                       fprintf(fileID, '};\n');
                    else
                            % 
                       fprintf(fileID, ', ');
                    end    
                end 
                formatSpec = 'Plane Surface(%d) = {%d};\n'; 
                obj.nb_surface = out_line_nb;
                fprintf(fileID, formatSpec,out_line_nb,-out_line_nb);
                obj.setNodeLineSurfaceNb(out_node_nb, out_line_nb, out_surface_nb); 
            end
        end
        
        function obj = addCoords(obj,ind_check)
            tol = 1e-3; 
            mz = 0.05; % mesh_size
            [add_coords, is_on_stone] = obj.setAddCoords(); 
            if isempty(add_coords)
                return
            end
            nb_add_node = size(add_coords,1); 
            nb_check_point = length(ind_check); 
            
            for i = 1:nb_add_node
                coords_i = add_coords(i,:); 
                for h = 1: nb_check_point
                    j = ind_check(h);
                   % check if that point lies within (check point check point +1)
                   % check to which edge that we are right now 
                   p_start = obj.coords(j,:);
                   p_end = obj.coords(j+1,:);
                   ind_start = obj.pos_ind(j,:);
                   ind_end = obj.pos_ind(j+1,:); 
                   ind_avg = (ind_start+ind_end); 
                   [M,M_indice] = max(ind_avg);
                   if (M~=2)
                       error('The two points seems to be not on the same edge, please check'); 
                   end
                   
                   if (M_indice == 1)||(M_indice == 2) % when it is on the left or right edge
                      if abs(coords_i(1)-p_start(1))<tol
                          if (p_start(2)-coords_i(2))*(coords_i(2)-p_end(2))>0
                              disp(sprintf('Found the edge containing point (%f, %f)',coords_i(1),coords_i(2)));
                              % adjust the coordate that is the in the
                              % midle of the two points 
                              [adj_p, add_point] = adjustAddCoord(p_start(2), p_end(2), coords_i(2), mz); 
                              if add_point
                                  obj.coords = [obj.coords(1:j,:); coords_i; obj.coords(j+1:end,:)];   
                                  % here we return because we assume that
                                  % for each stone, we only add one point 
                                  obj.pos_ind = [ obj.pos_ind(1:j,:)
                                                  obj.pos_ind(j,:)+obj.pos_ind(j+1,:)-max(obj.pos_ind(j:j+1,:))  % what is left in this expression is the common edge
                                                  obj.pos_ind(j+1:end,:)]; 
                                  is_on_stone(i) = true;     
                                  obj.setAddCoords(add_coords, is_on_stone);    
                                  return 
                              else
                                  add_coords(i,2) = adj_p;  
                                  is_on_stone(i) = true; 
                                  obj.setAddCoords(add_coords, is_on_stone);
                                  return 
                              end 
                          end 
                      end
                   elseif (M_indice == 3)||(M_indice == 4) % when it is on the down or up edge
                      if abs(coords_i(2)-p_start(2))<tol
                          if (p_start(1)-coords_i(1))*(coords_i(1)-p_end(1))>0
                              disp(sprintf('Found the edge containing point (%f, %f)',coords_i(1),coords_i(2)));
                              [adj_p, add_point] = obj.adjustAddCoord(p_start(1), p_end(1), coords_i(1), mz);    
                              if add_point
                                  obj.coords = [obj.coords(1:j,:); coords_i; obj.coords(j+1:end,:)];  
                                  obj.pos_ind = [ obj.pos_ind(1:j,:)
                                                  obj.pos_ind(j,:)+obj.pos_ind(j+1,:)-max(obj.pos_ind(j:j+1,:))
                                                  obj.pos_ind(j+1:end,:)]; 
                                  is_on_stone(i) = true;  
                                  obj.setAddCoords(add_coords, is_on_stone);
                                  % here we return because we assume that
                                  % for each stone, we only add one point 
                                  return 
                              else
                                  add_coords(i,1) = adj_p;  
                                  is_on_stone(i) = true;                                   
                                  obj.setAddCoords(add_coords, is_on_stone);
                                  return 
                              end                               
                              
                          end
                      end
                   end 
                end 
            end
        end
        
        function [adj_p, add_point] = adjustAddCoord(obj,coord_s, coord_e, coord_p, mz)
            % if the two points are two close (less than mz), ajust the point to one of the
            % points
            
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
        
        function [start_p,end_p] = findStartEnd(obj)
            flag = 0;
            start_p = 1; 
            end_p  = 1;
            for i = 2:obj.nb_point
                if sum(obj.pos_ind(i,:)) ~= 0
                    for j = 2:obj.nb_point
                        ii = obj.nb_point-j+1;
                        if sum(obj.pos_ind(ii,:)) ~= 0
                           start_p = i;                 
                           end_p = ii; 
                           flag = 1;
                           break
                        end
                    end 
                end
                if (flag==1)
                    break 
                end
            end
        end
    end
    

    methods (Static)
      function out = setgetVar(data)
         persistent Var;
         if nargin
            Var = data;
         end
         out = Var;
      end
    end
    methods (Static)
        function [out_node_nb, out_line_nb, out_surface_nb] = setNodeLineSurfaceNb(in_node_nb,in_line_nb,in_surface_nb)
            persistent node_nb;
            persistent line_nb;
            persistent surface_nb;
            if nargin
                node_nb = in_node_nb;
                line_nb = in_line_nb;
                surface_nb = in_surface_nb;
            end
            out_node_nb = node_nb;
            out_line_nb = line_nb;
            out_surface_nb = surface_nb; 
        end
    end
    
    methods (Static)
        function [out_add_coords, out_is_on_stone]= setAddCoords(in_add_coords, in_is_on_stone)
            persistent add_coords;
            persistent is_on_stone; 
            if nargin
                add_coords = in_add_coords; 
                is_on_stone = in_is_on_stone; 
            end
            out_add_coords = add_coords; 
            out_is_on_stone = is_on_stone; 
        end
    end
end