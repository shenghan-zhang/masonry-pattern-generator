function [ A,xy ] = compute_visibility_graph( environnement,epsilon)
% COMPUTE_VISIBILITY_GRAPH computes the visibility graph of an environnement
% Appart from calling the visibility_graph function from the VisiLibity C++
% library, it creates also the guards vector. The guards vector is the
% vector containing the points we want to compute the visibility from. In
% our case, every vertex will be a guard. 
% CAUTION!!!!! : We noted that this version is unstable because of a bug in the
% c++ library, better use the other function
% Compute_visibility_graph_from_vis_polygon.m instead. 
%
% %%%%%% usage %%%%%%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - environnement : M+1 x 1 cell array containing all the stones + the
%                    outside frame. 
%  - epsilon       : Approximation constraint used by VisiLibity library. 
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - A             : Adjacency matrix. Aij is 1 if vertex j can be seen
%                    from vertx i (of course it is symetric).
%  - xy            : Nx2 matrix containing all the x-y coordinates of the
%                    vertices.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : January 2016
% See also COMPUTE_VISIBILITY_GRAPH_FROM_VIS_POLYGON
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
guards=[];
for i=1:length(environnement)
    guards=[guards;environnement{i}];
end
disp('This version might crash Matlab, use compute_visibility_graph_from_vis_polygon.m instead');
A= visibility_graph(guards, environnement, epsilon);
xy=guards;
end

