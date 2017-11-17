function [h1] = draw_stones( stones_pos,resolution,Lx_wall,Ly_wall,colors,varargin)
% DRAW_STONES Draw all the stones when the stones are random polygons.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - stone_pos   : Array of M cells containing the px2 coordinates of the
%                  stones
%  - resolution  : The resolution in pixel/cm
%  - Lx_wall     : Length of the wall
%  - Ly_wall     : Height of the wall
%  - colors      : M x 3 matrix containing the RGB colors.
%  - varargin    : Can be the width of the lines to draw between the
%                  polygon or a char that will be displayed in the bottom 
%                  left corner.
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - h1          : handle to the figure
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rx=Lx_wall*100*resolution;
ry=Ly_wall*100*resolution;
linewidth=0;
added_text='';

for i=1:length(varargin)
    
    if ischar(varargin{i}) || iscell(varargin{i})
        
        added_text=varargin{i};
        
    elseif isfloat(varargin{i})
        
        linewidth=varargin{i};
        
    end
    
end

h1=figure('Color',[1,1,1],'Name',added_text);
set(gca,'Color',[1,1,1]);
set(gca,'visible','on')

screensize = get( groot, 'Screensize' );

set(gcf,'Position',[screensize(3)/4 0.1*screensize(4) screensize(3)/2,0.8*screensize(4)]);

axis image
hold on;
n_vertices=0;




if linewidth~=0
    
    for i=1:length(stones_pos)
        
        poly=stones_pos{i};
        fill(poly(:,1),poly(:,2),colors(i,:),'LineWidth',linewidth,'FaceAlpha',0.5)
        n_vertices=n_vertices+size(poly,1);
        
    end
    
else
    
    for i=1:length(stones_pos)
        
        poly=stones_pos{i};
        fill(poly(:,1),poly(:,2),colors(i,:),'LineStyle','none','FaceAlpha',0.5)
        n_vertices=n_vertices+size(poly,1);
    end
    
end

xl=xlim;
yl=ylim;
text(0.975*xl(2),-0.05*yl(2), {[num2str(length(stones_pos)),' Stones'], [num2str(n_vertices), ' Vertices']},'Color','k','HorizontalAlignment','right');
text(0.025*xl(2),-0.05*yl(2), {added_text,''},'Color','k');
drawnow;

end

