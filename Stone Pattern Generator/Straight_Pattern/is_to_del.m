function [ itd ] = is_to_del( stone )
% IS_TO_DEL says if a stone is to be deleted or not. 
% 
% A stone is to be deleted if all of its x or y coordinates are the same 
%
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - stone    : the stone to check
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - itd      : boolean that is 1 if the stone has to be deleted and 0 if
%               not.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if sum(stone(:,1)==stone(1,1))==size(stone,1) || sum(stone(:,2)==stone(1,2))==size(stone,1)
   
    itd=1;
    
else
    
    itd=0;
    
end


end

