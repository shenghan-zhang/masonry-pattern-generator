function [ stones_with_corners ] = put_corners( stones )
% PUT_CORNERS puts corners to polygons according to the max/min x-y coordinates
% It is used if the option regular_pattern is set to 1, to avoid fake
% rounding of the corners of the bricks by the resampling operation. 
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - stone      : 1xM cell array containing all the stones.
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - stones_with_corners : updated stones (1xM cell array) with corners. 
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : January 2016
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stones_with_corners=cell(1,size(stones,2));

for i=1:length(stones)
    
    minx=min(stones{i}(:,1));
    maxx=max(stones{i}(:,1));
    miny=min(stones{i}(:,2));
    maxy=max(stones{i}(:,2));
    c1=[minx,miny];
    c2=[minx,maxy];
    c3=[maxx,maxy];
    c4=[maxx,miny];
    new_stone=[stones{i};c1;c2;c3;c4];
    new_stone2 = unique(new_stone,'rows');
    if (size(new_stone,1)~=size(new_stone2,1))
        new_stone = new_stone2;
    end
    new_stone=order_polygon(new_stone);
    stones_with_corners{i}=new_stone;
    
end


end

