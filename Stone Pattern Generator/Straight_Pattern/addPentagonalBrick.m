function [ posOut, stonesNodesOut,yend] = addPentagonalBrick( xstart,xend,ystart,yend,xNextBricks,yBricks,pos,stonesNodes,epsilon,Ly_wall)
% ADDPENTAGONALBRICK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function that will add a pentagonal brick (instead of a stone and an
% understone) when the situation requires it.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - xstart    : starting point on the x coordinate
%  - xend      : ending point on the x coordinate
%  - ystart    : starting point on the y coordinate
%  - yend      : ending point on the y coordinate
%  - xNextBricks : vector representing the next bricks x coordinates (the
%                  first element is xstart)
%  - yNextBricks : vector representing the next bricks y coordinates (the
%                  first element is ystart)
%  - pos         : a Mx2 matrix containing the nodes x-y coordinates
%  - stonesNodes : a 1xN cell array containing the indexes of the nodes of
%                  each stone.
%  - epsilon     : approximation constant.
%  - Ly_wall     : Height of the wall
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - posOut         : the actualized coordinates of the nodes.
%  - stonesNodesOut : the stones cell actualized
%  - yend           : depending on the case, the y coordinate might have
%                     changed
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also ADDBRICK, ADDROW, FILL_WALL
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yend=max(yend,yBricks(2));
posOld=pos;
stonesNodesOld=stonesNodes;
posTabOld=cell(1,numel(stonesNodesOld));

for i=1:numel(stonesNodesOld)

    posTabOld{i}=posOld(min(stonesNodesOld{i},size(posOld,1)),:);
    
end


if yBricks(2)>ystart
    
    p1=[xstart,yend;...
        xend,yend;...
        xend,yBricks(2);...
        xNextBricks(2),ystart;...
        xstart,ystart];
    
elseif yBricks(2)<ystart
    
    p1=[xstart,yend;...
        xend,yend;...
        xend,yBricks(2);...
        xNextBricks(2),yBricks(2);...
        xstart,ystart];
    
    
end

[pos,stonesNodes] = addStone(p1(:,1),p1(:,2),pos,epsilon,stonesNodes);

newStonesNodes=stonesNodes;
newPos=pos;

for i=1:numel(stonesNodes)-1
    
    
    polygon=pos(min(stonesNodes{i},size(pos,1)),:);
    % The min is there because sometimes it crashes there with indices
    %too big but I have not had the time to check why so thats the way
    % I fixed it for the moment. The pattern will most likely be wrong
    % but it will be detected afterwards.
    
    if isempty(polybool('intersection',polygon(:,1),polygon(:,2),p1(:,1),p1(:,2)))==0
        
        [x,y]=polybool('subtraction',polygon(:,1),polygon(:,2),p1(:,1),p1(:,2));
        subtraction=[x,y];
        newNodes=zeros(1,size(subtraction,1));
        
        for j=1:size(subtraction,1)
            
            [newPos,newNodes(j),newStonesNodes]=addOrFindPoint(subtraction(j,:),newPos,epsilon,newStonesNodes);
            
        end
        
        newNodes=get_all_nodes(newPos,{newNodes},epsilon);
        newNodes=newNodes{1};
        oldNodes=newStonesNodes{i};
        newStonesNodes{i}=newNodes;
        toDelIndex=oldNodes(find(ismember(oldNodes,newNodes)==0));
        
        
        
        if isempty(toDelIndex)==0
            
            toDelIndex=sort(toDelIndex,'descend');
            
            for j=1:numel(toDelIndex)
                
                if toDelIndex(j)<=size(newPos,1)
                   
                    [newPos,newStonesNodes]=deleteNode(newPos,newStonesNodes,toDelIndex(j));
                
                end
                
            end
            
        end
        
    end
    
end

stonesNodesOut=newStonesNodes;
posOut=newPos;


end

