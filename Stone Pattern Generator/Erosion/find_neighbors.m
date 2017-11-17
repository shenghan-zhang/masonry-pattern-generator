function [ neighbors ] = find_neighbors( stone_nodes )
% FIND_NEIGHBORS function that will find the neighbors of all stones in the wall. 
% Neighbors mean that the two stones share an edge (not only a node). 
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - stone_nodes  : 1xM Cell of stone nodes identification
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - neighbors    : Px2 matrix of neigbors stones
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also ERODE_POLYGON
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
neighbors=[];
for i=1:size(stone_nodes,2)
    
    for j=i+1:size(stone_nodes,2)
        
        if length(intersect(stone_nodes{i},stone_nodes{j}))>=1 % If the stones have more than one node in common, they are neighbors
          
            neighbors=[neighbors;i,j];
            
        end
        
    end
    
end

    

end

