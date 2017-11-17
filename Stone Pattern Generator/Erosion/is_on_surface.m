function [ iOS ] = is_on_surface( mask,i,j )
% IS_ON_SURFACE function that verifies if a pixel is on the surface of the polygon or no. 
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - mask         : boolean matrix of the polygon
%  - i            : index of the pixel
%  - j            : index of the pixel
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - iOS          : boolean that is 1 if the pixel is on the surface, 0
%                   else. 
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if mask(i,j+1)==0 || mask(i,j-1)==0 || mask(i+1,j)==0 ||mask(i-1,j)==0
    
    iOS=1;
    
else
    
    iOS=0;
    
end


end

