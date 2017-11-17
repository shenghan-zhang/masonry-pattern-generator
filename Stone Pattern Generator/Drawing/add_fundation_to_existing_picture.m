function [  ] = add_fundation_to_existing_picture( chemin,picture_name,Ly,dl_mortar,dl_brick )
% ADD_FUNDATION_TO_EXISTING_PICTURE add a fundation to an existing picture. 
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - chemin      : string containing the folder in which the picture is. 
%  - picture_name: string containing the name of the pictures, for instance
%                  'wall.png'.
%  - Lx          : Initial length of the picture. 
%  - Ly          : Initial height of the picture. 
%  - dl_mortar   : Thickness of the mortar layer to add. 
%  - dl_brick    : Thickness of the brick fundation. 
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - none, the picture is automatically saved.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : February 2015
% See also ADD_FUNDATION
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
picture=imread(strcat(chemin,'\',picture_name));
ny=size(picture,1);
nx=size(picture,2);
sy=Ly/ny;
n_brick=round(dl_brick/sy);
n_mortar=round(dl_mortar/sy);
mortar=zeros(n_mortar,nx,3);
brick=zeros(n_brick,nx,3);
brick(:,:,1)=255;
picture_funded=[brick;mortar;picture;mortar;brick];
imwrite(picture_funded,strcat(chemin,'\',picture_name(1:end-4),'_funded_bis.png'));

end

