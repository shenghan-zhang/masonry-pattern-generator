function [ cropped_stones,Lx_wall,Ly_wall,colors ] = crop_picture( sieved_stones,dl_crop,Lx_wall,Ly_wall,colors_a )
%CROP_PICTURE Crop the outer frame of the polygons by a quantity dl_crop.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - sieved_stones  : Cell array containing the M polygons uncropped.
%  - dl_crop        : Length that is to be removed on the outer frame.
%  - Lx_wall        : Length of the wall.
%  - Ly_wall        : Height of the wall.
%  - colors_a       : M x 3 matrix containing the RGB coordinates of each
%                    polygon color.
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - cropped_stones : Cell array containing the M (some might have been
%                     removed if they were completely outside of the frame.
%  - Lx_wall        : Length of the wall updated (- 2 times dl_crop).
%  - Ly_wall        : Height of the wall updated (- 2 times dl_crop).
%  - colors         : M x 3 matrix containing the RGB coordinates of each
%                    polygon color.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : February 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

polycrop=[dl_crop,dl_crop;dl_crop,Ly_wall-dl_crop;Lx_wall-dl_crop,Ly_wall-dl_crop;Lx_wall-dl_crop,dl_crop];

k=1;
for i=1:numel(sieved_stones)
    poly=sieved_stones{i};
    [x,y]=polybool('intersection',polycrop(:,1),polycrop(:,2),poly(:,1),poly(:,2));
    if isempty(x)==0
        cropped_stones{k}=[x,y];
        colors(k,:)=colors_a(i,:);
        k=k+1;
    end
end
Lx_wall = Lx_wall - 2*dl_crop;
Ly_wall = Ly_wall - 2*dl_crop;
    
end



