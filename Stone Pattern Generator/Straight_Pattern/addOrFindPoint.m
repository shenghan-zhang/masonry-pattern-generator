function [pos,ind,stonesNodes] = addOrFindPoint( point,pos,epsilon,stonesNodes)
% ADDORFINDPOINT function that will either add a new point to the position matrix or find it if it already exists in this position matrix.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - point     : The point we want to add or find in the position tab.
%  - pos       : matrix containing all the positions of the existing points
%  - epsilon   : approximation constant
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos       : updated pos matrix
%  - ind       : index at which the point has been found or added
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:size(pos,1)
    
    if abs(point(1,1)-pos(i,1))<epsilon/2 && abs(point(1,2)-pos(i,2))<epsilon/2
        
        ind=i;
        return;
        
    end
    
end

ind=size(pos,1)+1;
pos(ind,:)=point;

for i=1:numel(stonesNodes)
    
    polygon=pos(stonesNodes{i},:);
    polygon=[polygon;polygon(1,:)];
    
    for j=1:size(polygon,1)-1
        
        p1=polygon(j,:);
        p2=polygon(j+1,:);
        
        if isPointBetween(pos(end,:),p1,p2,epsilon)
            
            if j~=size(polygon,1)-1
                
                stonesNodes{i}=[stonesNodes{i}(1:j),ind,stonesNodes{i}(j+1:end)];
            
            else
                
                stonesNodes{i}=[stonesNodes{i},ind];
                
            end
            
        end
        
    end
    
end

if epsilon~=0
    
    pos(end,1)=epsilon*round(pos(end,1)/epsilon);
    pos(end,2)=epsilon*round(pos(end,2)/epsilon);
    
end

end

