function [ SMC ] = satisfyMergingConditions( posTab,p1,p2,ratioMerging,epsilon)
% SATISFYMERGINGCONDITIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function that takes two polygons and decides if they can be merged or no.
% The two conditions implemented now are : 
%      - The two polygons must have two indexes in common (1 edge in
%      common)
%      - The area of the convex hull of the two polygons must be < than
%      1.05 the area of the two polygons
% the second conditons gives the warranty that the result will not be "too"
% concave. 
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - posTab         : a Mx2 matrix containing the x-y coordinates of the
%                     points
%  - p1             : vector containing the indexes of the first polygon
%  - p2             : vector containing the indexes of the second poylgon
%  - ratioMerging   : The merged polygons must occupy x% of the area of the
%                     convexhull of both polygons. 
%  - epsilon        : approximation constant. 
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - SMC            : boolean saying if the two polygons satisfy the
%                     merging conditions. 
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also MERGEPOLYGONS, SATISFYMERGINGCONDITIONS
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indicesInCommon=sum(ismember(p1,p2)); % computation of the indexes in common

if indicesInCommon==2
    
    polygon1=posTab(p1,:);
    polygon2=posTab(p2,:);
    
    if isRectangle(polygon1,epsilon) && isRectangle(polygon2,epsilon)
        
        coord1=[min(polygon1(:,1)),max(polygon1(:,1)),min(polygon1(:,2)),max(polygon1(:,2))];
        coord2=[min(polygon2(:,1)),max(polygon2(:,1)),min(polygon2(:,2)),max(polygon2(:,2))];
        
        if sum(ismember(coord1,coord2))<2
            
            SMC=0;
            return;
            
        end
        
    end
    
    ptot=[polygon1;polygon2];
    a1=get_area_polygon(polygon1);
    a2=get_area_polygon(polygon2);
    punion=convhull(ptot(:,1),ptot(:,2));
    punion=ptot(punion,:);
    aunion=get_area_polygon(punion);
    
    if aunion<ratioMerging*(a1+a2)
        
        SMC=1;
        
    else
        
        SMC=0;
        
    end
    
else
    
    SMC=0;
    
end

end

