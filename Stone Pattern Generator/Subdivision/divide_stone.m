function [stones_nodes,row_vec] = divide_stone(Pos_tab,stones_nodes,i,row_vec,opt,epsilon)
% DIVIDE_STONE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function that takes a polygon as an input and divide it splitting it in
% two parts.
%
% %%%%%% usage %%%%%%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - Pos_tab     : N x 2 Matrix containing the position of the nodes
%  - stone_nodes : Vector containing the stone nodes indexes(!!!ordered!!!)
%  - i           : index of the stone to split
%  - row_vec     : Mx1 vector containing the row indexes of the bricks
%  - opt         : splitting option
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - isConcave   : Boolean saying if the polygon is concave (1) or not (0).
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also SHAKE, TESTNODE
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=length(stones_nodes);
stone=Pos_tab(stones_nodes{i},:);
n_vertices=size(stone,1);

stone_nodes=stones_nodes{i};

stone=[stone(end,:);stone;stone(1,:)];
angle=zeros(1,size(stone,1)-2);

for j=2:size(stone,1)-1
    
    p1=stone(j-1,:);
    p2=stone(j,:);
    p3=stone(j+1,:);
    angle(1,j-1)=getAngleVectors(p1,p2,p3);
    
end

[~,imax]=max(angle);
ica=imax;

if ica>n_vertices/2
    
    icb=max(1,ica-round(n_vertices/2));
    
else
    
    icb=min(n_vertices,ica+round(n_vertices/2));
    
end


if isempty(ica)==0 && isempty(icb)==0
    
    if ica<icb
        
        stones_nodes{i}=stone_nodes([icb:n_vertices,1:ica]);
        stones_nodes{n+1}=stone_nodes(ica:icb);
        
    else
        
        stones_nodes{i}=stone_nodes(icb:ica);
        stones_nodes{n+1}=stone_nodes([ica:n_vertices,1:icb]);
        
    end
    
    row_vec=[row_vec;row_vec(i)];
    
end



end