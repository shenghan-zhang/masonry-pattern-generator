function [ poly_broomed ] = remove_double_nodes( poly )
% REMOVE_DOUBLE_NODES will remove any "too close" nodes, ie. less than 1e-6 distance between them.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - poly         : Initial polygon
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - poly_broomed : Polygon without any too close nodes. 
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also IS_CONCAVE, ORDER_POLYGON
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
to_del=[];
poly_broomed=[poly;poly(1,:)];
for i=1:size(poly_broomed,1)-1;
    if distanz(poly_broomed(i,:),poly_broomed(i+1,:))<1e-6
        to_del=[to_del,i];
    end
end
to_del=[to_del,size(poly_broomed,1)];
poly_broomed(to_del,:)=[];
end

