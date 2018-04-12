function [ sieved_polygons, colors ] = sieving( initial_polygons,min_length,colors )
% SIEVING sieves the polygons, ie. removes all the smallest stones.
%
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - initial_polygons : 1xM Cell containing the Nx2 matrices containing the
%                       x-y coordinates of the polygons. 
%  - min_length       : The minimum dimension a polygon can have. 
%  - colors           : The colors vector is passed in as deleted stones
%                       must also be deleted from the colors vectors.
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - sieved_polygons  : 1x(M-p) Cell containing the Nx2 matrices of the
%                       stones that have not been deleted.
%  - colors           : M-p x 3 matrix containing the RGB colors of the
%                       non-deleted stones.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : January 2016
%             Shzhang
%             Efficiency improve
%             TO DO: need to add the code finding the maximum distance,
%             current modification would not work for eliminating super
%             long stones
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k=1;
max_dst = zeros(length(initial_polygons),1); 
area_plg = zeros(length(initial_polygons),1); 
for i=1:length(initial_polygons)
    poly=initial_polygons{1,i};
    aera=get_area_polygon(poly);
    if aera > min_length*min_length
        sieved_polygons{1,k}=initial_polygons{1,i};
        colors(k,:)=colors(i,:);
        k=k+1; 
     %   continue
    end 
%     dx=max(poly(:,1))-min(poly(:,1));
%     dy=max(poly(:,2))-min(poly(:,2));
%     kk=1;
%     d = zeros(int(size(poly,1)/2)*size(poly,1)); 
%     for j=1:int(size(poly,1)/2)
%         for l=j+1:size(poly,1)
%             d(kk)=distanz(poly(j,:),poly(l,:));
%             kk=kk+1;
%         end
%     end
%     
%     maxd=max(d);
%     
%     if aera/maxd>min_length 
%         
%   
%         
%     end

end
        
    

end

