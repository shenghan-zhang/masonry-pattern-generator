function [ isValid ] = check_validity_polygon( polygon,stones,i,min_dist,Lx_wall,Ly_wall )
% CHECK_VALIDITY_POLYGON %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function that take a given polygon and check its validity with respect to
% all the other polygons in stones. The criteria are :
% - it must not be out of the wall (p c[0,Lx]x[0,Ly])
% - it must be distant of a minimal min_dist from all other polygons and
%   not intersect them of course.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - polygon     : the polygon we want to check its validity
%  - stones      : the 1xM cell array containing the stones coordinates.
%  - i           : the index of the polygon to check
%  - min_dist    : the minimum distance we want to keep between polygons.
%  - Lx_wall     : Width of the wall.
%  - Ly_wall     : Height of the wall
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - isValid     : Boolean saying 1 if the polygon is valid and 0 else.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also SHAKE_STONES, ROTATE_POLYGON
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
isValid=1;

% First, we check that the polygon is inside the wall boundaries
if min(polygon(:,1))<0 || max(polygon(:,1)) > Lx_wall || min(polygon(:,2))<0 || max(polygon(:,2))>Ly_wall
   
    isValid=0;
    return;
    
else 
    % Then we check that its distance regarding other polygon is < min_dist
    % and that it does not intersect them 
    for j=1:size(stones,2)
        
        if j~=i
            
            stone=stones{1,j};
            dmin=p_poly_dist(polygon(:,1), polygon(:,2), stone(:,1), stone(:,2)); % Distance
            x=polyxpoly(polygon(:,1),polygon(:,2),stone(:,1),stone(:,2)); % Intersection
           
            if min(dmin)<min_dist || isempty(x)~=1
                isValid=0;
                
                return;
                
            end
            
        end
        
    end
    
end


end

