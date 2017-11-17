function [ pos,stonesNodes ] = deleteNode( pos,stonesNodes,ind )
% DELETENODE function that will delete a node in the pos tab and update all
% the stones in stonesNodes affected by this deletions (all nodes indexes
% above ind should be diminished by 1).
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos       : x-y position the nodes
%  - stonesNodes : 1xM Cell containing the stones indexes
%  - ind         : index of the node to delete
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos         : updated pos tab
%  - stonesNodes : updated stonesNodes
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2016
% See also ADDPENTAGONALBRICK
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos=[pos(1:ind-1,:);pos(ind+1:end,:)];

for i=1:numel(stonesNodes) % We iterate on the stones
    
    if isempty(stonesNodes{i})==0 % If the stone is not empty
        
        j=1;
        
        while j<=size(stonesNodes{i},2) % We iterate on stone vertices
            
            if stonesNodes{i}(j)>ind % If the vertex is > ind
                
                stonesNodes{i}(j)=stonesNodes{i}(j)-1; % We remove 1
                
            elseif stonesNodes{i}(j)==ind % else if it is ind
                
                stonesNodes{i}(j)=[]; % We delete it
                
            end
            
            j=j+1; 
            
        end
        
    end
    
end

end
