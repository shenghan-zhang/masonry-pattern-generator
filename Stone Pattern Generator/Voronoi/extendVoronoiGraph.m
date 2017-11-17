function [ vx,vy ] = extendVoronoiGraph(vx,vy )
% EXTENDVORONOIGRAPH is used as depending on how the voronoi graph is
% defined, the supposed "towards the infinite vertices" are not far enough.
% So we translate them further, using a hardcoded factor of 10^7 which has
% proven empirically to be sufficient. This function is used at line 147 of
% VoronoiLimit.m
%
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - vx      : x coordinates of the edges of the voronoiGraph
%  - vy      : y coordinates of the edges of the voronoiGraph
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - vx      : updated x coordinates of the edges of the voronoiGraph
%  - vy      : updated y coordinates of the edges of the voronoiGraph
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : january 2017
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:size(vx,2)
    
    if ismember(vx(2,i),vx(1,:))==0 % If the ending point is not a starting point, then it is a "toward the infinite vertex" and we translate it further
        
        dvx=vx(2,i)-vx(1,i);
        dvy=vy(2,i)-vy(1,i);
        vx(2,i)=vx(2,i)+10000000*dvx;
        vy(2,i)=vy(2,i)+10000000*dvy;
        
    end
    
end