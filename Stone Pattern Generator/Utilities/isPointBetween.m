function [ iPB ] = isPointBetween( p,p1,p2,epsilon )
%ISPOINTBETWEEN Summary of this function goes here
%   Detailed explanation goes here
x1=p1(1);
x2=p2(1);
y1=p1(2);
y2=p2(2);
px=p(1);
py=p(2);
epsilon=max(10*eps,epsilon/2);

if px<min(x1,x2) || px > max(x1,x2) || py <min(y1,y2) || py > max(y1,y2)
    
    iPB = 0;
    
else
    
    if abs(x1-x2)<epsilon
        
        iPB=abs(px-x1)<epsilon;
        
    elseif abs(y1-y2)<epsilon
        
        iPB=abs(py-y1)<epsilon;
        
    else
        
        a=(y2-y1)/(x1-x2);
        c=-a*x1-y1;
        b=1;
        d=abs(a*px+b*py+c)/sqrt(a^2+b^2);
        iPB=d<epsilon;
        
    end
    
end


end

