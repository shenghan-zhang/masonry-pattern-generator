function [ exposure ] = update_exposure( exposure,ind_i,ind_j,surf_v,bubble,r,dx)
% UPDATE_EXPOSURE function that update the value of exposure of a pixel.
%
% The exposure is computed as the ratio between air and stone in a bubble
% centered around the pixel. This function is applied when a pixel is
% eroded completely (disappears). The pixel disapperance makes all pixels
% around being a bit more exposed and that is what this function computes.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - exposure     : initial Px1 matrix of exposure
%  - ind_i        : x-index of the disappeared pixel
%  - ind_j        : y-index of the disappeared pixel
%  - surf_v       : Px2 matrix containing all the surface pixels that are
%                   likely to be updated. 
%  - bubble       : Volume of the bubble (constant)
%  - r            : Radius of the bubble
%  - dx           : length of the pixels
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - exposure     : updated Px1 matrix of exposure values. 
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:size(surf_v,1)
    
    d=dx*sqrt(abs(ind_i-surf_v(i,1))^2+abs(ind_j-surf_v(i,2))^2);
    
    if d<=r
        
        exposure(i)=exposure(i)+1/bubble;
        
    end
    
end

end


