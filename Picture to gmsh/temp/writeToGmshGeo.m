function writeToGmshGeo(file_name, points, lines, line_loops, plane_surfaces, physical_surfaces, physical_lines, mesh_sizes)
%% write the mesh info 

fileID = fopen(file_name,'w');
% input mesh information
%structured_mesh=true;%true false;
keys = mesh_sizes.keys;
values = mesh_sizes.values; 
num2type = {};

for i = 1:length(mesh_sizes) 
  formatSpec = '%s = %f;\n';
  fprintf(fileID, formatSpec, keys{i}, values{i});
  num2type{i} = keys{i}; 
end

for i = 1:size(points,1) 
    i
    points(i,:)
    formatSpec = 'Point(%d) = {%f, %f, 0, %s};\n';
    fprintf(fileID, formatSpec, points(i,1), points(i,2), points(i,3), num2type{points(i,4)});
end

 
%% write the line info 
for i = 1:size(lines,1) 
    formatSpec = 'Line(%d) = {%d, %d};\n';
    fprintf(fileID, formatSpec, lines(i,1), lines(i,2), lines(i,3));
end

%% write the line loop info
for ll = 1:length(line_loops)
    line_loop = line_loops{ll}; 
    allOneString = sprintf('%d,' , line_loop(2:end));
    allOneString = allOneString(1:end-1);% strip final comma
    formatSpec = 'Line Loop(%d) = {%s};\n';
    fprintf(fileID, formatSpec, line_loop(1), allOneString);
end

%% write the surface info 
for s = 1:length(plane_surfaces)
    plane_surface = plane_surfaces{s}; 
    allOneString = sprintf('%d,' , plane_surface(2:end));
    allOneString = allOneString(1:end-1);% strip final comma
    formatSpec = 'Plane Surface(%d) = {%s};\n'; 
    fprintf(fileID, formatSpec, plane_surface(1), allOneString);
end

%% write the physical surface and physical line

physical_surface_keys = physical_surfaces.keys;
physical_surface_values = physical_surfaces.values;
for ps = 1:length(physical_surfaces)
    formatSpec = 'Physical Surface(%s) = {%s};\n';
    allOneString = sprintf('%d,' , physical_surface_values{ps});
    allOneString = allOneString(1:end-1);% strip final comma
    fprintf(fileID, formatSpec, physical_surface_keys{ps}, allOneString);
end


physical_line_keys = physical_lines.keys;
physical_line_values = physical_lines.keys;
for ps = 1:length(physical_lines)
    formatSpec = 'Physical Line(%s) = {%s};\n';
    allOneString = sprintf('%d,' , physical_line_values{ps});
    allOneString = allOneString(1:end-1);% strip final comma
    fprintf(fileID, formatSpec, physical_line_keys{ps}, allOneString);
end



end