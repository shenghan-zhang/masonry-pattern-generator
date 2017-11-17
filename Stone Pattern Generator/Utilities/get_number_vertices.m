function [ n_vertices ] = get_number_vertices( stones )
% GET_NUMBER_VERTICES function that gets the number of vertices in an array of stones
% 
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - stones : 1xM cell array of stones (Nx2 matrices) 
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - n_vertices : the total number of vertices. 
%
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : February 2016
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_vertices=0;

for i=1:length(stones)
    
    n_vertices=n_vertices+size(stones{i},1);
    
end

end

