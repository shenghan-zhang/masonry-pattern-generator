function [paths] = dijkstra_modified(A,xy,SID,FID,ref_tab,alpha,vlim)
% DIJKSTRA_MODIFIED computes the shortest path with an adjacency matrix an a xy coordinates tab.
%
% This function is just a slight modification of the function dijkstra.m
% made by Joseph Kirk (url below). I removed the possibility to use
% different kinds of inputs and added the possibility to have different
% weights depending on the zone you travel (plain mortar or interface
% mostly).
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - A      : Adjacency matrix
%  - xy     : Nx2 tab of the x-y coordinates of the vertices
%  - SID    : Id of the starting point
%  - FID    : Id of the ending point
%  - ref_tab: ref_tab is a data structure containing two columns and that
%             allows to know if two nodes are neighbors on a stone or not.
%             The first column contains the number of the stone, the second
%             column contains the id of the current vertex and the last
%             column contains the number of vertices of the current stone.
%  - alpha  : alpha is a multplying factor applied to the distance traveled
%             on the interfaces. If alpha is < 1, the path found will be
%             more "stuck" to the interfaces and if alpha is >1, it will
%             prefer to go through the mortar.
%  - vlim   : Trajects on the edges of the wall are prohibited in an area
%             delimited by x<vlim*Xmax and x>(1-vlim)*Xmax
%             
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - paths  : a vector containing the id's of the nodes composing the
%             shortest path.
%
% %% AUTEUR : Martin HOFMANN for the modifications, general function made
%             by J. Kirk.
% %% DATE   : FEBRUARY 2016
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     narginchk(3,6);
n=size(A,1);
[E,cost] = process_inputs(A,xy,ref_tab,alpha,vlim);


% Find the minimum costs and paths using Dijkstra's Algorithm


% Initializations
iTable = NaN(n,1);
minCost = Inf(n,1);
isSettled = false(n,1);
path = num2cell(NaN(n,1));
I = SID;
minCost(I) = 0;
iTable(I) = 0;
isSettled(I) = true;
path(I) = {I};

% Execute Dijkstra's Algorithm for this vertex
while any(~isSettled(FID))
    
    % Update the table
    jTable = iTable;
    iTable(I) = NaN;
    nodeIndex = find(E(:,1) == I);
    
    % Calculate the costs to the neighbor nodes and record paths
    for kk = 1:length(nodeIndex)
        J = E(nodeIndex(kk),2);
        if ~isSettled(J)
            c = cost(I,J);
            empty = isnan(jTable(J));
            if empty || (jTable(J) > (jTable(I) + c))
                iTable(J) = jTable(I) + c;
                path{J} = [path{I} J];
                
            else
                iTable(J) = jTable(J);
            end
        end
    end
    
    % Find values in the table
    K = find(~isnan(iTable));
    if isempty(K)
        break
    else
        % Settle the minimum value in the table
        [~,N] = min(iTable(K));
        I = K(N);
        minCost(I) = iTable(I);
        isSettled(I) = true;
    end
end

% Store costs and paths
costs = minCost(FID);
paths = path(FID);
end

% -------------------------------------------------------------------
function [E,C] = process_inputs(A,xy,ref_tab,alpha,vlim)

% Inputs = (A,xy)
n=size(A,1);
E = a2e(A);
D = ve2d(xy,E,ref_tab,alpha,vlim);
C = sparse(E(:,1),E(:,2),D,n,n);



end

% Convert adjacency matrix to edge list
function E = a2e(A)
[I,J] = find(A);
E = [I J];
end

% Compute Euclidean distance for edges
function D = ve2d(V,E,ref_tab,alpha,vlim)
VI = V(E(:,1),:);
VJ = V(E(:,2),:);
maxX=max(VI(:,1));
D=zeros(1,size(E,1));
for i=1:size(E,1)
    % First we check if the two points are on the prohibited vertical zones
    % delimited by x<vlim*maxX and x>(1-vlim)*maxX
    if (VI(i,1)<vlim*maxX || VJ(i,1)<vlim*maxX) || (VI(i,1)>(1-vlim)*maxX || VJ(i,1)>(1-vlim)*maxX)
        D(i)=1e10; % If this is the case, we give an enormous weight to the travel
    elseif alpha~=1 % If not, we check if the nodes are neighbors on a polygon
        if areNeighbors(E(i,1),E(i,2),ref_tab) 
            D(i)=alpha*sqrt(sum((VI(i)-VJ(i)).^2,2)); % If this is the case we mutiply the distance by alpha to give it less (or more) weight
        else
            D(i)=sqrt(sum((VI(i,:)-VJ(i,:)).^2,2)); % If not, the distance is just the euclidean distance. 
        end
    elseif alpha==1
        D(i)=sqrt(sum((VI(i,:)-VJ(i,:)).^2,2));
    end
end
end

function aN = areNeighbors(i,j,ref_tab) % Small function that determines if two nodes are neighbors on a polygon using ref_tab (see MAKE_ENVIRONNEMENT.m)
if ref_tab(i,1)==ref_tab(j,1) % If the polygon is the same 
    n1=ref_tab(i,2); % first node index
    n2=ref_tab(j,2); % second node index 
    n_vertices=ref_tab(i,3); 
    if abs(n2-n1)==1 || (n1==n_vertices && n2==1) || (n2==n_vertices && n1==1);
        aN=1;
    else
        aN=0;
    end
else
    aN=0;
end
end




