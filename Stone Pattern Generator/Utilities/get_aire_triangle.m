function [ a ] = get_aire_triangle( p1,p2,p3 )
% GET_AIRE_TRIANGLE function that computes the area of a triangle given its three vertices
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - p1  : first vertex
%  - p2  : second vertex
%  - p3  : third vertex
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - a   : area
%
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x1=p1(1);
x2=p2(1);
x3=p3(1);

y1=p1(2);
y2=p2(2);
y3=p3(2);

a=0.5*abs((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));

end

