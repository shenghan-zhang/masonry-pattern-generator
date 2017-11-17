function [ pos,top_line,xstartnext,stonesNodes] = addBrick( pos,top_line,xstart,Lx_wall,Ly_wall,ind_row,ind_brick,epsilon,stonesNodes,option_corner,file_params)
% ADDBRICK core function, that will add a brick to the wall.
%
% It first checks the limits in which the brick has to fit. Then add the
% brick to the differents tabs (nodes, stones, etc.) and finally, check if
% an "understone" is necessary.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos         : vector containing the position of the nodes.
%  - top_line    : vector containing the position of the topline
%  - xstart      : first x coordinate of the brick
%  - Lx_wall     : length of the wall
%  - Ly_wall     : height of the wall
%  - ind_row     : index of the current row
%  - ind_brick   : index of the current brick in the row
%  - epsilon     : approximation constant
%  - stonesNodes : 1xM cell array containing the indexes of the stones
%                  nodes
%  - option_corner : 1 if this option must be activated, 0 else
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos         : the actualized coordinates of the nodes.
%  - top_line    : the actualized top_line
%  - xstartnext  : the coordinate of the next starting point
%  - stonesNodes : the stones cell actualized
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also ADDROW, FILL_WALL
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Computing brick Coordinates..............................................

[ystart]=getYstart(xstart,top_line,epsilon); % Get the y coordinate of the bottom part of the brick
[Lxb,Lyb]=create_brick([xstart,ystart],ind_row,ind_brick,epsilon,file_params); % Create brick dimensions

% Computing brick coordinates
xend=min(Lx_wall,xstart+Lxb);
yend=min(Ly_wall,ystart+Lyb);
if abs((xstart+epsilon)-Lx_wall)<epsilon/2
    xend=Lx_wall;
end
%xend=min(xend,xmax);
[xNextBrick]=getXnextBrick(top_line,xstart,Lx_wall,ind_row,epsilon);
if xNextBrick<xend
    
    yBrick=getYstart(xNextBrick,top_line,epsilon);
    
end

xNextBricks=xstart;
indexBricks=getIndexBrick(top_line,xstart,xend,epsilon,ind_row,Lx_wall);
yBricks=ystart;
% First, we compute all the gaps to fill between xstart and xend (ie
% coordinates of the stones that the stone would either cross or overpass)

while xNextBrick<xend %&& yBrick<Ly_wall
    xNextBricks=[xNextBricks,xNextBrick];
    yBricks=[yBricks,yBrick];
    xNextBrick=getXnextBrick(top_line,xNextBrick,Lx_wall,ind_row,epsilon);
    if xNextBrick~=Lx_wall
        
        yBrick=getYstart(xNextBrick,top_line,epsilon);
        
    end
    
end

nBricks=length(unique(indexBricks));

% If the stone goes over another (or many other) stones, we recalculate
% stone coordinates accordingly.
% First, we compute the maximum y cooridnate of those stones, the stone
% will be put on top of this one and all the other stones will be put
% underneath. If this maximum is equal to Ly_wall, then the stone will stop
% there.

if  option_corner==0 || nBricks>2  %|| xend==Lx_wall
    
    [ym,iym]=max(yBricks);
    
    if ym==Ly_wall
        
        xend=xNextBricks(iym);
        
    end
    
    for i=1:size(xNextBricks,2)
        
        if yBricks(i)~=ym
            
            ys=yBricks(i);
            ye=ym;
            xs=xNextBricks(i);
            
            if i==size(xNextBricks,2)
                
                xe=xend;
                
            else
                
                xe=xNextBricks(i+1);
                
            end
            
            x=[xs,xe,xe,xs];
            y=[ye,ye,ys,ys];
            [pos,stonesNodes]=addStone(x,y,pos,epsilon,stonesNodes);

        elseif yBricks(i)==ym && ym==Ly_wall
            
            break;
            
        end
        
    end
    
    dy=yend-ystart;
    ystart=ym;
    yend=min(ystart+dy,Ly_wall);
    x=[xstart,xend,xend,xstart];
    y=[yend,yend,ystart,ystart];
    [pos,stonesNodes]=addStone(x,y,pos,epsilon,stonesNodes);
    
elseif (nBricks==2 && length(unique(yBricks))==2) && option_corner == 1 %&& xend ~=Lx_wall
    
    [pos,stonesNodes,yend]=addPentagonalBrick(xstart,xend,ystart,yend,xNextBricks,yBricks,pos,stonesNodes,epsilon,Ly_wall);

elseif size(xNextBricks,2)==1 || length(unique(yBricks))==1
    
    x=[xstart,xend,xend,xstart];
    y=[yend,yend,ystart,ystart];
    [pos,stonesNodes]=addStone(x,y,pos,epsilon,stonesNodes);

end

top_line=updateTopLine(xstart,xend,yend,top_line,epsilon,length(stonesNodes));
xstartnext=xend;

end
