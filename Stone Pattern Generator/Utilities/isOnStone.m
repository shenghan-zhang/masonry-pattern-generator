function [ iOS ] = isOnStone( pos,stone,epsilon )
% ISONSTONE function that will tell if a point is on a stone or no.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos   : position of the point which we want to know if 
%            it's on the stone.
%  - stone : Mx2 matrix containing the stone vertices
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - iOS               : boolean saying if the point is on the stone (1) or
%                        no (0).
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning('off','MATLAB:inpolygon:ModelingWorldLower');

[~,iOS0]=inpolygon(pos(1,1),pos(1,2),stone(:,1),stone(:,2));
if  iOS0
    iOS=1;
    return;
else
    iOS=0;
end
[iIS1,iOS1]=inpolygon(pos(1,1)+epsilon/2,pos(1,2)+epsilon/2,stone(:,1),stone(:,2));
if iIS1 || iOS1
    iOS=1;
    return;
end
[iIS2,iOS2]=inpolygon(pos(1,1)+epsilon/2,pos(1,2)-epsilon/2,stone(:,1),stone(:,2));
if iIS2 || iOS2
    iOS=1;
    return;
end
[iIS3,iOS3]=inpolygon(pos(1,1)-epsilon/2,pos(1,2)+epsilon/2,stone(:,1),stone(:,2));
if iIS3 || iOS3
    iOS=1;
    return;
end
[iIS4,iOS4]=inpolygon(pos(1,1)-epsilon/2,pos(1,2)-epsilon/2,stone(:,1),stone(:,2));
if iIS4 || iOS4
    iOS=1;
else
    iOS=0;
end

end

