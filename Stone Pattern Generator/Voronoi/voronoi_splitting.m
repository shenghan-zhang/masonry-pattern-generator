function [ posTabNew,stonesNodesNew,row_vec ] = voronoi_splitting(posTabOld,stonesNodesOld,i,n,epsilon,row_vec)
% VORONOI_SPLITTING takes as an input a list of polygons and
% divide those with an area superior to aireSeuil using a voronoi diagram.
%
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - posTabIOld      : 2xN xy coordinates of the nodes in their initial
%                      state (i.e. before any voronoi splitting)
%  - stonesNodesOld  : 1xM cell containing the list of the nodes that each
%                      stone comprises.in their initial state (i.e. before
%                      any voronoi splitting)
%  - i               : Integer corresponding to the stone to split using
%                      voronoi algorithm
%  - n               : Number of points to place as seeds
%  - epsilon         : approximation constant
%  - row_vec         : Mx1 vector corresponding to each stone row
%
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - posTabNew       : Updated nodes coordinates tab
%  - stonesNodesNew  : Updated cell containing the stones nodes id's.
%  - row_vec         : Updated row_vec
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : january 2017
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computing the delimiting polygon
polygon=posTabOld(stonesNodesOld{i},:);

% Computing its min and max coordinates
xmax=max(polygon(:,1));
xmin=min(polygon(:,1));
ymax=max(polygon(:,2));
ymin=min(polygon(:,2));
deltax=xmax-xmin;
deltay=ymax-ymin;
x=zeros(n,1);
y=zeros(n,1);

% Placing of the seeds

for j=1:n
    x(j)=xmin+randi([-10,110])*deltax/100;
    y(j)=ymin+randi([-10,110])*deltay/100;
end

% Computing the voronoi new vertices and stones
[V,C]=VoronoiLimit(x,y,'bs_ext',polygon,'figure','off','epsilon',epsilon);

% Updating data structures
posTabNew=posTabOld;
stonesNodesNew=stonesNodesOld;
vToPosTab=zeros(size(V,1),1);

for j=1:size(V,1) % We iterate on each point
    
    pt=V(j,:);
    [posTabNew,indexpt,stonesNodesNew]=addOrFindPoint(pt,posTabNew,epsilon,stonesNodesNew);
    vToPosTab(j)=indexpt; % We construct the correspondance matrix between V and postab
    
end

% First we remove the polygon that we splitted
stonesNodesNew(i)=[];
row_vec=[row_vec;row_vec(i)*ones(size(C,1),1)];
row_vec(i)=[];
nstart=size(stonesNodesNew,2);
stonesNodesNew=[stonesNodesNew,cell(1,size(C,1))];

for j=1:size(C,1)% We iterate on the created stones
    
    indexes=flip(C{j}); % We get the indexes
    indexesInPosTab=vToPosTab(indexes); % we convert those indexes into postab indexes
    newStone=indexesInPosTab;
    stonesNodesNew{nstart+j}=newStone'; % We add the stone to the cell array of stones nodes indexes
    
end

for j=1:numel(stonesNodesNew)
    
    stonesPos{j}=posTabNew(stonesNodesNew{j},:);
    
end





end

