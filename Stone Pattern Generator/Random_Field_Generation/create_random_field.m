function [ variability,Xq,Yq ] = create_random_field( m,n,corr,mean_var)
% CREATE_RANDOM_FIELD generates a random field given the size of the map.
% function that generates a random field according to the size of the grid
% (m x n) and statistical parameters. It uses the functions given in the
% Random Fiel Simulation Toolbox by Qiqi Wang and Paul G. Constantine
% (link below).
%
% http://www.mathworks.com/matlabcentral/fileexchange/27613-random-field-simulation
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - m           : number of samples along x axis
%  - n           : number of samples along y axis
%  - corr.       : data structure containing the useful parameters (see
%                  randomfield.m for detailed explanations about the data
%                  structure).
%  - mean_var    : mean value of the random field created
%
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - variability : The random field representing the variability of the
%                  stones' durability in our case.
%  - Xq          : Mesh (x coordinates)
%  - Yq          : Mesh (y coordinates)
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : december 2016
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xq = linspace(0,1,m);
yq = linspace(0,1,n);
[Xq,Yq] = meshgrid(xq,yq);
xx = linspace(0,1,corr.n_random_field);
yy = linspace(0,1,corr.n_random_field);
[X,Y] = meshgrid(xx,yy);
mesh = [X(:) Y(:)];
variability = randomfield(corr,mesh,'trunc', 0);
variability=reshape(variability,corr.n_random_field,corr.n_random_field);
% We put the variability mean at the mean_var value
variability=variability-mean(mean(variability));
variability=variability+1;
variability=variability*mean_var;
variability=interp2(xx,yy,variability,Xq,Yq);
variability=min(max(mean_var/4,variability),7*mean_var/4);
end

