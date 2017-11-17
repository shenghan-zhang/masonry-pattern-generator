function [ a ] = get_area_polygon( polygon )
% GET_AREA_POLYONG function that computes the area of a polygon given its vertices
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - polygon : an Nx2 matrix containing the x-y coordinates of the vertices
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - a   : area
%
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a=0;
mp=mean(polygon,1);
polygon=[polygon;polygon(1,:)];

for i=1:size(polygon,1)-1
    
    p1=polygon(i,:);
    p2=polygon(i+1,:);
    a=a+get_aire_triangle(mp,p1,p2);
    
end

end

