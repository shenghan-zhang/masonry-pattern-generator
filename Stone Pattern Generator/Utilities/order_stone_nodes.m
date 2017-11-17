function [ stone_nodes_ordered ] = order_stone_nodes( stone_nodes,pos )
%ORDER_STONE_NODES function that will order the nodes of a stone in a  clockwise order.
%
% This will be useful when we want to determine if the polygons are convex 
% or concave.
%
% %%%%%% usage %%%%%%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - stone_nodes       : Array of cells containing the nodes each stone
%                        comprise
%  - pos               : position tab
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - stone_nodes_ordered : Array of cells containing the nodes each stone
%                          comprise ordered clockwise.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also IS_CONCAVE, ORDER_POLYGON
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nodes=pos(stone_nodes,:);
[pos_ordered,index]=order_polygon(nodes);
stone_nodes_ordered=stone_nodes(index);

end

