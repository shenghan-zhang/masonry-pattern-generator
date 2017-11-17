function [ additions ] = actualize_surf( mask,i,j )
% ACTUALIZE_SURF actualizes the vector containing the coordinates of the pixels on the surface of the polygons during the erosion process.
% 
% If a pixel disappeared being eroded completely, it checks the 
% surroundings pixel to see if they must be placed in the surface pixels vector. 
%
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - mask     : mask of the actual polygon
%  - i        : index of the pixel that disappeared
%  - j        : index of the pixel that disappeared
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - additions: vector containing the pixels that must be added to the
%               surface vector. 
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also ERODE_POLYGON, IS_ON_SURFACE
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
additions=[];

if is_on_surface(mask,i,j+1)==1 && mask(i,j+1)==1
    
    additions=[additions;i,j+1];
    
end

if is_on_surface(mask,i,j-1) && mask(i,j-1)==1
    
    additions=[additions;i,j-1];
    
end

if is_on_surface(mask,i+1,j) && mask(i+1,j)==1
    
    additions=[additions;i+1,j];
    
end

if is_on_surface(mask,i-1,j) && mask(i-1,j)==1

    additions=[additions;i-1,j];
    
end

end

