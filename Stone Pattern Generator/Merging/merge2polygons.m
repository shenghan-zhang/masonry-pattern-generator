function [ stonesNodesOut ] = merge2polygons( stonesNodes,stonesNodesUpdated,i,j )
% MERGE2POLYGONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function that takes two polygons which satisfy the merging conditions
% (see satisfyMergingConditions.m) and merges them. Caution, the output is
% not necessarily convex. 
%
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - stonesNodes    :  a 1xM cell array containing the vertices of the
%                     stones before any stone had been merged.
%  - stonesNodesUpdated : a 1xN cell array containing the vertices of the
%                     stones with some of the previous stones already
%                     merged.
%  - i              : index of the first stone to merge. 
%  - j              : index of the second stone to merge. 
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - stonesNodesOut : The updated cell array containing the merged stone
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also MERGEPOLYGONS, SATISFYMERGINGCONDITIONS
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p1=stonesNodes{i}; % indexes of the first polygon
p2=stonesNodes{j}; % indexes of the second poylgon

% The point is to find the correct starting point for the first polygon and
% the correct starting point for the second polygon. Then we can join the
% polygons and the resultant will be the merged polygon. 
% The starting point will always be the furthest index in common


[ic1]=find(ismember(p1,p2)); % find the positions of the common indexes in the first polygon
[ic2]=find(ismember(p2,p1)); % find the positions of the common indexes in the second polygon

if ic1(1)~=1 || sum(ic1) == 3 
    
    ic1start=max(ic1);
    
else
    
    ic1start=1;
    
end

if ic2(1)~=1 || sum(ic2) == 3
    
    ic2start=max(ic2);
    
else
    
    ic2start=1;
    
end

p1ordered=p1(mod((1:end)+ic1start-2,end)+1); % We reorganize the first polygon
p2ordered=p2(mod((1:end)+ic2start-2,end)+1); % We reorganize the second polygon
p2ordered=p2ordered(2:end-1); % We cut both starting and ending point as they are already in p1
pn=unique([p1ordered,p2ordered],'stable'); % Merged polygon
stonesNodesOut=[stonesNodesUpdated,pn];  


end

