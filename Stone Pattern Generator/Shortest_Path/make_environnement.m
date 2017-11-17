function [ environnement,ref_tab ] = make_environnement( polygons,Lx,Ly )
% MAKE_ENVIRONNEMENT create a data structure that is needed by the visilibity toolbox.
%
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - polygons   : 1xM cell array containing all the polygons. 
%  - Lx         : Length of the wall
%  - Ly         : Height of the wall
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - environnement : cell array containing all the stones + the outter
%                    frame. 
%  - ref_tab       : Nx3 matrix containing in the first column the number
%                    of the stone, in the second column the number of the
%                    vertex and in the last one the number of vertices in
%                    the current stone. It is used in Dijkstra_modified to
%                    know if two vertices are direct neighbors. 
%
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : FEBRUARY 2016
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
environnement=cell(1,length(polygons)+1);
environnement{1}=[0,0;0,Ly;Lx,Ly;Lx,0];
ko=5;
ref_tab(1:4,1:3)=0;

for i=1:length(polygons)
    environnement{i+1}=polygons{i};
    kn=ko+size(polygons{i},1)-1;
    ref_tab(ko:kn,1)=i;
    ref_tab(ko:kn,2)=[1:size(polygons{i},1)]';
    ref_tab(ko:kn,3)=size(polygons{i},1);
    ko=kn+1;
end

end

