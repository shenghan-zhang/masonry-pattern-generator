%
function [ A,C_,C,xy ] = compute_visibility_graph_from_vis_polygon_matlab( environnement,epsilon,alpha,vlim,ref_tab,Lx_wall_tot,varargin )
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
%  - Lx_wall_tot   : Width of the wall, including the blank region. 
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - A             : Adjacency matrix. Aij is 1 if vertex j can be seen
%                    from vertx i (of course it is symetric).
%  - C             : Cost matrix without weighting.
%  - Calpha        : Cost matrix with weighting.
%  - xy            : Nx2 matrix containing all the x-y coordinates of the
%                    vertices.
%
% %% AUTEUR : Shenghan Zhang
              
% %% DATE   : February 2016
%    Updated: March 2018
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numvarargs = length(varargin);
if numvarargs > 1
    error('compute_visibility_graph_from_vis_polygon_debug:TooManyInputs', ...
        'requires at most 1 optional inputs');
end
optargs = {'x'};
optargs(1:numvarargs) = varargin;
confine_direction = optargs{:};
addpath('C:\Users\shzhang\Google Drive\for_martin\cal_visibility');
guards=[];
for i=1:length(environnement) % Creating guards (observation points)
    guards=[guards;environnement{i}];
end
n=length(guards);

% for i=1:n % creating all the visibility_polygons
%     visibility_polygons{i}=visibility_polygon( [guards(i,1),guards(i,2)] , environnement , epsilon , 0.05 );
% end
A=zeros(n,n);
C_ = cell(1,length(alpha));
for a =1:length(alpha)
    C_{a} = zeros(n,n);
end 
% persistent xy
xy=guards;
% We iterate on the visibility polygons (but not those of the outer frame)
% resampled_stones = environnement{2:end}; 
nb_stone = length(environnement)-1;
bound_rec = cell(nb_stone,1);
for s = 1:nb_stone
    stone = environnement{s+1}; 
    min_x = min(stone(:,1));
    max_x = max(stone(:,1));
    min_y = min(stone(:,2));
    max_y = max(stone(:,2)); 
    rec = [min_x,max_y;
                 max_x,max_y;
                 max_x,min_y;
                 min_x,min_y]; 
    bound_rec{s} = rec;       
end
is_concave = false;
C = zeros(n,n,length(alpha)); 
parpool
ppm = ParforProgMon('progress', n-4);
for i=5:n % We check if the points are insight (i.e. if p_j is in the i-th polygon -> A(i,j)=1 & A(j,i)=1
%     if mod(i,100)==0
%     fprintf('At %d', i/n);
%     end
    % We iterate on the vertices that havent been checked already
     ppm.increment();
%     C_i = cell(n,1,length(alpha));
%     for a =1:length(alpha)
%         C_i{a} = zeros(n,1);
%     end
    node1 = xy(i,:);
    [A(i,:), C(i,:,:)] = loopOverj(i,n,xy,ref_tab,node1,A(i,:),C(i,:,:),alpha,nb_stone,bound_rec,environnement);

end
delete(gcp('nocreate'));
disp('finish calculating visibility');
for i = 1:n
    A(i:end,i) = A(i,i:end); 
end 
C_ = reGenerate(A,C,alpha,xy,Lx_wall_tot,confine_direction,vlim);
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

function [A_i, C_i] = loopOverj(i,n,xy,ref_tab,node1,A_i,C_i,alpha,nb_stone,bound_rec,environnement)
%   stone_arrange_e_ij = 1:nb_stone;  
%   stone_arrange_e_ij(stone_arrange_e_ij == ref_tab(i,1))=[]; 
  for j=i+1:n
        % If the vertex is in the visibility polygon
        node2 = xy(j,:);
        if ref_tab(i,1)==ref_tab(j,1) % If the polygon is the same
            if areNeighbors(i,j,ref_tab)
                dist = norm(node1-node2);
                [A_i(j), C_i(1,j,:)] = fill_AC(C_i(1,j,:), alpha, dist);
                continue
            else
                coords_poly = environnement{ref_tab(i,1)+1};
                is_block = checkBlock(node1, node2, coords_poly);
            end
        else
            is_block = false;
%             stone_arrange_e_ij(stone_arrange_e_ij == ref_tab(j,1))=[]; 
%             stone_arrange_e_ij = [ref_tab(i,1),ref_tab(j,1),stone_arrange_e_ij];  
            for s = 1:nb_stone
%                 s = stone_arrange_e_ij(si); 
                % we the stone is where the node is, we do the full check 
                % try to avoid the situation when the line ij passes
                % through a corner node in the rectangular, while i or j in
                % within the rectanguler
                if ~(s==ref_tab(i,1)||s==ref_tab(j,1))
                    coords_rec = bound_rec{s};
                    is_block = checkBlock(node1, node2, coords_rec);
                    if ~is_block
                        continue
                    end
                end
                coords_poly = environnement{s+1};
                is_block = checkBlock(node1, node2, coords_poly);
                if is_block
                    break
                end
            end
        end
        if ~is_block
            dist = norm(node1-node2);
            [A_i(j), C_i(1,j,:)] = fill_AC(C_i(1,j,:), ones(1,length(alpha)), dist);
%             A_i(j) = 1; % i,j could see each other
%             %   A(j,i) = A(i,j);
%             for k = 1:length(alpha)
%                 C_i(1,j,k) = dist;
%                 %       C_{k}(j,i) = C_{k}(i,j);
%             end
        end
    end
end
function C_ = integrateCi(C_,C_i,i)
    for a =1:length(C_)
        C_{a}(i,:) = C_i; 
    end 
end

function [A_ij, C_ij] = fill_AC(C_ij, alpha, dist)
A_ij = 1;
for k = 1:length(alpha)
%     C_i(1,j,k)
    C_ij(k) = alpha(k)*dist;
end
end


