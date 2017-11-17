function [ indBrick ] = getIndexBrick( topLine,xStart,xEnd,epsilon,indRow,Lx_wall )
%GETINDEXBRICK Summary of this function goes here
%   Detailed explanation goes here
if indRow~=1
    
    if xStart == Lx_wall
        
        indStart = size(topLine,2);
        indEnd=size(topLine,2);
        
    elseif xEnd== Lx_wall
        
        indStart=max(1,round(xStart/epsilon)+1);
        indEnd=size(topLine,2);
        
    else
        indStart=max(1,round(xStart/epsilon)+1);
        indEnd=min(size(topLine,2),round(xEnd/epsilon)+1);
        
    end
    
    indBrick=unique(topLine(2,indStart:indEnd),'stable');
    
else
    
    indBrick=0;
    
end

end

