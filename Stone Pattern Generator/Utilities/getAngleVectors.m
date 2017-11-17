function [ angle ] = getAngleVectors(p1,p2,p3 )
%GETANGLEVECTORS Summary of this function goes here
%   Detailed explanation goes here
v1=p2-p1;
v2=p3-p2;
angle1=atan2(v1(:,2),v1(:,1));
angle2=atan2(v2(:,2),v2(:,1));
angle=mod(pi-angle1+angle2,2*pi);

end

