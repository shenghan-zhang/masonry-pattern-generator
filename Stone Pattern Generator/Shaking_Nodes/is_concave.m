function [ isConcave,angles] = is_concave(stone_nodes, pos )
% IS_CONCAVE function that determine if a polygon is concave or not.
% Be careful, the points of the polygons have to be ordered clockwise for
% the function to work.
%
% %%%%%% usage %%%%%%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - stone_nodes : Vector containing the stone nodes indexes(!!!ordered!!!)
%  - pos         : N x 2 Matrix containing the position of the nodes
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - isConcave   : Boolean saying if the polygon is concave (1) or not (0).
%  - angles      : Vector containing the angles of the polygons (>180 means
%  that the polygon is not convex)
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also SHAKE, TESTNODE
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
points=pos(stone_nodes,:);
N=size(points,1);

p0=points;
p1=[points(2:end,:);points(1,:)];
p2=[points(3:end,:);points(1:2,:)];

angles=getAngleVectors(p0,p1,p2);
maxAngles=max(angles);
isConcave = maxAngles>pi;
    
end

