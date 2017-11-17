function [] = draw_contact_points(contact_points,figureref)
% DRAW_CONTACT_POINTS Draw the contact points between the stones. 
% 
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - contact_points : QX1 Cell of Nx2 matrices containing the x-y
%                     coordinates of the contact points.
%  - figureref      : handle to the figure in which it must be drawn. 
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - none, it will just draw the contact points on the figure "figureref"
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(figureref)

for i=1:size(contact_points,2)
    
    for j=1:size(contact_points{i},1)
        
        plot(contact_points{i}(j,1),contact_points{i}(j,2),'wo');
        
    end
    
end

drawnow;
end

