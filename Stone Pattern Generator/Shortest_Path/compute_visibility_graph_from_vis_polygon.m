function [ A,C_,xy ] = compute_visibility_graph_from_vis_polygon_debug( environnement,epsilon,alpha,vlim,ref_tab,Lx_wall )
% COMPUTE_VISIBILITY_GRAPH_FROM_VIS_POLYGON computes the visibility graph
% of an environnement Appart from calling the visibility_graph function
% from the VisiLibity C++ library, it creates also the guards vector. The
% guards vector is the vector containing the points we want to compute the
% visibility from. In our case, every vertex will be a guard. It also
% computes the costs matrices C and Calpha that represent the differents
% costs between vertices without (C) or with (Calpha) weighting of the
% interfaces.
%
% %%%%%% usage %%%%%%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - environnement : M+1 x 1 cell array containing all the stones + the
%                    outside frame.
%  - epsilon       : Approximation constraint used by VisiLibity library.
%  - alpha         : Value between 0 and 1 representing the weight of the
%                    travel along the interfaces.
%  - vlim          : Width of the vertical bands on the sides in which
%                    travel is not allowed.
%  - ref_tab       : Nx2 matrix containing the stones number in the first
%                    column and the nodes number in the second column.
%                    Linked with environnement.
%  - Lx_wall       : Width of the wall.
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - A             : Adjacency matrix. Aij is 1 if vertex j can be seen
%                    from vertx i (of course it is symetric).
%  - C             : Cost matrix without weighting.
%  - Calpha        : Cost matrix with weighting.
%  - xy            : Nx2 matrix containing all the x-y coordinates of the
%                    vertices.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : February 2016
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
guards=[];
for i=1:length(environnement) % Creating guards (observation points)
    guards=[guards;environnement{i}];
end
n=length(guards);

for i=1:n % creating all the visibility_polygons
    visibility_polygons{i}=visibility_polygon( [guards(i,1),guards(i,2)] , environnement , epsilon , 0.05 );
end
A=zeros(n,n);
C_ = cell(1,length(alpha));


% We iterate on the visibility polygons (but not those of the outer frame)
for i=5:n % We check if the points are insight (i.e. if p_j is in the i-th polygon -> A(i,j)=1 & A(j,i)=1
    % We iterate on the vertices that havent been checked already
    for j=i+1:n
        % If the vertex is in the visibility polygon
        if inpolygon(guards(j,1),guards(j,2),visibility_polygons{i}(:,1),visibility_polygons{i}(:,2))
            
            A(i,j)=1;
            A(j,i)=1;
            % We check that the points are not in the prohibited bands on
            % the sides, if yes, we give them a really high cost.
            if guards(i,1) < vlim || guards(i,1) > Lx_wall-vlim || guards(j,1) < vlim || guards(j,1) > Lx_wall-vlim
                for k = 1:length(alpha)
                    C_{k}(i,j)=1e10;
                    C_{k}(j,i)=1e10;
                end
                
            else
                dist = sqrt((guards(i,1)-guards(j,1))^2+(guards(i,2)-guards(j,2))^2);
               
                if areNeighbors(i,j,ref_tab)
                    for k = 1:length(alpha)
                        C_{k}(i,j) = alpha(k)*dist;
                        C_{k}(j,i) = C_{k}(i,j);
                    end
                else
                    for k = 1:length(alpha)
                        C_{k}(i,j) = dist;
                        C_{k}(j,i) = C_{k}(i,j);
                    end
                end
                
            end
            
        end
        
    end
    
    xy=guards;
    
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