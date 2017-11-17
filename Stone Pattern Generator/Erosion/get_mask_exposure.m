function [ mask_exposure ] = get_mask_exposure( dx,r )
% GET_MASK_EXPOSURE function that compute the mask of the bubble
%
% function that compute the mask of the bubble. Each pixel that is inside 
% the bubble is 1 and the ones that are outside are 0.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - dx            : x discretization length
%  - r             : radius of the bubble
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - mask_exposure : the mask of the bubble 
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=ceil(r/dx);

mask_exposure=zeros(2*n+1,2*n+1);

for i=1:size(mask_exposure,1)
    
    for j=1:size(mask_exposure,2)
        
        delta_x=abs(n+1-j)*dx;
        delta_y=abs(n+1-i)*dx;
        d=norm([delta_x,delta_y]);
        
        if d<r
            
            mask_exposure(i,j)=1;
            
        end
        
    end
    
end

end

