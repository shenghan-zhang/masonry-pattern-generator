function [] = write_stones( stones_pos,figureref )
% WRITE_NODES Write the number of the stones on an existing picture.
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

for i=1:size(stones_pos,2)
    
    xmax=max(stones_pos{i}(:,1));
    xmin=min(stones_pos{i}(:,1));
    ymax=max(stones_pos{i}(:,2));
    ymin=min(stones_pos{i}(:,2));
    ymean=(ymin+ymax)/2;
    xmean=(xmin+xmax)/2;
    text(xmean,ymean,num2str(i),'Color',(1/255)*[100 100 100],'FontSize',12);
    
end


end
