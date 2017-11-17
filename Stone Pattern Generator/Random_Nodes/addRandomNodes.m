function [posTabOut,stonesNodesOut,stonesPosOut] = addRandomNodes( posTab,stonesNodes,minDist,randomNodeAdditionRate,epsilon )
% ADDRANDOMNODES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function that will add random nodes on a certain proportion of edges
% longer than minDist. The proportion of edges where a randomNode will be
% added is defined by randomNodeAdditionRate.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - posTab    : a Nx2 matrix containing the x-y coordinates of the nodes
%  - stonesNodes : a 1xM cell array containing the vectors representing the
%                  nodes of each stone.
%  - minDist     : The minimal length above which random nodes can be
%                  added.
%  - randomNodesAdditionRate : proportion of the edges>minDist on which we
%                  will add random nodes, given in percents.
%  - epsilon     : approximation constant.
%
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - posTabOut   : a (N+p)x2 matrix containing the x-y coordinates of the
%                  nodes (with p added random nodes).
%  - stonesNodes : a 1xM updated cell array containing the vectors
%                  representing the nodes of each stone.
%  - stonesPosOut: a 1xM cell array containing the x-y coordinates of each
%                  stone.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also ORDER_STONE_NODES
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:numel(stonesNodes) % We iterate on each stone.
    
    polygon=posTab(stonesNodes{i},:); % Polygon creation
    polygon=[polygon;polygon(1,:)];
    
    for j=1:size(polygon,1)-1 % We iterate on the edges
        
        p1=polygon(j,:);
        p2=polygon(j+1,:);
        
        if distanz(p1,p2)>minDist && randi([0,100])<=randomNodeAdditionRate % If the conditions are satisfyied
            
            n3=(p1+p2)/2;
            [posTab,~,stonesNodes]=addOrFindPoint(n3,posTab,epsilon,stonesNodes);
            
        end
        
    end
    
end

% Output computation
[stonesNodesOut,stonesPosOut]=get_all_nodes(posTab,stonesNodes,epsilon);
posTabOut=posTab;

end

