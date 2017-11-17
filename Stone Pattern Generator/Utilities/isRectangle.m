function [ iR ] = isRectangle( stone,epsilon )
%ISRECTANGLE Summary of this function goes here
%   Detailed explanation goes here
iR=1;
stone=unique(stone,'rows','stable');
stone=[stone;stone(1:2,:)];

for i=1:size(stone,1)-2
    
    p1=stone(i,:);
    p2=stone(i+1,:);
    p3=stone(i+2,:);
    angle=getAngleVectors(p1,p2,p3);
    
    if abs(angle-pi/2)>epsilon && abs(angle-pi)>epsilon
        
        iR=0;
        return;
        
    end
    
end

end

