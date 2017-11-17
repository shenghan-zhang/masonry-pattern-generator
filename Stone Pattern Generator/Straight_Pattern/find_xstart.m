function [ xstart ] = find_xstart( top_line,Ly_wall,epsilon)
% FIND_XSTART function that will find the first x coordinate on the topline that is not equal to Ly_wall.
%
% This coordinate will be the starting point of the row. In most of the 
% cases, it will be 0, but in some cases, when the grid is almost full, 
% it allows to fill the last cases.
%
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - top_line  : a vector containing the y coordinates of the top of the
%                current wall
%  - Ly_wall   : height  of the wall
%  - epsilon   : approximation constant
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - xstart    : coordinate of the starting point
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xstart=-1;
for i=1:size(top_line,2)
    
    if abs(top_line(1,i)-Ly_wall)>=epsilon
        
        xstart=max(0,(i-1)*epsilon);
        
        break;
    end
end

end

