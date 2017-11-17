function [ stones_nodes_out,row_vec,posStones] = divide_big_stones(Pos_tab,stones_nodes,A_seuil_division,row_vec,opt_division,epsilon,subdivisionRate)

n=size(stones_nodes,2);
for i=1:n
    stone=Pos_tab(stones_nodes{i},:);
    if get_area_polygon(stone)>A_seuil_division && randi([0,100])<subdivisionRate
        [stones_nodes,row_vec]=divide_stone(Pos_tab,stones_nodes,i,row_vec,opt_division,epsilon);
    end
end
stones_nodes_out=stones_nodes;
posStones=cell(1,size(stones_nodes_out,2));
for i=1:numel(stones_nodes_out)
    posStones{i}=Pos_tab(stones_nodes_out{i},:);
end
draw_stones(posStones,4,1,1.2,create_colors(200),0.1);


end

