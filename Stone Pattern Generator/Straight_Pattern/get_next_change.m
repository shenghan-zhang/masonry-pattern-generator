function [ change_pos,change ] = get_next_change( vec,start_pos )
% GET_NEXT_CHANGE function that will find the first change in a vector.
%
% It is used to find the changes in the topline. It also says if the change
% is up or down with the change output.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - vec       : Vector in which we want to find if there is a change
%  - start_pos : Starting position (the search is made to the right, that
%                means increasing the indexes)
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - change_pos: Index of the first change. If no change was found, the
%                index 0 is given.
%  - change    : The new valu of the vector.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also GETXNEXTBRICK
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
change=0;
change_pos=0;

for i=start_pos:size(vec,2)
    
    if i==size(vec,2)
        
        change_pos=0;
        break;
        
    elseif vec(1,i)<vec(1,i+1)
        
        change_pos=i+1;
        change = vec(1,i+1);
        break;
        
    elseif vec(1,i)>vec(1,i+1)
        
        change_pos=i+1;
        change = vec(1,i+1);
        break;
        
    end
    
end

end

