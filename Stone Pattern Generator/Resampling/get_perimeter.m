function [ p ] = get_perimeter( poly )
% GET_PERIMETER computes the perimeter of a polygon given its vertices.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - poly      : Nx2 matrix containing the x-y coordinates of the vertices.
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - p         : the perimeter.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : January 2016
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
poly=[poly;poly(1,:)];
p=0;

for i=1:size(poly,1)-1
    
    p=p+pdist([poly(i,:);poly(i+1,:)]);
    
end

end

