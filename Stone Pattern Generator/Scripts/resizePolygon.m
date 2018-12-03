function polygons = resizePolygon(polygons,dl,Lx,Ly)
% resizePolygon resize the polygons to the specific dimension 
% polygons: input polygon 
% Lx: assumed length of the wall
% Lx: assumed height of the wall
% dl: added length to the leftdown corner stone
%
% 09 Nov, 2019: modification of 
% Shenghan Zhang, EESD, EPFL, <shenghan.zhang@epfl.ch>

if (nargin == 1)
    dl = 0; 
    Lx = 1; 
    Ly = 1; 
    disp(['Supplement input parameters: Lx ',num2str(Lx), ...
                                    ',  Ly ',num2str(Ly), ...
                                    ',  dl ',num2str(dl), '.'])
elseif (nargin == 2)
    Lx = 1; 
    Ly = 1; 
    disp(['Supplement input parameters: dl ',num2str(dl), '.'])    
elseif (nargin == 3)
    error('Input number is 3. Not defined.')
end

for i=1:length(polygons)
    coord_poly = polygons{i}; 
    if i == 1
        x_min = min(coord_poly(:,1));
        x_max = max(coord_poly(:,1));
        y_min = min(coord_poly(:,2));
        y_max = max(coord_poly(:,2));        
    else
        x_min = min(x_min, min(coord_poly(:,1))); 
        x_max = max(x_max, max(coord_poly(:,1)));
        y_min = min(y_min, min(coord_poly(:,2))); 
        y_max = max(y_max, max(coord_poly(:,2)));
    end
end

for i=1:length(polygons)
    coord_poly = polygons{i};
    coord_poly(:,1) = (coord_poly(:,1)-x_min)/(x_max-x_min)*Lx + dl; 
    coord_poly(:,2) = (coord_poly(:,2)-y_min)/(y_max-y_min)*Ly + dl; 
    polygons{i} = coord_poly; 
end

end