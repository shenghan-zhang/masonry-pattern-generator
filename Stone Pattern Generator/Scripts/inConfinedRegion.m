function is_confined = inConfinedRegion(coords_node, confine_direction, Lx_wall_tot, vlim)
is_confined = false; 
for i = 1:length(coords_node(:,1))
    check_coord = coords_node(i,:);
    if confine_direction == 'x'
        cirt_in_region = check_coord(1) < vlim || check_coord(1) > Lx_wall_tot-vlim;
    else %TO BE DONE, add another dimension
        cirt_in_region = check_coord(1) < vlim || check_coord(1) > Lx_wall_tot-vlim || check_coord(2) < vlim || check_coord(2) > Lx_wall_tot-vlim;
    end
    if cirt_in_region
        is_confined = cirt_in_region; 
        break
    end 
end
end