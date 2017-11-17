function [ posTab,stonesNodes,posTabShaken ] = shake( pos,Lx_wall,Ly_wall,stone_nodes,limitAngle,file_params)
%SHAKE function that will move slightly every point of the wall. 
% It uses the function testNode to verify if the move is legal. The
% conditions are that the node should not go outside of the picture, and
% that each polygon must remain convex.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos         : vector containing the position of the nodes.
%  - Lx_wall     : length of the wall
%  - Ly_wall     : height of the wall
%  - nxr         : sigma of the normal distributed noise we want to apply on
%                  the x coordinates.
%  - nyr         : sigma of the normal distributed noise we want to apply on
%                  the y coordinates.
%  - stone_nodes : Array of cells containing the indexes of the nodes each
%                  stone contains
%  - limitAngle  : limit angle that we allow for concavity (ie > pi)

%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - posn        : the shaken coordinates of the nodes.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015$
% See also TESTNODE
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
posn=pos;
stonesNodes=stone_nodes;

str=[];
for i=1:size(pos,1)
    
    if isNotOnBorder(pos(i,:),Lx_wall,Ly_wall) % If the node is not on the border, we apply the noise
        
        isNodeValid = 0; % By default, we will assume that the node is not valid
        %disp(['Noeud n° : ' num2str(i),'/' num2str(size(pos,1))]); % Displaying operations
        k=1; % Initializing counter
        [nxr,nyr]=get_params_shaking(pos(i,:),file_params);
        
        while isNodeValid~=1 % While the node is not valid
            
            posn(i,1)= pos(i,1)+normrnd(0,nxr); % Apply the noise
            posn(i,2)=pos(i,2)+normrnd(0,nyr); % On the two coordinates
            isNodeValid = testNode(i,posn,stone_nodes,Lx_wall,Ly_wall,limitAngle); % Verifying if the node is valid
            k=k+1;
            
            if isNodeValid == 1
                
                break;
                
            end
            
            if k>1000 % If we go over 1000, we let the node where it is
                
                str=[str, num2str(i),', '];
                posn(i,1)=pos(i,1);
                posn(i,2)=pos(i,2);
                break;
                
            end
            
        end
        
        
        
    end
    
end

shaken_pos=cell(1,length(stone_nodes));

for i=1:length(stone_nodes)
    
    shaken_pos{i}=posn(stone_nodes{i},:);
    
end

if length(str)>1
    
    str(end-1:end)=[];
    
end

posTab=posn;
posTabShaken=shaken_pos;
disp(['Stones shaked, shaking unsucessful in nodes : ', str]);

end
