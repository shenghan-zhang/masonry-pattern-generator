function [ topline ] = updateTopLine( xstart,xend,yend,topline,epsilon,n )
% UPDATE_TOPLINE function that updates the topline when a new brick is added to the wall.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - xstart      : x coordinate of the starting point
%  - xend        : x coordinate of the ending point
%  - yend        : top coordinate of the brick
%  - topline     : old topline
%  - epsilon     : Approximation constant
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - topline     : updated topline
%
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ind_start=round(xstart/epsilon+1);
ind_end=round(xend/epsilon);
topline(1,ind_start:ind_end)=yend;
topline(2,ind_start:ind_end)=n;


end
