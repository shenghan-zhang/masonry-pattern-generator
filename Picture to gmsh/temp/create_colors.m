function [ colors ] = create_colors(n)
% CREATE_COLORS Creates an mx3 matrix of RGB colors randomly. 
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - n        : number of colors to be created
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - colors   : mx3 matrix of RGB colors
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colors=rand(n,3)/5-0.1; 
b_color=repmat(1/255.*[23,236,236],n,1);
colors=b_color+colors;

for i=1:n
    colors(i,:)=min(colors(i,:),[1,1,1]);
    colors(i,:)=max(colors(i,:),[0,0,0]);
end
