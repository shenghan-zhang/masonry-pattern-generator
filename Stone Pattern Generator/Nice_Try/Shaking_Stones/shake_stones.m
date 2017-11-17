function [ shaken_stones ] = shake_stones( stones,sigma_r,sigma_p,min_dist,Lx_wall, Ly_wall)
% SHAKE_STONES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function that takes a 1xN cell array containing the x,y coordinates of
% the stones and slightly translate/rotate each stone with a random x-y
% translation and a random rotation around its centroid. 
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - stones    : the 1xN cell array containing the x-y coordinates of the
%                stones
%  - sigma_r   : the standard deviation of the rotation we want to apply
%                (we will use a normal distribution with mean =0)
%  - sigma_p   : the standard deviation of the translation we want to apply
%  - min_dist  : the minimal distance that should remain between two
%                polygons after shaking. 
%  - Lx_wall   : Width of the wall
%  - Ly_wall   : Height of the wall
% 
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - shaken_stones : a 1xN cell array containing the x-y coordinates of the
%                    shaken stones.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also SHAKE_STONES, ROTATE_POLYGON
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
str=[];
shaken_stones=stones;
for i=1:size(stones,2)
    
    polygon=stones{1,i};
    is_valid=0;
    k=1;
    
    while is_valid==0 && k<500
        
        rotation=normrnd(0,sigma_r);
        tx=normrnd(0,sigma_p);
        ty=normrnd(0,sigma_p);
        polygon_rotated=rotate_polygon(polygon,rotation);
        polygon_translated=[polygon_rotated(:,1)+tx,polygon_rotated(:,2)+ty];
        
        if check_validity_polygon(polygon_translated,stones,i,min_dist,Lx_wall,Ly_wall)==1
            is_valid=1;
            shaken_stones{1,i}=polygon_translated;
            
        end
        
        k=k+1;
        
    end
    
    if is_valid==0
        
        str=[str, num2str(i),', '];
        
    end
    
end        

if length(str)>1
    
    str(end-1:end)=[];
    
end

disp(['Stones shaked, shaking unsucessful in stones : ', str]);



