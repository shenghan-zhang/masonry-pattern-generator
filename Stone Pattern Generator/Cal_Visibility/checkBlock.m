function is_block = checkBlock(node_i, node_j, coords_polygon, is_concave)
nb_node = length(coords_polygon(:,1));
XY1 = [node_i, node_j];
pass_node = [];
if nargin < 4
    is_concave = false;
end
tolerence = 1e-5; 
for e = 1:nb_node
    p_next = mod(e,nb_node-1)+1;
%     if e==nb_node
%        XY2 = [coords_polygon(nb_node,:) coords_polygon(1,:)];   
%     else
    XY2 = [coords_polygon(e,:) coords_polygon(p_next,:)];        
%     end
    out = lineSegmentIntersect(XY1,XY2);
    if out.intAdjacencyMatrix==1
        if out.intNormalizedDistance2To1 < tolerence
            if ~ismember(e,pass_node)
                pass_node = [pass_node,e]; % find node on one one side of the
            end
        elseif out.intNormalizedDistance2To1 > 1-tolerence
            if ~ismember(p_next,pass_node)
                pass_node = [pass_node,p_next]; % find node on one one side of the
            end            
        else
            is_block = true;
            return;
        end
    end
end
nb_pass_node = length(pass_node);
if nb_pass_node<=1
    % TO BE DONE: for concave polygons, find the mid point of the
    % intersection segments sequentially.
    is_block = false;
    return;
elseif nb_pass_node == 2
    xq = (coords_polygon(pass_node(1),1)+coords_polygon(pass_node(2),1))/2.0;
    yq = (coords_polygon(pass_node(1),2)+coords_polygon(pass_node(2),2))/2.0;
    strictly_in = strictlyinpolygon(xq,yq,coords_polygon(:,1),coords_polygon(:,2));
    is_block = strictly_in;
    return;
else
    if is_concave
        is_block = false;
        return;
    else
        for i = 1:nb_pass_node-1
            xq = (coords_polygon(pass_node(i),1)+coords_polygon(pass_node(i+1),1))/2.0;
            yq = (coords_polygon(pass_node(i),2)+coords_polygon(pass_node(i+1),2))/2.0;
            strictly_in = strictlyinpolygon(xq,yq,coords_polygon(:,1),coords_polygon(:,2));
            if strictly_in
                is_block = true;
                return;
            end
        end
        xq = (coords_polygon(pass_node(nb_pass_node),1)+coords_polygon(1,1))/2.0;
        yq = (coords_polygon(pass_node(nb_pass_node),2)+coords_polygon(1,2))/2.0;
        strictly_in = strictlyinpolygon(xq,yq,coords_polygon(:,1),coords_polygon(:,2));
        if strictly_in
            is_block = true;
            return;
        end
        is_block = false;
        return;
    end
end
end

function strictly_in = strictlyinpolygon(xq,yq,coords_x,coords_y)
[in, on] = inpolygon(xq,yq,coords_x,coords_y);
if in && ~on
    strictly_in = true;
    return;
else
    strictly_in = false;
    return;
end
end