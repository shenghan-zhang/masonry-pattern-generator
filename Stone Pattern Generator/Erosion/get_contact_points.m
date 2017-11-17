function [ contact_points ] = get_contact_points( stonesNodes,pos_tab_shaken,opt )
% GET_CONTACT_POINTS function that will create the contact points for all the stones in the wall.
%
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos_tab_shaken : 1xM Cell of Nx2 x-y coordinates of the polygons
%                     (uneroded stones).
%  - neighbors      : Px2 tab containing all pairs of neighbors
%  - opt            : parameters that decide if the contact point is put in
%                     the middle (1) or randomly between the two points (2)
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - contact_points : 1xQ cell of Nx2 x-y coordinates of the contact
%                     points.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also ERODE_POLYGON, FIND_NEIGHBORS
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
neighbors=[];

for i=1:numel(stonesNodes)
    
    for j=i:numel(stonesNodes)
        
        if length(ismember(stonesNodes{i},stonesNodes{j}))>=2
            
            neighbors=[neighbors;i,j];
            
        end
        
    end
    
end

contact_points=cell(1,size(pos_tab_shaken,2));

for i=1:size(neighbors,1)
    
    stn1=pos_tab_shaken{neighbors(i,1)};
    stn2=pos_tab_shaken{neighbors(i,2)};
    pts=intersect(stn1,stn2,'rows');
    
    if size(pts,1)==2
        
        pt1=pts(1,:);
        pt2=pts(2,:);
        d=distanz(pt1,pt2);
        
        switch opt
            
            case 1
                
                pintersect=0.5*(pt1+pt2);
                
            case 2
                
                coeff=rand(1);
                pintersect=coeff*pt1+(1-coeff)*pt2;
                
        end
        
        contact_points{neighbors(i,1)}=[contact_points{neighbors(i,1)};pintersect,d];
        contact_points{neighbors(i,2)}=[contact_points{neighbors(i,2)};pintersect,d];
   
    end
    
end

