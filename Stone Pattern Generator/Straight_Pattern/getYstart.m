function [ y ] = getYstart( xstart,topline,epsilon )
%GETYSTART function that will give the y coordinate of a given x coordinate on the topline.
%
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - xstart    : the x coordinate from where we want to search
%  - top_line  : a vector containing the y coordinates of the top of the
%                current wall
%  - epsilon   : approximation constant
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - y         : coordinate of the topline at ystart
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ind=round(xstart/epsilon)+1;
y=topline(1,ind);
y=round(y/epsilon)*epsilon;

end

