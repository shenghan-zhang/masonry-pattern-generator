function [ Lx,Ly ] = create_brick( pos,ind_row,ind_brick,epsilon,file_params)
% CREATE_BRICK function that will create the aleatory dimensions of a brick, given a medium length and a standard deviation.
%
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos       : x-y position of the bottom left corner of the brick
%  - ind_row   : index of the current row
%  - ind_brick : index of the current brick 
%  - epsilon   : approximation constant
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - Lx        : length of the brick
%  - Ly        : height of the brick
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also ADDBRICK
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Lx_bricks,Ly_bricks,nx,ny]=get_params_stght_pattern(pos,ind_row,file_params); % get the parameters 
    in_dedicated_function='straight_pattern';
    parameters_stone_masonry;
    if (~exist('option_long','var'))
        option_long = 'odd';
    end
    if (~exist('option_set_initial','var'))
        option_set_initial = 0.5;
    end
    if(strcmp(option_long,'even'))
        if mod(ind_row,2)==1 && ind_brick ==1 % If the row is even, we divide the length by two
            Lx_bricks=Lx_bricks*option_set_initial;
            nx=nx*option_set_initial;
        end        
    else
        if mod(ind_row,2)==0 && ind_brick ==1 % If the row is even, we divide the length by two
            Lx_bricks=Lx_bricks*option_set_initial;
            nx=nx*option_set_initial;
        end
    end
Lx=Lx_bricks*normrnd(1,nx); % noise on the dimensions
Ly=Ly_bricks*normrnd(1,ny); % noise on the dimensions 
Lx=max(epsilon,round(Lx/epsilon)*epsilon); % maximum is used so that the brick cannot have negative dimensions
Ly=max(epsilon,round(Ly/epsilon)*epsilon);

end

