function [ isValid ] = testNode( i,posn,stone_nodes,Lx_wall,Ly_wall,limitAngle )
% TESTNODE function that will assert that a given node is in a correct position (during shaking operation). 
% It will assert that the node is inside the boundaries of the picture, and
% that every polygon of the wall remains convex.
%
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - i           : index of the node to assert.
%  - posn        : vector containing the position of the nodes.
%  - stone_nodes : Array of cells containing the indexes of the nodes each
%                  stone contains
%  - Lx_wall     : Length of the wall
%  - Ly_wall     : Heigth of the wall
%  - limitAngle  : limit angle that we allow for concavity (ie > pi)
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - isValid     : 1 if the node is valid, 0 else
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also IS_CONCAVE
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

isValid=1;

% First we check that the point is not outside of the frame 

if posn(i,2)>Ly_wall || posn(i,2)<0 % Y coordinate
    
    isValid=0;
    
end

if posn(i,1)>Lx_wall ||posn(i,1)<0 % X coordinate
    
    isValid=0;
    
end

if isValid==1 % Then we go on with concavity (on every polygon)
    
    for j=1:size(stone_nodes,2) % We iterate on every stone 
        
        if isempty(find(stone_nodes{j}==i,1))~=1 % If the node belongs to the stone 
            
            [~,angles]=is_concave(stone_nodes{j},posn);
            
            if  max(angles) > limitAngle % We check concavity 
                
                isValid=0;
                
            end
            
        else % If the node does not belong to the stone, we check that it is not inside the polygon
            
            if inpolygon(posn(i,1),posn(i,2),posn(stone_nodes{j},1),posn(stone_nodes{j},2))
                
                isValid=0;
                
            end
            
        end
        
    end
    
end

