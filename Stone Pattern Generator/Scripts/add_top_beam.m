%%
% crop pictures and add loading beam 
chemin = 'Y:\06_File_Transfer\For_Shenghan\Resources Shenghan v2\Italian topologies\';
picture_name = 'TypoEN2.png'; %'TypoEN2.png'
Ly = 1.; 
dl_mortar = 0.02;
dl_brick = 0.1; 

%%
% read picture
picture=imread(strcat(chemin,'\',picture_name));
ny=size(picture,1);
nx=size(picture,2);

%%
% crop picture
crop_per = 0.01; 
crop_pxl_x = floor(crop_per*nx); 
crop_pxl_y = floor(crop_per*ny); 
picture2 = picture(crop_pxl_y+1:(ny-crop_pxl_y),crop_pxl_x+1:(nx-crop_pxl_x),:);

%%
% add loading beam 
sy=Ly/(ny-2*crop_pxl_y);
n_brick=round(dl_brick/sy);
n_mortar=round(dl_mortar/sy);
mortar=zeros(n_mortar,nx-2*crop_pxl_x,3);
mortar(:,:,1) = 255;
mortar(:,:,2) = 255;
mortar(:,:,3) = 255;

brick=zeros(n_brick,nx-2*crop_pxl_x,3);
brick(:,:,1)=255;
picture_funded=[brick;mortar;picture2];
imwrite(picture_funded,strcat(chemin,'\',picture_name(1:end-4),'_funded_bis.png'));
%%
