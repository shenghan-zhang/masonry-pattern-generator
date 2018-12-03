function [resampled_stones,k] = alternatePoints(resampled_stones,epsl)
k = 0; 
for i=1:length(resampled_stones(:,1))
%     if i==1
%         p_pre = resampled_stones(end-1,:); 
%         p_post = resampled_stones(2,:); 
%     else
%         p_pre = resampled_stones(i-1,:);
%         p_post = resampled_stones(i+1,:);     
%     end
%     poly_temp = [p_pre
%                  resampled_stones(i,:)
%                  p_post]; 
%     if polyarea(poly_temp(:,1),poly_temp(:,2))==0
%         k = k+1; 
%         resampled_stones(i,:) = resampled_stones(i,:) + epsl*([rand,rand]*2-1); 
%     end
    resampled_stones(i,:) = resampled_stones(i,:) + epsl*([rand,rand]*2-1); 
end 
% resampled_stones = [resampled_stones;
%                     resampled_stones(1,:)]; 
end 