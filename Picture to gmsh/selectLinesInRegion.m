function [select_lines] = selectLinesInRegion(obj_array, region)
     x_min = region(1); 
     x_max = region(2);
     y_min = region(3);
     y_max = region(4);
     nb_obj = length(obj_array); 
     select_lines = []; 
     for j = 1:nb_obj
         obj = obj_array{j};
         lines = obj.lines;
         nb_lines = length(lines);
         for l = 1:nb_lines
             line = lines(l,:);
             coord1 = obj.findCoordOnNodeID(line(2));
             coord2 = obj.findCoordOnNodeID(line(3));
             coord_m = (coord1+coord2)/2;
             if (x_min<coord_m(1))&&(coord_m(1)<x_max)&&(y_min<coord_m(2))&&(coord_m(2)<y_max)
                select_lines = [select_lines; line(1) coord1 coord2 coord_m]; 
             end
         end
     end
end