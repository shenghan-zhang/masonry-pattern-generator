function [] = save_picture( stones_pos,resolution,color,folder,name,Lx_wall,Ly_wall,dl_crop)
% SAVE_PICTURE creates and save a png picture into a folder
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - stones_pos   : Cell array containing the x-y coordinates of the stones
%  - resolution   : The resolution in pixels per centimeter (in picture
%                   coordinates)
%  - color        : A color to fill the stones (the mortar will appear in
%                   black)
%  - folder       : A string containig the destination folder
%  - name         : The name of the picture to be saved, for instance
%                   'wall.png'
%  - Lx_wall      : The length of the wall
%  - Ly_wall      : The height of the wall
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - none, this function just saves and plot the picture. 
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : February 2015
% modification add dl_crop
% See also ADD_FUNDATION_TO_EXISTING_PICTURE
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rx=Lx_wall*100*resolution;
ry=Ly_wall*100*resolution;
h1=figure('Color',[1 1 1],'Name','Figure to be saved');
set(gca,'Color',[1 1 1]);
set(gca,'visible','off');
set(gca,'units','pixels','position',[0,0,rx,ry]);
set(gcf,'units','pixels','position',[0,0,rx,ry]);
fig.InvertHardcopy = 'off';
ylim([dl_crop,Ly_wall+dl_crop]);
xlim([dl_crop,Lx_wall+dl_crop]);
hold on;

for i=1:length(stones_pos)
    
    poly=stones_pos{i};
    fill(poly(:,1),poly(:,2),color,'LineStyle','none');
    
end

a=getframe(h1);
a.cdata(1,:,:)=[];
a.cdata(:,end,:)=[];

if exist(folder,'dir')~=7
    
    mkdir(folder);
    
end

if exist(strcat(folder,name,'.png'),'file')==2
    
    name=[name,'_copy'];
    
end

imwrite(a.cdata,strcat(folder,name,'.png'),'png');
save(strcat(folder,name,'.mat'),'stones_pos');

end
