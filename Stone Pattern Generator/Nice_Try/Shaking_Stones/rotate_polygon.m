function [ rotated_polygon ] = rotate_polygon( polygon,angle )
% ROTATE_POLYGON %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function that takes a polygon as an input and rotate it by a certain
% angle. 
%
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - polygon        : the input polygon as an Nx2 matrix of vertices
%  - angle          : a double representing the angle (in radians)
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - rotated_polygon: the output polygon as an Nx2 Matrix of vertices
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also SHAKE_STONES
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=polygon(:,1);
y=polygon(:,2);
geom = polygeom( x, y ); % centroid of the polygon
xc=geom(2);
yc=geom(3);
rotMatrix=[cos(angle),-sin(angle);sin(angle),cos(angle)];
[pr]=rotMatrix*[x'-xc;y'-yc];
rotated_polygon=[pr(1,:)'+xc,pr(2,:)'+yc];
end

