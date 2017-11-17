function [ pos,top_line,stonesNodes,stonesPos,row_vec,neighbors ] = fill_wall( Lx_wall,Ly_wall,epsilon,option_corner,file_params)
% FILL_WALL core function that will initialize all the useful variables and fill the wall adding rows while the wall is not full.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - Lx_wall       : Length of the wall
%  - Ly_wall       : Height of the wall
%  - epsilon       : Approximation constant.
%  - option_corner : 0 : classical straight pattern ,1 : pentagonal bricks
%                    option
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos         : matrix containing the position of the nodes
%  - top_line    : vector containing the y coordinates of the topline
%  - stones      : Mx4 matrix containing the stones coordinates with the
%                  following format:
%                  [xstart1, xend1, ystart1, yend1;
%                   xstart2, xend2, ystart2, yend2;
%                   ...
%                   xstartM, xendM, ystartM, yendM];
%  - stones_nodes: 1xM array of cells containing the indexes of the nodes
%                  comprised in each stone.
%  - stones_pos  : 1xM array of cells containing the x-y position of the
%                  stones.
%  - row_vec     : a Mx1 vector of the rows index of the bricks. 
%  - neighbors   : Px2 matrix of neighbor stones indexes.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also ADDBRICK, ADDROW
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while 1>0 % Forever (while the validity of the pattern has not been proved)
    
    pos=[];
    row_vec=[];
    stonesNodes={};
    stonesPos={};
    top_line=zeros(1,round(Lx_wall/epsilon)); % Number of points in the topline Lx/epsilon.
    ind_row=1;
    v = VideoWriter('peaks20.avi');
    v.Quality = 100;
    v.FrameRate = 5;
    open(v)
    fig1 = figure;
    axis([0 Lx_wall 0 Ly_wall])
    axis equal
    ax = gca;
    ax.Units = 'pixels';
    posi = ax.Position;
    marg = 0;
    rect = [-marg, -marg, posi(3)+2*marg, posi(4)+2*marg];    
    nb_f=1;
    set(fig1.CurrentAxes,'visible','off');
    M(nb_f) = getframe(gcf);
    nb_f = nb_f+1;
    
    while sum(abs(top_line(1,:)-Ly_wall)<epsilon/2)<length(top_line)
        
        [pos,top_line,row_vec,stonesNodes,nb_f,M,v,fig1]=addrow(Lx_wall,Ly_wall,pos,top_line,ind_row,row_vec,epsilon,stonesNodes,option_corner,fig1,nb_f,M,v,file_params);
        ind_row=ind_row+1;
    end
    close(v)
    [stonesNodes,stonesPos]=get_all_nodes(pos,stonesNodes,epsilon);
    
    if check_validity2(pos,stonesNodes,Lx_wall,Ly_wall,epsilon)==1
        
        break;
        
    else
        
        disp('failed straight pattern, redo');

    end
end

to_del=[];

for i=1:length(stonesPos)
    
    if length(stonesPos{i})<3
        
        to_del=[to_del;i];
        
    elseif is_to_del(stonesPos{i})
        
        to_del=[to_del;i];
        
    end
    
end

if isempty(to_del)==0
    
    stonesPos(to_del)=[];
    stonesNodes(to_del)=[];
    row_vec(to_del)=[];
    
end

neighbors=find_neighbors(stonesNodes);

end
