function [ pos,top_line,row_vec,stonesNodes,nb_f,M,v,fig] = addrow(Lx_wall,Ly_wall,pos,top_line,ind_row,row_vec,epsilon,stonesNodes,option_corner,fig,nb_f,M,v,file_params)
% ADDROW core function that will add a row to the existing wall, based on the topline
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - Lx_wall     : Length of the wall
%  - Ly_wall     : Height of the wall
%  - pos         : matrix containing the position of the nodes
%  - top_line    : vector containing the y coordinates of the topline
%  - stones      : Mx4 matrix containing the stones coordinates with the
%                  following format:
%                  [xstart1, xend1, ystart1, yend1;
%                   xstart2, xend2, ystart2, yend2;
%                   ...
%                   xstartM, xendM, ystartM, yendM];
%  - ind_row     : index of the current row (used mostly to know if this
%                  row is the first). 
%  - row_vec     : a Mx1 vector containing the row number of the stones. 
%  - epsilon     : approximation constant.
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos         : matrix containing the position of the nodes
%  - top_line    : vector containing the y coordinates of the topline
%  - stones      : Mx4 matrix containing the stones coordinates (Cf. inputs
%                  for the format).
%  - row_vec     : a Mx1 vector containing the row number of the stones. 
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also ADDBRICK, FILL_WALL
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xstart1=find_xstart(top_line,Ly_wall,epsilon);

if xstart1==0
    
    ind_brick=1;
    
else 
    
    ind_brick=2;
    
end

is_over=0;

if xstart1==-1
    
    is_over=1;
    
end

while is_over==0  % We add bricks while we have not reached the top or the left of the square in which the wall is inscribed. 
    
    nb_stones_init=size(stonesNodes,2);
    [pos,top_line,xstart2,stonesNodes]=addBrick(pos,top_line,xstart1,Lx_wall,Ly_wall,ind_row,ind_brick,epsilon,stonesNodes,option_corner,file_params);
    nb_stones_added=size(stonesNodes,2)-nb_stones_init;
    row_vec=[row_vec;repmat(ind_row,nb_stones_added,1)];
    xstart1=xstart2;
    ind_brick=ind_brick+1;
    if (nargin==13)
            [stones_nodes,stones_pos]=get_all_nodes(pos,stonesNodes,epsilon);
             darwStone4Video(fig,stones_pos,false,Lx_wall,Ly_wall);
             figure(fig)
             axis([0 Lx_wall 0 Ly_wall])
             axis equal
             ax = gca;
             ax.Units = 'pixels';
             posi = ax.Position;
             marg = 0;
             rect = [-marg, -marg, posi(3)+2*marg, posi(4)+2*marg];    
             M(nb_f) = getframe(gcf,rect);
             set(fig.CurrentAxes,'visible','off');
             axis([0 Lx_wall 0 Ly_wall])
             writeVideo(v, getframe(fig));
             nb_f = nb_f+1;
    end
    if abs(xstart1-Lx_wall)<epsilon || abs(getYstart(xstart1,top_line,epsilon)-Ly_wall)<epsilon
        
        is_over=1;
    end
    
end
