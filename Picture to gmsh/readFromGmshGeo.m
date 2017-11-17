%%
% the read information is gathered as follows 
% point with point ID, mesh
% line with lineID pointID
% lineloop with all the line IDs
% surface with corresponding lineloop ID 
function [points, lines, line_loops, plane_surfaces, physical_surfaces, physical_lines, mesh_sizes] = readFromGmshGeo(file_name)
        fid=fopen(file_name);
        points = []; 
        lines = [];
        line_loops = {};
        ind_line_loop = 1; 
        plane_surfaces = {}; 
        ind_plane_surface = 1; 
        physical_surfaces = containers.Map(); 
        physical_lines = containers.Map(); 
        read_inital_mesh_info = true; 
        mesh_sizes = containers.Map(); 
        while 1
            tline = fgetl(fid);
            if ~ischar(tline), break, end
            tline_segs = split(tline,';');
            % get the part before and after expression 
            for t = 1:length(tline_segs)
            if isempty(tline_segs{t}), continue, end
            field_name = regexp(tline_segs{t},'.*(?=\=)','match'); 
            field_value = regexp(tline_segs{t},'(?<=\=).*','match');
            if read_inital_mesh_info
                if (isempty(strfind(field_name{1},'Point')))
                   mesh_sizes(field_name{1}) = str2num(field_value{1}); 
                end 
            end
            if (~isempty(strfind(field_name{1},'Point')))
                read_inital_mesh_info = false; 
                point_id = regexp(field_name{1},'(?<=\().*(?=\))','match');
                field_value = regexp(field_value{1},'(?<={).*(?=})','match');
                values = split(field_value{1},', '); 
                mesh_size_id = 0; 
                mesh_keys = mesh_sizes.keys;
                for i=1:length(mesh_keys)
                    if (~isempty(strfind(mesh_keys{i},values{4})))
                        mesh_size_id = i; 
                        break
                    end 
                end
                points = [points
                          str2num(point_id{1}) str2double(values{1}) str2double(values{2}) mesh_size_id];
            elseif (~isempty(strfind(field_name{1},'Line')))&&(isempty(strfind(field_name{1},'Physical')))&&(isempty(strfind(field_name{1},'Loop')))
                line_id = regexp(field_name{1},'(?<=\().*(?=\))','match');
                field_value = regexp(field_value{1},'(?<={).*(?=})','match');
                values = split(field_value{1},', '); 
                lines = [lines
                         str2num(line_id{1}) str2num(values{1}) str2num(values{2})]; 
            elseif (~isempty(strfind(field_name{1},'Line Loop')))
                line_loop_id = regexp(field_name{1},'(?<=\().*(?=\))','match');
                field_value = regexp(field_value{1},'(?<={).*(?=})','match');
                line_loops{ind_line_loop} = [str2num(line_loop_id{1}) str2num(field_value{1})]; 
                ind_line_loop = ind_line_loop+1; 
            elseif (~isempty(strfind(field_name{1},'Plane Surface')))
                plane_surface_id = regexp(field_name{1},'(?<=\().*(?=\))','match');
                field_value = regexp(field_value{1},'(?<={).*(?=})','match');
                plane_surfaces{ind_plane_surface} = [str2num(plane_surface_id{1}) str2num(field_value{1})]; 
                ind_plane_surface = ind_plane_surface + 1; 
            elseif (~isempty(strfind(field_name{1},'Physical Surface')))
                physical_surface_name = regexp(field_name{1},'(?<=\().*(?=\))','match');
                field_value = regexp(field_value{1},'(?<={).*(?=})','match');
                physical_surfaces(physical_surface_name{1}) = str2num(field_value{1}); 
            elseif (~isempty(strfind(field_name{1},'Physical Line')))
                physical_line_name = regexp(field_name{1},'(?<=\().*(?=\))','match');
                field_value = regexp(field_value{1},'(?<={).*(?=})','match');
                physical_lines(physical_line_name{1}) = str2num(field_value{1});                
            end
            end
            
            
            disp(tline)
        end
        fclose(fid);
end