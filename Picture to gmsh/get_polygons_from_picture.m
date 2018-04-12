function [ polygons_coord ] = get_polygons_from_picture( folder,file,pic_bw_wb,Lx,Ly,dl,do_crop,per_crop)
%GET_POLYGONS_FROM_PICTURE This function creates polygons out of a black and white picture.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - folder        : String containing the folder in which the picture is
%  - file          : String with the name of the picture, for instance
%                    'wall.png'.
%  - pic_bw_wb     : 'bw' if the stones are in black and the mortar in white,
%                    and 'wb' if the stones are white and the mortar black. 
%  - Lx            : Length of the picture (in meters)
%  - Ly            : Height of the picture (in meters)
%  - dl            : Size of the frame to add (the stones can not touch the
%                    edges of the picture or they are not detected). 
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - polygons_coord: Polygons coordinates in a 1xM cell array.  
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : February 2016
% See also SHORTEST_PATH_FROM_PICTURE
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = imread(strcat(folder,file));
I=rgb2gray(I);
disp(exist('do_crop'));
% if ()
BW = im2bw(I, graythresh(I)); % Transforms the picture into a true BW picture, with threshold determined by graythresh (Otsu's method)
if strcmp(pic_bw_wb,'wb') % If the stones are white, we reverse the picture
    BW=~BW;
end

nx=size(BW,2); % Number of pixels along x axis
ny=size(BW,1); % Number of pixels along y axis
if exist('do_crop','var')
    if do_crop
        BW = imcrop(BW, [per_crop*nx per_crop*ny (1-2*per_crop)*nx (1-2*per_crop)*ny]);
    end 
else
    BW = imcrop(BW, [0.02*nx 0.02*ny 0.96*nx 0.96*ny]);
end
nx=size(BW,2); % Number of pixels along x axis
ny=size(BW,1); % Number of pixels along y axis
sx=Lx/(nx-1); % size of the pixels in x dimension
sy=Ly/(ny-1); % size of the pixels in y dimension

n_dl_x=round(dl/sx); % Number of pixels to add along x direction
n_dl_y=round(dl/sy); % Number of pixels to add along y direction
dlx_true=n_dl_x*sx; % True dl added along x axis
dly_true=n_dl_y*sy; % True dl added along y axis

% Adding of the white (mortar) frame 

BW=[ones(n_dl_y,nx);BW;ones(n_dl_y,nx)];
BW=[ones(ny+2*n_dl_y,n_dl_x),BW,ones(ny+2*n_dl_y,n_dl_x)];


[B] = bwboundaries(BW); % Detection of boundaries
polygons=B;

polygons_coord=cell(1,length(polygons)-1);
for i=2:length(polygons) % The first one is the outside frame
        polygons_coord{i-1}(:,1)=(polygons{i}(:,2)-n_dl_x-1)*sx; % Computation of x coordinates 
        polygons_coord{i-1}(:,2)=(ny+n_dl_y-polygons{i}(:,1))*sy;
        %polygons_coord{i-1}(:,2)=(n_dl_y+ny-polygons{i}(:,2))*sy;%Ly+2*dly_true-(polygons{i}(j,1)-0.5)*sy; % Computation of y coordinates
end
to_del=[];
for i=1:numel(polygons_coord)
    if size(unique(polygons_coord{i},'rows'),1)<=3
        to_del=[to_del,i];
    end
end
polygons_coord(to_del)=[];


end

