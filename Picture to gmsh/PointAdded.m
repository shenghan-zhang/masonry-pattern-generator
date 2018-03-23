classdef PointAdded
    properties
      coord
      id
      coincide = false
      modified = false
      tol = 1e-6
      on_edge = [false false false false] % the sequence is left right bottom up 
    end
    methods
      function obj = PointAdded(in_coord)
          obj.coord = in_coord; 
      end
      function obj = checkInList(obj, points)
        for i = 1:size(points,1)
             point_coord = points(i,2:3); 
             if (norm(obj.coord-point_coord)<obj.tol)
                obj.id = points(i,1); 
                obj.coincide = true;                 
             end
        end
      end
      function obj = setID(obj, in_id)
          obj.id = in_id; 
      end
      function obj = setCoord(obj, in_coord)
          obj.coord = in_coord; 
      end      
       function obj = setOnEdge(obj, in_on_edge)
          obj.on_edge = in_on_edge; 
      end          
      function [obj, points,lines,line_loops] = modifyLines(obj,points,lines,line_loops)
          % For the corner point should have been already excluded from the
          % previous function 
          obj = checkInList(obj, points);

          dis_merge = 0.02; 
          x_p = obj.coord(1);
          y_p = obj.coord(2);
          xy_min_max = obj.setgetVar(); 
          x_min = xy_min_max(1);
          x_max = xy_min_max(2);
          y_min = xy_min_max(3);
          y_max = xy_min_max(4);         
%           x_min = min(points(:,2));
%           x_max = max(points(:,2));
%           y_min = min(points(:,3));
%           y_max = max(points(:,3));
          obj = obj.setOnEdge([(norm(x_min-x_p)<obj.tol)&&((y_p>=y_min)&&(y_max>=y_p)), norm(x_max-x_p)<obj.tol&&((y_p>=y_min)&&(y_max>=y_p)), norm(y_min-y_p)<obj.tol&&((x_p>=x_min)&&(x_max>=x_p)), norm(y_max-y_p)<obj.tol&&((x_p>=x_min)&&(x_max>=x_p))]); 
          if obj.coincide 
              return
          end
          check_index = [1, 1, 2, 2]; 
          match_value = [x_min, x_max, y_min, y_max];
          pos_index = [2, 2, 1, 1];
          % judge if the point is outside the sqaure 
          if (x_p < x_min-obj.tol)||(x_p > x_max+obj.tol)||(y_p < y_min-obj.tol)||(y_p > y_max+obj.tol)
              max_node_id = max(points(:,1)); 
              obj = obj.setID(max_node_id+1); 
              % now fixed mesh size, to be improved
              points = [points
                       obj.id obj.coord 3]; 
              return    
          end
          
          for e = 1:length(obj.on_edge)
             if (~obj.on_edge(e))
                continue
             end
             c_ind = check_index(e); 
             m_val = match_value(e); 
             p_ind = pos_index(e); 
             for l = 1:size(lines,1)
                node_1 = lines(l,2); 
                node_2 = lines(l,3);
                for i = 1:size(points,1)
                    if node_1 == points(i,1)
                        coord_1 = points(i,2:3); 
                        mz1 = points(i,4); 
                    end 
                    if node_2 == points(i,1)
                        coord_2 = points(i,2:3);
                        mz2 = points(i,4);
                    end
                end
                if (norm(coord_1(c_ind)-m_val)<obj.tol) && (norm(coord_2(c_ind)-m_val)<obj.tol)
                    if (coord_1(p_ind)-obj.coord(p_ind))*(coord_2(p_ind)-obj.coord(p_ind))<0
                       % find the line number to modify
                       % check if we need to add a point 
                       [v_min, i_min] = min([abs(coord_1(p_ind)-obj.coord(p_ind)),abs(coord_2(p_ind)-obj.coord(p_ind))]); 
                       if v_min < dis_merge
                           if i_min == 1 
                                obj = obj.setCoord(coord_1); 
                                obj = obj.setID(node_1); 
                               % obj.id = node_1;
                                return
                           elseif i_min == 2 
                                %obj.coord = coord_2;
                                obj = obj.setCoord(coord_2); 
                                obj = obj.setID(node_2); 
                                %obj.id = node_2; 
                                return
                           end
                       else
                           
                           max_node_id = max(points(:,1)); 
                           obj.id = max_node_id+1; 
                           points = [points
                                     obj.id obj.coord floor((mz1+mz2)/2.0)]; 
                           lines(l,3) = obj.id; 
                           % we need to add a line 
                           line_loops_id = zeros(1,length(line_loops)); 
                           for l_lp = 1:length(line_loops)
                               line_loops_id(l_lp) = line_loops{l_lp}(1); 
                           end 
                           max_line_id = max([max(line_loops_id),max(lines(:,1))]); 
                           max_line_id = max_line_id+1; 
                           lines = [lines
                                    max_line_id obj.id node_2];
                            
                           % all the line loops containing lines(l,1) need
                           % to be modified.
                            for l_lp = 1:length(line_loops)
                                for l_i = 2:length(line_loops{l_lp})
                                    if line_loops{l_lp}(l_i) == lines(l,1) 
                                       % for in the position direction 
                                       temp = [line_loops{l_lp}(1:l_i), max_line_id, line_loops{l_lp}(l_i+1:end)]; 
                                       line_loops{l_lp} = temp; 
                                    elseif line_loops{l_lp}(l_i) == -lines(l,1) 
                                       % for in the negative diretion 
                                       temp = [line_loops{l_lp}(1:l_i-1), -(max_line_id), line_loops{l_lp}(l_i:end)]; 
                                       line_loops{l_lp} = temp; 
                                    end
                                end
                            end
                       end
                    end 
                end
             end
          end
      end
    end
    methods (Static)
         function out = setgetVar(points)
             persistent x_min; 
             persistent x_max;
             persistent y_min;
             persistent y_max;
             if nargin
                  x_min = min(points(:,2));
                  x_max = max(points(:,2));
                  y_min = min(points(:,3));
                  y_max = max(points(:,3));
             end
             out = [x_min,x_max,y_min,y_max];
         end
   end    
end