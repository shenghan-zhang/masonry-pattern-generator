function [ pos,stonesNodes] = addStone( x,y,pos,epsilon,stonesNodes )
% ADDSTONE function that will add an stone when called. 
% The understones are used to fill the possible gaps that can appear when a
% stone is placed on the wall.
%
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - x         : coordinates of the x points
%  - y         : coordinates of the y points
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos         : the actualized coordinates of the nodes.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also ADDBRICK
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

indices=zeros(1,size(x,1));
for i=1:numel(x)
    p=[x(i),y(i)];
    [pos,indices(i),stonesNodes]=addOrFindPoint(p,pos,epsilon,stonesNodes);
end
stonesNodes=[stonesNodes,indices];


end

