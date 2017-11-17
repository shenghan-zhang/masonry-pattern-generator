function [ Lx,Ly,nx,ny ] = get_params_stght_pattern( pos,row,file_params)
% GET_PARAMS_STGHT_PATTERN will return the parameters of the straight pattern process process, if needed according to the position of the stone or the row of the stone.
%
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos : postion of the stone
%  - row : current row.
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - Lx     : length of the bricks.
%  - Ly     : height of the bricks.
%  - nx     : randomness on the length of the bricks.
%  - ny     : randomness on the height of the bricks. 
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=pos(1);
y=pos(2);
%%
in_dedicated_function='straight_pattern';
eval(file_params);%parameters_stone_masonry;
%% PARAMETERS DEFINTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

opt = option; % Choose between 'uniform', 'by_pos' or 'by_row'

switch opt
    case 'uniform'
        if (~exist('Lx_','var'))
            Lx_ = Lxy(1);
            Ly_ = Lxy(2);
            nx_ = nxy(1);
            ny_ = nxy(2);
        end 
        Lx = Lx_;%Lxy(1);
        Ly = Ly_;%Lxy(2);
        nx = nx_;%nxy(1);
        ny = ny_;%nxy(2);
        
    case 'by_row'
        lenLxy = length(Lx_);
        if (length(Lx_)~=length(Ly_))
            disp('there is something wrong');
        end
        lennxy = length(nx_);
        % ROWS DEFINTION
%         lengths(1,[1:10])=0.25;
%         lengths(1,[3,4,5,7,8,9,11,12,13])=0.08;
%         lengths(1,[14,15])=0.2;
%         heigths(1,[1,3,5,7])=0.18;
%         heigths(1,[2,4,6,8])=0.14;
%         nxs(1,[1,2,6,10,14,15])=0.2;
%         nxs(1,[14,15])=0.3;
%         nxs(1,[1:15])=0.1;
%         nys(1,[1:15])=0.0;
%         nys(1,[3,4,5,7,8,9,11,12,13])=00;
  
        % PROPERTIES ASSIGNMENT BY ROW
        if (lenLxy>1)
            if (row>length(Lx_))
                disp('WTF')
            end 
            Lx = Lx_(row);
            Ly = Ly_(row);
        else 
             Lx = Lx_;
             Ly = Ly_;           
        end 
        if (lennxy>1)
            nx = nx_(row);
            ny = ny_(row);
        else
            nx = nx_;
            ny = ny_;
        end
%         nx=nxs(1,row);
%         ny=nys(1,row);
        
    case 'by_pos'
        
        % ZONE DEFINITION
        a=0.1;
        b=0.2;
        c=0.3;
        d=0.4;
        
        % PROPERTIES ASSIGNEMENT BY POSITION
        if (y>=0 && y<a) || (y>=b && y<c) || y>=d
            Lx=0.20;
            Ly=0.0625;
            nx=0.00;
            ny=0.00;
        elseif (y>=a && y<b) ||  (y>=c && y<d)
            Lx=0.20;
            Ly=0.03125;
            nx=0.00;
            ny=0.00;
        end
end
end