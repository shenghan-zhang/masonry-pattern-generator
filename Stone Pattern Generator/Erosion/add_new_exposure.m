function [ exposure ] = add_new_exposure( exposure,to_add,mask,mask_exposure,n,bulle )
% ADD_NEW_EXPOSURE function that computes the initial exposure value of a pixel
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - exposure      : the initial array of exposure values.
%  - to_add        : the points to add (i,j coordinates)
%  - mask          : the mask of the polygon
%  - mask_exposure : the mask of the bubble
%  - n             : half the length of the bubble
%  - bulle         : the surface of the bubble
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - exposure      : the updated array of exposure values
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also ERODE_POLYGON
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nstart=size(exposure,2);
exposure=[exposure,zeros(1,size(to_add,1))];
for i=1:size(to_add,1)
        sub_mask=~mask(to_add(i,1)-n:to_add(i,1)+n,to_add(i,2)-n:to_add(i,2)+n);
        va=sum(sum(sub_mask.*mask_exposure));
        exposure(i+nstart)=va/bulle;
end

