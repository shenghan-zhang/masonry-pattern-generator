function [ new_polygons ] = delete_redondant_vertices( polygons )
%DELETE_REDONDANT_VERTICES This function deletes any vertex that is on a line between its two neighbors (ie. if two consecutive edges are //) 
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - polygons     : 1xM Cell array containing the initial polygons 
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - new_polygons : 1xM Cell array containing the updated polygons. 
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : February 2016
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(polygons)
    
    poly=polygons{i};
    poly=[poly;poly(1:2,:)]; % We add the two first vertices for the following for loop
    to_del=[];
    
    for j=1:size(poly,1)-2 % We iterate from 1 to n (the polygon is now n+2)
        % Creation of the points
        p1=poly(j,:);
        p2=poly(j+1,:);
        p3=poly(j+2,:);
        % Creation of the two vectors
        v1=p2-p1; 
        v2=p3-p2;
        
        if norm(v1)*norm(v2)==v1(1)*v2(1)+v1(2)*v2(2) %  If the vectors are parallels
            
            if j~=size(poly,1)-2 % We add the index in the to_delete vector
              
                to_del=[to_del,j+1];
           
            elseif j==size(poly,1)-2 % Except if j == n, which means we have to delete the first vertex
             
                to_del=[to_del,1];
           
            end
            
        end
        
    end
    
    poly(end-1:end,:)=[]; % we remove the two nodes we added on line 17
    poly(to_del,:)=[]; % We delete the unnecessary vertices
    new_polygons{i}=poly; % Assignement of the new polygon
    
end

end

