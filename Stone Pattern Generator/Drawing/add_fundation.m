function [ funded_poly,Ly_wall ] = add_fundation( cropped_poly,Lx_wall,Ly_wall,dl_mortar,dl_brick )
% ADD_FUNDATION add a fundation to an existing picture. 
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - cropped_poly : The initial cell array of polygons
%  - Lx_wall      : The length of the wall
%  - Ly_wall      : The height of the wall
%  - dl_mortar    : The thickness of the mortar layer to add in the
%                   fundation
%  - dl_brick     : The thickness of the brick layer to add in the
%                   fundation
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - funded_poly  : The updated cell array, with the last two cells being
%                   the brick fundations
%  - Ly_wall      : The updated height of the wall 
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : February 2015
% See also ADD_FUNDATION_TO_EXISTING_PICTURE
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
funded_poly=cropped_poly;

for i=1:length(cropped_poly) % We assign every stone to the new cell array of stone 
    
    funded_poly{i}(:,2)=funded_poly{i}(:,2)+dl_mortar+dl_brick; % The height is augmented 

end

low_fund=[0,0;0,dl_brick;Lx_wall,dl_brick;Lx_wall,0]; % Lower fundation polygon
hi_fund=[0,Ly_wall+2*dl_mortar+dl_brick;0,Ly_wall+2*dl_mortar+2*dl_brick;Lx_wall,Ly_wall+2*dl_mortar+2*dl_brick;Lx_wall,Ly_wall+2*dl_mortar+dl_brick]; % Higher fundation polygon
funded_poly{length(funded_poly)+1}=low_fund; % assignement of the lower fundation
funded_poly{length(funded_poly)+1}=hi_fund; % assignement of the higher fundation
Ly_wall=Ly_wall+2*dl_mortar+2*dl_brick; % update of wall height

end

