function [ posTabOut,stonesNodesOut,stonesPos,row_vec_out] = mergePolygons( posTab,stonesNodes,row_vec,Lx_wall,Ly_wall,epsilon,limitAngleMerging,mergingRate,ratioMerging )
% MERGEPOLYGONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function that takes all the polygons, verify which of them can satisfy
% the merging conditions defined by satisfyMergingConditions.m and merges
% them.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - posTab         : a Mx2 matrix containing the x-y coordinates of the
%                     points
%  - stonesNodes    : a 1xM cell array containing the vertices of the
%                     stones before any stone had been merged.
%  - row_vec        : a 1xM vector containing the rows of the stones
%  - Lx_wall        : Height of the wall
%  - Ly_wall        : Width of the wall
%  - epsilon        : approximation constant
%  - limitAngleMerging : Max value of the concave angle that two merged
%                        polygons can form. 
%  - mergingRate    : rate of merging of the polygons (X %  of the polygons
%                     that satisfy the conditions will be merged)
%  - ratioMerging   : the merged polygon must occupy x% of the convexhull
%                     defined by both polygons.
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - posTabOut      : The updated posTab
%  - stonesNodesOut : The updated cell array containing the merged stones
%                     indexes.
%  - stonesPos      : A cell array containing the x-y coordinates of the
%                     stones.
%  - row_vec_out    : updated row_vec
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also MERGEPOLYGONS, SATISFYMERGINGCONDITIONS
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
isValid=0;

while isValid==0 % We redo merging while the obtained pattern is not ok.
    
    % Initialisation of variables
    mergedPolygons=[];
    stonesNodesUpdated=stonesNodes;
    row_vec_out=row_vec;
    
    for i=1:size(stonesNodes,2) % We iterate on the stones
        
        if ismember(i,mergedPolygons)==0 % If the stone has not been merged yet
            
            for j=1:size(stonesNodes,2) % We iterate on the other stones
                
                if ismember(j,mergedPolygons)==0 && j~=i % If the second stone has not been merged neither (and is not the same stone of course)
                    
                    % we assign the vertices indexes
                    p1=stonesNodes{i};
                    p2=stonesNodes{j};
                    
                    if satisfyMergingConditions(posTab,p1,p2,ratioMerging,epsilon) && randi([1,100])<mergingRate % We check if the two stones satisfy the mergin conditions
                        
                        % If yes, we merge them and update the variables.
                        [stonesNodesUpdated]=merge2polygons(stonesNodes,stonesNodesUpdated,i,j);
                        [~,angles]=is_concave(stonesNodesUpdated{end},posTab);
                        
                        if max(angles) > limitAngleMerging || sum(angles>=3*pi/2)>=2
                            
                            stonesNodesUpdated(end)=[];
                            
                        else
                            
                            mergedPolygons=[mergedPolygons,i,j];
                            row_vec_out=[row_vec_out;row_vec_out(i)];
                            break;% We get out of the "for j" loop
                            
                        end
                        
                    end
                    
                end
                
            end
            
        end
        
    end
    
    stonesNodesUpdated(mergedPolygons)=[]; % We delete the merged stones
    row_vec_out(mergedPolygons)=[]; % also in the row_vec
    posTabOut=posTab; % The posTab is unchanged.
    stonesNodesOut=stonesNodesUpdated; % Assignment of output value
    isValid=check_validity2(posTabOut,stonesNodesOut,Lx_wall,Ly_wall,epsilon); % We check the validity of the obtained pattern
    
    if isValid==0;
        
        disp('Failed merging, redo...');
        
    end
end

stonesPos=cell(size(stonesNodesOut));

for i=1:size(stonesNodesOut,2) % We create the stonesPos cell array
    
    stonesPos{i}=posTabOut(stonesNodesOut{i},:);
    
end



end

