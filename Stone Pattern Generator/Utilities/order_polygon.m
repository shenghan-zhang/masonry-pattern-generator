function [ poly_ordered,i ] = order_polygon( poly )
% ORDER_POLYGON function that will order a polygon in clockwise order.
%
% %%%%%% usage %%%%%%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - poly         : The initial polygon (unordered)
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - poly_ordered : The ordered polygon
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : January 2016
% See also ORDER_STONE_NODES
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
polyunique=unique(poly,'rows');

if size(polyunique,1)<3
    
    x=mean(poly(:,1));
    y=mean(poly(:,2));
    
else
    
    k=convhull(poly(:,1),poly(:,2));
    [ geom ] = polygeom( poly(k,1),poly(k,2) );
    x=geom(2);
    y=geom(3);
    
end

vecs=poly-repmat([x,y],size(poly,1),1);
angles=atan2(vecs(:,2),vecs(:,1));
[~,i]=sort(angles);
i=flip(i);
poly_ordered=poly(i,:);

end

