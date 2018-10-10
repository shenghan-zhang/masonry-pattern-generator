function [ polygon ] = reorder_by_distance_polygon( poly )
% REORDER_BY_DISTANCE_POLYGON function that reorders a polygon with the method of the closest neighbor. 
% 
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - poly     : Nx2 Matrix containing the x-y coordinates of the unordered
%               polygon.
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - polygon  : Nx2 Matrix containing the x-y coordinates, ordered by
%               distance.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% bug correction for deleting unsorted points 
% %% AUTEUR : Shenghan Zhang
% %% email: shenghan.zhang@epfl.ch
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
polygon(1,:)=poly(1,:);
poly(1,:)=[];
k=1;
out=0;
n=size(poly,1)+1;
fisrt_point = polygon(1,:); 
while out==0
    
    d=distanz(polygon(k,:),poly);
    [cur_min,ind]=min(d);
    if ((size(polygon,1)>n/2)&&(norm(polygon(k,:)-fisrt_point)<cur_min)) %
        out = 2; 
        break
    end
    polygon(k+1,:)=poly(ind,:);
    poly(ind,:)=[];
    k=k+1;
    
    if size(polygon,1)==n 
        
        out=1;
        
    end
    
end

    

end

