function [ SID,FID ] = get_points(xy, point_start_end)
% GET_POINTS function that allows the user to pick the starting and ending point in the current figure.
% 
% The function takes the entry of the user and instead of creating a point
% in the middle of the mortar, takes the closest vertex that exists. That
% allow not to recompute the visibility graph at each shortest path
% request, as no additional point is needed. 
% 
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - xy        : Nx2 matrix containing the x-y coordinates of all the
%                vertices
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - SID       : Id of the starting point
%  - FID       : Id of the ending point
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : FEBRUARY 2016
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('point_start_end','var')
     disp('press any key to select the start point ... ');
     pause();
     [start_x, start_y] = ginput(1);
     disp('press any key to select the end point ... ');
     pause();
     [finish_x, finish_y] = ginput(1);
else
    start_x=point_start_end(1,1);
    start_y=point_start_end(1,2);
    finish_x=point_start_end(2,1);
    finish_y=point_start_end(2,2);
%     [start_x, start_y] = point_start_end{1};
%      [finish_x, finish_y] = point_start_end{2};
end

dist_SID=Inf;
dist_FID=Inf;

% For loop to get the closest vertices
for i=1:size(xy,1)
    if distance(start_x,start_y,xy(i,1),xy(i,2))<dist_SID
        SID=i;
        dist_SID=distance(start_x,start_y,xy(i,1),xy(i,2));
    end
    if distance(finish_x,finish_y,xy(i,1),xy(i,2))<dist_FID
        FID=i;
        dist_FID=distance(finish_x,finish_y,xy(i,1),xy(i,2));
    end
end


end

