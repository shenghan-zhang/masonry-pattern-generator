function [] = write_nodes( pos,figureref )
% WRITE_NODES Write the number of the nodes on an existing picture.
%
% %%%%%% usage %%%%%%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos         : vector containing the position of the nodes.
%  - figureref   : handle to the figure on which the nodes must be drawn.
%
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - none, the function only writes on the current figure. 
%
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also PLOT_BRICK, DRAW_STONES
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(figureref);

for i=1:size(pos,1)
    
    text(pos(i,1),pos(i,2),num2str(i),'Color',(1/255)*[100 100 100],'FontSize',12);

end


end

