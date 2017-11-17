function [ angle ] = getAngle( p1,p2,p3 )
%GET_ANGLE Summary of this function goes here
%   Detailed explanation goes here
v1=p2-p1;
v2=p3-p2;
nv1=norm(v1);
nv2=norm(v2);
pscal=dot(v1,v2);
angle=acos(pscal/(nv1*nv2));


end

