%%
% re-generate the cost matrix  
function [C_] = reGenerate(A,C,alpha,xy,Lx_wall_tot,confine_direction,vlim)
n = length(xy(:,1)); 
C_ = cell(1,length(alpha));
for a =1:length(alpha)
    C_{a} = zeros(n,n);
end 
for a =1:length(alpha)
    if (2*length(C_)==size(C,3))
    C_{a} = C(:,:,2*a);
    else
        C_{a} = C(:,:,a);
        if length(C_)~=size(C,3)
            error('Something is wrong with the size of the matrix')
        end 
    end 
    for i = 1:n
        C_{a}(i:end,i) = C_{a}(i,i:end); 
    end     
end
for i=5:n % We check if the points are insight (i.e. if p_j is in the i-th polygon -> A(i,j)=1 & A(j,i)=1
    node1 = xy(i,:);
    for j=i+1:n
        node2 = xy(j,:);
        if A(i,j)
            coords_node = [node1; node2]; 
            is_confined = inConfinedRegion(coords_node, confine_direction, Lx_wall_tot, vlim);
            if is_confined
%             if inConfinedRegion([node1; node2], confine_direction, Lx_wall, vlim)
                for k = 1:length(alpha)
                    C_{k}(i,j)=1e10;
                    C_{k}(j,i)=1e10;
                end
            end
        end
    end
end
end