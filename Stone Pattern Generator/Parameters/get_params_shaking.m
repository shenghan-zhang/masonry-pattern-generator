function [nxr,nyr] = get_params_shaking(pos,file_params)
% GET_PARAMS_SHAKING will return the parameters of the shaking process, if needed according to the position of the stone.
%
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos    : postion of the stone
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - nxr    : noise to put on the x coordinates.
%  - nyr    : noise to put on the y coordinates. 
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=pos(1);
y=pos(2);
%%
in_dedicated_function = 'shaken_pattern';
eval(file_params);
%% PARAMETERS DEFINTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
opt=option; % Choose between 'uniform' or 'by_zone' 
switch opt
    case 'uniform'
        
        nxr=noise(1);
        nyr=noise(2);

    case 'by_pos'
        
        % ZONE DEFINITION
        a=0.10;
        b=0.16;
        c=0.20;
        d=0.26;
        e=0.37;
        f=0.42;
        g=0.45;
        h=0.50;
        
        % ASSIGNEMENT OF PROPERTIES BY ZONE
        if (y>=0 && y<a) || (y>=d && y<e) || y>=h
            nxr=0.001;
            nyr=0.001;
        elseif (y>=a && y<b) || (y>=c && y<d) || (y>=e && y<f) || (y>=g && y<h)
            nxr=0.002;
            nyr=0.002;
        elseif (y>=b && y<c) ||  (y>=f && y<g)
            nxr=0.002;
            nyr=0.002;
        end
end
end