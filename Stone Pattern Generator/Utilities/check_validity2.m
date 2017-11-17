function [ isValid ] = check_validity2( posTab,stonesNodes,Lx_wall,Ly_wall,epsilon)
%CHECK_VALIDITY Summary of this function goes here
%   Detailed explanation goes here

isValid=1;
atot=0;

for i=1:numel(stonesNodes)
    
    if max(stonesNodes{i})>size(posTab,1)
        
        isValid=0;
        
    else
        
        polygon1=posTab(stonesNodes{i},:);
        geom=polygeom(polygon1(:,1),polygon1(:,2));
        atot=atot+geom(1);
        
        for j=1:numel(stonesNodes)
            
            if max(stonesNodes{j})>size(posTab,1)
                
                isValid=0;
                
            else
                polygon2=posTab(stonesNodes{j},:);
                
                if j~=i
                    
                    [x,y]=polybool('intersection',polygon1(:,1),polygon1(:,2),polygon2(:,1),polygon2(:,2));
                    
                    if isempty(x) == 0 || isempty(y)==0
                        
                        isValid=0;
                        break;
                        
                    end
                    
                end
                
            end
            
        end
        
        if isValid==0
            
            break;
            
        end
        
    end
    
end

if abs(atot-Lx_wall*Ly_wall)>epsilon^2
    
    isValid=0;
    
end

end

