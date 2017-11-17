function [ d ] = distanz( p1,p2 )
% DISTANZ function that compute the distance between two points 
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - p1  : first point
%  - p2  : second point
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - d   : distance
%
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:size(p2,1)
    
    d(1,i)=sqrt((p1(1,1)-p2(i,1))^2+(p1(1,2)-p2(i,2))^2);
%     d2 = norm(p2-p1,2);
%     if abs(d2 - d) > 0.00001
%         disp('something is wrong'); 
%     end    
end


end

