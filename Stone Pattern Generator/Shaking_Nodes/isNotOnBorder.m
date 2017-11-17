function [ iNOB ] = isNotOnBorder( pos,Lx_wall,Ly_wall)
% ISNOTONBORDER function that will tell if a point is on the border or no.
%
% %%%%%% usage %%%%%%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos       : position of the point which we want to know if it's on the
%                border.
%  - Lx_wall   : length of the wall
%  - Ly_wall   : height of the wall
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - iNOB      : boolean which is 0 if the point is on the border and 1
%                else
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if pos(1,1)<1e-3 || abs(pos(1,1)-Lx_wall)<1e-3 || pos(1,2)<1e-3 || abs(pos(1,2)-Ly_wall)<1e-3
    
    iNOB=0;
    
else
    
    iNOB=1;
    
end


end

