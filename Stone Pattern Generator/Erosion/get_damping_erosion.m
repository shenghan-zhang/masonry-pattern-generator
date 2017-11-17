function [ damp ] = get_damping_erosion( x,y,contact_points,a,b,seuil_contact )
%GET_DAMPING_EROSION function that will compute the damping factor for the erosion with contact points.
%
% The damping factor is 0 if we are close from the contact point and 1 if 
% we are far away. Between that (when the% distance is between a and b), the
% damping factor grows linearly. If the point is influenced by two different 
% contact points, the closest is choosen. There is also a limit on the 
% length of the edge, if an edge is <seuil_contact, then there is no contact 
% point.
%
% ^
% |1        -------                       ---------
% |                \                     /
% |                 \                   /
% |                  \                 /
% |                   \               /
% | 0                  \_____________/
%                 -b   -a     0      a    b
%  <--------------------------|----------------------------------> distance
%
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - x              : x coordinate of the current point
%  - y              : y coordinate of the current point
%  - contact_points : Px3 matrix containing the coordinates of the contact
%                     points in the two first columns, and the lengths of
%                     the edges concerned in the third column.
%  - a              : length of the zone where the damping function is 0
%                     around the contact point.
%  - b              : length of the zone till which the damping function
%                     grows linearly till 1.
%  - seuil_contact  : limit on the edge length, if the edge is <
%                     seuil_contact, there is no contact point on this
%                     edge.
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - damp           : scalar value between 1 (away from contact point) and
%                     0 (at the contact point).
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also ERODE_POLYGON
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[dist,ind]=min(distanz([x,y],contact_points(:,1:2)));
longueur=contact_points(ind,3);

if longueur>seuil_contact
    
    a=a*longueur;
    b=b*longueur;
    
    if dist<a
        
        damp=0;
        
    elseif dist>=a && dist<b
        
        damp=max(0,(dist-a)/(b-a));
        
    else
        
        damp=1;
        
    end
    
    
else
    
    damp=1;
    
end



end

