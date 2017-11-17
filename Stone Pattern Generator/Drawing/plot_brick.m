function [] = plot_brick( p1,p2,p3,p4 )
% PLOT_BRICK Draw a rectangular brick according to its four corners.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - p1     : first corner (top left)
%  - p2     : second corner (top right)
%  - p3     : third corner (bottom right)
%  - p4     : fourth corner (bottom left)
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - none, the brick is drawn in the current graph.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also DRAW_STONES, DRAW_STONES2
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x=[p1(1);p2(1);p3(1);p4(1);p1(1)];
y=[p1(2);p2(2);p3(2);p4(2);p1(2)];

fill(x,y,[153/255,0,0],'EdgeColor','k',...
    'LineWidth',0.05)
end

