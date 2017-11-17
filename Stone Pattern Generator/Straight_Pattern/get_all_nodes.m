function [ stonesNodes,stonesPos ] = get_all_nodes( pos,stonesNodes,epsilon )
% GET_ALL_NODES function that will get all nodes corresponding to a stone and order them in a clockwise order.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - stones       : tab containing the xstart,xend,ystar and yend of all the
%                  bricks.
%  - pos          : vector containing the position of the nodes.
%  - epsilon      : geometrical approximation constraint
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - stones_nodes : an array of cells containing the ordered nodes of the
%                   stones
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also ORDER_STONE_NODES
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
to_del=[];
stonesPos=cell(1,numel(stonesNodes));

for i=1:size(stonesNodes,2)
    
    if numel(unique(stonesNodes{i}))>2
        
        stone=pos(stonesNodes{i},:);
        stone=[stone;stone(1,:)];

        for j=1:size(pos,1)
            
            if ismember(j,stonesNodes{i})==0
                
                a=size(stone,1)-1;
                
                for k=1:a
                    
                    p1=stone(k,:);
                    p2=stone(k+1,:);
                    
                    if isPointBetween(pos(j,:),p1,p2,epsilon)

                        if k~=size(stone,1)-1
                            
                            stonesNodes{i}=[stonesNodes{i}(1:k),j,stonesNodes{i}(k+1:end)];
                        
                        else
                            
                            stonesNodes{i}=[stonesNodes{i},j];
                        
                        end
                        
                        stone=pos(stonesNodes{i},:);
                        stone=[stone;stone(1,:)];
                        break;
                        
                    end
                    
                end
                
            end
            
        end
        
    end
    
    if isempty(stonesNodes{i})==0
        
        stonesNodes{i}=unique(stonesNodes{i},'stable');
        stonesPos{i}=pos(stonesNodes{i}',:);
        
    else
        
        to_del=[to_del,i];
        
    end
    
end

stonesPos(to_del)=[];
stonesNodes(to_del)=[];

end

