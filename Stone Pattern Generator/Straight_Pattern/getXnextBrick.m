function [ x,ind_brick ] = getXnextBrick(topline,xstart,Lx_wall,ind_row,epsilon )
% GETXNEXTBRICK function that will get the x coordinate of the next brick on the topline.
%
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - top_line  : a vector containing the y coordinates of the top of the
%                current wall
%  - xstart    : the x coordinate from where we want to search
%  - Lx_wall   : length  of the wall
%  - ind_row   : index of the current row
%  - epsilon   : approximation constant
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - x         : coordinate of the next brick
%  - change    : the height of the next brick
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind_start=round(xstart/epsilon+1);

if ind_row~=1
    
    change_pos=get_next_change(topline(1,:),ind_start);
    x=max(0,(change_pos-1)*epsilon);
    
    if change_pos==0
        
        x=Lx_wall;
        
    end
    
else
    
    x=Lx_wall;
end

end

